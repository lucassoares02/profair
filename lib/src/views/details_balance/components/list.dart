import 'package:profair/src/controllers/details_balance_controller.dart';
import 'package:profair/src/repositories/requests_stores_model.dart';
import 'package:profair/src/components/header_list.dart';
import 'package:profair/src/components/loading_list.dart';
import 'package:profair/src/utils/format_currency.dart';
import 'package:profair/src/views/home/state_management.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ComponentList extends StatefulWidget {
  ComponentList({
    super.key,
    this.description,
    required this.listItems,
    required this.state,
    required this.codeProvider,
    this.userCode,
    required this.balanceController,
  });

  Iterable<RequestsStoresModel> listItems;
  final String? description;
  final ValueListenable state;
  final int? codeProvider;
  final int? userCode;
  final DetailsBalanceController balanceController;

  @override
  State<ComponentList> createState() => _ComponentListState();
}

class _ComponentListState extends State<ComponentList> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return StateManagement(
      width: width,
      listenable: widget.state,
      widgetLoading: LoadingList(label: "Pedidos Realizados", icon: Icons.receipt_long_rounded),
      component: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderList(
            icon: Icons.receipt_long_rounded,
            onSearch: (String? value) {
              widget.balanceController.search(value);
            },
            label: "Pedidos Realizados",
          ),
          ValueListenableBuilder(
            valueListenable: widget.balanceController.stateSearchStore,
            builder: (context, value, child) {
              final items = widget.balanceController.requestsStores.toList();

              if (items.isEmpty) {
                return _buildEmptyState(context);
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: appPadding),
                child: Column(
                  children: items.map((e) => _OrderCard(item: e)).toList(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: appPadding),
      child: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.receipt_long_rounded,
                size: 32,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              "Nenhum pedido encontrado",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.item});

  final RequestsStoresModel item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final hasValue = (item.value ?? 0) > 0;

    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(
        "orderdetails",
        arguments: {"order": item},
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: cs.onSurface.withValues(alpha: 0.07)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ícone lateral
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: colorPrimary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.receipt_long_rounded, color: colorPrimary, size: 20),
            ),
            const SizedBox(width: 12),

            // Conteúdo
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Negociação + código
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          item.descriptionNegotiation ?? "Pedido",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            height: 1.3,
                            color: cs.onSurface,
                          ),
                        ),
                      ),
                      if (item.codeNegotiation != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: colorPrimary.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            "#${item.codeNegotiation}",
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: colorPrimary,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Fornecedor
                  if ((item.nameForn ?? '').isNotEmpty)
                    Text(
                      item.nameForn!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  const SizedBox(height: 10),

                  // Tags: valor + horário
                  Row(
                    children: [
                      if (hasValue)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981).withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Text(
                            formatCurrency(item.value!),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF10B981),
                            ),
                          ),
                        ),
                      if (hasValue && (item.hour ?? '').isNotEmpty) const SizedBox(width: 6),
                      if ((item.hour ?? '').isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: cs.surfaceContainerHighest.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Text(
                            item.hour!,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // Chevron
            const SizedBox(width: 8),
            Icon(Icons.chevron_right_rounded, size: 20, color: cs.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}
