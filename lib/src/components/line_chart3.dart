import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:profair/src/models/value_minute_graph.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:profair/src/utils/format_currency.dart';

class LineChartSample3 extends StatefulWidget {
  LineChartSample3({super.key, required this.values, required this.maxValue, required this.horizontalInterval});

  List<ValueMinutesGraph> values;
  double maxValue;
  double horizontalInterval;

  @override
  State<LineChartSample3> createState() => _LineChartSample3State();
}

class _LineChartSample3State extends State<LineChartSample3> {
  final List<Color> gradientColors = [
    colorSecondary,
    colorPrimary,
  ];

  @override
  Widget build(BuildContext context) {
    return LineChart(mainData());
  }

  LineChartData mainData() {
    return LineChartData(
      lineTouchData: LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (_) => colorTertiary.withValues(alpha: 0.95),
          tooltipRoundedRadius: 12,
          tooltipPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          getTooltipItems: (List<LineBarSpot> barSpots) {
            return barSpots.map((e) {
              final hour = DateFormat.Hm().format(DateTime.parse(widget.values[(e.x).toInt()].hour!));
              final value = formatCurrency(widget.values[(e.x).toInt()].totalValue!);
              return LineTooltipItem(
                '$hour\n',
                const TextStyle(
                  color: Colors.white54,
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                ),
                children: [
                  TextSpan(
                    text: value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              );
            }).toList();
          },
        ),
        getTouchedSpotIndicator: (LineChartBarData barData, List<int> spotIndexes) {
          return spotIndexes.map((index) {
            return TouchedSpotIndicatorData(
              FlLine(
                color: colorPrimary.withValues(alpha: 0.35),
                strokeWidth: 1.5,
                dashArray: [4, 4],
              ),
              FlDotData(
                getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                  radius: 6,
                  color: colorPrimary,
                  strokeWidth: 2.5,
                  strokeColor: Colors.white,
                ),
              ),
            );
          }).toList();
        },
      ),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        drawHorizontalLine: true,
        horizontalInterval: widget.horizontalInterval,
        getDrawingHorizontalLine: (value) => FlLine(
          color: Colors.white.withValues(alpha: 0.07),
          strokeWidth: 1,
        ),
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 28,
            interval: widget.values.length / 3,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(show: false),
      minX: 0,
      minY: 0,
      maxY: widget.maxValue,
      lineBarsData: [
        LineChartBarData(
          spots: widget.values.asMap().entries.map((e) {
            return FlSpot(e.key.toDouble(), e.value.totalValue!);
          }).toList(),
          isCurved: true,
          curveSmoothness: 0.35,
          preventCurveOverShooting: true,
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          barWidth: 2.5,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                colorSecondary.withValues(alpha: 0.28),
                colorPrimary.withValues(alpha: 0.04),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    final textValue = widget.values[value.toInt()].hour!.split(' ');
    return SideTitleWidget(
      meta: meta,
      space: 6,
      child: Text(
        textValue[1],
        style: const TextStyle(
          fontSize: 11,
          color: Colors.white54,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
