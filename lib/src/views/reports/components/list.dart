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
  ComponentList({super.key, required this.reportsController, this.codeProvider, this.accessTargeting});

  int? codeProvider;
  int? accessTargeting;

  final ReportsController reportsController;

  @override
  State<ComponentList> createState() => _ComponentListState();
}

class _ComponentListState extends State<ComponentList> {
  double maxValue = 10000;
  double horizontalInterval = 5000;
  double maxValuePeriod = 20000;
  double horizontalIntervalPeriod = 5000;

  getMaxValue() {
    for (int i = 0; i < widget.reportsController.reportValueMinutes.length; i++) {
      if (widget.reportsController.reportValueMinutes[i].totalValue! > maxValue) {
        maxValue = widget.reportsController.reportValueMinutes[i].totalValue! + widget.reportsController.reportValueMinutes[i].totalValue!;
      }
    }
    print("MaxValue $maxValue");
    horizontalInterval = maxValue / 5;
  }

  getMaxValuePeriod() {
    for (int i = 0; i < widget.reportsController.reportValueMinutes.length; i++) {
      if (widget.reportsController.reportValueMinutes[i].value! > maxValuePeriod) {
        maxValuePeriod = widget.reportsController.reportValueMinutes[i].value! + widget.reportsController.reportValueMinutes[i].value! * 0.2;
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
        Container(
          padding: const EdgeInsets.all(appPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.accessTargeting == 3)
                ValueListenableBuilder(
                    valueListenable: widget.reportsController.statePercentageClients,
                    builder: (context, value, child) {
                      return value == StateApp.loading
                          ? Skeletonizer(
                              effect: const ShimmerEffect(),
                              child: Card(
                                child: SizedBox(
                                  height: 100,
                                  width: width,
                                ),
                              ),
                            )
                          : CardPercentage(
                              backgroundColor: colorRed,
                              reportsController: widget.reportsController,
                              title: "Fornecedores com venda",
                              value: widget.reportsController.percentageProviders!.percentage,
                              footer: "${widget.reportsController.percentageProviders!.parcial} de ${widget.reportsController.percentageProviders!.total} realizaram vendas.",
                            );
                    }),
              const AppSpacing(),
              if (widget.accessTargeting == 3 || widget.accessTargeting == 1)
                Text(
                  widget.accessTargeting == 3 ? "Ranking Fornecedores" : "Ranking de produtos",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              const AppSpacing(),
              if (widget.accessTargeting == 3 || widget.accessTargeting == 1)
                (widget.accessTargeting == 3)
                    ? ValueListenableBuilder(
                        valueListenable: widget.reportsController.stateReportsProducts,
                        builder: (context, value, child) {
                          return value == StateApp.loading
                              ? Skeletonizer(
                                  effect: const ShimmerEffect(),
                                  child: Card(
                                    child: SizedBox(
                                      height: 300,
                                      width: width,
                                    ),
                                  ),
                                )
                              : Column(
                                  children: [
                                    SizedBox(
                                      height: 300,
                                      child: BarChartTeste(reportsClients: widget.reportsController.reportsTotalProvider),
                                    ),
                                    const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.touch_app_outlined,
                                          size: 20,
                                        ),
                                        Text(
                                          "Toque para obter mais informações",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                        },
                      )
                    : ValueListenableBuilder(
                        valueListenable: widget.reportsController.stateReportsProducts,
                        builder: (context, value, child) {
                          return value == StateApp.loading
                              ? Skeletonizer(
                                  effect: const ShimmerEffect(),
                                  child: Card(
                                    child: SizedBox(
                                      height: 300,
                                      width: width,
                                    ),
                                  ),
                                )
                              // : BarChartTeste(listItems: widget.reportsController.reportsTotalProducts);
                              : Column(
                                  children: [
                                    SizedBox(
                                        // padding: const EdgeInsets.only(top: appPadding * 3, right: appPadding * 2, left: appPadding * 2, bottom: appPadding),
                                        height: 300,
                                        child: BarChartSample1(
                                          reportsProducts: widget.reportsController.reportsTotalProducts,
                                          barColor: colorSecondary,
                                        )),
                                    const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.touch_app_outlined,
                                          size: 20,
                                        ),
                                        Text(
                                          "Toque para obter mais informações",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                        }),
              const AppSpacing(),
              const AppSpacing(),
              ValueListenableBuilder(
                  valueListenable: widget.reportsController.statePercentageClients,
                  builder: (context, value, child) {
                    return value == StateApp.loading
                        ? Skeletonizer(
                            effect: const ShimmerEffect(),
                            child: Card(
                              child: SizedBox(
                                height: 100,
                                width: width,
                              ),
                            ),
                          )
                        : CardPercentage(
                            title: widget.accessTargeting == 1 || widget.accessTargeting == 3 ? "Clientes Atendidos" : "Fornecedores visitados",
                            content:
                                "Nessa sessão é possível visualizar quantos ${widget.accessTargeting == 1 || widget.accessTargeting == 3 ? "associados" : "fornecedores"} foram atendidos até o momento em relação a quantidade total presentes no evento.",
                            value: widget.reportsController.percentageClients!.percentage,
                            footer: "${widget.reportsController.percentageClients!.parcial} de ${widget.reportsController.percentageClients!.total} foram atendidos",
                            reportsController: widget.reportsController,
                          );
                  }),
              const AppSpacing(),
              const AppSpacing(),
              Text(
                widget.accessTargeting == 1
                    ? "Ranking de Clientes"
                    : widget.accessTargeting == 2
                        ? "Ranking de Fornecedores"
                        : "Ranking de Associados",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "Aqui você pode acompanhar o ranking de valores movimentados até agora para sua empresa. Para saber mais sobre os dados e informações toque nas barras do gráfico.",
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
              const AppSpacing(),
              const AppSpacing(),
              ValueListenableBuilder(
                valueListenable: widget.reportsController.stateReports,
                builder: (context, value, child) {
                  return value == StateApp.loading
                      ? Skeletonizer(
                          effect: const ShimmerEffect(),
                          child: Card(
                            child: SizedBox(
                              height: 250,
                              width: width,
                            ),
                          ),
                        )
                      : Column(
                          children: [
                            SizedBox(
                                height: 300,
                                child: BarChartTeste(
                                  reportsClients: widget.reportsController.reportsTotalClient,
                                  barColor: colorBlueDark,
                                  touchedBarColor: colorBlue,
                                )),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.touch_app_outlined,
                                  size: 20,
                                ),
                                Text(
                                  "Toque para obter mais informações",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                },
              ),
              const AppSpacing(),
              const AppSpacing(),
              if (widget.accessTargeting == 1)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Evolução das vendas",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )),
                    const AppSpacing(),
                    ValueListenableBuilder(
                      valueListenable: widget.reportsController.stateReportsSells,
                      builder: (context, value, child) {
                        getMaxValue();
                        return value == StateApp.loading
                            ? Skeletonizer(
                                effect: const ShimmerEffect(),
                                child: Card(
                                  child: SizedBox(
                                    height: 250,
                                    width: width,
                                  ),
                                ),
                              )
                            : widget.reportsController.reportValueMinutes.isNotEmpty
                                ? Container(
                                    width: double.maxFinite,
                                    height: 250,
                                    padding: const EdgeInsets.all(5),
                                    child: LineChartSample3(
                                      values: widget.reportsController.reportValueMinutes,
                                      maxValue: maxValue,
                                      horizontalInterval: horizontalInterval,
                                    ),
                                  )
                                : Container();
                      },
                    ),
                    const AppSpacing(),
                    const AppSpacing(),
                    const Text("Venda por período",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )),
                    const AppSpacing(),
                    ValueListenableBuilder(
                      valueListenable: widget.reportsController.stateReportsSells,
                      builder: (context, value, child) {
                        getMaxValuePeriod();
                        return value == StateApp.loading
                            ? Skeletonizer(
                                effect: const ShimmerEffect(),
                                child: Card(
                                  child: SizedBox(
                                    height: 250,
                                    width: width,
                                  ),
                                ),
                              )
                            : widget.reportsController.reportValueMinutes.isNotEmpty
                                ? Container(
                                    width: double.maxFinite,
                                    height: 250,
                                    padding: const EdgeInsets.all(5),
                                    child: LineChartSample2(
                                      values: widget.reportsController.reportValueMinutes,
                                      maxValue: maxValuePeriod,
                                      horizontalInterval: horizontalIntervalPeriod,
                                    ),
                                  )
                                : Container();
                      },
                    ),
                  ],
                )
            ],
          ),
        ),
      ],
    );
  }
}
