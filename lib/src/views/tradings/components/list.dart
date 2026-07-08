import 'package:intl/intl.dart';
import 'package:profair/src/controllers/tradings_controller.dart';
import 'package:profair/src/views/home/home_controller.dart';
import 'package:profair/src/views/home/state_management.dart';
import 'package:profair/src/components/loading_list.dart';
import 'package:profair/src/components/header_list.dart';
import 'package:profair/src/models/tradings_model.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ComponentList extends StatefulWidget {
  ComponentList({super.key, this.description, required this.listItems, required this.state, required this.homeController, this.codeNegotiation, required this.tradingsController});

  Iterable<TradingsModel> listItems;
  final String? description;
  final ValueListenable state;
  final HomeController homeController;
  final int? codeNegotiation;
  final TradingsController tradingsController;

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
      widgetLoading: LoadingList(icon: Icons.swap_horiz_rounded, label: "Negociações"),
      component: Column(
        children: [
          HeaderList(
            icon: Icons.swap_horiz_rounded,
            onSearch: (String? value) {
              widget.tradingsController.search(value);
            },
            label: "Negociações",
            aditionAction: IconButton(
              tooltip: "Ordenar negociações",
              onPressed: () {
                Navigator.of(context).pushNamed('reordertradings', arguments: widget.homeController);
              },
              icon: const Icon(Icons.settings_outlined),
            ),
          ),
          ValueListenableBuilder(
              valueListenable: widget.tradingsController.stateSearchTrandings,
              builder: (context, value, child) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: appMargin),
                  child: Column(
                      children: widget.tradingsController.tradingList.map((e) {
                    final bool hasVolume = e.totalVolume != "0";
                    final Color accentColor = hasVolume ? colorSecondary : colorGreyDark;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(appRadius),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(appRadius),
                          onTap: () {
                            Navigator.of(context).pushNamed('listrequestsstores',
                                arguments: {"codeProvider": e.provider, "userCode": 0, "codeNegotiation": e.code, "homeController": widget.homeController, "visibleBuyers": false});
                          },
                          child: Container(
                            width: width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(appRadius),
                              color: Theme.of(context).colorScheme.surface,
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
                                    Container(
                                      width: 4,
                                      color: accentColor,
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                                  decoration: BoxDecoration(
                                                    color: accentColor.withValues(alpha: 0.1),
                                                    borderRadius: BorderRadius.circular(20),
                                                  ),
                                                  child: Text(
                                                    'Nº ${e.code}',
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      fontWeight: FontWeight.w600,
                                                      color: accentColor,
                                                      letterSpacing: 0.3,
                                                    ),
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.chevron_right_rounded,
                                                  size: 20,
                                                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              '${e.title}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 15,
                                                color: Theme.of(context).colorScheme.onSurface,
                                                height: 1.3,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.calendar_today_rounded,
                                                  size: 13,
                                                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.45),
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  DateFormat("dd/MM/yyyy").format(DateTime.parse(e.term!)),
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.55),
                                                  ),
                                                ),
                                                const Spacer(),
                                                _InfoChip(
                                                  icon: Icons.inventory_2_outlined,
                                                  label: '${e.totalVolume} un.',
                                                  active: hasVolume,
                                                ),
                                                const SizedBox(width: 8),
                                                _InfoChip(
                                                  label: 'R\$ ${e.totalValue}',
                                                  active: hasVolume,
                                                  highlight: true,
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
                  }).toList()),
                );
              })
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({this.icon, required this.label, required this.active, this.highlight = false});

  final IconData? icon;
  final String label;
  final bool active;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final Color color = active ? (highlight ? colorSecondary : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)) : colorGrey;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 3),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: highlight ? FontWeight.w700 : FontWeight.w500,
            color: color,
          ),
        ),
      ],
    );
  }
}
