import 'dart:developer';

import 'package:profair/src/models/login_model.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:profair/src/views/home/state_management.dart';
import 'package:profair/src/views/home/home_controller.dart';
import 'package:profair/src/utils/spacing.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:skeletons/skeletons.dart';
import 'package:flutter/material.dart';

class AppActions extends StatefulWidget {
  const AppActions({
    super.key,
    required this.homeController,
  });

  final HomeController homeController;

  @override
  State<AppActions> createState() => _AppActionsState();
}

class _AppActionsState extends State<AppActions> {
  actionButton(String? route) {
    if (route == "selectstore") {
      navigatorRoutes("preorder", widget.homeController);
    } else if (route == "productsprovider") {
      navigatorRoutes(
          route, {"codeProvider": widget.homeController.data!.codCompany, "codeClient": 0, "nextScreen": true});
    } else if (route == "clients") {
      navigatorRoutes(
        route,
        {
          "codeProvider": widget.homeController.data!.codCompany,
          "accessTargenting": widget.homeController.data!.accessTargeting,
          "merchandise": 0,
          "codeTrading": 0,
        },
      );
    } else if (route == "tradings") {
      navigatorRoutes(route, widget.homeController.data!.codCompany);
    } else if (route == "reports") {
      inspect(widget.homeController.data);
      navigatorRoutes(route, {
        "accessTargeting": widget.homeController.data!.accessTargeting,
        "codeProvider": widget.homeController.data!.accessTargeting == 2
            ? widget.homeController.data!.userCode
            : widget.homeController.data!.codCompany
      });
    } else if (route == "providerbygroup") {
      navigatorRoutes(
        route,
        {
          "codeClient": widget.homeController.data!.userCode,
        },
      );
    } else if (route == "selectprovider") {
      if (widget.homeController.data!.accessTargeting == 2) {
        navigatorRoutes(
          route,
          {
            "codeClient": widget.homeController.data!.userCode,
            "codeBuyer": 0,
            "codeBranch": widget.homeController.data!.codCompany,
          },
        );
      } else {
        navigatorRoutes(route, {"codeClient": 0, "codeBuyer": 0, "codeBranch": 0});
      }
    } else if (route == "ticket") {
      navigatorRoutes(route, widget.homeController);
    }
  }

  testeInterno() async {
    LoginModel? response = await widget.homeController.findClient("1000000065510");
    navigatorRoutes("selectstore", {"client": response, "codeProvider": widget.homeController.data!.codCompany});
  }

  accessCamPermission() async {
    final PermissionStatus status = await Permission.camera.request();
    return status;
  }

  navigatorRoutes(route, data) {
    Navigator.of(context).pushNamed(
      route,
      arguments: data,
    );
  }

  @override
  void initState() {
    super.initState();
    // widget.homeController.getCategories();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return ValueListenableBuilder(
      valueListenable: widget.homeController.stateData,
      builder: (context, value, _) {
        return StateManagement(
          width: width,
          listenable: widget.homeController.stateData,
          widgetLoading: Container(
            margin: const EdgeInsets.only(left: 10),
            height: 60,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: 6,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: SkeletonAvatar(
                      style: SkeletonAvatarStyle(height: 60, width: 60, borderRadius: BorderRadius.circular(50)),
                    ),
                  );
                }),
          ),
          component: SizedBox(
            height: 90,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: widget.homeController.categories.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      actionButton(widget.homeController.categories[index].route);
                      // testeInterno();
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                          left: (index == 0) ? 20 : appMargin,
                          right: (index == widget.homeController.categories.length - 1) ? appMargin : 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(50)),
                              border: Border.all(color: colorSecondary, width: 2),
                              color: colorWhite,
                            ),
                            padding: const EdgeInsets.all(2),
                            child: Container(
                              padding: const EdgeInsets.all(appPadding),
                              decoration: const BoxDecoration(
                                color: colorSecondary,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(50),
                                ),
                              ),
                              child: Icon(
                                widget.homeController.categories[index].icon,
                                size: 20,
                                color: colorWhite,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            '${widget.homeController.categories[index].title}',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          ),
        );
      },
    );
  }
}
