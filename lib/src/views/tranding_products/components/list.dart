import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:profair/src/components/button.dart';
import 'package:profair/src/components/header_list.dart';
import 'package:profair/src/components/loading_list.dart';
import 'package:profair/src/controllers/trading_products_controller.dart';
import 'package:profair/src/models/nogotiation_model.dart';
import 'package:profair/src/views/home/state_management.dart';
import 'package:profair/src/components/spacing.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:profair/src/utils/colors.dart';
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
      widgetLoading:
          LoadingList(icon: Icons.shopping_basket_rounded, label: "Produtos"),
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
                if (widget.codeClient == 0 &&
                    widget.tradingProductsController.detailsSell!.quantity != 0)
                  Builder(
                    builder: (shareContext) {
                      return IconButton(
                        onPressed: () {
                          widget.tradingProductsController.exportData(
                              widget.codeProvider,
                              widget.codeTrading,
                              widget.codeBranch,
                              shareContext);
                        },
                        icon: const Icon(Icons.share_rounded),
                      );
                    },
                  )
              ],
            ),
            onSort: widget.tradingProductsController.detailsSell!.quantity != 0
                ? () {
                    widget.tradingProductsController.sort();
                  }
                : null,
            label: "Produtos",
          ),
          Column(
            children: [
              // ── Card Detalhes da Venda ──────────────────────────────
              Container(
                margin: EdgeInsets.symmetric(horizontal: appPadding),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(appRadius),
                  border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.08)),
                  color: Theme.of(context).colorScheme.surface,
                ),
                child: Column(
                  children: [
                    // Cabeçalho do card
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: appPadding, vertical: appPadding * 0.9),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(appRadius),
                          topRight: Radius.circular(appRadius),
                        ),
                        border: Border(
                          bottom: BorderSide(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.07)),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: colorSecondary.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.receipt_long_rounded,
                                size: 16, color: colorSecondary),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            "Detalhes da venda",
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 15),
                          ),
                          const SizedBox(width: 8),
                          AppBadge(
                            borderRadius: 8,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            color: colorQuartiary.withOpacity(0.12),
                            child: const Text(
                              "Produtos",
                              style: TextStyle(
                                  color: colorQuartiary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Gráfico
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: appPadding),
                      child: PieChartSample2(
                          products:
                              widget.tradingProductsController.productsTrading),
                    ),

                    // Label resumo
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: appPadding),
                      child: Row(
                        children: [
                          Text(
                            "Resumo do pedido",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.5),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Tooltip(
                            message:
                                "O gráfico mostra os 10 primeiros itens do pedido.",
                            child: Icon(Icons.info_outline,
                                size: 14,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(0.35)),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),
                    Divider(
                        height: 1,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.07)),
                    const SizedBox(height: 4),

                    // Linha: Quantidade de itens
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: appPadding, vertical: appPadding * 0.6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: colorSecondary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: const Icon(Icons.numbers,
                                    size: 15, color: colorSecondary),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                "Quantidade de itens",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.75),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: colorSecondary.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "${widget.tradingProductsController.detailsSell!.quantity}",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                                color: colorSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Divider(
                        height: 1,
                        indent: appPadding,
                        endIndent: appPadding,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.05)),

                    // Linha: Volume
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: appPadding, vertical: appPadding * 0.6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: colorTertiary.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: const Icon(Icons.bolt,
                                    size: 15, color: colorTertiary),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                "Volume",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.75),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: colorBlue.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: colorBlue.withOpacity(0.3)),
                                ),
                                child: const Text(
                                  "Agregado",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 11,
                                      color: colorBlue),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "${widget.tradingProductsController.detailsSell!.volume}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 13),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              ),

              // ── Lista de Produtos ───────────────────────────────────
              ValueListenableBuilder(
                valueListenable:
                    widget.tradingProductsController.stateSearchProductsTrading,
                builder: (context, value, child) {
                  return Column(
                    children: widget.tradingProductsController.productsTrading
                        .asMap()
                        .entries
                        .map((e) {
                      return InkWell(
                        onTap: () {
                          if (widget.codeBranch == 0 ||
                              widget.listBranchs == null) {
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
                                  arguments: {
                                    "merchandise": e.value.codeProduct,
                                    "codeProvider": 0,
                                    "accessTargenting": 0,
                                    "codeTrading": widget.codeTrading
                                  },
                                );
                              }
                            }
                          } else {
                            FocusManager.instance.primaryFocus?.unfocus();
                            amountItem.text = e.value.amount == "0"
                                ? ""
                                : "${e.value.amount}";
                            if (e.key !=
                                widget.tradingProductsController.itemSelected
                                    .value) {
                              widget.tradingProductsController.itemSelected
                                  .value = e.key;
                              widget.tradingProductsController.visibleText
                                  .value = false;
                              widget.tradingProductsController.visibleText
                                  .value = true;
                            } else {
                              widget.tradingProductsController.visibleText
                                      .value =
                                  !widget.tradingProductsController.visibleText
                                      .value;
                            }
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                              left: appMargin,
                              right: appMargin,
                              top: appMargin * 0.5),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: double.parse(e.value.amount!) > 0
                                  ? colorSecondary.withOpacity(0.2)
                                  : Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.07),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: appMargin * 1.1,
                                vertical: appMargin * 0.9),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Linha 1: código/complemento + embalagem/coeficiente
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${e.value.codeProduct} - ${e.value.complement!}",
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withOpacity(0.45),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 11,
                                        letterSpacing: 0.2,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 7, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withOpacity(0.05),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        "${e.value.packing} | ${e.value.coefficient}",
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withOpacity(0.5),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 5),

                                // Linha 2: título
                                Text(
                                  e.value.title!,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                      letterSpacing: 0.1),
                                ),

                                const SizedBox(height: 8),

                                // Linha 3: badges marca + preços
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 3, horizontal: 8),
                                      decoration: BoxDecoration(
                                        color: colorGreen.withOpacity(0.12),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(8)),
                                      ),
                                      child: Text(
                                        e.value.brand!,
                                        style: TextStyle(
                                            color: colorGreen,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 11),
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 3, horizontal: 8),
                                      decoration: BoxDecoration(
                                        color: colorBlue.withOpacity(0.08),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(8)),
                                      ),
                                      child: Text(
                                        widget.tradingProductsController
                                            .formatCurrency(e.value.unitPrice!),
                                        style: TextStyle(
                                            color: colorBlue,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 11),
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 3, horizontal: 8),
                                      decoration: BoxDecoration(
                                        color: colorBlue.withOpacity(0.15),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(8)),
                                      ),
                                      child: Text(
                                        widget.tradingProductsController
                                            .formatCurrency(e.value.price!),
                                        style: const TextStyle(
                                            color: colorBlue,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 11),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 10),
                                Divider(
                                    height: 1,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withOpacity(0.06)),
                                const SizedBox(height: 10),

                                // Linha 4: quantidade + total
                                ValueListenableBuilder(
                                  valueListenable: widget
                                      .tradingProductsController.visibleText,
                                  builder: (context, value, child) {
                                    return value == false ||
                                            widget.tradingProductsController
                                                    .itemSelected.value !=
                                                e.key
                                        ? Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(Icons.layers_outlined,
                                                      size: 13,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSurface
                                                          .withOpacity(0.4)),
                                                  const SizedBox(width: 5),
                                                  Text(
                                                    "Quantidade: ",
                                                    style: TextStyle(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSurface
                                                          .withOpacity(0.5),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  Text(
                                                    e.value.amount!,
                                                    style: TextStyle(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSurface
                                                          .withOpacity(0.85),
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              widget.codeClient == 0
                                                  ? Text(
                                                      widget
                                                          .tradingProductsController
                                                          .formatCurrency(
                                                              (double.parse(e
                                                                      .value
                                                                      .amount!) *
                                                                  e.value
                                                                      .price!)),
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: double.parse(e
                                                                    .value
                                                                    .amount!) >
                                                                0
                                                            ? colorSecondary
                                                            : Theme.of(context)
                                                                .colorScheme
                                                                .onSurface
                                                                .withOpacity(
                                                                    0.4),
                                                      ),
                                                    )
                                                  : Text(
                                                      widget
                                                          .tradingProductsController
                                                          .formatCurrency(
                                                              (double.parse(e
                                                                      .value
                                                                      .amount!) *
                                                                  e.value
                                                                      .price!)),
                                                      style: TextStyle(
                                                        fontWeight: (double.parse(e
                                                                        .value
                                                                        .amount!) *
                                                                    e.value
                                                                        .price!) ==
                                                                0.0
                                                            ? FontWeight.w400
                                                            : FontWeight.w700,
                                                        fontSize: 14,
                                                        color: (double.parse(e
                                                                        .value
                                                                        .amount!) *
                                                                    e.value
                                                                        .price!) ==
                                                                0.0
                                                            ? Theme.of(context)
                                                                .colorScheme
                                                                .onSurface
                                                                .withOpacity(
                                                                    0.35)
                                                            : colorSecondary,
                                                      ),
                                                    ),
                                            ],
                                          )
                                        : Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                width: width / 3,
                                                child: TextField(
                                                  controller: amountItem,
                                                  autofocus: true,
                                                  inputFormatters: <TextInputFormatter>[
                                                    FilteringTextInputFormatter
                                                        .allow(RegExp(r'[0-9]'))
                                                  ],
                                                  decoration: InputDecoration(
                                                    fillColor: Theme.of(context)
                                                        .colorScheme
                                                        .onSurface
                                                        .withOpacity(0.05),
                                                    filled: true,
                                                    contentPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            vertical: 0,
                                                            horizontal: 12),
                                                    hintText: "0",
                                                    hintStyle: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onSurface
                                                            .withOpacity(0.3)),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      borderSide:
                                                          BorderSide.none,
                                                    ),
                                                  ),
                                                  keyboardType:
                                                      TextInputType.number,
                                                  onChanged: (value) {
                                                    widget
                                                        .tradingProductsController
                                                        .updateProductsTrading(
                                                            value, e.key);
                                                  },
                                                ),
                                              ),
                                              ValueListenableBuilder(
                                                valueListenable: widget
                                                    .tradingProductsController
                                                    .itemTotal,
                                                builder:
                                                    (context, values, child) {
                                                  return Text(
                                                    widget
                                                        .tradingProductsController
                                                        .formatCurrency(
                                                            (double.parse(e
                                                                    .value
                                                                    .amount!) *
                                                                e.value
                                                                    .price!)),
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: colorSecondary,
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),

          // ── Botão Próximo ───────────────────────────────────────────
          Container(
            width: width,
            padding: const EdgeInsets.symmetric(
                horizontal: appPadding, vertical: appPadding * 3),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.codeBranch != 0 && widget.listBranchs != null)
                  const AppSpacing(),
                if (widget.codeBranch != 0 && widget.listBranchs != null)
                  AppButton(
                    label: "Próximo",
                    colorButton: colorSecondary,
                    iconButton: Icons.check,
                    onPressButton: () {
                      bool filled = false;
                      for (var i = 0;
                          i < widget.tradingProductsController.products.length;
                          i++) {
                        if (int.parse(widget.tradingProductsController
                                .products[i].amount!) >
                            0) {
                          filled = true;
                          break;
                        }
                      }
                      if (filled) {
                        Navigator.of(context)
                            .pushNamed('finishtrading', arguments: {
                          "codeProvider": widget.codeProvider,
                          "codeBranch": widget.codeBranch,
                          "nameBranch": widget.nameBranch,
                          "codeClient": widget.codeClient,
                          "codeTrading": widget.codeTrading,
                          "codeConsult": widget.codeConsult,
                          "productsTrading":
                              widget.tradingProductsController.products,
                          "initialListProducts": widget
                              .tradingProductsController.initialListproducts,
                          "tradings": widget.tradings,
                          "listBranchs": widget.listBranchs,
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
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
