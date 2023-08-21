import 'package:profair/src/components/progress_indicator.dart';
import 'package:profair/src/controllers/finish_trading_controller.dart';
import 'package:profair/src/models/nogotiation_model.dart';
import 'package:profair/src/models/product_model.dart';
import 'package:profair/src/components/spacing.dart';
import 'package:profair/src/notification/notification_model.dart';
import 'package:profair/src/notification/notification_service.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';

class ComponentList extends StatefulWidget {
  ComponentList(
      {super.key,
      required this.listItems,
      this.description,
      required this.finishTradingController,
      required this.tradings,
      required this.codeClient,
      required this.codeBranch,
      required this.nameBranch,
      required this.codeProvider});

  final List<ProductModel> listItems;
  final String? description;
  final int? codeProvider;
  final int? codeClient;
  final String? nameBranch;
  final int? codeBranch;
  final FinishTradingController finishTradingController;
  List<NegotiationModel> tradings;

  @override
  State<ComponentList> createState() => _ComponentListState();
}

class _ComponentListState extends State<ComponentList> {
  TextEditingController amountItem = TextEditingController();

  saveOrder() async {
    await widget.finishTradingController.sendOrder(widget.listItems, widget.tradings, widget.codeBranch, widget.codeProvider, widget.codeClient);
    navigatorHome();
  }

  navigatorHome() {
    showNotification();
    Navigator.of(context).pushNamed("/home");
  }

  showNotification() async {
    try {
      Provider.of<NotificationService>(context, listen: false).showNotification(
        CustomNotification(
          id: 1,
          title: "✅ ${widget.codeClient} - Pedido Realizado com sucesso!",
          body: "Lucas seu pedido foi realizado, código ${widget.codeBranch}",
          payload: "/home",
        ),
      );
    } catch (e) {
      print("Error Show Notification: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(top: appMargin),
          child: Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.arrow_back_rounded),
              ),
            ],
          ),
        ),
        Container(
          width: width,
          // decoration: const BoxDecoration(color: colorGreyLigth, borderRadius: BorderRadius.all(Radius.circular(appRadius))),
          padding: const EdgeInsets.all(appPadding),
          // margin: const EdgeInsets.only(bottom: appPadding),
          // margin: const EdgeInsets.all(appPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Detalhes do Pedido",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(Icons.shield_outlined, color: colorSecondary)
                ],
              ),
              const AppSpacing(),
              const AppSpacing(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(bottom: appPadding),
                      decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: colorGrey)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${widget.nameBranch}",
                                style: const TextStyle(fontSize: 18, color: colorGreyDark),
                              ),
                              Text(
                                "${DateTime.now().hour}:${DateTime.now().minute}h",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: colorGreyDark,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const AppSpacing(),
              ValueListenableBuilder(
                  valueListenable: widget.finishTradingController.stateCheckList,
                  builder: (context, value, child) {
                    return value == StateApp.loading
                        ? SkeletonAvatar(
                            style: SkeletonAvatarStyle(
                              height: 80,
                              borderRadius: BorderRadius.circular(50),
                            ),
                          )
                        : Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Quantidade de Itens",
                                    style: TextStyle(fontSize: 18, color: colorGreyDark),
                                  ),
                                  ValueListenableBuilder(
                                    valueListenable: widget.finishTradingController.stateTradings,
                                    builder: (context, value, child) {
                                      return Text(
                                        "${widget.finishTradingController.totalVolume * widget.finishTradingController.totalChecked}",
                                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Valor Total",
                                    style: TextStyle(fontSize: 18, color: colorGreyDark),
                                  ),
                                  ValueListenableBuilder(
                                    valueListenable: widget.finishTradingController.stateTradings,
                                    builder: (context, value, child) {
                                      return Text(
                                        widget.finishTradingController
                                            .formatCurrency(widget.finishTradingController.totalValue * widget.finishTradingController.totalChecked),
                                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          );
                  })
            ],
          ),
        ),
        const AppSpacing(),
        const AppSpacing(),
        Container(
          width: width,
          child: Column(
              children: widget.tradings.asMap().entries.map((e) {
            return InkWell(
              onTap: () {
                if (e.value.checked! && widget.finishTradingController.totalChecked > 1) {
                  widget.finishTradingController.totalChecked -= 1;
                  widget.tradings[e.key].checked = !e.value.checked!;
                } else if (!e.value.checked!) {
                  widget.finishTradingController.totalChecked += 1;
                  widget.tradings[e.key].checked = !e.value.checked!;
                }
                widget.finishTradingController.updateTrading();
              },
              child: Container(
                width: double.maxFinite,
                margin: const EdgeInsets.symmetric(horizontal: appMargin),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: colorGrey)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ValueListenableBuilder(
                        valueListenable: widget.finishTradingController.stateTradings,
                        builder: (context, bool value, child) {
                          return Checkbox(
                            activeColor: colorSecondary,
                            value: e.value.checked,
                            side: const BorderSide(color: colorGrey),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(4),
                              ),
                            ),
                            onChanged: (value) {},
                          );
                        }),
                    Text(
                      e.value.title!.length < 28 ? '${e.value.negotiation} -  ${e.value.title}' : e.value.title!.substring(0, 25),
                      style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
            );
          }).toList()),
        ),
        const AppSpacing(),
        const AppSpacing(),
        Container(
          width: width,
          margin: const EdgeInsets.all(appMargin),
          padding: const EdgeInsets.symmetric(vertical: appMargin / 2, horizontal: appPadding),
          decoration: const BoxDecoration(
            color: colorSecondary,
            borderRadius: BorderRadius.all(
              Radius.circular(appRadius),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Finalizar pedido",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: colorWhite),
              ),
              ValueListenableBuilder(
                valueListenable: widget.finishTradingController.stateFinishTrading,
                builder: (context, value, child) {
                  return value == StateApp.loading
                      ? Container(
                          padding: const EdgeInsets.all(14),
                          child: AppProgressIndicator(colorItem: colorWhite),
                        )
                      : IconButton(
                          onPressed: () {
                            saveOrder();
                          },
                          icon: const Icon(
                            Icons.login_rounded,
                            color: colorWhite,
                          ));
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
