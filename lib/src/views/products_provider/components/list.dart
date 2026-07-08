import 'package:fluttertoast/fluttertoast.dart';
import 'package:profair/src/components/card_product.dart';
import 'package:profair/src/components/tag_dialog.dart';
import 'package:profair/src/controllers/products_provider.dart';
import 'package:profair/src/repositories/products_provider_model.dart';
import 'package:profair/src/repositories/trading_products_repository.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:profair/src/views/home/state_management.dart';
import 'package:profair/src/components/loading_list.dart';
import 'package:profair/src/components/header_list.dart';
import 'package:profair/src/utils/format_currency.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ComponentList extends StatefulWidget {
  ComponentList({
    super.key,
    this.description,
    required this.listItems,
    required this.state,
    required this.codeProvider,
    required this.productsProviderController,
    required this.nextScreen,
  });

  List<ProductsProviderModel> listItems;
  final String? description;
  final ValueListenable state;
  final int? codeProvider;
  final ProductsProviderController productsProviderController;
  final bool nextScreen;

  @override
  State<ComponentList> createState() => _ComponentListState();
}

class _ComponentListState extends State<ComponentList> {
  final TradingProductsRepository _merchRepository = TradingProductsRepository();
  final Set<int> _selected = {};
  bool _saving = false;

  List<ProductsProviderModel> get _products => widget.productsProviderController.productsProvider;

  List<ProductsProviderModel> get _selectedProducts => _products.where((p) => _selected.contains(p.codeProduct)).toList();

  void _toggleSelection(ProductsProviderModel product) {
    final code = product.codeProduct;
    if (code == null) return;
    setState(() {
      if (_selected.contains(code)) {
        _selected.remove(code);
      } else {
        _selected.add(code);
      }
    });
  }

  void _showSnack(String message, bool success) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: success ? colorSecondary : colorRed,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _applyHighlight(bool highlight) async {
    if (_selected.isEmpty || _saving) return;
    setState(() => _saving = true);

    final codes = _selected.toList();
    final success = await _merchRepository.updateHighlight(codes, highlight);

    if (!mounted) return;
    setState(() {
      if (success) {
        for (final product in _products) {
          if (_selected.contains(product.codeProduct)) product.highlight = highlight;
        }
        _selected.clear();
      }
      _saving = false;
    });

    _showSnack(
      success ? (highlight ? "Produtos marcados como destaque" : "Destaque removido") : "Não foi possível atualizar o destaque",
      success,
    );
  }

  Future<void> _openTagDialog() async {
    if (_selected.isEmpty || _saving) return;

    final selectedProducts = _selectedProducts;

    // Pré-preenche caso todos os selecionados compartilhem a mesma tag
    String initial = "";
    final first = selectedProducts.first.tag ?? "";
    if (selectedProducts.every((p) => (p.tag ?? "") == first)) initial = first;

    // Sugestões: tags já usadas em outros produtos
    final suggestions = _products.map((p) => p.tag).whereType<String>().map((t) => t.trim()).where((t) => t.isNotEmpty).toSet().toList()..sort();

    final String? result = await showDialog<String>(
      context: context,
      builder: (context) => TagDialog(
        initialTag: initial,
        selectedCount: selectedProducts.length,
        suggestions: suggestions,
      ),
    );

    if (result == null) return; // cancelado
    await _applyTag(result);
  }

  Future<void> _applyTag(String? tag) async {
    if (_selected.isEmpty || _saving) return;
    setState(() => _saving = true);

    final codes = _selected.toList();
    final String? normalized = (tag == null || tag.trim().isEmpty) ? null : tag.trim();
    final success = await _merchRepository.updateTag(codes, normalized);

    if (!mounted) return;
    setState(() {
      if (success) {
        for (final product in _products) {
          if (_selected.contains(product.codeProduct)) product.tag = normalized;
        }
        _selected.clear();
      }
      _saving = false;
    });

    _showSnack(
      success ? (normalized == null ? "Tag removida" : "Tag aplicada aos produtos") : "Não foi possível atualizar a tag",
      success,
    );
  }

  Widget? _buildMenu() {
    if (_saving) {
      return const Padding(
        padding: EdgeInsets.all(14),
        child: SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: colorSecondary)),
      );
    }

    if (_selected.isEmpty) return null;

    final selectedProducts = _selectedProducts;
    final bool allHighlighted = selectedProducts.isNotEmpty && selectedProducts.every((p) => p.highlight == true);

    return PopupMenuButton<int>(
      icon: const Icon(Icons.more_vert),
      onSelected: (value) {
        if (value == 0) {
          _openTagDialog();
        } else if (value == 1) {
          _applyHighlight(!allHighlighted);
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 0,
          child: Row(
            children: [
              Icon(Icons.sell_outlined, size: 20, color: colorSecondary),
              SizedBox(width: 10),
              Text("Adicionar tag"),
            ],
          ),
        ),
        PopupMenuItem(
          value: 1,
          child: Row(
            children: [
              Icon(allHighlighted ? Icons.star_rounded : Icons.star_border_rounded, size: 20, color: colorSecondary),
              const SizedBox(width: 10),
              Text(allHighlighted ? "Remover destaque" : "Marcar destaque"),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return StateManagement(
      width: width,
      listenable: widget.state,
      widgetLoading: LoadingList(icon: Icons.shopping_basket_rounded, label: "Produtos disponíveis"),
      component: Column(
        children: [
          HeaderList(
            icon: Icons.shopping_basket_rounded,
            onSearch: (String? value) {
              widget.productsProviderController.search(value);
            },
            activeSearch: _selected.isEmpty,
            onSort: _selected.isEmpty
                ? () {
                    widget.productsProviderController.sort();
                  }
                : null,
            label: "Produtos disponíveis",
            aditionAction: _buildMenu(),
          ),
          ValueListenableBuilder(
              valueListenable: widget.productsProviderController.stateSearchProducts,
              builder: (context, value, child) {
                return Column(
                    children: _products.map((e) {
                  return CardProduct(
                      description: e.nameProduct!,
                      barcode: e.barcode,
                      code: e.codeProduct.toString(),
                      brand: e.brand!,
                      packing: e.packing!,
                      factor: e.coefficient!,
                      complement: e.complement!,
                      price: formatCurrency(e.productPrice!),
                      unitPrice: formatCurrency(e.unitPrice!),
                      amount: e.totalVolume!,
                      total: formatCurrency(e.totalValue!),
                      highlight: e.highlight ?? false,
                      tag: e.tag,
                      selected: _selected.contains(e.codeProduct),
                      onLongPress: () => _toggleSelection(e),
                      action: () {
                        // Em modo de seleção, o toque alterna a seleção
                        if (_selected.isNotEmpty) {
                          _toggleSelection(e);
                          return;
                        }
                        if (widget.nextScreen) {
                          if (e.totalVolume != "0") {
                            Navigator.of(context).pushNamed(
                              "/clientsproduct",
                              arguments: e,
                            );
                          } else {
                            Fluttertoast.showToast(
                                msg: "Produto não possui pedidos!",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                        }
                      });
                }).toList());
              })
        ],
      ),
    );
  }
}
