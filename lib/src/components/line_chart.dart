import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:profair/src/models/value_minute_graph.dart';
import 'package:profair/src/utils/format_currency.dart';

class LineChartSample2 extends StatefulWidget {
  LineChartSample2({super.key, required this.values, required this.maxValue, required this.horizontalInterval});

  List<ValueMinutesGraph> values;
  double maxValue;
  double horizontalInterval;

  @override
  State<LineChartSample2> createState() => _LineChartSample2State();
}

class _LineChartSample2State extends State<LineChartSample2> {
  List<Color> gradientColors = [
    Colors.cyan,
    Colors.blue,
  ];

  @override
  Widget build(BuildContext context) {
    return LineChart(
      mainData(),
    );
  }

  LineChartData mainData() {
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(getTooltipItems: (List<LineBarSpot> barSpots) {
          return barSpots.map((e) {
            return LineTooltipItem(
              "${DateFormat.Hm().format(DateTime.parse(widget.values[(e.x).toInt()].hour!))} - ${formatCurrency(widget.values[(e.x).toInt()].value!)}",
              const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            );
          }).toList();
        }),
      ),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        drawHorizontalLine: true,
        horizontalInterval: widget.horizontalInterval,
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: widget.values.length / 3,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      minX: 0,
      minY: 0,
      maxY: widget.maxValue,
      lineBarsData: [
        LineChartBarData(
          spots: widget.values.asMap().entries.map((e) {
            return FlSpot((e.key).toDouble(), e.value.value!);
          }).toList(),
          isCurved: false,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontSize: 15,
    );
    Widget text;

    final textValue = widget.values[value.toInt()].hour!.split(" ");

    text = Text(textValue[1], style: style);

    return SideTitleWidget(
      child: text,
      meta: meta,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '10K';
        break;
      case 3:
        text = '30k';
        break;
      case 5:
        text = '50k';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }
}
