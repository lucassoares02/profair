import 'package:profair/src/components/barcode_scanner_simple_sell.dart';
import 'package:profair/src/models/login_model.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:profair/src/views/home/state_management.dart';
import 'package:profair/src/views/home/home_controller.dart';
import 'package:profair/src/utils/spacing.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:skeletonizer/skeletonizer.dart';
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
  actionButton(String? route, double height) async {
    if (route == "users") {
      navigatorRoutes(route, {});
    } else if (route == "selectstore") {
      // scannerQrCode();
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => BarcodeScannerSimpleSell(
      //       homeController: widget.homeController,
      //     ),
      //   ),
      // );
      showDialog(
        context: context,
        barrierDismissible: true, // fecha se clicar fora
        builder: (context) => Dialog(
          backgroundColor: Colors.transparent, // remove o fundo branco padrão
          insetPadding: const EdgeInsets.all(16), // margem nas bordas
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              height: height * 0.8, // defina o tamanho do seu scanner
              child: BarcodeScannerSimpleSell(
                homeController: widget.homeController,
              ),
            ),
          ),
        ),
      );

      // navigatorRoutes("preorder", widget.homeController);
      // navigatorRoutes("customers", widget.homeController);
    } else if (route == "productsprovider") {
      navigatorRoutes(route, {"codeProvider": widget.homeController.data!.codCompany, "codeClient": 0, "nextScreen": true});
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
      navigatorRoutes(route, widget.homeController);
    } else if (route == "reports") {
      navigatorRoutes(route, {
        "accessTargeting": widget.homeController.data!.accessTargeting,
        "codeProvider": widget.homeController.data!.accessTargeting == 2 ? widget.homeController.data!.userCode : widget.homeController.data!.codCompany
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
    final height = MediaQuery.of(context).size.height;

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
                  return const Skeletonizer(
                    effect: ShimmerEffect(),
                    child: Card(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      child: SizedBox(
                        height: 60,
                        width: 60,
                      ),
                    ),
                  );
                }),
          ),
          component: SizedBox(
            height: 100,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: widget.homeController.categories.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      actionButton(widget.homeController.categories[index].route, height);
                      // testeInterno();
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: (index == 0) ? 20 : appPadding * 1.3, right: (index == widget.homeController.categories.length - 1) ? appPadding * 1.3 : 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(50)),
                              border: Border.all(color: colorSecondary, width: 2),
                              color: colorWhite,
                            ),
                            padding: const EdgeInsets.all(3),
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
                                size: 22,
                                color: colorWhite,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            '${widget.homeController.categories[index].title}',
                            style: const TextStyle(fontWeight: FontWeight.w500),
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
