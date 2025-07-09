import 'dart:math';
import 'package:profair/src/models/product_model.dart';
import 'package:profair/src/utils/abreviation_number.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:profair/src/utils/format_currency.dart';

class BarChartSample1 extends StatefulWidget {
  BarChartSample1({
    super.key,
    required this.reportsProducts,
    this.barColor,
    this.legendValue = true,
  });

  final List<ProductModel> reportsProducts;
  final Color barBackgroundColor = transparent;
  final Color? barColor;
  final Color touchedBarColor = colorSecondary;
  final bool legendValue;

  @override
  State<BarChartSample1> createState() => _BarChartSample1State();
}

class _BarChartSample1State extends State<BarChartSample1> {
  final Duration animDuration = const Duration(milliseconds: 350);
  final List<Color> topProductColors = [
    Colors.amber, // 🥇
    Colors.grey, // 🥈
    Colors.brown, // 🥉
  ];
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: BarChart(
        _mainBarData(),
        swapAnimationDuration: animDuration,
      ),
    );
  }

  BarChartData _mainBarData() {
    final maxValue = widget.reportsProducts.map((e) => e.total!).reduce((a, b) => a > b ? a : b);
    final maxY = (maxValue * 1.1).ceilToDouble();

    return maxValue == 0
        ? BarChartData(
            maxY: 1,
            alignment: BarChartAlignment.spaceBetween,
            barTouchData: BarTouchData(enabled: false),
            titlesData: FlTitlesData(show: false),
            gridData: FlGridData(show: false),
            borderData: FlBorderData(show: false),
            barGroups: [],
          )
        : BarChartData(
            maxY: maxY,
            alignment: BarChartAlignment.spaceBetween,
            barTouchData: BarTouchData(
              enabled: true,
              touchTooltipData: BarTouchTooltipData(
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  final prod = widget.reportsProducts[group.x].title!;
                  final value = widget.reportsProducts[group.x].total!;
                  return BarTooltipItem(
                    "$prod\n",
                    const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: widget.legendValue ? formatCurrency(value) : null,
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  );
                },
              ),
              touchCallback: (event, response) {
                setState(() {
                  touchedIndex = response?.spot?.touchedBarGroupIndex ?? -1;
                });
              },
            ),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 44,
                  interval: 1,
                  getTitlesWidget: _buildBottomTitle,
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: maxY / 5,
                  getTitlesWidget: (value, meta) => Text(abbreviateNumber(value)),
                  reservedSize: 40,
                ),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: maxY / 5,
              getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.withOpacity(0.3), strokeWidth: 1),
            ),
            borderData: FlBorderData(show: false),
            barGroups: _buildBarGroups(maxY),
          );
  }

  List<BarChartGroupData> _buildBarGroups(double maxY) {
    final count = min(widget.reportsProducts.length, 10);
    return List.generate(count, (i) {
      final prod = widget.reportsProducts[i];
      final isTouched = i == touchedIndex;
      final baseColor = i < 3 ? topProductColors[i] : (widget.barColor ?? colorPrimary);
      final displayColor = isTouched ? baseColor.withOpacity(0.7) : baseColor;

      return BarChartGroupData(
        x: i,
        barsSpace: 4,
        barRods: [
          BarChartRodData(
            toY: prod.total!,
            width: 18,
            borderRadius: BorderRadius.circular(6),
            gradient: LinearGradient(
              colors: [
                displayColor.withOpacity(0.8),
                displayColor,
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: maxY,
              color: widget.barBackgroundColor,
            ),
          ),
        ],
        showingTooltipIndicators: isTouched ? [0] : [],
      );
    });
  }

  Widget _buildBottomTitle(double value, TitleMeta meta) {
    final idx = value.toInt();
    if (idx < 0 || idx >= widget.reportsProducts.length) return const SizedBox();
    final name = widget.reportsProducts[idx].title!;
    final color = idx < 3 ? topProductColors[idx] : (widget.barColor ?? colorPrimary);

    return SideTitleWidget(
      meta: meta,
      space: 6,
      child: Transform.rotate(
        angle: pi / 4,
        child: SizedBox(
          width: 60,
          child: Text(
            name,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}
