import 'package:fluttertoast/fluttertoast.dart';
import 'package:profair/src/components/header_list.dart';
import 'package:profair/src/components/loading_list.dart';
import 'package:profair/src/controllers/trading_products_controller.dart';
import 'package:profair/src/models/nogotiation_model.dart';
import 'package:profair/src/models/product_model.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:profair/src/views/home/state_management.dart';
import 'package:profair/src/components/spacing.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:profair/generated/l10n.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ComponentList extends StatefulWidget {
  const ComponentList(
      {super.key,
      required this.listItems,
      this.description,
      required this.state,
      required this.codeProvider,
      required this.codeBranch,
      required this.nameBranch,
      required this.codeTrading,
      required this.codeClient,
      required this.tradingProductsController,
      required this.tradings});

  final List<ProductModel> listItems;
  final String? description;
  final ValueListenable state;
  final TradingProductsController tradingProductsController;
  final int? codeProvider;
  final int? codeBranch;
  final String? nameBranch;
  final int? codeClient;
  final int? codeTrading;
  final List<NegotiationModel> tradings;

  @override
  State<ComponentList> createState() => _ComponentListState();
}

class _ComponentListState extends State<ComponentList> {
  TextEditingController amountItem = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return StateManagement(
      width: width,
      listenable: widget.state,
      widgetLoading: LoadingList(icon: Icons.shopping_basket_rounded, label: S.of(context).text_products),
      component: Column(
        children: [
          HeaderList(
            icon: Icons.shopping_basket_rounded,
            onSearch: (String? value) {
              widget.tradingProductsController.search(value);
            },
            label: S.of(context).text_products,
          ),
          Container(
            width: width,
            // decoration: const BoxDecoration(color: Colors.orange),
            padding: const EdgeInsets.all(appPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppSpacing(),
                Container(
                  width: width,
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
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed('finishtrading', arguments: {
                              "codeProvider": widget.codeProvider,
                              "codeBranch": widget.codeBranch,
                              "nameBranch": widget.nameBranch,
                              "codeClient": widget.codeClient,
                              "codeTrading": widget.codeTrading,
                              "productsTrading": widget.tradingProductsController.productsTrading,
                              "tradings": widget.tradings
                            });
                          },
                          icon: const Icon(
                            Icons.login_rounded,
                            color: colorWhite,
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Column(
              children: widget.listItems.asMap().entries.map((e) {
            return InkWell(
              onTap: () {
                print("e.value.codeProduct");
                print(e.value.codeProduct);
                if (widget.codeBranch == 0) {
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
                } else {
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
                margin: const EdgeInsets.symmetric(horizontal: appMargin),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: colorGrey)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      e.value.title!.length < 28 ? '${e.value.title}' : e.value.title!.substring(0, 25),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const AppSpacing(),
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
                                              Text(
                                                "${e.value.packing} | ${e.value.coefficient}",
                                                style: const TextStyle(color: colorGreyDark),
                                              ),
                                              const SizedBox(height: appMargin),
                                              Text(
                                                "${widget.tradingProductsController.formatCurrency(e.value.price!)}  |  ${e.value.amount}",
                                                style: const TextStyle(color: colorGreyDark),
                                              ),
                                            ],
                                          ),
                                          widget.codeClient == 0
                                              ? Text(
                                                  widget.tradingProductsController.formatCurrency((double.parse(e.value.amount!) * e.value.price!)),
                                                  style: const TextStyle(
                                                    color: colorBlack,
                                                    fontSize: 14,
                                                  ),
                                                )
                                              : Text(
                                                  widget.tradingProductsController.formatCurrency((double.parse(e.value.amount!) * e.value.price!)),
                                                  style: TextStyle(
                                                    color: (double.parse(e.value.amount!) * e.value.price!) == 0.0 ? colorGrey : colorBlack,
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
                                              controller: amountItem,
                                              autofocus: true,
                                              decoration: InputDecoration(
                                                fillColor: colorGreyLigth,
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
                                                        style: const TextStyle(color: colorBlack, fontSize: 14),
                                                      )
                                                    : Text(
                                                        widget.tradingProductsController.formatCurrency((double.parse(e.value.amount!) * e.value.price!)),
                                                        style: const TextStyle(color: colorBlack, fontSize: 14),
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
          }).toList())
        ],
      ),
    );
  }
}
