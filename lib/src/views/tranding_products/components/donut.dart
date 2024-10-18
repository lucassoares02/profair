import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
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
    colorPurple
  ];

  double getTotalValue() {
    return widget.products.fold(0, (sum, item) => sum + item.total!);
  }

  String formatPercentage(double value, double total) {
    if (total == 0) {
      return "0%";
    }
    return "${((value / total) * 100).toStringAsFixed(1)}%";
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AspectRatio(
            aspectRatio: 1,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions || pieTouchResponse == null || pieTouchResponse.touchedSection == null) {
                            touchedIndex = -1;
                            return;
                          }
                          touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                        });
                      },
                    ),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    sectionsSpace: 4,
                    centerSpaceRadius: 90,
                    sections: showingSections(),
                  ),
                ),
                Positioned(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        formatCurrency(getTotalValue()),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<PieChartSectionData>? showingSections() {
    final totalValue = getTotalValue();

    return widget.products.asMap().entries.map((item) {
      final isTouched = item.key == touchedIndex;
      const fontSize = 15.0;
      final radius = isTouched ? 43.0 : 40.0;
      const style = TextStyle(fontSize: fontSize, color: colorWhite, fontWeight: FontWeight.bold);

      final double value = item.value.total!;
      final String percentage = formatPercentage(value, totalValue);

      return PieChartSectionData(
        badgeWidget: isTouched
            ? Container(
                decoration: BoxDecoration(color: colors[item.key], borderRadius: BorderRadius.all(Radius.circular(radius))),
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: appPadding),
                child: Text(
                  "${item.value.title}",
                  style: style,
                ),
              )
            : Container(),
        color: colors[item.key],
        value: value,
        title: isTouched ? "" : percentage,
        radius: radius,
        titleStyle: style,
      );
    }).toList();
  }
}
