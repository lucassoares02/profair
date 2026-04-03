import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:profair/src/components/card_product.dart';
import 'package:profair/src/components/loading_list.dart';
import 'package:profair/src/components/loading_notices.dart';
import 'package:profair/src/models/history_clients_tradings_model.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:profair/src/utils/format_currency.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:flutter/material.dart';
import 'package:profair/src/views/details_provider.dart/components/list_negotiations.dart';
import 'package:profair/src/views/details_provider.dart/details_provider_controller.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../reports/components/chart_negotiation.dart';

class DetailsProviderScreen extends StatefulWidget {
  const DetailsProviderScreen({
    super.key,
    required this.detailsProviderController,
    required this.codeBranch,
    required this.codeProvider,
    this.image,
    this.color,
    required this.nameProvider,
  });

  final DetailsProviderController detailsProviderController;
  final int codeBranch;
  final int codeProvider;
  final String? image;
  final String? color;
  final String nameProvider;

  @override
  State<DetailsProviderScreen> createState() => _DetailsProviderState();
}

class _DetailsProviderState extends State<DetailsProviderScreen> {
  bool headerProvider = true;
  ValueNotifier<int> indexTab = ValueNotifier(0);
  int? _selectedHistoryEvent;

  Color get _providerColor => widget.color != null ? Color(int.parse(widget.color!)) : colorPrimary;
  Color _providerColorLight(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Color.lerp(_providerColor, isDark ? Colors.black : Colors.white, isDark ? 0.70 : 0.85)!;
  }

  Color get _providerColorDark => Color.lerp(_providerColor, Colors.black, 0.35)!;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<_TabItem> tabs = [
      _TabItem(label: "Destaques", icon: Icons.auto_awesome_outlined),
      _TabItem(
        label: widget.codeBranch == 0 ? "Pedidos" : "Meus pedidos",
        icon: Icons.receipt_long_outlined,
      ),
      _TabItem(label: "Negociações", icon: Icons.handshake_outlined),
      _TabItem(label: "Consultores", icon: Icons.people_outline_rounded),
      _TabItem(label: "Histórico", icon: Icons.timeline_rounded),
    ];

    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          top: false,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (headerProvider) _buildHeader(),
                    _buildTabBar(tabs),
                    const SizedBox(height: 16),
                    _buildTabContent(),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // HEADER
  // ─────────────────────────────────────────────

  Widget _buildHeader() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Main gradient background
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                _providerColorDark,
                _providerColor,
                Color.lerp(_providerColor, Colors.white, 0.08)!,
              ],
              stops: const [0.0, 0.55, 1.0],
            ),
          ),
          child: Stack(
            children: [
              // Decorative elements
              Positioned(
                top: -60,
                right: -50,
                child: _decorBlurCircle(200, 0.08),
              ),
              Positioned(
                top: 30,
                right: 40,
                child: _decorBlurCircle(80, 0.06),
              ),
              Positioned(
                bottom: 20,
                left: -40,
                child: _decorBlurCircle(140, 0.06),
              ),
              Positioned(
                top: 80,
                left: 30,
                child: _decorBlurCircle(24, 0.10),
              ),
              Positioned(
                top: 50,
                right: 100,
                child: _decorBlurCircle(16, 0.12),
              ),
              // Content
              Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Back button
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 6, top: 6),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: colorWhite, size: 18),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Avatar with glow ring
                    widget.image != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.network(
                              widget.image!,
                              height: 80,
                              fit: BoxFit.contain,
                            ),
                          )
                        : Container(
                            width: 84,
                            height: 84,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  _providerColor.withOpacity(0.15),
                                  _providerColor.withOpacity(0.05),
                                ],
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                widget.nameProvider.isNotEmpty ? widget.nameProvider[0].toUpperCase() : "?",
                                style: TextStyle(
                                  color: _providerColor,
                                  fontSize: 38,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                    const SizedBox(height: 18),
                    // Provider name
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        widget.nameProvider,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: colorWhite,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                          height: 1.15,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    // Code badge — glass effect
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.14),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: Colors.white.withOpacity(0.28), width: 1),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.tag_rounded, color: Colors.white.withOpacity(0.7), size: 14),
                              const SizedBox(width: 6),
                              Text(
                                "Cód. ${widget.codeProvider}",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.92),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 36),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Bottom fade-out curve
        Positioned(
          left: 0,
          right: 0,
          bottom: -1,
          child: Container(
            height: 24,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _decorBlurCircle(double size, double opacity) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              Colors.white.withOpacity(opacity),
              Colors.white.withOpacity(opacity * 0.3),
              Colors.transparent,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
      );

  // ─────────────────────────────────────────────
  // TAB BAR
  // ─────────────────────────────────────────────

  Widget _buildTabBar(List<_TabItem> tabs) {
    return ValueListenableBuilder<int>(
      valueListenable: indexTab,
      builder: (context, activeIndex, _) {
        final theme = Theme.of(context);
        return Container(
          height: 44,
          margin: const EdgeInsets.only(top: 14),
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: appPadding),
            scrollDirection: Axis.horizontal,
            separatorBuilder: (_, __) => const SizedBox(width: 6),
            itemCount: tabs.length,
            itemBuilder: (context, index) {
              final isActive = index == activeIndex;
              return GestureDetector(
                onTap: () => indexTab.value = index,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
                  decoration: BoxDecoration(
                    color: isActive ? _providerColor : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        tabs[index].icon,
                        size: 15,
                        color: isActive ? colorWhite : theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        tabs[index].label,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                          color: isActive ? colorWhite : theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  // ─────────────────────────────────────────────
  // SECTION TITLE helper
  // ─────────────────────────────────────────────

  Widget _sectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 22,
          decoration: BoxDecoration(
            color: _providerColor,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // CARD WRAPPER helper
  // ─────────────────────────────────────────────

  Widget _cardWrapper({required Widget child, VoidCallback? onTap}) {
    final cardColor = Theme.of(context).cardColor;
    final shadowColor = Theme.of(context).shadowColor;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: shadowColor.withOpacity(0.04),
            blurRadius: 12,
            spreadRadius: 0,
            offset: const Offset(0, 3),
          ),
          BoxShadow(
            color: shadowColor.withOpacity(0.02),
            blurRadius: 4,
            spreadRadius: 0,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // TAB CONTENT
  // ─────────────────────────────────────────────

  Widget _buildTabContent() {
    return SizedBox(
      width: double.infinity,
      child: ValueListenableBuilder<int>(
        valueListenable: indexTab,
        builder: (context, value, _) {
          if (value == 0) {
            widget.detailsProviderController.findTopMerchandises(widget.codeProvider);
          } else if (value == 1) {
            widget.detailsProviderController.findRequestStoresOrOrg(widget.codeBranch, widget.codeProvider);
          } else if (value == 2) {
            widget.detailsProviderController.findNegotiations(widget.codeBranch, widget.codeProvider);
          } else if (value == 3) {
            widget.detailsProviderController.findConsults(widget.codeProvider);
          } else if (value == 4) {
            if (widget.detailsProviderController.stateHistory.value == StateApp.start) {
              widget.detailsProviderController.findHistory(widget.codeBranch, widget.codeProvider);
            }
          }

          final List<Widget> pages = [
            _pageDestaques(),
            _pagePedidos(),
            _pageNegociacoes(),
            _pageConsultores(),
            _pageHistorico(),
          ];

          return pages[value];
        },
      ),
    );
  }

  // ─────────────────────────────────────────────
  // PAGE: DESTAQUES
  // ─────────────────────────────────────────────

  Widget _pageDestaques() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: appPadding),
      child: ValueListenableBuilder(
        valueListenable: widget.detailsProviderController.stateTopMerchandises,
        builder: (context, valueTop, _) {
          if (valueTop == StateApp.loading) {
            return const Skeletonizer(
              effect: ShimmerEffect(),
              child: Column(
                children: [
                  Card(
                    margin: EdgeInsets.only(bottom: 12),
                    child: SizedBox(height: 80, width: double.maxFinite),
                  ),
                  Card(
                    margin: EdgeInsets.only(bottom: 12),
                    child: SizedBox(height: 260, width: double.maxFinite),
                  ),
                  Card(child: SizedBox(height: 200, width: double.maxFinite)),
                ],
              ),
            );
          }

          final products = widget.detailsProviderController.topMerchandises;
          final hasData = products[9].total != 0;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Header compacto ---
              _destaquesHeader(),
              const SizedBox(height: 16),

              if (!hasData)
                _destaquesEmptyState()
              else ...[
                // --- Gráfico de barras ---
                _destaquesChart(products),
                const SizedBox(height: 20),

                // --- Ranking dos produtos ---
                _destaquesRankingHeader(),
                const SizedBox(height: 12),

                // --- Lista de produtos ---
                ...products.asMap().entries.map((e) {
                  return _destaquesProductCard(
                    position: e.key,
                    product: e.value,
                  );
                }),
              ],
            ],
          );
        },
      ),
    );
  }

  // --- Destaques: Header ---
  Widget _destaquesHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _providerColor,
            _providerColorDark,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _providerColor.withValues(alpha: 0.3),
            blurRadius: 16,
            spreadRadius: -4,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.emoji_events_rounded, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Top 10 produtos",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  "Os itens mais negociados deste fornecedor",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Destaques: Estado vazio ---
  Widget _destaquesEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _providerColor.withValues(alpha: 0.12),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: _providerColorLight(context),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.bar_chart_rounded, color: _providerColor, size: 28),
          ),
          const SizedBox(height: 16),
          Text(
            "Métricas em processamento",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Em breve você verá os produtos mais negociados deste fornecedor. Os dados são atualizados ao longo do evento.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // --- Destaques: Gráfico ---
  Widget _destaquesChart(products) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.05),
            blurRadius: 16,
            spreadRadius: -2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 6, bottom: 4),
            child: Row(
              children: [
                Icon(Icons.insights_rounded, size: 16, color: _providerColor),
                const SizedBox(width: 6),
                Text(
                  "Volume de negociações",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 260,
            child: BarChartSample1(
              legendValue: false,
              barColor: _providerColor,
              reportsProducts: products,
            ),
          ),
        ],
      ),
    );
  }

  // --- Destaques: Subtítulo do ranking ---
  Widget _destaquesRankingHeader() {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: _providerColor,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          "Ranking de produtos",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.onSurface,
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }

  // --- Destaques: Card de produto ---
  Widget _destaquesProductCard({required int position, required product}) {
    final List<Color> medalColors = [
      const Color(0xFFFFB800), // Ouro
      const Color(0xFF94A3B8), // Prata
      const Color(0xFFCD7F32), // Bronze
    ];
    final List<IconData> medalIcons = [
      Icons.emoji_events_rounded,
      Icons.emoji_events_rounded,
      Icons.emoji_events_rounded,
    ];

    final bool isTopThree = position < 3;
    final Color rankColor = isTopThree ? medalColors[position] : _providerColor.withValues(alpha: 0.7);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        border: isTopThree ? Border.all(color: rankColor.withValues(alpha: 0.25), width: 1) : null,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Badge de posição
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: isTopThree ? rankColor.withValues(alpha: 0.12) : Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: isTopThree
                    ? Icon(medalIcons[position], color: rankColor, size: 20)
                    : Text(
                        "${position + 1}",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 12),

            // Informações do produto
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nome do produto
                  Text(
                    product.title!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.onSurface,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Código + complemento
                  Text(
                    "${product.codeProduct} · ${product.complement}",
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Tags: marca, preço unitário, preço, embalagem
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      _destaquesTag(product.brand!, _providerColor),
                      if (product.unitPrice != null) _destaquesTag(formatCurrency(product.unitPrice!), const Color(0xFF3B82F6)),
                      if (product.price != null) _destaquesTag(formatCurrency(product.price!), const Color(0xFF10B981)),
                      _destaquesTag(
                        "${product.packing} × ${product.coefficient}",
                        Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Posição numérica para top 3
            if (isTopThree)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: rankColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "${position + 1}º",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: rankColor,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // --- Destaques: Tag chip ---
  Widget _destaquesTag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.15), width: 0.5),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // PAGE: PEDIDOS
  // ─────────────────────────────────────────────

  Widget _pagePedidos() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: appPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle("Pedidos"),
          const SizedBox(height: 14),
          ValueListenableBuilder(
            valueListenable: widget.detailsProviderController.stateRequestStores,
            builder: (context, stateRequest, _) {
              return Column(
                children: widget.detailsProviderController.requestsStores.map((e) {
                  return e.codeForn != widget.codeProvider
                      ? Container()
                      : stateRequest == StateApp.loading
                          ? LoadingList(loadingHeader: false)
                          : _cardWrapper(
                              onTap: stateRequest == StateApp.success
                                  ? () async {
                                      Navigator.of(context).pushNamed(
                                        "orderdetails",
                                        arguments: {"order": e},
                                      );
                                    }
                                  : null,
                              child: Row(
                                children: [
                                  // Left accent bar
                                  Container(
                                    width: 4,
                                    height: 52,
                                    margin: const EdgeInsets.only(right: 14),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [_providerColor, _providerColor.withOpacity(0.3)],
                                      ),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "#${e.codeNegotiation}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 14,
                                                color: _providerColor,
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                              decoration: BoxDecoration(
                                                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                DateFormat("dd/MM/yyyy").format(DateTime.parse(e.termNegotiation!)),
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          widget.codeBranch == 0 ? e.razaoClient! : e.descriptionNegotiation!,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            color: Theme.of(context).colorScheme.onSurface,
                                          ),
                                        ),
                                        stateRequest == StateApp.loading
                                            ? const Skeletonizer(
                                                effect: ShimmerEffect(),
                                                child: Card(
                                                  margin: EdgeInsets.symmetric(horizontal: 16),
                                                  child: SizedBox(height: appPadding, width: 50),
                                                ),
                                              )
                                            : stateRequest == StateApp.success
                                                ? widget.detailsProviderController.request != null
                                                    ? Padding(
                                                        padding: const EdgeInsets.only(top: 6),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Text(
                                                              formatCurrency(e.value!),
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 16,
                                                                color: Theme.of(context).colorScheme.onSurface,
                                                              ),
                                                            ),
                                                            Text(
                                                              e.hour!,
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                color: Theme.of(context).hintColor,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    : Container()
                                                : Container(),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(Icons.chevron_right_rounded, color: Theme.of(context).hintColor, size: 22),
                                ],
                              ),
                            );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // PAGE: NEGOCIAÇÕES
  // ─────────────────────────────────────────────

  Widget _pageNegociacoes() {
    return Column(
      children: [
        if (headerProvider)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ValueListenableBuilder(
                valueListenable: widget.detailsProviderController.stateNegotiations,
                builder: (context, value, _) {
                  return value == StateApp.loading
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 0),
                          child: LoadingNotice(cardHeigth: 120, cardWidth: 300),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: appPadding),
                              child: _sectionTitle("Negociações / Prazos"),
                            ),
                            const SizedBox(height: 12),
                            ListNegotiations(
                              codeBranch: widget.codeBranch,
                              codeProvider: widget.codeProvider,
                              detailsProviderController: widget.detailsProviderController,
                            ),
                          ],
                        );
                },
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: appPadding),
                child: Divider(color: Theme.of(context).dividerColor, thickness: 1),
              ),
            ],
          ),
        ValueListenableBuilder(
          valueListenable: widget.detailsProviderController.stateMerchandises,
          builder: (context, value, _) {
            final noEmptyList = widget.detailsProviderController.merchandises.isNotEmpty;
            return value == StateApp.loading
                ? LoadingList(loadingHeader: false)
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: appPadding, left: appPadding),
                        child: noEmptyList
                            ? _sectionTitle("Mercadorias")
                            : _emptyState(
                                icon: Icons.inventory_2_outlined,
                                message: "Nenhum resultado!",
                              ),
                      ),
                      Column(
                        children: widget.detailsProviderController.merchandises.map((e) {
                          return CardProduct(
                            visibleActions: (widget.codeBranch == 0),
                            packing: e.packing!,
                            factor: e.coefficient!,
                            description: e.nameProduct!,
                            code: e.codeProduct.toString(),
                            brand: e.brand!,
                            complement: e.complement!,
                            price: formatCurrency(e.productPrice!),
                            unitPrice: formatCurrency(e.unitPrice!),
                            amount: e.totalVolume!,
                            total: formatCurrency(e.totalValue!),
                            action: () {},
                          );
                        }).toList(),
                      ),
                    ],
                  );
          },
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // PAGE: CONSULTORES
  // ─────────────────────────────────────────────

  Widget _pageConsultores() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: appPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle("Consultores"),
          const SizedBox(height: 14),
          ValueListenableBuilder(
            valueListenable: widget.detailsProviderController.stateConsults,
            builder: (context, stateConsult, _) {
              return stateConsult == StateApp.loading
                  ? LoadingList(loadingHeader: false)
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: widget.detailsProviderController.consults.map((e) {
                        return _cardWrapper(
                          child: Row(
                            children: [
                              Container(
                                width: 46,
                                height: 46,
                                margin: const EdgeInsets.only(right: 14),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      _providerColor,
                                      _providerColorDark,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: [
                                    BoxShadow(
                                      color: _providerColor.withOpacity(0.25),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    e.nameUser!.substring(0, 1).toUpperCase(),
                                    style: const TextStyle(
                                      color: colorWhite,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  e.nameUser!,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    color: Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                              ),
                              Icon(Icons.chevron_right_rounded, color: Theme.of(context).hintColor, size: 22),
                            ],
                          ),
                        );
                      }).toList(),
                    );
            },
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // PAGE: HISTÓRICO
  // ─────────────────────────────────────────────

  Widget _pageHistorico() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: appPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle("Histórico"),
          const SizedBox(height: 14),
          ValueListenableBuilder(
            valueListenable: widget.detailsProviderController.stateHistory,
            builder: (context, stateHistory, _) {
              if (stateHistory == StateApp.loading) {
                return LoadingList(loadingHeader: false);
              }

              final items = widget.detailsProviderController.history;

              if (items.isEmpty) {
                return _emptyState(
                  icon: Icons.timeline_rounded,
                  message: "Nenhum histórico encontrado",
                  subtitle: "Os dados de eventos anteriores aparecerão aqui",
                );
              }

              final groupedItems = <int, List<HistoryClientsTradingsModel>>{};
              for (final item in items) {
                groupedItems.putIfAbsent(item.event ?? 0, () => []).add(item);
              }

              final availableEvents = groupedItems.keys.toList()..sort();
              final normalizedSelectedEvent = availableEvents.contains(_selectedHistoryEvent) ? _selectedHistoryEvent : null;
              final visibleEvents = normalizedSelectedEvent == null ? availableEvents : availableEvents.where((event) => event == normalizedSelectedEvent).toList();

              return Column(
                children: [
                  _buildHistoryOverview(
                    context,
                    totalItems: items.length,
                    totalEvents: availableEvents.length,
                  ),
                  const SizedBox(height: 14),
                  ...visibleEvents.asMap().entries.map((entry) {
                    final event = entry.value;
                    return _buildHistoryEventSection(
                      context,
                      event: event,
                      items: groupedItems[event]!,
                      isLastSection: entry.key == visibleEvents.length - 1,
                    );
                  }),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryOverview(
    BuildContext context, {
    required int totalItems,
    required int totalEvents,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _providerColorLight(context),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _providerColor.withValues(alpha: 0.12)),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: _providerColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.timeline_rounded, color: _providerColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Linha do tempo de negociações",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "$totalItems ${totalItems == 1 ? 'registro encontrado' : 'registros encontrados'} em $totalEvents ${totalEvents == 1 ? 'evento' : 'eventos'}",
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.4,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryEventSection(
    BuildContext context, {
    required int event,
    required List<HistoryClientsTradingsModel> items,
    required bool isLastSection,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = _historyEventColor(event, colorScheme);
    final title = items.first.descriptionEvent?.trim().isNotEmpty == true ? items.first.descriptionEvent!.trim() : "Evento $event";

    return Padding(
      padding: EdgeInsets.only(bottom: isLastSection ? 0 : 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "$event",
                    style: const TextStyle(
                      color: colorWhite,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "${items.length} ${items.length == 1 ? 'negociação' : 'negociações'}",
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ...items.asMap().entries.map((entry) {
            return _HistoryTimelineCard(
              item: entry.value,
              providerColor: color,
              provider: widget.codeProvider,
              isLast: entry.key == items.length - 1,
            );
          }),
        ],
      ),
    );
  }

  Color _historyEventColor(int event, ColorScheme colorScheme) {
    return colorScheme.secondary;
  }

  // ─────────────────────────────────────────────
  // EMPTY STATE helper
  // ─────────────────────────────────────────────

  Widget _emptyState({
    required IconData icon,
    required String message,
    String? subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: _providerColorLight(context),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 36, color: _providerColor.withOpacity(0.5)),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            if (subtitle != null)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  subtitle,
                  style: TextStyle(
                    color: Theme.of(context).hintColor,
                    fontSize: 13,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────

class _HistoryFilterChip extends StatelessWidget {
  const _HistoryFilterChip({
    required this.label,
    required this.isSelected,
    required this.color,
    required this.count,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final Color color;
  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: isSelected ? color : color.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? colorWhite : color,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white.withValues(alpha: 0.18) : color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "$count",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? colorWhite : colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabItem {
  final String label;
  final IconData icon;
  const _TabItem({required this.label, required this.icon});
}

class _HistoryTimelineCard extends StatelessWidget {
  const _HistoryTimelineCard({
    required this.item,
    required this.providerColor,
    required this.provider,
    required this.isLast,
  });

  final HistoryClientsTradingsModel item;
  final Color providerColor;
  final int provider;
  final bool isLast;

  String _formatHistoryDate(String? value) {
    if (value == null || value.isEmpty) return '';
    try {
      return DateFormat('dd/MM/yyyy').format(DateTime.parse(value).toLocal());
    } catch (_) {
      return value;
    }
  }

  String _formatHistoryHour(String? value) {
    if (value == null || value.isEmpty) return '';
    try {
      return DateFormat('HH:mm').format(DateTime.parse(value).toLocal());
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasTotal = (item.total ?? 0) > 0;
    final date = _formatHistoryDate(item.date);
    final hour = _formatHistoryHour(item.date);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 32,
            child: Column(
              children: [
                Container(
                  width: 2,
                  height: 6,
                  color: providerColor.withValues(alpha: 0.22),
                ),
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: providerColor, width: 2.5),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.only(top: 4),
                      color: providerColor.withValues(alpha: 0.18),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Material(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(14),
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      "/tradingproductshistory",
                      arguments: {
                        "codeBranch": item.id,
                        "codeProvider": provider,
                        "codeTrading": item.negotiation,
                        "comprador": item.comprador,
                        "vendedor": item.vendedor,
                        "date": item.date,
                      },
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: colorScheme.onSurface.withValues(alpha: 0.07)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.descNegotiation?.trim().isNotEmpty == true ? item.descNegotiation!.trim() : "Negociação ${item.negotiation ?? '-'}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      height: 1.3,
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: [
                                      _HistoryBadge(
                                        icon: Icons.handshake_outlined,
                                        label: "Negociação ${item.negotiation ?? '-'}",
                                        color: providerColor,
                                      ),
                                      if (date.isNotEmpty)
                                        _HistoryBadge(
                                          icon: Icons.calendar_today_rounded,
                                          label: hour.isNotEmpty ? "$date às $hour" : date,
                                          color: providerColor,
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: providerColor.withValues(alpha: 0.10),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.receipt_long_rounded,
                                color: providerColor,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                        // const SizedBox(height: 14),
                        // if ((item.comprador ?? '').isNotEmpty || (item.vendedor ?? '').isNotEmpty)
                        //   Wrap(
                        //     spacing: 10,
                        //     runSpacing: 10,
                        //     children: [
                        //       if ((item.comprador ?? '').isNotEmpty)
                        //         _HistoryInfoTile(
                        //           icon: Icons.person_outline_rounded,
                        //           label: "Comprador",
                        //           value: item.comprador!,
                        //         ),
                        //       if ((item.vendedor ?? '').isNotEmpty)
                        //         _HistoryInfoTile(
                        //           icon: Icons.storefront_rounded,
                        //           label: "Vendedor",
                        //           value: item.vendedor!,
                        //         ),
                        //     ],
                        //   ),
                        if ((item.comprador ?? '').isNotEmpty || (item.vendedor ?? '').isNotEmpty) const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: providerColor.withValues(alpha: 0.04),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: _HistoryMetric(
                                  label: "Volume total",
                                  value: item.volume?.trim().isNotEmpty == true ? item.volume!.trim() : "-",
                                  valueColor: colorScheme.onSurface,
                                ),
                              ),
                              Container(
                                width: 1,
                                height: 36,
                                color: colorScheme.onSurface.withValues(alpha: 0.08),
                              ),
                              Expanded(
                                child: _HistoryMetric(
                                  label: "Valor total",
                                  value: formatCurrency(item.total ?? 0),
                                  valueColor: hasTotal ? providerColor : colorScheme.onSurfaceVariant,
                                  alignEnd: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
}

class _HistoryBadge extends StatelessWidget {
  const _HistoryBadge({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color.withValues(alpha: 0.8)),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color.withValues(alpha: 0.82),
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryInfoTile extends StatelessWidget {
  const _HistoryInfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      constraints: const BoxConstraints(minWidth: 150),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.onSurface.withValues(alpha: 0.035),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 17, color: colorScheme.primary),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryMetric extends StatelessWidget {
  const _HistoryMetric({
    required this.label,
    required this.value,
    required this.valueColor,
    this.alignEnd = false,
  });

  final String label;
  final String value;
  final Color valueColor;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          textAlign: alignEnd ? TextAlign.right : TextAlign.left,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}

class InvertedArcClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
      size.width / 2,
      size.height - 50,
      size.width,
      size.height,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
