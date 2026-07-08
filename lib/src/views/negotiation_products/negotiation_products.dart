import 'package:intl/intl.dart';
import 'package:profair/src/components/header_list.dart';
import 'package:profair/src/components/loading_list.dart';
import 'package:profair/src/components/tag_dialog.dart';
import 'package:profair/src/models/product_model.dart';
import 'package:profair/src/repositories/trading_products_repository.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:flutter/material.dart';

class NegotiationProducts extends StatefulWidget {
  const NegotiationProducts({super.key, required this.codeProvider, required this.codeTrading, this.title});

  final int? codeProvider;
  final int? codeTrading;
  final String? title;

  @override
  State<NegotiationProducts> createState() => _NegotiationProductsState();
}

class _NegotiationProductsState extends State<NegotiationProducts> {
  final TradingProductsRepository _repository = TradingProductsRepository();
  final NumberFormat _currency = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  List<ProductModel> _products = [];
  final Set<int> _selected = {};
  bool _loading = true;
  bool _error = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = false;
    });
    try {
      // codeClient e codeBranch = 0 direcionam para a rota merchandisenegotiationprovider/:provider/:negotiation
      final result = await _repository.getTradingProducts(0, widget.codeProvider, widget.codeTrading, 0);
      setState(() {
        _products = result is List ? result.cast<ProductModel>() : <ProductModel>[];
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = true;
        _loading = false;
      });
    }
  }

  void _toggleSelection(ProductModel product) {
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

  Future<void> _applyHighlight(bool highlight) async {
    if (_selected.isEmpty || _saving) return;
    setState(() => _saving = true);

    final codes = _selected.toList();
    final success = await _repository.updateHighlight(codes, highlight);

    if (!mounted) return;
    setState(() {
      if (success) {
        for (final product in _products) {
          if (_selected.contains(product.codeProduct)) {
            product.highlight = highlight;
          }
        }
        _selected.clear();
      }
      _saving = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success
            ? (highlight ? "Produtos marcados como destaque" : "Destaque removido")
            : "Não foi possível atualizar o destaque"),
        backgroundColor: success ? colorSecondary : colorRed,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _openTagDialog() async {
    if (_selected.isEmpty || _saving) return;

    final selectedProducts = _products.where((p) => _selected.contains(p.codeProduct)).toList();

    // Pré-preenche caso todos os selecionados compartilhem a mesma tag
    String initial = "";
    final first = selectedProducts.first.tag ?? "";
    if (selectedProducts.every((p) => (p.tag ?? "") == first)) initial = first;

    // Sugestões: tags já usadas em outros produtos desta negociação
    final suggestions = _products
        .map((p) => p.tag)
        .whereType<String>()
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .toSet()
        .toList()
      ..sort();

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
    final success = await _repository.updateTag(codes, normalized);

    if (!mounted) return;
    setState(() {
      if (success) {
        for (final product in _products) {
          if (_selected.contains(product.codeProduct)) {
            product.tag = normalized;
          }
        }
        _selected.clear();
      }
      _saving = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success
            ? (normalized == null ? "Tag removida" : "Tag aplicada aos produtos")
            : "Não foi possível atualizar a tag"),
        backgroundColor: success ? colorSecondary : colorRed,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            HeaderList(
              icon: Icons.inventory_2_outlined,
              label: widget.title?.isNotEmpty == true ? widget.title! : "Produtos",
              activeSearch: false,
              aditionAction: _buildActions(),
            ),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildActions() {
    if (_saving) {
      return const Padding(
        padding: EdgeInsets.all(14),
        child: SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: colorSecondary)),
      );
    }

    final selectedProducts = _products.where((p) => _selected.contains(p.codeProduct)).toList();

    // Ações aparecem apenas quando há produtos selecionados
    if (selectedProducts.isEmpty) return const SizedBox.shrink();

    final bool allHighlighted = selectedProducts.every((p) => p.highlight == true);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          tooltip: "Adicionar tag",
          onPressed: _openTagDialog,
          icon: const Icon(Icons.sell_outlined, color: colorSecondary),
        ),
        IconButton(
          tooltip: allHighlighted ? "Remover destaque" : "Marcar como destaque",
          onPressed: () => _applyHighlight(!allHighlighted),
          icon: Icon(
            allHighlighted ? Icons.star_rounded : Icons.star_border_rounded,
            color: colorSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return LoadingList(icon: Icons.inventory_2_outlined, label: "Produtos");
    }
    if (_error) {
      return _buildEmpty("Não foi possível carregar os produtos");
    }
    if (_products.isEmpty) {
      return _buildEmpty("Nenhum produto nesta negociação");
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: appMargin, vertical: 10),
      itemCount: _products.length,
      itemBuilder: (context, index) => _buildProductCard(context, _products[index]),
    );
  }

  Widget _buildEmpty(String message) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inventory_2_outlined, size: 48, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.25)),
          const SizedBox(height: 12),
          Text(
            message,
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.55)),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, ProductModel product) {
    final String subtitle = [product.brand, product.complement].where((e) => e != null && e.trim().isNotEmpty).join(' • ');
    final bool isSelected = _selected.contains(product.codeProduct);
    final bool isHighlighted = product.highlight == true;
    final bool hasTag = product.tag != null && product.tag!.trim().isNotEmpty;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(appRadius),
        child: InkWell(
          borderRadius: BorderRadius.circular(appRadius),
          onTap: () => _toggleSelection(product),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(appRadius),
              color: Theme.of(context).colorScheme.surface,
              border: Border.all(
                color: isSelected ? colorSecondary : Colors.transparent,
                width: 1.6,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(appRadius),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(width: 4, color: isHighlighted ? colorTertiary : colorSecondary),
                    // Indicador de seleção (aparece apenas quando o item está selecionado)
                    if (isSelected)
                      const Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Icon(
                          Icons.check_circle_rounded,
                          color: colorSecondary,
                          size: 22,
                        ),
                      ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    product.title ?? '',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                      color: Theme.of(context).colorScheme.onSurface,
                                      height: 1.3,
                                    ),
                                  ),
                                ),
                                if (isHighlighted)
                                  const Padding(
                                    padding: EdgeInsets.only(left: 6),
                                    child: Icon(Icons.star_rounded, size: 18, color: colorTertiary),
                                  ),
                              ],
                            ),
                            if (subtitle.isNotEmpty) ...[
                              const SizedBox(height: 3),
                              Text(
                                subtitle,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.55),
                                ),
                              ),
                            ],
                            if (hasTag) ...[
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: colorSecondary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.sell_rounded, size: 12, color: colorSecondary),
                                    const SizedBox(width: 4),
                                    Text(
                                      product.tag!,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: colorSecondary,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                _InfoChip(icon: Icons.sell_outlined, label: _currency.format(product.price ?? 0)),
                                const SizedBox(width: 12),
                                _InfoChip(icon: Icons.inventory_2_outlined, label: '${product.amount ?? '0'} un.'),
                                const Spacer(),
                                Text(
                                  _currency.format(product.total ?? 0),
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: colorSecondary),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final Color color = Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 3),
        Text(
          label,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: color),
        ),
      ],
    );
  }
}
