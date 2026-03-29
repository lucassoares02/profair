import 'package:profair/src/controllers/clients_controller.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:profair/src/utils/format_currency.dart';
import 'package:profair/src/views/home/state_management.dart';
import 'package:profair/src/components/loading_list.dart';
import 'package:profair/src/components/header_list.dart';
import 'package:profair/src/models/clients_model.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:profair/src/views/reports/components/card_percentage_client_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ComponentList extends StatefulWidget {
  const ComponentList({
    super.key,
    this.description,
    required this.listItems,
    required this.state,
    required this.codeProvider,
    required this.clientsController,
    this.onClickCard = true,
    required this.accessTargenting,
  });

  final Iterable<ClientsModel> listItems;
  final String? description;
  final ValueListenable state;
  final int? codeProvider;
  final ClientsController clientsController;
  final int accessTargenting;
  final bool onClickCard;

  @override
  State<ComponentList> createState() => _ComponentListState();
}

class _ComponentListState extends State<ComponentList> {
  void _handleCardTap(BuildContext context, dynamic client) {
    if (!widget.onClickCard) return;

    if (client.totalValue == 0) {
      Fluttertoast.showToast(
        msg: "Cliente não possui pedidos!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red.shade600,
        textColor: Colors.white,
        fontSize: 14.0,
      );
      return;
    }

    if (widget.accessTargenting == 3 || widget.accessTargenting == 0) {
      Navigator.of(context).pushNamed(
        "selectprovider",
        arguments: {
          "codeClient": 0,
          "codeBuyer": 0,
          "codeBranch": client.codeBranch,
        },
      );
    } else {
      Navigator.of(context).pushNamed(
        "selectnegotiationgroup",
        arguments: {
          "codeGroup": client.codeGroup,
          "codeClient": 0,
          "codeProvider": widget.codeProvider,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return StateManagement(
      width: width,
      listenable: widget.state,
      widgetLoading: LoadingList(icon: Icons.groups_2_sharp, label: "Lojas"),
      component: Column(
        children: [
          HeaderList(
            icon: Icons.groups_2_sharp,
            onSort: () => widget.clientsController.sort(),
            onSearch: (String? value) => widget.clientsController.search(value),
            label: "Lojas",
          ),
          ValueListenableBuilder(
            valueListenable: widget.clientsController.stateSearchClients,
            builder: (context, value, child) {
              return Column(
                children: [
                  // — Card de porcentagem de clientes atendidos
                  if (widget.accessTargenting == 1) _buildPercentageCard(width),

                  // — Lista de lojas
                  if (widget.clientsController.clientsList.isEmpty)
                    _buildEmptyState()
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 16),
                      itemCount: widget.clientsController.clientsList.length,
                      itemBuilder: (context, index) {
                        final client = widget.clientsController.clientsList[index];
                        return BranchCard(
                          client: client,
                          width: width,
                          hasOrders: client.totalValue != 0,
                          onTap: () => _handleCardTap(context, client),
                        );
                      },
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPercentageCard(double width) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: appPadding,
        vertical: 8,
      ),
      child: ValueListenableBuilder(
        valueListenable: widget.clientsController.statePercentageClients,
        builder: (context, stateClients, child) {
          if (stateClients == StateApp.loading) {
            return Skeletonizer(
              effect: const ShimmerEffect(),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: SizedBox(height: 100, width: width),
              ),
            );
          }

          final percentage = widget.clientsController.percentageClients!;

          return CardPercentageClientsProvider(
            clientsController: widget.clientsController,
            title: "Clientes atendidos",
            content: "Quantidade de associados que foram atendidos até o momento em relação a quantidade total presentes no evento.",
            value: percentage.percentage,
            footer: "${percentage.parcial} de ${percentage.total} foram atendidos",
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 32),
      child: Column(
        children: [
          Icon(
            Icons.storefront_outlined,
            size: 48,
            color: colorScheme.onSurface.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 16),
          Text(
            "Nenhuma loja encontrada",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Tente ajustar sua busca",
            style: TextStyle(
              fontSize: 13,
              color: colorScheme.onSurface.withValues(alpha: 0.3),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// BranchCard — card individual de cada loja
// ─────────────────────────────────────────────

class BranchCard extends StatelessWidget {
  final dynamic client;
  final double width;
  final bool hasOrders;
  final VoidCallback onTap;

  const BranchCard({
    super.key,
    required this.client,
    required this.width,
    required this.hasOrders,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: appMargin, vertical: 5),
      child: Material(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          splashColor: colorScheme.primary.withValues(alpha: 0.06),
          highlightColor: colorScheme.primary.withValues(alpha: 0.03),
          child: Container(
            width: width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: colorScheme.onSurface.withValues(alpha: 0.06),
                width: 1,
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header: nome + indicador de status
                Row(
                  children: [
                    // Indicador visual de pedidos
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: hasOrders ? Colors.green.shade400 : colorScheme.onSurface.withValues(alpha: 0.15),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "${client.nameCompany}",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: colorScheme.onSurface.withValues(alpha: 0.88),
                          height: 1.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (hasOrders)
                      Icon(
                        Icons.chevron_right_rounded,
                        size: 20,
                        color: colorScheme.onSurface.withValues(alpha: 0.25),
                      ),
                  ],
                ),

                const SizedBox(height: 14),

                // ── Divider sutil
                Divider(
                  height: 1,
                  thickness: 1,
                  color: colorScheme.onSurface.withValues(alpha: 0.05),
                ),

                const SizedBox(height: 14),

                // ── Footer: volume + valor total
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Volume
                    _MetricTile(
                      label: "Volume",
                      value: "${client.totalVolume ?? 0}",
                      alignment: CrossAxisAlignment.start,
                      colorScheme: colorScheme,
                    ),

                    // Valor total
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Total",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: colorScheme.onSurface.withValues(alpha: 0.4),
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          formatCurrency(client.totalValue ?? 0),
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: hasOrders ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.3),
                            letterSpacing: -0.4,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Widget auxiliar para métricas reutilizáveis
// ─────────────────────────────────────────────

class _MetricTile extends StatelessWidget {
  final String label;
  final String value;
  final CrossAxisAlignment alignment;
  final ColorScheme colorScheme;

  const _MetricTile({
    required this.label,
    required this.value,
    required this.alignment,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurface.withValues(alpha: 0.4),
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}
