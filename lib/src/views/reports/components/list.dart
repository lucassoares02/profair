import 'package:flutter/gestures.dart';
import 'package:profair/src/views/reports/components/card_percentage.dart';
import 'package:profair/src/views/reports/components/chart_negotiation.dart';
import 'package:profair/src/views/reports/components/chart_product.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:profair/src/controllers/reports_controller.dart';
import 'package:profair/src/components/header_list.dart';
import 'package:profair/src/components/spacing.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class ComponentList extends StatefulWidget {
  ComponentList({super.key, required this.reportsController, this.codeProvider});

  int? codeProvider;

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
              CardPercentage(
                title: "Clientes Atendidos",
                content:
                    "Nessa sessão é possível visualizar quantos associados foram atendidos até o momento em relação a quantidade total de associados presentes na feira",
                value: "${double.parse("${widget.reportsController.percentageClients!.percentage}").toStringAsFixed(0)}%",
                footer: "${widget.reportsController.percentageClients!.parcial} de ${widget.reportsController.percentageClients!.total} foram atendidos",
                reportsController: widget.reportsController,
              ),
              const AppSpacing(),
              CardPercentage(
                backgroundColor: colorRed,
                reportsController: widget.reportsController,
                title: "Fornecedores com venda",
                value: "${double.parse("${widget.reportsController.percentageProviders!.percentage}").toStringAsFixed(0)}%",
                footer: "${widget.reportsController.percentageProviders!.parcial} de ${widget.reportsController.percentageProviders!.total} realizaram vendas.",
              ),
              const AppSpacing(),
              const AppSpacing(),
              Text(
                widget.codeProvider == 0 ? "Ranking de Associados" : "Ranking de Clientes",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const AppSpacing(),
              ValueListenableBuilder(
                valueListenable: widget.reportsController.stateReports,
                builder: (context, value, child) {
                  return value == StateApp.loading
                      ? SkeletonAvatar(
                          style: SkeletonAvatarStyle(
                            height: 300,
                            width: width,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        )
                      : Container(
                          padding: const EdgeInsets.only(top: appPadding * 3, right: appPadding * 2, left: appPadding * 2, bottom: appPadding),
                          height: 300,
                          decoration: const BoxDecoration(
                            color: colorGreyLigth,
                            borderRadius: BorderRadius.all(
                              Radius.circular(appRadius),
                            ),
                          ),
                          child: BarChartTeste(reportsClients: widget.reportsController.reportsTotalClient));
                },
              ),

              // const AppSpacing(),
              // const AppSpacing(),
              // const AppSpacing(),
              // const Text(
              //   "Linha de horários",
              //   style: TextStyle(
              //     fontSize: 20,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
              // const AppSpacing(),
              // Container(
              //   padding: EdgeInsets.all(appMargin),
              //   decoration: const BoxDecoration(
              //     color: colorGreyLigth,
              //     borderRadius: BorderRadius.all(
              //       Radius.circular(appRadius),
              //     ),
              //   ),
              //   child: LineChartSample2(),
              // ),
              const AppSpacing(),
              const AppSpacing(),
              const AppSpacing(),
              Text(
                widget.codeProvider == 0 ? "Ranking Fornecedores" : "Ranking de produtos",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const AppSpacing(),

              (widget.codeProvider == 0)
                  ? ValueListenableBuilder(
                      valueListenable: widget.reportsController.stateReports,
                      builder: (context, value, child) {
                        return value == StateApp.loading
                            ? SkeletonAvatar(
                                style: SkeletonAvatarStyle(
                                  height: 300,
                                  width: width,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              )
                            : Container(
                                padding: const EdgeInsets.only(top: appPadding * 3, right: appPadding * 2, left: appPadding * 2, bottom: appPadding),
                                height: 300,
                                decoration: const BoxDecoration(
                                  color: colorGreyLigth,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(appRadius),
                                  ),
                                ),
                                child: BarChartTeste(reportsClients: widget.reportsController.reportsTotalProvider));
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
                            : Container(
                                // padding: const EdgeInsets.only(top: appPadding * 3, right: appPadding * 2, left: appPadding * 2, bottom: appPadding),
                                height: 300,
                                padding: const EdgeInsets.only(top: appPadding * 3),
                                decoration: const BoxDecoration(
                                  color: colorGreyLigth,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(appRadius),
                                  ),
                                ),
                                child: BarChartSample1(reportsProducts: widget.reportsController.reportsTotalProducts));
                      }),
            ],
          ),
        ),
      ],
    );
  }
}
