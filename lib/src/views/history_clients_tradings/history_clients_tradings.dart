import 'package:flutter/material.dart';
import 'package:profair/src/components/header_list.dart';
import 'package:profair/src/controllers/history_clients_tradings_controller.dart';
import 'package:profair/src/models/history_clients_tradings_model.dart';
import 'package:profair/src/repositories/history_clients_tradings_repository.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:profair/src/utils/format_currency.dart';
import 'package:profair/src/utils/format_date.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HistoryClientsTradings extends StatefulWidget {
  const HistoryClientsTradings({super.key, required this.provider, required this.client});

  final int provider;
  final int client;

  @override
  State<HistoryClientsTradings> createState() => _HistoryClientsTradingsState();
}

class _HistoryClientsTradingsState extends State<HistoryClientsTradings> {
  HistoryClientsTradingsController historyClientsTradingsController = HistoryClientsTradingsController(
    StateApp.start,
    HistoryClientsTradingsRepository(),
  );

  int? _selectedEvent;

  @override
  void initState() {
    historyClientsTradingsController.findHistoryClientsTradings(widget.provider, widget.client);
    historyClientsTradingsController.findHistoryClientsSummaryTradings(widget.provider, widget.client);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ValueListenableBuilder<StateApp>(
          valueListenable: historyClientsTradingsController.stateHistoryTradingsClients,
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
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: appMargin, vertical: 4),
              children: const [
                _SkeletonSectionHeader(),
                _SkeletonCard(),
                _SkeletonCard(),
                _SkeletonCard(),
                SizedBox(height: 8),
                _SkeletonSectionHeader(),
                _SkeletonCard(),
                _SkeletonCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Lista com dados agrupados por evento
  Widget _buildContent(BuildContext context) {
    final list = historyClientsTradingsController.historyClientsTradingsList;

    final Map<int, List<HistoryClientsTradingsModel>> grouped = {};
    for (final item in list) {
      grouped.putIfAbsent(item.event ?? 0, () => []).add(item);
    }
    final allKeys = grouped.keys.toList()..sort();
    final filteredKeys = _selectedEvent == null ? allKeys : allKeys.where((k) => k == _selectedEvent).toList();

    return Column(
      children: [
        HeaderList(
          icon: Icons.receipt_long_outlined,
          onSort: () => historyClientsTradingsController.sort(),
          onSearch: (String? value) => historyClientsTradingsController.search(value),
          label: "Hist. por associado",
        ),
        _buildSummaryBar(context),
        Flexible(
          child: list.isEmpty
              ? _buildEmptyState(context)
              : ListView.builder(
                  padding: const EdgeInsets.only(top: 4, bottom: 28),
                  itemCount: filteredKeys.length,
                  itemBuilder: (context, index) {
                    final key = filteredKeys[index];
                    return _TimelineSection(
                      provider: widget.provider,
                      eventKey: key,
                      items: grouped[key]!,
                      isLastSection: index == filteredKeys.length - 1,
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
                Icons.receipt_long_outlined,
                size: 36,
                color: colorScheme.primary.withValues(alpha: 0.45),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Nenhum pedido encontrado",
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
              "Erro ao carregar pedidos",
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
// Seção de timeline agrupada por evento
// ─────────────────────────────────────────────

class _TimelineSection extends StatelessWidget {
  final int eventKey;
  final List<HistoryClientsTradingsModel> items;
  final bool isLastSection;
  final int provider;

  const _TimelineSection({
    required this.eventKey,
    required this.items,
    required this.isLastSection,
    required this.provider,
  });

  Color _color(ColorScheme cs) => eventKey == 1 ? cs.primary : cs.tertiary;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = _color(colorScheme);
    final eventDesc = items.first.descriptionEvent ?? 'Evento $eventKey';

    return Padding(
      padding: EdgeInsets.only(
        left: appMargin,
        right: appMargin,
        bottom: isLastSection ? 0 : 12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TimelineHeader(
            eventKey: eventKey,
            description: eventDesc,
            color: color,
            colorScheme: colorScheme,
          ),
          ...items.asMap().entries.map((entry) {
            final isLastItem = entry.key == items.length - 1;
            return _TimelineItem(
              provider: provider,
              item: entry.value,
              color: color,
              colorScheme: colorScheme,
              isLast: isLastItem && isLastSection,
            );
          }),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Cabeçalho do evento na timeline
// ─────────────────────────────────────────────

class _TimelineHeader extends StatelessWidget {
  final int eventKey;
  final String description;
  final Color color;
  final ColorScheme colorScheme;

  const _TimelineHeader({
    required this.eventKey,
    required this.description,
    required this.color,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Ícone do evento
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, color.withValues(alpha: 0.72)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: Text(
              '$eventKey',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    'EVENTO $eventKey',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: color,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface.withValues(alpha: 0.87),
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Item individual com conector de timeline
// ─────────────────────────────────────────────

class _TimelineItem extends StatelessWidget {
  final HistoryClientsTradingsModel item;
  final Color color;
  final ColorScheme colorScheme;
  final bool isLast;
  final int provider;

  const _TimelineItem({
    required this.item,
    required this.color,
    required this.colorScheme,
    required this.isLast,
    required this.provider,
  });

  String _formatDate(String? isoString) {
    if (isoString == null || isoString.isEmpty) return '';
    try {
      final date = DateTime.parse(isoString).toLocal();
      final day = date.day.toString().padLeft(2, '0');
      final month = date.month.toString().padLeft(2, '0');
      final year = date.year;
      return '$day/$month/$year';
    } catch (_) {
      return isoString;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool hasValue = (item.total ?? 0) > 0;
    final dateStr = _formatDate(item.date);
    final hourStr = formatHour(item.date);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Conector de timeline
          SizedBox(
            width: 42,
            child: Column(
              children: [
                Container(
                  width: 2,
                  height: 14,
                  color: color.withValues(alpha: 0.22),
                ),
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    shape: BoxShape.circle,
                    border: Border.all(color: color, width: 2),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: color.withValues(alpha: 0.22),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // ── Card do pedido
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Material(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(14),
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      "/tradingproductshistory",
                      arguments: {
                        "codeBranch": item.id,
                        "codeProvider": provider,
                        "codeTrading": item.negotiation,
                        "comprador": item.comprador,
                        "vendedor": item.vendedor,
                        "date": item.date,
                      },
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: colorScheme.onSurface.withValues(alpha: 0.06),
                      ),
                    ),
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Header: título + data
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                item.descNegotiation ?? 'Sem descrição',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: colorScheme.onSurface.withValues(alpha: 0.88),
                                  height: 1.3,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (dateStr.isNotEmpty) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: color.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.calendar_today_rounded,
                                      size: 11,
                                      color: color.withValues(alpha: 0.7),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      dateStr,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: color.withValues(alpha: 0.8),
                                      ),
                                    ),
                                    if (hourStr.isNotEmpty) ...[
                                      Text(
                                        '  $hourStr',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                          color: color.withValues(alpha: 0.55),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),

                        const SizedBox(height: 10),

                        // ── Comprador e Vendedor
                        if ((item.comprador ?? '').isNotEmpty || (item.vendedor ?? '').isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: [
                                if ((item.comprador ?? '').isNotEmpty)
                                  Expanded(
                                    child: _InfoChip(
                                      icon: Icons.person_outline_rounded,
                                      label: 'Comprador',
                                      value: item.comprador!,
                                      colorScheme: colorScheme,
                                    ),
                                  ),
                                if ((item.comprador ?? '').isNotEmpty && (item.vendedor ?? '').isNotEmpty) const SizedBox(width: 8),
                                if ((item.vendedor ?? '').isNotEmpty)
                                  Expanded(
                                    child: _InfoChip(
                                      icon: Icons.storefront_rounded,
                                      label: 'Vendedor',
                                      value: item.vendedor!,
                                      colorScheme: colorScheme,
                                    ),
                                  ),
                              ],
                            ),
                          ),

                        Divider(
                          height: 1,
                          thickness: 1,
                          color: colorScheme.onSurface.withValues(alpha: 0.05),
                        ),

                        const SizedBox(height: 10),

                        // ── Volume + Total
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
                                  formatCurrency(item.total ?? 0),
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: -0.4,
                                    color: hasValue ? color : colorScheme.onSurface.withValues(alpha: 0.3),
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
            ),
          ),
        ],
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
// Chip de informação (comprador / vendedor)
// ─────────────────────────────────────────────

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final ColorScheme colorScheme;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.onSurface.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 14,
            color: colorScheme.onSurface.withValues(alpha: 0.35),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface.withValues(alpha: 0.35),
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Cabeçalho de seção skeleton
// ─────────────────────────────────────────────

class _SkeletonSectionHeader extends StatelessWidget {
  const _SkeletonSectionHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 14),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 60,
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 6),
              Container(
                width: 180,
                height: 14,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ],
          ),
        ],
      ),
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
      padding: const EdgeInsets.only(left: 52, bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: colorScheme.onSurface.withValues(alpha: 0.06),
          ),
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título + badge de data
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    height: 13,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 80,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Comprador + Vendedor
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 38,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    height: 38,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
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
