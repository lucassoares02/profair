import 'package:profair/src/components/spacing.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:profair/src/views/home/state_management.dart';
import 'package:profair/src/views/home/home_controller.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CardCount extends StatefulWidget {
  CardCount({super.key, required this.homeController});

  HomeController homeController;

  @override
  State<CardCount> createState() => _CardCountState();
}

class _CardCountState extends State<CardCount> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return ValueListenableBuilder(
        valueListenable: widget.homeController.stateData,
        builder: (context, value, child) {
          return value == StateApp.loading
              ? Container(
                  height: 120,
                  width: width,
                  margin: const EdgeInsets.symmetric(horizontal: appMargin),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Skeletonizer(
                            effect: const ShimmerEffect(),
                            child: Card(
                              child: SizedBox(
                                height: appMargin,
                                width: width / 5,
                              ),
                            ),
                          ),
                          Skeletonizer(
                            effect: const ShimmerEffect(),
                            child: Card(
                              child: SizedBox(
                                height: appPadding,
                                width: width / 2,
                              ),
                            ),
                          ),
                          Skeletonizer(
                            effect: const ShimmerEffect(),
                            child: Card(
                              child: SizedBox(
                                height: appMargin,
                                width: width / 3,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Skeletonizer(
                        effect: ShimmerEffect(),
                        child: Card(
                          margin: EdgeInsets.symmetric(horizontal: 16),
                          child: SizedBox(
                            height: appPadding,
                            width: appPadding,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : StateManagement(
                  width: width,
                  listenable: widget.homeController.stateData,
                  component: InkWell(
                    onTap: () {
                      if (widget.homeController.data!.accessTargeting == 3) {
                        Navigator.of(context).pushNamed('listrequestsstores', arguments: {
                          "codeProvider": 0,
                          "userCode": 0,
                        });
                      } else if (widget.homeController.data!.accessTargeting == 2) {
                        Navigator.of(context).pushNamed('listrequestsstorenegotiation', arguments: {
                          "codeProvider": widget.homeController.data!.codCompany,
                          "userCode": widget.homeController.data!.userCode,
                        });
                      } else {
                        Navigator.of(context).pushNamed('listrequestsstores',
                            arguments: {"codeProvider": widget.homeController.data!.codCompany, "userCode": 0, "visibleBuyers": true, "homeController": widget.homeController});
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: appPadding),
                      width: width,
                      // decoration: const BoxDecoration(color: colorTertiary),
                      padding: const EdgeInsets.all(appPadding),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Pedidos",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: colorGreyDark,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "R\$ ${widget.homeController.data!.valueOrder!}",
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 5),
                              const Text(
                                "Clique e veja mais detalhes",
                                style: TextStyle(fontSize: 12, color: colorGreyDark),
                              ),
                            ],
                          ),
                          const Icon(
                            FontAwesomeIcons.chevronRight,
                            size: 16,
                            color: colorGreyDark,
                          )
                        ],
                      ),
                    ),
                  ),
                );
        });
  }
}
