import 'package:flutter/foundation.dart';
import 'package:profair/src/components/line_chart.dart';
import 'package:profair/src/components/line_chart3.dart';
import 'package:profair/src/views/reports/components/card_percentage.dart';
import 'package:profair/src/views/reports/components/chart_negotiation.dart';
import 'package:profair/src/views/reports/components/chart_product.dart';
import 'package:profair/src/controllers/reports_controller.dart';
import 'package:profair/src/components/header_list.dart';
import 'package:profair/src/components/spacing.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ComponentList extends StatefulWidget {
  const ComponentList({
    super.key,
    required this.reportsController,
    this.codeProvider,
    this.accessTargeting,
  });

  final int? codeProvider;
  final int? accessTargeting;
  final ReportsController reportsController;

  @override
  State<ComponentList> createState() => _ComponentListState();
}

class _ComponentListState extends State<ComponentList> {
  double maxValue = 10000;
  double horizontalInterval = 5000;
  double maxValuePeriod = 20000;
  double horizontalIntervalPeriod = 5000;

  // ── Helpers de acesso rápido ──
  ReportsController get _ctrl => widget.reportsController;
  int get _access => widget.accessTargeting ?? 0;
  bool get _isProvider => _access == 1;
  bool get _isAdmin => _access == 3;
  bool get _isBuyer => _access == 2;

  void _calcMaxValue() {
    for (final item in _ctrl.reportValueMinutes) {
      if (item.totalValue! > maxValue) {
        maxValue = item.totalValue! * 2;
      }
    }
    horizontalInterval = maxValue / 5;
  }

  void _calcMaxValuePeriod() {
    for (final item in _ctrl.reportValueMinutes) {
      if (item.value! > maxValuePeriod) {
        maxValuePeriod = item.value! * 1.2;
      }
    }
    horizontalIntervalPeriod = maxValuePeriod / 5;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeaderList(
          icon: Icons.show_chart_rounded,
          activeSearch: false,
          label: "Relatórios",
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: appPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),

              // ═══════════════════════════════════════
              // 1) Card: Fornecedores com venda (admin)
              // ═══════════════════════════════════════
              if (_isAdmin)
                _buildAsyncCard(
                  listenable: _ctrl.statePercentageClients,
                  width: width,
                  builder: () => CardPercentage(
                    backgroundColor: colorRed,
                    reportsController: _ctrl,
                    title: "Fornecedores com venda",
                    value: _ctrl.percentageProviders!.percentage,
                    footer: "${_ctrl.percentageProviders!.parcial} de ${_ctrl.percentageProviders!.total} realizaram vendas.",
                  ),
                ),

              // ═══════════════════════════════════════
              // 2) Ranking Fornecedores / Produtos
              // ═══════════════════════════════════════
              if (_isAdmin || _isProvider) ...[
                const SizedBox(height: 24),
                _SectionHeader(
                  title: _isAdmin ? "Ranking Fornecedores" : "Ranking de produtos",
                  icon: Icons.emoji_events_outlined,
                ),
                const SizedBox(height: 16),
                _buildRankingChart(width),
              ],

              // ═══════════════════════════════════════
              // 3) Card: Clientes atendidos / Fornecedores visitados
              // ═══════════════════════════════════════
              const SizedBox(height: 28),
              if (!_isProvider && !_isAdmin)
                _buildAsyncCard(
                  listenable: _ctrl.statePercentageClients,
                  width: width,
                  builder: () => CardPercentage(
                    title: "Fornecedores visitados",
                    content: "Nessa sessão é possível visualizar quantos fornecedores foram atendidos até o momento em relação a quantidade total presentes no evento.",
                    value: _ctrl.percentageClients!.percentage,
                    footer: "${_ctrl.percentageClients!.parcial} de ${_ctrl.percentageClients!.total} foram visitados.",
                    reportsController: _ctrl,
                  ),
                ),

              // ═══════════════════════════════════════
              // 4) Ranking de valores movimentados
              // ═══════════════════════════════════════
              const SizedBox(height: 28),
              _SectionHeader(
                title: _isProvider
                    ? "Ranking de Clientes"
                    : _isBuyer
                        ? "Ranking de Fornecedores"
                        : "Ranking de Associados",
                icon: Icons.bar_chart_rounded,
              ),
              const SizedBox(height: 6),
              Text(
                "Acompanhe o ranking de valores movimentados até agora. Toque nas barras para mais detalhes.",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),
              _buildAsyncChart(
                listenable: _ctrl.stateReports,
                width: width,
                skeletonHeight: 280,
                chartBuilder: () => _ChartWithHint(
                  height: 300,
                  chart: BarChartTeste(
                    reportsClients: _ctrl.reportsTotalClient,
                    barColor: colorBlueDark,
                    touchedBarColor: colorBlue,
                  ),
                ),
              ),

              // ═══════════════════════════════════════
              // 5) Evolução e período (fornecedor)
              // ═══════════════════════════════════════
              if (_isProvider) ...[
                const SizedBox(height: 32),
                _buildSalesEvolutionSection(width),
                const SizedBox(height: 32),
                _buildSalesPeriodSection(width),
              ],

              const SizedBox(height: 32),
            ],
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // Ranking chart (fornecedores ou produtos)
  // ─────────────────────────────────────────────
  Widget _buildRankingChart(double width) {
    if (_isAdmin) {
      return _buildAsyncChart(
        listenable: _ctrl.stateReportsProducts,
        width: width,
        skeletonHeight: 300,
        chartBuilder: () => _ChartWithHint(
          height: 300,
          chart: BarChartTeste(reportsClients: _ctrl.reportsTotalProvider),
        ),
      );
    }

    return _buildAsyncChart(
      listenable: _ctrl.stateReportsProducts,
      width: width,
      skeletonHeight: 300,
      chartBuilder: () => _ChartWithHint(
        height: 300,
        chart: BarChartSample1(
          reportsProducts: _ctrl.reportsTotalProducts,
          barColor: colorSecondary,
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Evolução de vendas (line chart acumulado)
  // ─────────────────────────────────────────────
  Widget _buildSalesEvolutionSection(double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(
          title: "Evolução das vendas",
          icon: Icons.trending_up_rounded,
        ),
        const SizedBox(height: 16),
        ValueListenableBuilder(
          valueListenable: _ctrl.stateReportsSells,
          builder: (context, value, child) {
            _calcMaxValue();
            if (value == StateApp.loading) {
              return _SkeletonCard(height: 250, width: width);
            }
            if (_ctrl.reportValueMinutes.isEmpty) {
              return const _EmptyChartState(
                message: "Sem dados de evolução disponíveis",
              );
            }
            return _ChartContainer(
              height: 250,
              child: LineChartSample3(
                values: _ctrl.reportValueMinutes,
                maxValue: maxValue,
                horizontalInterval: horizontalInterval,
              ),
            );
          },
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // Venda por período (line chart por intervalo)
  // ─────────────────────────────────────────────
  Widget _buildSalesPeriodSection(double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(
          title: "Venda por período",
          icon: Icons.schedule_rounded,
        ),
        const SizedBox(height: 16),
        ValueListenableBuilder(
          valueListenable: _ctrl.stateReportsSells,
          builder: (context, value, child) {
            _calcMaxValuePeriod();
            if (value == StateApp.loading) {
              return _SkeletonCard(height: 250, width: width);
            }
            if (_ctrl.reportValueMinutes.isEmpty) {
              return const _EmptyChartState(
                message: "Sem dados de período disponíveis",
              );
            }
            return _ChartContainer(
              height: 250,
              child: LineChartSample2(
                values: _ctrl.reportValueMinutes,
                maxValue: maxValuePeriod,
                horizontalInterval: horizontalIntervalPeriod,
              ),
            );
          },
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // Builders genéricos para reduzir repetição
  // ─────────────────────────────────────────────

  /// Card assíncrono com skeleton (usado para CardPercentage)
  Widget _buildAsyncCard({
    required ValueListenable listenable,
    required double width,
    required Widget Function() builder,
  }) {
    return ValueListenableBuilder(
      valueListenable: listenable,
      builder: (context, value, child) {
        if (value == StateApp.loading) {
          return _SkeletonCard(height: 100, width: width);
        }
        return builder();
      },
    );
  }

  /// Gráfico assíncrono com skeleton (usado para bar charts)
  Widget _buildAsyncChart({
    required ValueListenable listenable,
    required double width,
    required double skeletonHeight,
    required Widget Function() chartBuilder,
  }) {
    return ValueListenableBuilder(
      valueListenable: listenable,
      builder: (context, value, child) {
        if (value == StateApp.loading) {
          return _SkeletonCard(height: skeletonHeight, width: width);
        }
        return chartBuilder();
      },
    );
  }
}

// ═══════════════════════════════════════════════
// Widgets auxiliares reutilizáveis
// ═══════════════════════════════════════════════

/// Header de seção com ícone e título
class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 18,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface.withValues(alpha: 0.85),
              letterSpacing: -0.3,
            ),
          ),
        ),
      ],
    );
  }
}

/// Container estilizado para gráficos de linha
class _ChartContainer extends StatelessWidget {
  final double height;
  final Widget child;

  const _ChartContainer({required this.height, required this.child});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.maxFinite,
      height: height,
      padding: const EdgeInsets.fromLTRB(4, 12, 16, 8),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.onSurface.withValues(alpha: 0.06),
        ),
      ),
      child: child,
    );
  }
}

/// Gráfico de barras + dica de toque
class _ChartWithHint extends StatelessWidget {
  final double height;
  final Widget chart;

  const _ChartWithHint({required this.height, required this.chart});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Container(
          height: height,
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: colorScheme.onSurface.withValues(alpha: 0.06),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(4, 12, 16, 8),
          child: chart,
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.touch_app_outlined,
              size: 16,
              color: colorScheme.onSurface.withValues(alpha: 0.35),
            ),
            const SizedBox(width: 6),
            Text(
              "Toque para mais informações",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface.withValues(alpha: 0.35),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Skeleton padronizado
class _SkeletonCard extends StatelessWidget {
  final double height;
  final double width;

  const _SkeletonCard({required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      effect: const ShimmerEffect(),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: SizedBox(height: height, width: width),
      ),
    );
  }
}

/// Estado vazio para gráficos sem dados
class _EmptyChartState extends StatelessWidget {
  final String message;

  const _EmptyChartState({required this.message});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.maxFinite,
      height: 180,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.onSurface.withValues(alpha: 0.06),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.insert_chart_outlined_rounded,
            size: 40,
            color: colorScheme.onSurface.withValues(alpha: 0.15),
          ),
          const SizedBox(height: 12),
          Text(
            message,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface.withValues(alpha: 0.35),
            ),
          ),
        ],
      ),
    );
  }
}
