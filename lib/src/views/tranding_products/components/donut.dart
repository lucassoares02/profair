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
    colorPurple
  ];

  double getTotalValue() {
    return widget.products.fold(0, (sum, item) => sum + item.total!);
  }

  String formatPercentage(double value, double total) {
    if (total == 0) {
      return "0%";
    }
    return "${((value / total) * 100).toStringAsFixed(0)}%";
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
                        // só processa quando for um "tap down" e houver de fato uma seção tocada
                        if (event is FlTapDownEvent && pieTouchResponse != null && pieTouchResponse.touchedSection != null) {
                          final index = pieTouchResponse.touchedSection!.touchedSectionIndex;
                          setState(() {
                            // se já estava selecionada, desliga; se não, seleciona
                            touchedIndex = (touchedIndex == index) ? -1 : index;
                          });
                        }
                        // nos demais eventos (tap up, pan, etc.) não faz nada,
                        // logo a seleção permanece até um novo tap down
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

  List<PieChartSectionData> showingSections() {
    final totalValue = getTotalValue();
    return widget.products.asMap().entries.take(10).map((entry) {
      final index = entry.key;
      final item = entry.value;
      final isTouched = index == touchedIndex;

      // raio maior quando tocado
      final double radius = isTouched ? 43 : 40;
      // força o fundo 100% opaco
      final Color sectionColor = colors[index].withOpacity(1.0);
      // percentual formatado
      final String percentage = formatPercentage(item.total!, totalValue);

      // só cria o badge quando tocado
      final Widget? badge = isTouched
          ? Container(
              decoration: BoxDecoration(
                color: sectionColor, // fundo opaco
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 5,
                horizontal: appPadding,
              ),
              child: Text(
                "$percentage – ${item.title}",
                style: const TextStyle(
                  fontSize: 15,
                  color: colorWhite,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null;

      return PieChartSectionData(
        color: sectionColor,
        value: item.total!,
        radius: radius,
        title: (isTouched || double.parse(percentage.replaceAll('%', '')) < 5) ? '' : percentage,
        titleStyle: const TextStyle(
          fontSize: 15,
          color: colorWhite,
          fontWeight: FontWeight.bold,
        ),

        // aqui: posiciona o badge mais perto do centro, evitando overflow
        badgePositionPercentageOffset: isTouched ? 0.75 : 0.0,
        badgeWidget: badge,
      );
    }).toList();
  }
}
