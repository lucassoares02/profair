import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:profair/src/views/home/state_management.dart';
import 'package:profair/src/views/home/home_controller.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

Color _parseHexColor(String? hex, Color fallback) {
  if (hex == null || hex.isEmpty) return fallback;
  try {
    // Inteiro decimal (ex: "4291962416")
    final asInt = int.tryParse(hex);
    if (asInt != null) return Color(asInt);
    // Remove prefixos: #, 0x, 0X
    final clean = hex.replaceAll(RegExp(r'^(0x|0X|#)'), '');
    if (clean.length == 6) return Color(int.parse('FF$clean', radix: 16));
    if (clean.length == 8) return Color(int.parse(clean, radix: 16));
  } catch (_) {}
  return fallback;
}

Color _darken(Color color, [double amount = 0.25]) {
  final hsl = HSLColor.fromColor(color);
  return hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0)).toColor();
}

Color _lighten(Color color, [double amount = 0.15]) {
  final hsl = HSLColor.fromColor(color);
  return hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0)).toColor();
}

class CardCount extends StatefulWidget {
  CardCount({super.key, required this.homeController});

  HomeController homeController;

  @override
  State<CardCount> createState() => _CardCountState();
}

class _CardCountState extends State<CardCount> {
  bool _valueVisible = true;

  bool get _hasOrders {
    final val = widget.homeController.data?.valueOrder;
    if (val == null) return false;
    try {
      final parsed = double.parse(val.replaceAll('.', '').replaceAll(',', '.'));
      return parsed > 0;
    } catch (_) {
      return val.isNotEmpty && val != '0';
    }
  }

  void _navigate(BuildContext context) {
    if (widget.homeController.data!.accessTargeting == 3) {
      Navigator.of(context).pushNamed('listrequestsstores', arguments: {
        "codeProvider": 0,
        "userCode": 0,
      });
    } else if (widget.homeController.data!.accessTargeting == 2) {
      Navigator.of(context).pushNamed('listrequestsstorenegotiation', arguments: {
        "codeProvider": widget.homeController.data!.codCompany,
        "userCode": widget.homeController.data!.userCode,
      });
    } else {
      Navigator.of(context).pushNamed('listrequestsstores', arguments: {
        "codeProvider": widget.homeController.data!.codCompany,
        "userCode": 0,
        "visibleBuyers": true,
        "homeController": widget.homeController,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final colorScheme = Theme.of(context).colorScheme;
    final onSurface = colorScheme.onSurface;

    return ValueListenableBuilder(
      valueListenable: widget.homeController.stateData,
      builder: (context, value, child) {
        if (value == StateApp.loading) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Skeletonizer(
              effect: const ShimmerEffect(),
              child: Container(
                margin: const EdgeInsets.only(bottom: 14),
                height: 120,
                width: width,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          );
        }

        if (value == StateApp.error) {
          return Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: colorScheme.errorContainer.withValues(alpha: 0.12),
              border: Border.all(
                color: colorScheme.errorContainer.withValues(alpha: 0.18),
                width: 1.5,
              ),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.error,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.error_outline,
                    size: 32,
                    color: colorWhite,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Ops, algo deu errado',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: onSurface,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Não foi possível carregar o total de pedidos. Tente novamente mais tarde.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: onSurface.withValues(alpha: 0.55),
                    height: 1.55,
                  ),
                ),
              ],
            ),
          );
        }

        final isProvider = widget.homeController.data?.accessTargeting == 1;
        final isProviderEmpty = isProvider && !_hasOrders;

        if (isProviderEmpty) {
          return _ProviderEmptyState(
            brandColor: _parseHexColor(widget.homeController.data?.color, colorSecondary),
            imageUrl: widget.homeController.data?.image,
            companyName: widget.homeController.data?.nameCompany,
            onStartSale: () => Navigator.of(context).pushNamed(
              'clients',
              arguments: {
                'codeProvider': widget.homeController.data!.codCompany,
                'accessTargenting': widget.homeController.data!.accessTargeting,
                'merchandise': 0,
                'codeTrading': 0,
              },
            ),
          );
        }

        if (isProvider) {
          return _ProviderBrandCard(
            homeController: widget.homeController,
            valueVisible: _valueVisible,
            onToggleVisibility: () => setState(() => _valueVisible = !_valueVisible),
            onTap: () => _navigate(context),
          );
        }

        return StateManagement(
          width: width,
          listenable: widget.homeController.stateData,
          component: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Material(
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: () => _navigate(context),
                borderRadius: BorderRadius.circular(16),
                splashColor: Theme.of(context).colorScheme.primary.withAlpha(36),
                highlightColor: Theme.of(context).colorScheme.primary.withAlpha(18),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Total em pedidos",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: onSurface.withValues(alpha: 0.55),
                                  letterSpacing: 0.1,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: colorSecondary.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  FontAwesomeIcons.chevronRight,
                                  size: 11,
                                  color: colorSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            transitionBuilder: (child, animation) => FadeTransition(
                              opacity: animation,
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0, 0.15),
                                  end: Offset.zero,
                                ).animate(animation),
                                child: child,
                              ),
                            ),
                            child: Align(
                              key: ValueKey(_valueVisible),
                              alignment: Alignment.centerLeft,
                              child: _valueVisible
                                  ? Text(
                                      "R\$ ${widget.homeController.data!.valueOrder!}",
                                      style: TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold,
                                        color: onSurface,
                                      ),
                                    )
                                  : Text(
                                      "R\$ ••••••••",
                                      style: TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold,
                                        color: onSurface.withValues(alpha: 0.3),
                                        letterSpacing: 2,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => setState(() => _valueVisible = !_valueVisible),
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 200),
                                child: Icon(
                                  _valueVisible ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash,
                                  key: ValueKey(_valueVisible),
                                  size: 18,
                                  color: onSurface.withValues(alpha: 0.35),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      const Row(
                        children: [
                          _Tag(
                            label: "Ver detalhes",
                            color: colorSecondary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ─── Card premium para fornecedor ────────────────────────────────────────────

class _ProviderBrandCard extends StatelessWidget {
  final HomeController homeController;
  final bool valueVisible;
  final VoidCallback onToggleVisibility;
  final VoidCallback onTap;

  const _ProviderBrandCard({
    required this.homeController,
    required this.valueVisible,
    required this.onToggleVisibility,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final data = homeController.data!;
    final brandColor = _parseHexColor(data.color, colorSecondary);
    final colorDark = _darken(brandColor, 0.22);
    final colorLight = _lighten(brandColor, 0.08);
    final hasImage = data.image != null && data.image!.isNotEmpty;
    final companyName = data.nameCompany ?? '';
    final initials = companyName.isNotEmpty ? companyName.trim().split(' ').take(2).map((w) => w[0].toUpperCase()).join() : '?';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [colorDark, brandColor, colorLight],
            stops: const [0.0, 0.55, 1.0],
          ),
          boxShadow: [
            BoxShadow(
              color: brandColor.withValues(alpha: 0.45),
              blurRadius: 20,
              offset: const Offset(0, 8),
              spreadRadius: -4,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // — Decoração de fundo: círculos difusos —
              Positioned(
                top: -32,
                right: -32,
                child: Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorWhite.withValues(alpha: 0.08),
                  ),
                ),
              ),
              Positioned(
                bottom: -48,
                right: 60,
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorWhite.withValues(alpha: 0.05),
                  ),
                ),
              ),
              Positioned(
                top: 12,
                left: -20,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorWhite.withValues(alpha: 0.04),
                  ),
                ),
              ),

              // — Conteúdo principal —
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header: logo + empresa + seta
                    Row(
                      children: [
                        // Logo
                        Container(
                          width: 48,
                          height: 48,
                          // padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            // color: colorWhite.withValues(alpha: 0.18),
                            // borderRadius: BorderRadius.circular(10),
                            // border: Border.all(
                            //   color: colorWhite.withValues(alpha: 0.25),
                            //   width: 1,
                            // ),
                          ),
                          // clipBehavior: Clip.antiAlias,
                          child: hasImage
                              ? Image.network(
                                  data.image!,
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, __, ___) => Center(
                                    child: Text(
                                      initials,
                                      style: const TextStyle(
                                        color: colorWhite,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                )
                              : Center(
                                  child: Text(
                                    initials,
                                    style: const TextStyle(
                                      color: colorWhite,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            companyName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: colorWhite.withValues(alpha: 0.9),
                              letterSpacing: 0.1,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: colorWhite.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            FontAwesomeIcons.chevronRight,
                            size: 10,
                            color: colorWhite.withValues(alpha: 0.85),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // Label + valor
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total em pedidos',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: colorWhite.withValues(alpha: 0.65),
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 250),
                              transitionBuilder: (child, animation) => FadeTransition(
                                opacity: animation,
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0, 0.15),
                                    end: Offset.zero,
                                  ).animate(animation),
                                  child: child,
                                ),
                              ),
                              child: valueVisible
                                  ? Text(
                                      key: const ValueKey(true),
                                      "R\$ ${data.valueOrder!}",
                                      style: const TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold,
                                        color: colorWhite,
                                        letterSpacing: -0.5,
                                      ),
                                    )
                                  : Text(
                                      key: const ValueKey(false),
                                      "R\$ ••••••••",
                                      style: TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold,
                                        color: colorWhite.withValues(alpha: 0.4),
                                        letterSpacing: 2,
                                      ),
                                    ),
                            ),
                            const SizedBox(width: 10),
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: onToggleVisibility,
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 200),
                                  child: Icon(
                                    valueVisible ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash,
                                    key: ValueKey(valueVisible),
                                    size: 16,
                                    color: colorWhite.withValues(alpha: 0.55),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Tag genérica ─────────────────────────────────────────────────────────────

class _Tag extends StatelessWidget {
  final String label;
  final Color color;

  const _Tag({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: color,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

// ─── Estado vazio para fornecedor ─────────────────────────────────────────────

class _ProviderEmptyState extends StatelessWidget {
  final VoidCallback onStartSale;
  final Color brandColor;
  final String? imageUrl;
  final String? companyName;

  const _ProviderEmptyState({
    required this.onStartSale,
    required this.brandColor,
    this.imageUrl,
    this.companyName,
  });

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final colorDark = _darken(brandColor, 0.18);
    final hasImage = imageUrl != null && imageUrl!.isNotEmpty;
    final initials = (companyName ?? '').trim().split(' ').take(2).map((w) => w[0].toUpperCase()).join();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            brandColor.withValues(alpha: 0.07),
            colorPrimary.withValues(alpha: 0.04),
          ],
        ),
        border: Border.all(
          color: brandColor.withValues(alpha: 0.18),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [colorDark, brandColor],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: brandColor.withValues(alpha: 0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: hasImage
                ? Image.network(
                    imageUrl!,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Center(
                      child: Text(
                        initials.isNotEmpty ? initials : '?',
                        style: const TextStyle(
                          color: colorWhite,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  )
                : Center(
                    child: Text(
                      initials.isNotEmpty ? initials : '?',
                      style: const TextStyle(
                        color: colorWhite,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
          ),
          const SizedBox(height: 16),
          Text(
            'Pronto para vender?',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: onSurface,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Use o botão "Novo" para iniciar seu primeiro pedido quando um cliente for até você.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: onSurface.withValues(alpha: 0.55),
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}
