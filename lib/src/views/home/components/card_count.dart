import 'package:profair/src/components/spacing.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:profair/src/views/home/state_management.dart';
import 'package:profair/src/views/home/home_controller.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:profair/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

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
                  margin: const EdgeInsets.symmetric(horizontal: appPadding),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SkeletonAvatar(
                            style: SkeletonAvatarStyle(
                              height: appPadding,
                              width: width / 2,
                              borderRadius: BorderRadius.circular(appRadius),
                            ),
                          ),
                          const AppSpacing(),
                          SkeletonAvatar(
                            style: SkeletonAvatarStyle(
                              height: appMargin,
                              width: width / 3,
                              borderRadius: BorderRadius.circular(appRadius),
                            ),
                          ),
                        ],
                      ),
                      SkeletonAvatar(
                        style: SkeletonAvatarStyle(
                          height: appPadding,
                          width: appPadding,
                          borderRadius: BorderRadius.circular(appRadius),
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
                        Navigator.of(context).pushNamed('listrequestsstores', arguments: {
                          "codeProvider": 0,
                          "userCode": widget.homeController.data!.userCode,
                        });
                      } else {
                        Navigator.of(context).pushNamed('listrequestsstores', arguments: {
                          "codeProvider": widget.homeController.data!.codCompany,
                          "userCode": 0,
                        });
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
