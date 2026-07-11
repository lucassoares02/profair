import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:profair/src/controllers/tradings_provider_controller.dart';
import 'package:profair/src/models/clients_select_stores_model.dart';
import 'package:profair/src/models/nogotiation_model.dart';
import 'package:profair/src/models/product_model.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:profair/src/utils/format_currency.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:flutter/material.dart';

class ComponentList extends StatefulWidget {
  ComponentList({
    super.key,
    required this.tradingsProviderController,
    required this.negotiation,
    required this.codeBranch,
    required this.codeClient,
    required this.index,
    required this.listBranchs,
    this.compactHeader = false,
    this.showTagFilters = false,
    this.simpleProductInfo = true,
    this.hideHeader = false,
  });

  final TradingsProviderController tradingsProviderController;
  final NegotiationModel negotiation;
  final int codeBranch;
  final int codeClient;
  final int index;
  final List<ClientsSelectStoreModel>? listBranchs;
  final bool compactHeader;
  final bool showTagFilters;
  final bool simpleProductInfo;
  final bool hideHeader;

  @override
  State<ComponentList> createState() => _ComponentListState();
}

class _ComponentListState extends State<ComponentList> {
  TextEditingController amountItem = TextEditingController();
  FocusNode selectedProduct = FocusNode();
  FocusNode searchBar = FocusNode();
  final DateFormat formatter = DateFormat('dd/MM/yyyy');

  // Tag selecionada para filtrar os produtos (null = todas).
  String? _selectedTag;

  /// Tags distintas dos produtos desta negociação.
  List<String> get _tags {
    final set = <String>{};
    for (final m in widget.negotiation.merchandises ?? []) {
      final t = m.tag?.trim();
      if (t != null && t.isNotEmpty) set.add(t);
    }
    final list = set.toList()..sort();
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(
        children: [
          if (!widget.hideHeader) widget.compactHeader ? _buildCompactHeader() : _buildBlueCard(),
          if (widget.showTagFilters) _buildTagFilters(),
          ValueListenableBuilder(
            valueListenable: widget.tradingsProviderController.stateSearchProductsTrading,
            builder: (context, value, child) {
              return Column(
                  children: widget.negotiation.merchandises!.asMap().entries.map((e) {
                // Filtro por tag (não muta a lista para preservar os índices).
                if (widget.showTagFilters && _selectedTag != null && (e.value.tag ?? '').trim() != _selectedTag) {
                  return const SizedBox.shrink();
                }
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
                    decoration: BoxDecoration(
                      color: e.value.amount != "0"
                          ? colorSecondary.withOpacity(0.2)
                          : (e.value.highlight ?? false)
                              ? Colors.amber.withOpacity(0.06)
                              : transparent,
                      borderRadius: BorderRadius.circular(appRadius),
                      border: (e.value.highlight ?? false)
                          ? Border.all(color: Colors.amber.withOpacity(0.4), width: 1)
                          : const Border(bottom: BorderSide(color: colorGrey)),
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
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (e.value.highlight ?? false) ...[
                              const Icon(Icons.star, color: Colors.amber, size: 18),
                              const SizedBox(width: 4),
                            ],
                            Expanded(
                              child: Text(
                                e.value.title!,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        widget.simpleProductInfo ? _buildInfoText(e.value) : _buildInfoChips(e.value),
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
                                            crossAxisAlignment: CrossAxisAlignment.center,
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
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  if (e.value.tag != null && e.value.tag!.trim().isNotEmpty) ...[
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 7),
                                                      decoration: BoxDecoration(
                                                        color: colorSecondary.withValues(alpha: 0.1),
                                                        borderRadius: const BorderRadius.all(Radius.circular(6)),
                                                        border: Border.all(color: colorSecondary.withValues(alpha: 0.25)),
                                                      ),
                                                      child: Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          const Icon(Icons.local_offer_outlined, color: colorSecondary, size: 10),
                                                          const SizedBox(width: 3),
                                                          Text(
                                                            e.value.tag!,
                                                            style: const TextStyle(color: colorSecondary, fontWeight: FontWeight.w600, fontSize: 10),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                  ],
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

  // Separador em ponto, na cor da fonte.
  Widget _infoDot() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      width: 4,
      height: 4,
      decoration: BoxDecoration(color: colorGreyDark.withOpacity(0.4), shape: BoxShape.circle),
    );
  }

  // ── Marca / preços em texto sutil (formato simplificado) ──────────────────
  Widget _buildInfoText(ProductModel item) {
    const style = TextStyle(color: colorGreyDark, fontWeight: FontWeight.w500, fontSize: 13);
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      runSpacing: 2,
      children: [
        Text(item.brand ?? "", style: style),
        _infoDot(),
        Text(formatCurrency(item.unitPrice!), style: style),
        _infoDot(),
        const Icon(Icons.sell, size: 12, color: colorGreyDark),
        const SizedBox(width: 4),
        Text(formatCurrency(item.price!), style: style),
      ],
    );
  }

  // ── Marca / preços em tags coloridas (formato antigo) ─────────────────────
  Widget _buildInfoChips(ProductModel item) {
    return Wrap(
      runSpacing: 5,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
          decoration: BoxDecoration(color: colorGreen.withOpacity(0.5), borderRadius: const BorderRadius.all(Radius.circular(10))),
          child: Text(item.brand ?? "", style: const TextStyle(color: colorWhite, fontWeight: FontWeight.w500)),
        ),
        const SizedBox(width: 5),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
          decoration: BoxDecoration(color: colorBlue.withOpacity(0.5), borderRadius: const BorderRadius.all(Radius.circular(10))),
          child: Text(formatCurrency(item.unitPrice!), style: const TextStyle(color: colorWhite, fontWeight: FontWeight.w500)),
        ),
        const SizedBox(width: 5),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
          decoration: const BoxDecoration(color: colorBlue, borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.sell, color: colorWhite, size: 12),
              const SizedBox(width: 5),
              Text(formatCurrency(item.price!), style: const TextStyle(color: colorWhite, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        const SizedBox(width: 5),
      ],
    );
  }

  // ── Cartão azul original (negociação completa) ────────────────────────────
  Widget _buildBlueCard() {
    return Container(
      margin: const EdgeInsets.all(appPadding),
      padding: const EdgeInsets.symmetric(horizontal: appPadding, vertical: appPadding),
      decoration: const BoxDecoration(
        color: colorBlue,
        borderRadius: BorderRadius.all(Radius.circular(appRadius)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.negotiation.negotiation.toString(),
                style: const TextStyle(color: colorWhite, fontWeight: FontWeight.w600),
              ),
              Text(
                formatter.format(DateTime.parse(widget.negotiation.term!)),
                style: const TextStyle(color: colorWhite, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const Divider(),
          Text(
            widget.negotiation.title!,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: colorWhite),
          ),
          Column(
            children: [
              Text(
                widget.negotiation.observation!,
                overflow: TextOverflow.clip,
                style: const TextStyle(color: colorWhite, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Cabeçalho compacto (código + data em um badge) ────────────────────────
  Widget _buildCompactHeader() {
    String? dateStr;
    try {
      if (widget.negotiation.term != null) {
        dateStr = formatter.format(DateTime.parse(widget.negotiation.term!));
      }
    } catch (_) {}

    return Container(
      width: double.maxFinite,
      margin: const EdgeInsets.fromLTRB(appPadding, appPadding, appPadding, 0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: colorBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: colorBlue.withOpacity(0.25)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.receipt_long_rounded, size: 14, color: colorBlue),
              const SizedBox(width: 5),
              Text(
                "Nº ${widget.negotiation.negotiation}",
                style: const TextStyle(color: colorBlue, fontWeight: FontWeight.bold, fontSize: 12.5),
              ),
              if (dateStr != null) ...[
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(color: colorBlue.withOpacity(0.4), shape: BoxShape.circle),
                ),
                const Icon(Icons.event_outlined, size: 13, color: colorBlue),
                const SizedBox(width: 4),
                Text(
                  dateStr,
                  style: TextStyle(color: colorBlue.withOpacity(0.9), fontWeight: FontWeight.w600, fontSize: 12.5),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ── Filtros por tag ───────────────────────────────────────────────────────
  Widget _buildTagFilters() {
    final tags = _tags;
    if (tags.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.fromLTRB(appPadding, 10, appPadding, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.sell_outlined, size: 13, color: colorGreyDark),
              const SizedBox(width: 4),
              Text("Filtrar por tag", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: colorGreyDark)),
            ],
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _tagChip(label: "Todas", selected: _selectedTag == null, onTap: () => setState(() => _selectedTag = null)),
                const SizedBox(width: 8),
                ...tags.map((t) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: _tagChip(
                        label: t,
                        selected: _selectedTag == t,
                        icon: Icons.local_offer_outlined,
                        onTap: () => setState(() => _selectedTag = _selectedTag == t ? null : t),
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tagChip({required String label, required bool selected, required VoidCallback onTap, IconData? icon}) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? colorSecondary : colorSecondary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? colorSecondary : colorSecondary.withOpacity(0.25)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 12, color: selected ? colorWhite : colorSecondary),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                color: selected ? colorWhite : colorSecondary,
                fontWeight: FontWeight.w600,
                fontSize: 12.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
