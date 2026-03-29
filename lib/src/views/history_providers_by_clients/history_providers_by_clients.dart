import 'package:flutter/material.dart';
import 'package:profair/src/components/header_list.dart';
import 'package:profair/src/controllers/history_clients_tradings_controller.dart';
import 'package:profair/src/models/history_clients_model.dart';
import 'package:profair/src/repositories/history_clients_tradings_repository.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:profair/src/utils/format_currency.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HistoryProvidersByClients extends StatefulWidget {
  const HistoryProvidersByClients({super.key, required this.client, required this.isProvider});

  final int client;
  final bool isProvider;

  @override
  State<HistoryProvidersByClients> createState() => _HistoryProvidersByClientsState();
}

class _HistoryProvidersByClientsState extends State<HistoryProvidersByClients> {
  HistoryClientsTradingsController historyClientsTradingsController = HistoryClientsTradingsController(
    StateApp.start,
    HistoryClientsTradingsRepository(),
  );

  int? _selectedEvent;

  @override
  void initState() {
    if (widget.isProvider) {
      historyClientsTradingsController.findHistoryProvidersByProvider(widget.client);
      historyClientsTradingsController.findHistoryClientsSummaryClients(widget.client);
    } else {
      historyClientsTradingsController.findHistoryProvidersByClient(widget.client);
      historyClientsTradingsController.findHistoryClientsSummaryProviders(widget.client);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ValueListenableBuilder<StateApp>(
          valueListenable: historyClientsTradingsController.stateHistoryTradingsProvidersByClient,
          builder: (context, state, child) {
            if (state == StateApp.loading) {
              return _buildSkeleton(context);
            } else if (state == StateApp.success) {
              return _buildContent(context);
            } else if (state == StateApp.error) {
              return _buildError(context);
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }

  // ── Skeleton shimmer enquanto carrega
  Widget _buildSkeleton(BuildContext context) {
    return Skeletonizer(
      effect: const ShimmerEffect(),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const SizedBox(width: 8),
                    Container(
                      width: 100,
                      height: 22,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ],
                ),
                const Row(
                  children: [
                    Icon(Icons.search),
                    SizedBox(width: 4),
                    Icon(Icons.sort_outlined),
                    SizedBox(width: 4),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: appMargin, vertical: 4),
              itemCount: 7,
              itemBuilder: (_, __) => const _SkeletonCard(),
            ),
          ),
        ],
      ),
    );
  }

  // ── Lista simples de fornecedores
  Widget _buildContent(BuildContext context) {
    final list = historyClientsTradingsController.historyProvidersByClientsList;

    return Column(
      children: [
        HeaderList(
          icon: Icons.storefront_outlined,
          onSort: () => historyClientsTradingsController.sort(),
          onSearch: (String? value) => historyClientsTradingsController.search(value),
          label: "Hist. por fornecedor",
        ),
        _buildSummaryBar(context),
        Flexible(
          child: list.isEmpty
              ? _buildEmptyState(context)
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 28),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return _ProviderCard(
                      isProvider: widget.isProvider,
                      client: widget.client,
                      item: list[index],
                      selectedEvent: _selectedEvent,
                      rank: index + 1,
                    );
                  },
                ),
        ),
      ],
    );
  }

  // ── Barra de resumo por evento (filtrável)
  Widget _buildSummaryBar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ValueListenableBuilder<StateApp>(
      valueListenable: historyClientsTradingsController.stateHistoryTradingsSummaryClients,
      builder: (context, state, _) {
        if (state == StateApp.loading) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(appMargin, 8, appMargin, 4),
            child: Row(
              children: List.generate(
                  2,
                  (i) => Expanded(
                        child: Container(
                          height: 80,
                          margin: EdgeInsets.only(left: i > 0 ? 8 : 0),
                          decoration: BoxDecoration(
                            color: colorScheme.onSurface.withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      )),
            ),
          );
        }
        if (state != StateApp.success) return const SizedBox.shrink();
        final summaries = historyClientsTradingsController.historyClientsSummaryTradings;
        if (summaries.length <= 1) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.fromLTRB(appMargin, 8, appMargin, 4),
          child: Row(
            children: [
              for (int i = 0; i < summaries.length; i++) ...[
                if (i > 0) const SizedBox(width: 8),
                Expanded(
                  child: _buildSummaryCard(context, summaries[i], colorScheme),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryCard(BuildContext context, dynamic summary, ColorScheme colorScheme) {
    final eventNum = summary.event as int? ?? 1;
    final isSelected = _selectedEvent == eventNum;
    final color = eventNum == 1 ? colorScheme.primary : colorScheme.tertiary;

    return Material(
      color: isSelected ? color : color.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: () => setState(() {
          _selectedEvent = isSelected ? null : eventNum;
        }),
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white.withValues(alpha: 0.22) : color.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$eventNum',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : color,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      summary.description ?? 'Evento $eventNum',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white.withValues(alpha: 0.85) : color.withValues(alpha: 0.8),
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (isSelected)
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Icon(
                        Icons.check_circle_rounded,
                        size: 14,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'Total',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.3,
                  color: isSelected ? Colors.white.withValues(alpha: 0.65) : colorScheme.onSurface.withValues(alpha: 0.4),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                formatCurrency(summary.total ?? 0),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.4,
                  color: isSelected ? Colors.white : color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Estado vazio
  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.07),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.storefront_outlined,
                size: 36,
                color: colorScheme.primary.withValues(alpha: 0.45),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Nenhum fornecedor encontrado",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface.withValues(alpha: 0.45),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Tente ajustar sua busca",
              style: TextStyle(
                fontSize: 13,
                color: colorScheme.onSurface.withValues(alpha: 0.3),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Estado de erro
  Widget _buildError(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: colorScheme.error.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.cloud_off_rounded,
                size: 36,
                color: colorScheme.error.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Erro ao carregar fornecedores",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Verifique sua conexão e tente novamente",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: colorScheme.onSurface.withValues(alpha: 0.35),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Card individual de fornecedor
// ─────────────────────────────────────────────

class _ProviderCard extends StatelessWidget {
  final HistoryClientsModel item;
  final int? selectedEvent;
  final int rank;
  final int client;
  final bool isProvider;

  const _ProviderCard({
    required this.item,
    required this.selectedEvent,
    required this.rank,
    required this.client,
    required this.isProvider,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final double displayValue;
    if (selectedEvent == 1) {
      displayValue = item.totalEvent1 ?? 0;
    } else if (selectedEvent == 2) {
      displayValue = item.totalEvent2 ?? 0;
    } else {
      displayValue = item.total ?? 0;
    }

    final bool hasValue = displayValue > 0;

    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          "/history-clients-tradings",
          arguments: {
            "provider": isProvider ? client : item.id,
            "client": isProvider ? item.id : client,
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: appMargin, vertical: 5),
        child: Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
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
              Text(
                item.razao ?? "Sem descrição",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface.withValues(alpha: 0.88),
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
              Divider(
                height: 1,
                thickness: 1,
                color: colorScheme.onSurface.withValues(alpha: 0.05),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _MetricTile(
                    label: "Volume",
                    value: item.volume ?? "0",
                    alignment: CrossAxisAlignment.start,
                    colorScheme: colorScheme,
                  ),
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
                        formatCurrency(displayValue),
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.4,
                          color: hasValue ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.3),
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
    );
  }
}

// ─────────────────────────────────────────────
// Métrica reutilizável (label + value)
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

// ─────────────────────────────────────────────
// Card fantasma para o skeleton loader
// ─────────────────────────────────────────────

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: colorScheme.onSurface.withValues(alpha: 0.06),
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 14,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            const SizedBox(height: 10),
            Container(height: 1, color: Colors.grey),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 36,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 30,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 88,
                      height: 18,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
