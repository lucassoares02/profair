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
import 'package:skeletons/skeletons.dart';

class ComponentList extends StatefulWidget {
  ComponentList({super.key, required this.reportsController, this.codeProvider, this.accessTargeting});

  int? codeProvider;
  int? accessTargeting;

  final ReportsController reportsController;

  @override
  State<ComponentList> createState() => _ComponentListState();
}

class _ComponentListState extends State<ComponentList> {
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
                    valueListenable: widget.reportsController.stateReportsProducts,
                    builder: (context, value, child) {
                      return value == StateApp.loading
                          ? SkeletonAvatar(
                              style: SkeletonAvatarStyle(
                                height: 100,
                                width: width,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            )
                          : CardPercentage(
                              backgroundColor: colorRed,
                              reportsController: widget.reportsController,
                              title: "Fornecedores com venda",
                              value: widget.reportsController.percentageProviders!.percentage,
                              footer:
                                  "${widget.reportsController.percentageProviders!.parcial} de ${widget.reportsController.percentageProviders!.total} realizaram vendas.",
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
                              ? SkeletonAvatar(
                                  style: SkeletonAvatarStyle(
                                    height: 300,
                                    width: width,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                )
                              : Column(
                                  children: [
                                    SizedBox(
                                        height: 300,
                                        child: BarChartTeste(
                                            reportsClients: widget.reportsController.reportsTotalProvider)),
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
                              ? SkeletonAvatar(
                                  style: SkeletonAvatarStyle(
                                    height: 300,
                                    width: width,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                )
                              // : BarChartTeste(listItems: widget.reportsController.reportsTotalProducts);
                              : Column(
                                  children: [
                                    SizedBox(
                                        // padding: const EdgeInsets.only(top: appPadding * 3, right: appPadding * 2, left: appPadding * 2, bottom: appPadding),
                                        height: 300,
                                        child: BarChartSample1(
                                            reportsProducts: widget.reportsController.reportsTotalProducts)),
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
                        ? SkeletonAvatar(
                            style: SkeletonAvatarStyle(
                              height: 100,
                              width: width,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          )
                        : CardPercentage(
                            title: widget.accessTargeting == 1 || widget.accessTargeting == 3
                                ? "Clientes Atendidos"
                                : "Fornecedores visitados",
                            content:
                                "Nessa sessão é possível visualizar quantos ${widget.accessTargeting == 1 || widget.accessTargeting == 3 ? "associados" : "fornecedores"} foram atendidos até o momento em relação a quantidade total presentes no evento.",
                            value: widget.reportsController.percentageClients!.percentage,
                            footer:
                                "${widget.reportsController.percentageClients!.parcial} de ${widget.reportsController.percentageClients!.total} foram atendidos",
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
                      ? SkeletonAvatar(
                          style: SkeletonAvatarStyle(
                            height: 250,
                            width: width,
                            borderRadius: BorderRadius.circular(10),
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
            ],
          ),
        ),
      ],
    );
  }
}
