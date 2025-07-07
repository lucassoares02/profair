import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:profair/src/components/button.dart';
import 'package:profair/src/components/header_list.dart';
import 'package:profair/src/components/loading_list.dart';
import 'package:profair/src/components/spacing.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:profair/src/views/home/home_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ComponentDetails extends StatefulWidget {
  ComponentDetails({
    super.key,
    required this.title,
    required this.content,
    required this.hour,
    required this.image,
    required this.homeController,
  });

  String title;
  String content;
  String hour;
  String image;
  HomeController homeController;

  @override
  State<ComponentDetails> createState() => _ComponentDetailsState();
}

class _ComponentDetailsState extends State<ComponentDetails> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeaderList(
          activeSearch: false,
          label: "Detalhes",
        ),
        ValueListenableBuilder(
            valueListenable: widget.homeController.stateNotification,
            builder: (context, stateNotification, child) {
              return stateNotification == StateApp.loading
                  ? LoadingList(loadingHeader: false)
                  : stateNotification != StateApp.success
                      ? Container()
                      : Container(
                          padding: const EdgeInsets.symmetric(horizontal: appPadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.maxFinite,
                                height: 150,
                                padding: const EdgeInsets.all(appPadding * 2),
                                decoration: BoxDecoration(
                                  color: widget.homeController.notification!.color != null ? Color(int.parse(widget.homeController.notification!.color!)) : Colors.red,
                                  borderRadius: const BorderRadius.all(Radius.circular(appRadius)),
                                ),
                                child: Image.network(
                                  widget.homeController.notification!.imageProvider != null
                                      ? widget.homeController.notification!.imageProvider!
                                      : "https://drive.google.com/uc?export=view&id=1CXbRVXo5QkrjV960dYFfLlrmpf5TfwT-",
                                ),
                              ),
                              const AppSpacing(),
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: .2),
                                      borderRadius: BorderRadius.circular(40),
                                      border: Border.all(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: .2), width: 1),
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: appPadding, vertical: appPadding / 2),
                                    child: Row(children: [
                                      Text(widget.hour),
                                      const SizedBox(width: 5),
                                      Icon(
                                        Icons.sell_outlined,
                                        size: 16,
                                        color: Theme.of(context).colorScheme.onSurface,
                                      ),
                                    ]),
                                  ),
                                ],
                              ),
                              const AppSpacing(),
                              Text(
                                widget.title,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const AppSpacing(),
                              Text(
                                widget.content,
                                style: const TextStyle(
                                  color: colorGreyDark,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 16,
                                ),
                              ),
                              const AppSpacing(),
                              Divider(
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: .2),
                                thickness: 1,
                              ),
                              const AppSpacing(),
                              if (widget.homeController.notification!.provider != 0)
                                AppButton(
                                  onPressButton: () async {
                                    final prefs = await SharedPreferences.getInstance();
                                    final codeBranch = prefs.getString("company");
                                    Modular.to.pushNamed(
                                      "detailsprovider",
                                      arguments: {
                                        "imageProvider": widget.homeController.notification!.imageProvider,
                                        "color": widget.homeController.notification!.color,
                                        "nameProvider": widget.homeController.notification!.nameProvider,
                                        "codeBranch": int.parse(codeBranch!),
                                        "codeProvider": widget.homeController.notification!.provider,
                                      },
                                    );
                                  },
                                  label: "Confira",
                                  iconButton: Icons.arrow_outward_outlined,
                                  colorButton: widget.homeController.notification!.color != null ? Color(int.parse(widget.homeController.notification!.color!)) : Colors.red,
                                )
                              // Container(
                              //   width: double.maxFinite,
                              //   padding: const EdgeInsets.symmetric(horizontal: appPadding, vertical: appMargin),
                              //   decoration: BoxDecoration(
                              //     border: Border.all(color: colorGreyLigth),
                              //     borderRadius: const BorderRadius.all(
                              //       Radius.circular(appRadius),
                              //     ),
                              //   ),
                              //   child: Column(
                              //     crossAxisAlignment: CrossAxisAlignment.start,
                              //     children: [
                              //       Container(
                              //         decoration: const BoxDecoration(
                              //           border: Border(
                              //             bottom: BorderSide(
                              //               color: colorGreyLigth,
                              //             ),
                              //           ),
                              //         ),
                              //         padding: const EdgeInsets.only(bottom: appMargin, top: 5),
                              //         child: Row(
                              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //           children: const [
                              //             Text(
                              //               "Informações adicionais",
                              //               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                              //             ),
                              //             Icon(
                              //               Icons.check_circle,
                              //               size: 16,
                              //               color: Colors.green,
                              //             )
                              //             // Text(
                              //             //   "Novo",
                              //             //   style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green),
                              //             // ),
                              //           ],
                              //         ),
                              //       ),
                              //       const AppSpacing(),
                              //       Column(
                              //         crossAxisAlignment: CrossAxisAlignment.start,
                              //         children: [
                              //           Text("10 de Janeiro de 2024", style: TextStyle(color: colorGrey, fontSize: 12)),
                              //           SizedBox(height: 10),
                              //           Text(
                              //             "Hoje é 10 de janeiro, estamos realizando teste desse layhout, parece que tudo está indo bem!",
                              //             style: TextStyle(fontSize: 12),
                              //           ),
                              //           Container(
                              //             margin: EdgeInsets.symmetric(vertical: 5),
                              //             height: 20,
                              //             decoration: const BoxDecoration(border: Border(left: BorderSide(color: colorGreyLigth, width: 3))),
                              //           ),
                              //           Text("10 de Janeiro, 10:40", style: TextStyle(color: colorGrey, fontSize: 12)),
                              //           SizedBox(height: 10),
                              //           Text(
                              //             "Hoje é 10 de janeiro, estamos realizando teste desse layhout, parece que tudo está indo bem!",
                              //             style: TextStyle(fontSize: 12),
                              //           ),
                              //         ],
                              //       )
                              //     ],
                              //   ),
                              // ),
                            ],
                          ),
                        );
            })
      ],
    ));
  }
}
