import 'package:flutter/material.dart';
import 'package:profair/src/models/providers_model.dart';
import 'package:profair/src/models/stand_model.dart';
import 'package:profair/src/repositories/map_repository.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:profair/src/utils/format_currency.dart';

const _colorOrdered = Color(0xFF22C55E);
const _colorWithoutOrder = colorBlue;
const _colorWithoutProvider = colorRed;
const _markerBorder = Border.fromBorderSide(
  BorderSide(color: Color(0x33000000), width: 0.7),
);

class MapEventDynamic extends StatefulWidget {
  const MapEventDynamic({
    super.key,
    required this.map,
    this.codOrg,
    this.providers,
    this.codeBranch,
  });

  final String map;
  final int? codOrg;

  /// Fornecedores do associado (com valor de pedido), para status no mapa.
  final List<ProvidersModel>? providers;
  final int? codeBranch;

  @override
  State<MapEventDynamic> createState() => _MapEventDynamicState();
}

class _MapEventDynamicState extends State<MapEventDynamic> {
  final MapRepository _mapRepository = MapRepository();

  List<StandModel> _stands = [];
  bool _loading = true;
  bool _error = false;

  // Dimensões naturais da imagem do mapa (para mapear coordenadas normalizadas).
  Size? _imageSize;

  // Lookup: codForn -> fornecedor (valor de pedido, logo, cor...).
  late final Map<int, ProvidersModel> _providersByCode = {
    for (final p in widget.providers ?? <ProvidersModel>[])
      if (p.codeProvider != null) p.codeProvider!: p,
  };

  ProvidersModel? _providerOf(StandModel stand) =>
      stand.codForn == null ? null : _providersByCode[stand.codForn!];

  bool _hasOrder(StandModel stand) => (_providerOf(stand)?.totalValue ?? 0) > 0;

  @override
  void initState() {
    super.initState();
    _resolveImageSize();
    _carregarStands();
  }

  void _resolveImageSize() {
    final image = NetworkImage(widget.map);
    final stream = image.resolve(const ImageConfiguration());
    late final ImageStreamListener listener;
    listener = ImageStreamListener(
      (info, _) {
        if (!mounted) return;
        setState(() {
          _imageSize = Size(
            info.image.width.toDouble(),
            info.image.height.toDouble(),
          );
        });
        stream.removeListener(listener);
      },
      onError: (error, stack) {
        if (!mounted) return;
        setState(() => _error = true);
        stream.removeListener(listener);
      },
    );
    stream.addListener(listener);
  }

  Future<void> _carregarStands() async {
    if (widget.codOrg == null) {
      setState(() {
        _stands = [];
        _loading = false;
      });
      return;
    }
    try {
      final stands = await _mapRepository.getStands(widget.codOrg!);
      if (!mounted) return;
      setState(() {
        _stands = stands;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = true;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Mapa em tela cheia
          Positioned.fill(
            child: _error
                ? _buildError()
                : (_loading || _imageSize == null)
                    ? const Center(child: CircularProgressIndicator())
                    : InteractiveViewer(
                        minScale: 0.5,
                        maxScale: 9,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            // Retângulo real onde a imagem é desenhada (BoxFit.contain),
                            // usado como referência para posicionar os stands.
                            final rect = _fittedImageRect(
                                constraints.biggest, _imageSize!);
                            return Stack(
                              children: [
                                Positioned(
                                  left: rect.left,
                                  top: rect.top,
                                  width: rect.width,
                                  height: rect.height,
                                  child: Image.network(widget.map,
                                      fit: BoxFit.fill),
                                ),
                                ..._stands.map(
                                    (stand) => _buildStandMarker(stand, rect)),
                              ],
                            );
                          },
                        ),
                      ),
          ),

          // Botão de voltar flutuante
          Positioned(
            top: 0,
            left: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Material(
                  color: Theme.of(context)
                      .colorScheme
                      .surface
                      .withValues(alpha: 0.92),
                  shape: const CircleBorder(),
                  elevation: 3,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => Navigator.of(context).pop(),
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(Icons.arrow_back_rounded, size: 22),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Calcula o retângulo da imagem dentro do container mantendo a proporção (contain).
  Rect _fittedImageRect(Size container, Size image) {
    if (image.width == 0 || image.height == 0) {
      return Rect.fromLTWH(0, 0, container.width, container.height);
    }
    final scale =
        (container.width / image.width) < (container.height / image.height)
            ? container.width / image.width
            : container.height / image.height;
    final drawnW = image.width * scale;
    final drawnH = image.height * scale;
    final offsetX = (container.width - drawnW) / 2;
    final offsetY = (container.height - drawnH) / 2;
    return Rect.fromLTWH(offsetX, offsetY, drawnW, drawnH);
  }

  Widget _buildStandMarker(StandModel stand, Rect rect) {
    final left = rect.left + stand.x * rect.width;
    final top = rect.top + stand.y * rect.height;
    final width = stand.w * rect.width;
    final height = stand.h * rect.height;

    final ordered = _hasOrder(stand);
    final logo = _logoOf(stand);

    return Positioned(
      left: left,
      top: top,
      width: width,
      height: height,
      child: GestureDetector(
        onTap: () => _mostrarDetalhesDoStand(stand),
        child: ordered
            ? _orderedMarker(stand, logo, width, height)
            : _defaultMarker(stand, logo, width, height),
      ),
    );
  }

  // Logo do fornecedor sobre o stand.
  Widget _logoChip(String logo) {
    return Image.network(
      logo,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => const SizedBox.shrink(),
    );
  }

  String? _logoOf(StandModel stand) {
    final logo = stand.fornImage ?? _providerOf(stand)?.image;
    return (logo != null && logo.trim().isNotEmpty) ? logo : null;
  }

  // Stand com pedido feito: card verde com check (e logo, quando houver).
  Widget _orderedMarker(
      StandModel stand, String? logo, double width, double height) {
    final small = width < 34 || height < 34;
    return Container(
      decoration: BoxDecoration(
        color: _colorOrdered.withValues(alpha: 0.82),
        border: _markerBorder,
        boxShadow: [
          BoxShadow(
              color: _colorOrdered.withValues(alpha: 0.4),
              blurRadius: 6,
              offset: const Offset(0, 2)),
        ],
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(2),
      child: logo == null
          ? const FittedBox(
              fit: BoxFit.scaleDown,
              child: Icon(Icons.check_rounded, color: colorWhite, size: 9),
            )
          : Stack(
              alignment: Alignment.center,
              children: [
                // Logo do fornecedor
                Positioned.fill(
                  child: Padding(
                    padding: EdgeInsets.all(small ? 1 : 3),
                    child: _logoChip(logo),
                  ),
                ),
                // Badge de check no canto (indica que já passou ali)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(1),
                    decoration: const BoxDecoration(
                      color: _colorOrdered,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 3)
                      ],
                    ),
                    child: const Icon(Icons.check_rounded,
                        color: colorWhite, size: 6),
                  ),
                ),
              ],
            ),
    );
  }

  // Stand sem pedido: azul com fornecedor, vermelho sem fornecedor.
  Widget _defaultMarker(
      StandModel stand, String? logo, double width, double height) {
    final hasName = stand.nome != null && stand.nome!.trim().isNotEmpty;
    // O nome só acompanha a logo quando há espaço; senão a logo domina o card.
    final showName = hasName && (logo == null || height >= 44);
    final markerColor =
        stand.codForn == null ? _colorWithoutProvider : _colorWithoutOrder;
    return Container(
      decoration: BoxDecoration(
        color: markerColor,
        border: _markerBorder,
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (logo != null)
            Flexible(
              child: _logoChip(logo),
            ),
          if (showName)
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  stand.nome!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: colorWhite,
                      fontWeight: FontWeight.bold,
                      fontSize: 10),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.map_outlined, size: 48, color: colorGrey),
            const SizedBox(height: 12),
            const Text(
              "Não foi possível carregar o mapa do evento.",
              textAlign: TextAlign.center,
              style: TextStyle(color: colorGreyDark),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                setState(() {
                  _error = false;
                  _loading = true;
                });
                _resolveImageSize();
                _carregarStands();
              },
              child: const Text("Tentar novamente"),
            ),
          ],
        ),
      ),
    );
  }

  // ── Dialog de detalhes do stand ─────────────────────────────────────────
  void _mostrarDetalhesDoStand(StandModel stand) {
    final provider = _providerOf(stand);
    final ordered = _hasOrder(stand);
    final logo = _logoOf(stand);
    final nomeForn = provider?.nameProvider ?? stand.nomeForn;
    final hasProvider = stand.codForn != null;

    // Cor de destaque: verde se já pediu, azul sem pedido e vermelho sem fornecedor.
    final accent = ordered
        ? _colorOrdered
        : hasProvider
            ? _colorWithoutOrder
            : _colorWithoutProvider;
    final accentDark = Color.lerp(accent, Colors.black, 0.3)!;

    showDialog(
      context: context,
      builder: (dialogContext) {
        final onSurface = Theme.of(dialogContext).colorScheme.onSurface;
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Header colorido ────────────────────────────────────────
              Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 12, 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [accent, accentDark],
                  ),
                ),
                child: Row(
                  children: [
                    // Logo / ícone
                    Container(
                      width: 52,
                      height: 52,
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: colorWhite,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: logo != null
                          ? Image.network(
                              logo,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => Icon(
                                  Icons.storefront_rounded,
                                  color: accent,
                                  size: 26),
                            )
                          : Icon(Icons.storefront_rounded,
                              color: accent, size: 26),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nomeForn?.isNotEmpty == true
                                ? nomeForn!
                                : (stand.nome ?? "Stand"),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: colorWhite,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                          if (stand.nome != null &&
                              stand.nome!.trim().isNotEmpty &&
                              nomeForn?.isNotEmpty == true) ...[
                            const SizedBox(height: 3),
                            Text(
                              stand.nome!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: colorWhite.withValues(alpha: 0.8),
                                  fontSize: 12.5),
                            ),
                          ],
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      icon: Icon(Icons.close_rounded,
                          color: colorWhite.withValues(alpha: 0.9)),
                    ),
                  ],
                ),
              ),

              // ── Corpo ─────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: (ordered ? _colorOrdered : colorGreyDark)
                            .withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            ordered
                                ? Icons.check_circle_rounded
                                : Icons.schedule_rounded,
                            size: 15,
                            color: ordered ? _colorOrdered : colorGreyDark,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            ordered
                                ? "Você já fez pedido aqui"
                                : "Ainda sem pedido",
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: ordered ? _colorOrdered : colorGreyDark,
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (hasProvider && provider != null) ...[
                      const SizedBox(height: 16),
                      // Valor do pedido
                      Container(
                        width: double.maxFinite,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: onSurface.withValues(alpha: 0.04),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                              color: onSurface.withValues(alpha: 0.08)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: accent.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(Icons.payments_outlined,
                                  size: 18, color: accent),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "VALOR DO PEDIDO",
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.8,
                                    color: onSurface.withValues(alpha: 0.45),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  formatCurrency(provider.totalValue),
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: ordered ? _colorOrdered : onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],

                    if (!hasProvider) ...[
                      const SizedBox(height: 14),
                      Text(
                        "Nenhum fornecedor vinculado a este stand.",
                        style: TextStyle(
                            fontSize: 13,
                            color: onSurface.withValues(alpha: 0.55)),
                      ),
                    ],

                    const SizedBox(height: 18),

                    // Ações
                    if (hasProvider && provider != null)
                      SizedBox(
                        width: double.maxFinite,
                        height: 46,
                        child: TextButton.icon(
                          style: TextButton.styleFrom(
                            backgroundColor: colorSecondary,
                            foregroundColor: colorWhite,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () {
                            Navigator.pop(dialogContext);
                            Navigator.of(context).pushNamed(
                              "detailsprovider",
                              arguments: {
                                "codeProvider": provider.codeProvider,
                                "imageProvider": provider.image,
                                "nameProvider": provider.nameProvider,
                                "codeBranch": widget.codeBranch,
                                "color": provider.color,
                              },
                            );
                          },
                          icon: const Icon(Icons.storefront_outlined, size: 18),
                          label: const Text(
                            "Ver fornecedor",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
                      )
                    else
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          child: const Text("Fechar"),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
