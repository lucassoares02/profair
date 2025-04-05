import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:profair/src/components/button.dart';
import 'package:profair/src/components/header_list.dart';
import 'package:profair/src/components/loading_list.dart';
import 'package:profair/src/controllers/trading_products_controller.dart';
import 'package:profair/src/models/nogotiation_model.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:profair/src/utils/format_currency.dart';
import 'package:profair/src/views/home/state_management.dart';
import 'package:profair/src/components/spacing.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:profair/generated/l10n.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:profair/src/views/tranding_products/components/badge.dart';
import 'package:profair/src/views/tranding_products/components/donut.dart';

import '../../../models/clients_select_stores_model.dart';

class ComponentList extends StatefulWidget {
  const ComponentList({
    super.key,
    this.description,
    required this.state,
    required this.codeProvider,
    required this.codeBranch,
    required this.nameBranch,
    this.codeConsult,
    required this.codeTrading,
    required this.codeClient,
    required this.tradingProductsController,
    required this.tradings,
    required this.listBranchs,
  });

  final String? description;
  final ValueListenable state;
  final TradingProductsController tradingProductsController;
  final int? codeProvider;
  final int? codeBranch;
  final int? codeConsult;
  final String? nameBranch;
  final int? codeClient;
  final int? codeTrading;
  final List<NegotiationModel>? tradings;
  final List<ClientsSelectStoreModel>? listBranchs;

  @override
  State<ComponentList> createState() => _ComponentListState();
}

class _ComponentListState extends State<ComponentList> {
  TextEditingController amountItem = TextEditingController();
  FocusNode selectedProduct = FocusNode();
  FocusNode searchBar = FocusNode();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return StateManagement(
      width: width,
      listenable: widget.state,
      widgetLoading: LoadingList(icon: Icons.shopping_basket_rounded, label: "Produtos"),
      component: Column(
        children: [
          HeaderList(
            icon: Icons.shopping_basket_rounded,
            onSearch: (String? value) {
              widget.tradingProductsController.visibleText.value = false;
              widget.tradingProductsController.search(value);
            },
            aditionAction: Row(
              children: [
                if (widget.codeClient == 0)
                  IconButton(
                      onPressed: () {
                        widget.tradingProductsController.exportData(widget.codeProvider, widget.codeTrading, widget.codeBranch);
                      },
                      icon: const Icon(
                        Icons.share_rounded,
                      ))
              ],
            ),
            onSort: () {
              widget.tradingProductsController.sort();
            },
            label: "Produtos",
          ),
          Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: appPadding),
                padding: EdgeInsets.all(appPadding),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(appRadius),
                  border: Border.all(
                    color: colorGrey,
                  ),
                ),
                child: Column(children: [
                  Row(
                    children: [
                      const Text(
                        "Detalhes da venda",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      const SizedBox(width: 5),
                      AppBadge(
                        borderRadius: 8,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        color: colorQuartiary.withOpacity(0.2),
                        child: const Text(
                          "Produtos",
                          style: TextStyle(color: colorQuartiary, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                  // PieChartSample2(products: widget.tradingProductsController.productsTrading),
                  const AppSpacing(),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Resumo do pedido",
                            style: TextStyle(color: null),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.info_outline,
                            size: 20,
                            color: colorGrey,
                          )
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: colorSecondary.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Icon(
                              Icons.numbers,
                              size: 18,
                              color: colorSecondary,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            "Quantidade de itens",
                            style: TextStyle(color: null),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "${widget.tradingProductsController.detailsSell!.quantity}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          AppBadge(
                            color: colorTertiary.withOpacity(0.3),
                            child: const Icon(
                              Icons.bolt,
                              size: 18,
                              color: colorTertiary,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            "Volume",
                            style: TextStyle(color: null),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                            decoration: BoxDecoration(
                              color: colorBlue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: colorBlue),
                            ),
                            child: const Text(
                              "Agregado",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: colorBlue),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            "${widget.tradingProductsController.detailsSell!.volume}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      )
                    ],
                  ),
                ]),
              ),
              ValueListenableBuilder(
                valueListenable: widget.tradingProductsController.stateSearchProductsTrading,
                builder: (context, value, child) {
                  return Column(
                      children: widget.tradingProductsController.productsTrading.asMap().entries.map((e) {
                    return InkWell(
                      onTap: () {
                        if (widget.codeBranch == 0 || widget.listBranchs == null) {
                          if (widget.codeClient != 0) {
                            if (e.value.amount == "0") {
                              Fluttertoast.showToast(
                                  msg: "Mercadoria não possui pedidos!",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            } else {
                              Navigator.of(context).pushNamed(
                                "clients",
                                arguments: {"merchandise": e.value.codeProduct, "codeProvider": 0, "accessTargenting": 0, "codeTrading": widget.codeTrading},
                              );
                            }
                          }
                        } else {
                          FocusManager.instance.primaryFocus?.unfocus();
                          amountItem.text = e.value.amount == "0" ? "" : "${e.value.amount}";
                          if (e.key != widget.tradingProductsController.itemSelected.value) {
                            widget.tradingProductsController.itemSelected.value = e.key;
                            widget.tradingProductsController.visibleText.value = false;
                            widget.tradingProductsController.visibleText.value = true;
                          } else {
                            widget.tradingProductsController.visibleText.value = !widget.tradingProductsController.visibleText.value;
                          }
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(appMargin),
                        margin: const EdgeInsets.only(left: appMargin, right: appMargin, top: appMargin),
                        decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide(color: colorGrey)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  // "${e.value.packing} | ${e.value.coefficient}",
                                  "${e.value.codeProduct} - ${e.value.complement!}",
                                  style: const TextStyle(color: colorGreyDark, fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  "${e.value.packing} | ${e.value.coefficient}",
                                  style: const TextStyle(color: colorGreyDark, fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Text(
                              e.value.title!,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                                  decoration: BoxDecoration(color: colorGreen.withOpacity(0.5), borderRadius: const BorderRadius.all(Radius.circular(10))),
                                  child: Text(
                                    e.value.brand!,
                                    style: const TextStyle(color: colorWhite, fontWeight: FontWeight.w500),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Container(
                                  padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                                  decoration: BoxDecoration(color: colorBlue.withOpacity(0.5), borderRadius: const BorderRadius.all(Radius.circular(10))),
                                  child: Text(
                                    widget.tradingProductsController.formatCurrency(e.value.unitPrice!),
                                    style: const TextStyle(color: colorWhite, fontWeight: FontWeight.w500),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Container(
                                  padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                                  decoration: const BoxDecoration(color: colorBlue, borderRadius: BorderRadius.all(Radius.circular(10))),
                                  child: Text(
                                    widget.tradingProductsController.formatCurrency(e.value.price!),
                                    style: const TextStyle(color: colorWhite, fontWeight: FontWeight.w500),
                                  ),
                                ),
                                const SizedBox(width: 5),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ValueListenableBuilder(
                                    valueListenable: widget.tradingProductsController.visibleText,
                                    builder: (context, value, child) {
                                      return value == false || widget.tradingProductsController.itemSelected.value != e.key
                                          ? Expanded(
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          const Text(
                                                            "Quantidade: ",
                                                            style: TextStyle(color: colorGreyDark, fontWeight: FontWeight.w500),
                                                          ),
                                                          Text(
                                                            e.value.amount!,
                                                            style: const TextStyle(color: colorGreyDark, fontWeight: FontWeight.bold),
                                                          ),
                                                        ],
                                                      ),
                                                      // Text(
                                                      //   "${widget.tradingProductsController.formatCurrency(e.value.price!)}  |  ${e.value.amount}",
                                                      //   style: const TextStyle(color: colorGreyDark),
                                                      // ),
                                                    ],
                                                  ),
                                                  widget.codeClient == 0
                                                      ? Text(
                                                          widget.tradingProductsController.formatCurrency((double.parse(e.value.amount!) * e.value.price!)),
                                                          style: const TextStyle(
                                                            fontSize: 14,
                                                          ),
                                                        )
                                                      : Text(
                                                          widget.tradingProductsController.formatCurrency((double.parse(e.value.amount!) * e.value.price!)),
                                                          style: TextStyle(
                                                            fontWeight: (double.parse(e.value.amount!) * e.value.price!) == 0.0 ? FontWeight.normal : FontWeight.w600,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                ],
                                              ),
                                            )
                                          : Expanded(
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  SizedBox(
                                                    width: width / 3,
                                                    child: TextField(
                                                      // focusNode: selectedProduct,
                                                      controller: amountItem,
                                                      autofocus: true,
                                                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
                                                      decoration: InputDecoration(
                                                        fillColor: colorGrey.withOpacity(0.5),
                                                        filled: true,
                                                        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                                                        hintText: "0",
                                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                                      ),
                                                      keyboardType: TextInputType.number,
                                                      onChanged: (value) {
                                                        widget.tradingProductsController.updateProductsTrading(value, e.key);
                                                      },
                                                    ),
                                                  ),
                                                  ValueListenableBuilder(
                                                      valueListenable: widget.tradingProductsController.itemTotal,
                                                      builder: (context, values, child) {
                                                        return values == StateApp.start
                                                            ? Text(
                                                                widget.tradingProductsController.formatCurrency((double.parse(e.value.amount!) * e.value.price!)),
                                                                style: const TextStyle(fontSize: 14),
                                                              )
                                                            : Text(
                                                                widget.tradingProductsController.formatCurrency((double.parse(e.value.amount!) * e.value.price!)),
                                                                style: const TextStyle(fontSize: 14),
                                                              );
                                                      }),
                                                ],
                                              ),
                                            );
                                    }),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList());
                },
              ),
            ],
          ),
          Container(
            width: width,
            // decoration: const BoxDecoration(color: Colors.orange),
            padding: const EdgeInsets.symmetric(horizontal: appPadding, vertical: appPadding * 3),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.codeBranch != 0 && widget.listBranchs != null) const AppSpacing(),
                if (widget.codeBranch != 0 && widget.listBranchs != null)
                  AppButton(
                      label: "Próximo",
                      colorButton: colorSecondary,
                      iconButton: Icons.check,
                      onPressButton: () {
                        // widget.tradingProductsController.visibleText.value = false;
                        // widget.tradingProductsController.search("");
                        bool filled = false;
                        for (var i = 0; i < widget.tradingProductsController.products.length; i++) {
                          if (int.parse(widget.tradingProductsController.products[i].amount!) > 0) {
                            filled = true;
                            break;
                          }
                        }
                        if (filled) {
                          Navigator.of(context).pushNamed('finishtrading', arguments: {
                            "codeProvider": widget.codeProvider,
                            "codeBranch": widget.codeBranch,
                            "nameBranch": widget.nameBranch,
                            "codeClient": widget.codeClient,
                            "codeTrading": widget.codeTrading,
                            "codeConsult": widget.codeConsult,
                            // "productsTrading": widget.tradingProductsController.productsTrading,
                            "productsTrading": widget.tradingProductsController.products,
                            "initialListProducts": widget.tradingProductsController.initialListproducts,
                            "tradings": widget.tradings,
                            "listBranchs": widget.listBranchs
                          });
                        } else {
                          Fluttertoast.showToast(
                              msg: "Nenhum pedido adicionado!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      }),
                // if (widget.codeBranch != 0 && widget.listBranchs != null) const AppSpacing(),
                // if (widget.codeBranch != 0 && widget.listBranchs != null)
                //   Container(
                //     width: width,
                //     padding: const EdgeInsets.symmetric(vertical: appMargin / 2, horizontal: appPadding),
                //     decoration: const BoxDecoration(
                //       color: colorSecondary,
                //       borderRadius: BorderRadius.all(
                //         Radius.circular(appRadius),
                //       ),
                //     ),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       children: [
                //         const Text(
                //           "Finalizar pedido",
                //           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: colorWhite),
                //         ),
                //         IconButton(
                //             onPressed: () {
                //               Navigator.of(context).pushNamed('finishtrading', arguments: {
                //                 "codeProvider": widget.codeProvider,
                //                 "codeBranch": widget.codeBranch,
                //                 "nameBranch": widget.nameBranch,
                //                 "codeClient": widget.codeClient,
                //                 "codeTrading": widget.codeTrading,
                //                 "productsTrading": widget.tradingProductsController.productsTrading,
                //                 "tradings": widget.tradings,
                //                 "listBranchs": widget.listBranchs
                //               });
                //             },
                //             icon: const Icon(
                //               Icons.login_rounded,
                //               color: colorWhite,
                //             )),
                //       ],
                //     ),
                //   ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
