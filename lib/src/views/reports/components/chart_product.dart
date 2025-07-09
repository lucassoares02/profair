import 'dart:math';
import 'package:profair/src/models/total_value_clients.dart';
import 'package:profair/src/utils/abreviation_number.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:profair/src/utils/format_currency.dart';

class BarChartTeste extends StatefulWidget {
  BarChartTeste({
    super.key,
    required this.reportsClients,
    this.barColor = colorPrimary,
    this.barBackgroundColor = transparent,
    this.touchedBarColor = colorSecondary,
    this.legendValue = true,
  });

  final List<TotalValueClients> reportsClients;
  final Color barColor;
  final Color barBackgroundColor;
  final Color touchedBarColor;
  final bool legendValue;

  @override
  State<BarChartTeste> createState() => _BarChartTesteState();
}

class _BarChartTesteState extends State<BarChartTeste> {
  final Duration animDuration = const Duration(milliseconds: 350);
  final List<Color> topClientColors = [
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
        _buildChartData(),
        swapAnimationDuration: animDuration,
      ),
    );
  }

  BarChartData _buildChartData() {
    if (widget.reportsClients.isEmpty) {
      return BarChartData();
    }

    final maxValue = widget.reportsClients.map((c) => c.total!).reduce((a, b) => a > b ? a : b);
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
                getTooltipItem: (group, _, rod, __) {
                  final client = widget.reportsClients[group.x].client!;
                  final value = widget.reportsClients[group.x].total!;
                  return BarTooltipItem(
                    '$client\n',
                    const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: formatCurrency(value),
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
                  reservedSize: 40,
                  getTitlesWidget: (value, _) => Text(
                    abbreviateNumber(value),
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
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
    final count = min(widget.reportsClients.length, 10);
    return List.generate(count, (i) {
      final clientData = widget.reportsClients[i];
      final isTouched = i == touchedIndex;
      final baseColor = i < 3 ? topClientColors[i] : widget.barColor;
      final displayColor = isTouched ? widget.touchedBarColor : baseColor;

      return BarChartGroupData(
        x: i,
        barsSpace: 4,
        barRods: [
          BarChartRodData(
            toY: clientData.total!,
            width: 18,
            borderRadius: BorderRadius.circular(6),
            gradient: LinearGradient(
              colors: [displayColor.withOpacity(0.8), displayColor],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: maxY,
              color: widget.barBackgroundColor,
            ),
            borderSide: isTouched ? BorderSide(color: widget.touchedBarColor) : const BorderSide(color: Colors.transparent),
          ),
        ],
        showingTooltipIndicators: isTouched ? [0] : [],
      );
    });
  }

  Widget _buildBottomTitle(double value, TitleMeta meta) {
    final idx = value.toInt();
    if (idx < 0 || idx >= widget.reportsClients.length) return const SizedBox();
    final name = widget.reportsClients[idx].client!;
    final color = idx < 3 ? topClientColors[idx] : widget.barColor;

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
