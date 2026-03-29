import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:profair/src/components/spacing.dart';
import 'package:profair/src/models/product_model.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:profair/src/utils/format_currency.dart';
import 'package:profair/src/utils/spacing.dart';

class PieChartSample2 extends StatefulWidget {
  const PieChartSample2({super.key, required this.products});

  final List<ProductModel> products;

  @override
  State<StatefulWidget> createState() => PieChart2State();
}

class PieChart2State extends State<PieChartSample2> {
  int touchedIndex = -1;

  List<Color> colors = [
    colorPrimary,
    colorSecondary,
    colorTertiary,
    colorRed,
    colorGreyDark,
    colorBlue,
    colorGreen,
    colorBlack,
    colorCyan,
    colorPurple,
    colorPrimary,
    colorSecondary,
    colorTertiary,
    colorRed,
    colorGreyDark,
    colorBlue,
    colorGreen,
    colorBlack,
    colorCyan,
    colorPurple,
    colorPrimary,
    colorSecondary,
    colorTertiary,
    colorRed,
    colorGrey,
    colorGreyDark,
    colorBlue,
    colorGreen,
    colorBlack,
    colorCyan,
    colorPurple,
    colorPrimary,
    colorSecondary,
    colorTertiary,
    colorRed,
    colorGrey,
    colorGreyDark,
    colorBlue,
    colorGreen,
    colorBlack,
    colorCyan,
    colorPurple,
  ];

  double getTotalValue() {
    return widget.products.fold(0, (sum, item) => sum + item.total!);
  }

  String formatPercentage(double value, double total) {
    if (total == 0) return "0%";
    return "${((value / total) * 100).toStringAsFixed(0)}%";
  }

  @override
  Widget build(BuildContext context) {
    final totalValue = getTotalValue();
    final topProducts = widget.products.asMap().entries.take(10).toList();

    return Column(
      children: [
        const AppSpacing(),
        const AppSpacing(),

        // ── Gráfico ────────────────────────────────────────────────
        SizedBox(
          height: 220,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      if (event is FlTapDownEvent && pieTouchResponse != null && pieTouchResponse.touchedSection != null) {
                        final index = pieTouchResponse.touchedSection!.touchedSectionIndex;
                        setState(() {
                          touchedIndex = (touchedIndex == index) ? -1 : index;
                        });
                      }
                    },
                  ),
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 3,
                  centerSpaceRadius: 72,
                  sections: showingSections(),
                ),
              ),

              // Centro do donut
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    touchedIndex >= 0 && touchedIndex < topProducts.length ? formatPercentage(topProducts[touchedIndex].value.total!, totalValue) : 'Total',
                    style: TextStyle(
                      fontSize: touchedIndex >= 0 ? 20 : 13,
                      fontWeight: FontWeight.w700,
                      color: touchedIndex >= 0 ? colors[touchedIndex] : Theme.of(context).colorScheme.onSurface.withOpacity(0.45),
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    touchedIndex >= 0 && touchedIndex < topProducts.length ? formatCurrency(topProducts[touchedIndex].value.total!) : formatCurrency(totalValue),
                    style: TextStyle(
                      fontSize: touchedIndex >= 0 ? 15 : 18,
                      fontWeight: FontWeight.bold,
                      color: touchedIndex >= 0 ? colors[touchedIndex] : Theme.of(context).colorScheme.onSurface,
                      letterSpacing: -0.3,
                    ),
                  ),
                  if (touchedIndex >= 0 && touchedIndex < topProducts.length)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: SizedBox(
                        width: 120,
                        child: Text(
                          topProducts[touchedIndex].value.title ?? '',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),

        const AppSpacing()
      ],
    );
  }

  List<PieChartSectionData> showingSections() {
    final totalValue = getTotalValue();
    return widget.products.asMap().entries.take(10).map((entry) {
      final index = entry.key;
      final item = entry.value;
      final isTouched = index == touchedIndex;
      final double radius = isTouched ? 46 : 38;
      final Color sectionColor = colors[index];
      final String percentage = formatPercentage(item.total!, totalValue);
      final double pctValue = double.parse(percentage.replaceAll('%', ''));

      return PieChartSectionData(
        color: isTouched ? sectionColor : sectionColor.withOpacity(0.82),
        value: item.total!,
        radius: radius,
        title: isTouched || pctValue < 6 ? '' : percentage,
        titleStyle: const TextStyle(
          fontSize: 12,
          color: colorWhite,
          fontWeight: FontWeight.w700,
        ),
        badgeWidget: null,
        badgePositionPercentageOffset: 0,
      );
    }).toList();
  }
}
