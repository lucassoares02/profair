import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:profair/src/components/button.dart';
import 'package:profair/src/components/header_list.dart';
import 'package:profair/src/controllers/finish_trading_controller.dart';
import 'package:profair/src/models/nogotiation_model.dart';
import 'package:profair/src/models/product_model.dart';
import 'package:profair/src/components/spacing.dart';
import 'package:profair/src/notification/notification_model.dart';
import 'package:profair/src/notification/notification_service.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:profair/src/utils/format_currency.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';
import '../../../models/clients_select_stores_model.dart';

class ComponentList extends StatefulWidget {
  ComponentList({
    super.key,
    required this.listItems,
    this.description,
    required this.finishTradingController,
    required this.tradings,
    required this.codeClient,
    required this.codeBranch,
    required this.nameBranch,
    required this.codeProvider,
    this.codeConsult,
    required this.listBranchs,
  });

  final List<ProductModel> listItems;
  final String? description;
  final int? codeProvider;
  final int? codeConsult;
  final int? codeClient;
  final String? nameBranch;
  final int? codeBranch;
  final FinishTradingController finishTradingController;
  List<NegotiationModel> tradings;
  List<ClientsSelectStoreModel>? listBranchs;

  @override
  State<ComponentList> createState() => _ComponentListState();
}

class _ComponentListState extends State<ComponentList> {
  TextEditingController amountItem = TextEditingController();

  saveOrder() async {
    await widget.finishTradingController.sendOrder(widget.listItems, widget.tradings, widget.codeBranch,
        widget.codeProvider, widget.codeClient, widget.listBranchs!, widget.codeConsult);
    totalCurrentTime();
    navigatorHome();
  }

  navigatorHome() {
    int trade = 0;
    for (int i = 0; i < widget.tradings.length; i++) {
      if (widget.tradings[i].checked!) {
        trade = widget.tradings[i].negotiation!;
        break;
      }
    }
    Navigator.of(context).pushNamed("/tradingsuccess", arguments: {
      "trading": trade,
      "provider": widget.codeProvider,
      "branch": widget.codeBranch,
      "finishTradingController": widget.finishTradingController,
      "value": widget.finishTradingController.formatCurrency(
          (widget.finishTradingController.totalValue * widget.finishTradingController.totalChecked) *
              widget.finishTradingController.totalCheckedBranch),
      "hour": DateFormat.Hm().format(DateTime.now()).toString()
    });
    showNotification();
  }

  showNotification() async {
    try {
      Provider.of<NotificationService>(context, listen: false).showNotification(
        CustomNotification(
          id: 1,
          title: "✅ Bom Trabalho!",
          body: "Pedido realizado com sucesso!",
          payload: "/home",
        ),
      );
    } catch (e) {
      print("Error Show Notification: $e");
    }
  }

  totalCurrentTime() {
    // PARA NOTIFICAR A ATUALIZAÇÃO DO ESTADO DO SALDO
  }

  handleChangeCheckbox(MapEntry<int, NegotiationModel> trading) {
    if (trading.value.checked! && widget.finishTradingController.totalChecked > 1) {
      widget.finishTradingController.totalChecked -= 1;
      widget.tradings[trading.key].checked = !trading.value.checked!;
    } else if (!trading.value.checked!) {
      widget.finishTradingController.totalChecked += 1;
      widget.tradings[trading.key].checked = !trading.value.checked!;
    }
    widget.finishTradingController.updateTrading();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Container(
      constraints: BoxConstraints(minHeight: height - 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderList(activeSearch: false, label: ""),
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
                    const Text(
                      "Detalhes",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ValueListenableBuilder(
                          valueListenable: widget.finishTradingController.stateTradings,
                          builder: (context, value, child) {
                            return Text(
                              widget.finishTradingController.formatCurrency((widget.finishTradingController.totalValue *
                                      widget.finishTradingController.totalChecked) *
                                  widget.finishTradingController.totalCheckedBranch),
                              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: colorSecondary),
                            );
                          },
                        ),
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
                                  : ValueListenableBuilder(
                                      valueListenable: widget.finishTradingController.stateTradings,
                                      builder: (context, value, child) {
                                        return Text(
                                          "${(widget.finishTradingController.totalVolume * widget.finishTradingController.totalChecked) * widget.finishTradingController.totalCheckedBranch}",
                                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                        );
                                      },
                                    );
                            })
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "para ",
                              style: TextStyle(fontSize: 14, color: colorGreyDark),
                            ),
                            Text(
                              "${widget.listBranchs!.first.nameUser}",
                              style: const TextStyle(fontSize: 14, color: colorGreyDark, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Text(
                          // "${DateTime.now().hour}:${DateTime.now().minute}",
                          DateFormat.Hm().format(DateTime.now()),
                          style: const TextStyle(
                            fontSize: 14,
                            color: colorGreyDark,
                          ),
                        )
                      ],
                    ),
                    // const Divider(),

                    const AppSpacing(),
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: colorGrey)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              ValueListenableBuilder(
                                  valueListenable: widget.finishTradingController.stateTradings,
                                  builder: (context, value, child) {
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: widget.listBranchs!.asMap().entries.map((e) {
                                        return e.value.checked!
                                            ? Container(
                                                width: double.maxFinite,
                                                margin: const EdgeInsets.symmetric(vertical: appMargin),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      e.value.documentCompany!,
                                                      style: const TextStyle(fontSize: 14, color: colorGreyDark),
                                                      overflow: TextOverflow.fade,
                                                    ),
                                                    // const SizedBox(height: 5),
                                                    // Text(
                                                    //   e.value.documentCompany.toString(),
                                                    //   style: const TextStyle(fontSize: 14, color: colorGreyDark),
                                                    // ),
                                                  ],
                                                ),
                                              )
                                            : Container();
                                      }).toList(),
                                    );
                                  }),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(appPadding),
                child: Text(
                  "Mercadorias selecionadas",
                  style: TextStyle(fontSize: 18, color: Colors.grey, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 110,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.finishTradingController.actualList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(
                          left: appPadding,
                          right: (index == widget.finishTradingController.actualList.length - 1 ? appPadding : 0)),
                      padding: const EdgeInsets.symmetric(horizontal: appPadding),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.withOpacity(0.5), width: 1.5),
                        borderRadius: BorderRadius.circular(appRadius),
                      ),
                      child: Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${widget.finishTradingController.actualList[index]["quantMercadoria"]}",
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              Text(
                                widget.finishTradingController.actualList[index]["nomeMercadoria"],
                                style: const TextStyle(),
                              ),
                              Text(
                                formatCurrency(
                                    double.parse(widget.finishTradingController.actualList[index]["quantMercadoria"]) *
                                        widget.finishTradingController.actualList[index]["precoMercadoria"]),
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              // const AppSpacing(),
              // const AppSpacing(),
              // const AppSpacing(),
              // const AppSpacing(),
              // Container(
              //   padding: const EdgeInsets.all(appPadding),
              //   child: const Text(
              //     "Selecione as negociações desejadas",
              //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              //   ),
              // ),
              // SizedBox(
              //   width: width,
              //   child: Column(
              //       children: widget.tradings.asMap().entries.map((trading) {
              //     return InkWell(
              //       onTap: () => handleChangeCheckbox(trading),
              //       child: Container(
              //         width: double.maxFinite,
              //         margin: const EdgeInsets.symmetric(horizontal: appMargin),
              //         decoration: const BoxDecoration(
              //           border: Border(bottom: BorderSide(color: colorGrey)),
              //         ),
              //         child: Row(
              //           crossAxisAlignment: CrossAxisAlignment.center,
              //           mainAxisAlignment: MainAxisAlignment.start,
              //           children: [
              //             ValueListenableBuilder(
              //                 valueListenable: widget.finishTradingController.stateTradings,
              //                 builder: (context, bool value, child) {
              //                   return Checkbox(
              //                     activeColor: colorSecondary,
              //                     value: trading.value.checked,
              //                     side: const BorderSide(color: colorGrey),
              //                     shape: const RoundedRectangleBorder(
              //                       borderRadius: BorderRadius.all(
              //                         Radius.circular(4),
              //                       ),
              //                     ),
              //                     onChanged: (value) {
              //                       handleChangeCheckbox(trading);
              //                     },
              //                   );
              //                 }),
              //             Text(
              //               trading.value.title!.length < 28
              //                   ? '${trading.value.negotiation} -  ${trading.value.title}'
              //                   : trading.value.title!.substring(0, 25),
              //               style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
              //             ),
              //           ],
              //         ),
              //       ),
              //     );
              //   }).toList()),
              // ),
              const AppSpacing(),
            ],
          ),
          Column(
            children: [
              if (widget.listBranchs!.length > 1)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: appPadding),
                  child: ExpansionTile(
                    title: const Text(
                      "Deseja adicionar outras lojas?",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    trailing: const Icon(
                      Icons.info_outline,
                      size: 20,
                    ),
                    iconColor: Colors.grey,
                    collapsedIconColor: Colors.grey,
                    tilePadding: const EdgeInsets.all(0),
                    shape: const Border.symmetric(horizontal: BorderSide(color: Colors.transparent)),
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(appMargin),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(appRadius),
                              border: Border.all(
                                color: Colors.grey,
                              ),
                            ),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Importante! Caso outras opções sejam selecionadas, o mesmo pedido será replicado para as demais filiais, confira a diferença de valor na sessão acima.",
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: width,
                            child: Column(
                              children: widget.listBranchs!.asMap().entries.map(
                                (e) {
                                  return InkWell(
                                    onTap: () {
                                      if (e.value.checked! && widget.finishTradingController.totalCheckedBranch > 1) {
                                        widget.finishTradingController.totalCheckedBranch -= 1;
                                        widget.listBranchs![e.key].checked = !e.value.checked!;
                                      } else if (e.value.checked! == false) {
                                        widget.finishTradingController.totalCheckedBranch += 1;
                                        widget.listBranchs![e.key].checked = !e.value.checked!;
                                      }
                                      widget.finishTradingController.updateTrading();
                                    },
                                    child: Container(
                                      width: double.maxFinite,
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
                                                  onChanged: (value) {
                                                    if (e.value.checked! &&
                                                        widget.finishTradingController.totalCheckedBranch > 1) {
                                                      widget.finishTradingController.totalCheckedBranch -= 1;
                                                      widget.listBranchs![e.key].checked = !e.value.checked!;
                                                    } else if (e.value.checked! == false) {
                                                      widget.finishTradingController.totalCheckedBranch += 1;
                                                      widget.listBranchs![e.key].checked = !e.value.checked!;
                                                    }
                                                    widget.finishTradingController.updateTrading();
                                                  },
                                                );
                                              }),
                                          Text(
                                            e.value.nameCompany!.length < 28
                                                ? '${e.value.nameCompany}'
                                                : e.value.nameCompany!.substring(0, 25),
                                            style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ).toList(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              SizedBox(height: appMargin),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: appPadding),
                child: ValueListenableBuilder(
                    valueListenable: widget.finishTradingController.stateFinishTrading,
                    builder: (context, value, child) {
                      return AppButton(
                        label: "Finalizar Pedido",
                        colorButton: colorSecondary,
                        iconButton: Icons.done_all,
                        loading: value == StateApp.loading,
                        onPressButton: () {
                          saveOrder();
                        },
                      );
                    }),
              ),
              const AppSpacing()
            ],
          ),

          // Container(
          //   width: width,
          //   margin: const EdgeInsets.all(appMargin),
          //   padding: const EdgeInsets.symmetric(vertical: appMargin / 2, horizontal: appPadding),
          //   decoration: const BoxDecoration(
          //     color: colorSecondary,
          //     borderRadius: BorderRadius.all(
          //       Radius.circular(appRadius),
          //     ),
          //   ),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       const Text(
          //         "Finalizar pedido",
          //         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: colorWhite),
          //       ),
          //       ValueListenableBuilder(
          //         valueListenable: widget.finishTradingController.stateFinishTrading,
          //         builder: (context, value, child) {
          //           return value == StateApp.loading
          //               ? Container(
          //                   padding: const EdgeInsets.all(14),
          //                   child: AppProgressIndicator(colorItem: colorWhite),
          //                 )
          //               : IconButton(
          //                   onPressed: () {
          //                     saveOrder();
          //                   },
          //                   icon: const Icon(
          //                     Icons.login_rounded,
          //                     color: colorWhite,
          //                   ));
          //         },
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
