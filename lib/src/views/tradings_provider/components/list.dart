import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:profair/src/controllers/tradings_provider_controller.dart';
import 'package:profair/src/controllers/users_controller.dart';
import 'package:profair/src/models/clients_select_stores_model.dart';
import 'package:profair/src/models/nogotiation_model.dart';
import 'package:profair/src/models/product_model.dart';
import 'package:profair/src/models/users_model.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:profair/src/utils/format_currency.dart';
import 'package:profair/src/views/home/state_management.dart';
import 'package:profair/src/components/loading_list.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/material.dart';

class ComponentList extends StatefulWidget {
  ComponentList({super.key, required this.tradingsProviderController, required this.negotiation, required this.codeBranch, required this.codeClient, required this.index, required this.listBranchs});

  final TradingsProviderController tradingsProviderController;
  final NegotiationModel negotiation;
  final int codeBranch;
  final int codeClient;
  final int index;
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
    return SingleChildScrollView(
      child: Column(
        children: [
          ValueListenableBuilder(
            valueListenable: widget.tradingsProviderController.stateSearchProductsTrading,
            builder: (context, value, child) {
              return Column(
                  children: widget.negotiation.merchandises!.asMap().entries.map((e) {
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
                            arguments: {"merchandise": e.value.codeProduct, "codeProvider": 0, "accessTargenting": 0, "codeTrading": widget.negotiation.negotiation},
                          );
                        }
                      }
                    } else {
                      print("asdfasdfasdf");
                      FocusManager.instance.primaryFocus?.unfocus();
                      amountItem.text = e.value.amount == "0" ? "" : "${e.value.amount}";
                      if (e.key != widget.tradingsProviderController.itemSelected.value) {
                        widget.tradingsProviderController.itemSelected.value = e.key;
                        widget.tradingsProviderController.visibleText.value = false;
                        widget.tradingsProviderController.visibleText.value = true;
                      } else {
                        widget.tradingsProviderController.visibleText.value = !widget.tradingsProviderController.visibleText.value;
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
                                formatCurrency(e.value.unitPrice!),
                                style: const TextStyle(color: colorWhite, fontWeight: FontWeight.w500),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                              decoration: const BoxDecoration(color: colorBlue, borderRadius: BorderRadius.all(Radius.circular(10))),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.sell,
                                    color: colorWhite,
                                    size: 12,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    formatCurrency(e.value.price!),
                                    style: const TextStyle(color: colorWhite, fontWeight: FontWeight.w500),
                                  ),
                                ],
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
                                valueListenable: widget.tradingsProviderController.visibleText,
                                builder: (context, value, child) {
                                  return value == false || widget.tradingsProviderController.itemSelected.value != e.key
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
                                                      formatCurrency((double.parse(e.value.amount!) * e.value.price!)),
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                      ),
                                                    )
                                                  : Text(
                                                      formatCurrency((double.parse(e.value.amount!) * e.value.price!)),
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
                                                    widget.tradingsProviderController.updateProductsTrading(value, widget.index, e.key);
                                                  },
                                                ),
                                              ),
                                              ValueListenableBuilder(
                                                  valueListenable: widget.tradingsProviderController.itemTotal,
                                                  builder: (context, values, child) {
                                                    return values == StateApp.start
                                                        ? Text(
                                                            formatCurrency((double.parse(e.value.amount!) * e.value.price!)),
                                                            style: const TextStyle(fontSize: 14),
                                                          )
                                                        : Text(
                                                            formatCurrency((double.parse(e.value.amount!) * e.value.price!)),
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
    );
  }
}
