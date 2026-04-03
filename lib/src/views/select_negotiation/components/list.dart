import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:profair/src/components/header_list.dart';
import 'package:profair/src/components/loading_list.dart';
import 'package:profair/src/models/nogotiation_model.dart';
import 'package:profair/src/views/home/state_management.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:profair/generated/l10n.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../models/clients_select_stores_model.dart';

class ComponentList extends StatefulWidget {
  ComponentList({
    super.key,
    required this.listItems,
    this.description,
    this.codeBranch,
    this.codeProvider,
    this.codeClient,
    this.nameBranch,
    this.codeConsult,
    required this.state,
    this.balance = true,
    required this.listBranchs,
  });

  List<NegotiationModel> listItems;
  final String? description;
  final ValueListenable state;
  final int? codeBranch;
  final int? codeConsult;
  final String? nameBranch;
  final int? codeProvider;
  final int? codeClient;
  final bool balance;
  final List<ClientsSelectStoreModel>? listBranchs;

  @override
  State<ComponentList> createState() => _ComponentListState();
}

class _ComponentListState extends State<ComponentList> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return StateManagement(
      width: width,
      listenable: widget.state,
      widgetLoading: LoadingList(icon: Icons.swap_horiz_rounded, label: "Negociações"),
      component: Column(
        children: [
          HeaderList(
            icon: Icons.swap_horiz_rounded,
            activeSearch: false,
            label: "Negociações",
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              children: widget.listItems.asMap().entries.map((e) {
                return e.value.confirm == null && widget.balance
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Material(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(14),
                          elevation: isDark ? 0 : 2,
                          shadowColor: Colors.black.withValues(alpha: 0.08),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: () {
                              for (var i = 0; i < widget.listItems.length; i++) {
                                if (i == e.key) {
                                  widget.listItems[e.key].checked = true;
                                } else {
                                  widget.listItems[i].checked = false;
                                }
                              }
                              if (e.value.confirm != null) {
                                Navigator.of(context).pushNamed('tradingproducts', arguments: {
                                  "codeProvider": widget.codeProvider,
                                  "codeBranch": widget.codeBranch,
                                  "nameBranch": widget.nameBranch,
                                  "codeClient": widget.codeClient,
                                  "codeTrading": e.value.negotiation,
                                  "tradings": widget.listItems,
                                  "listBranchs": widget.listBranchs,
                                  "codeConsult": widget.codeConsult,
                                });
                              } else {
                                Fluttertoast.showToast(
                                  msg: "Negociação não possui pedidos!",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                border: isDark ? Border.all(color: colorScheme.onSurface.withValues(alpha: 0.1)) : null,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      _BadgePill(
                                        icon: Icons.tag_rounded,
                                        label: '${e.value.negotiation}',
                                        backgroundColor: colorPrimary.withValues(alpha: 0.12),
                                        foregroundColor: colorPrimary,
                                      ),
                                      if (e.value.confirm != null)
                                        _BadgePill(
                                          icon: Icons.check_circle_rounded,
                                          label: "Com pedidos",
                                          backgroundColor: colorGreen.withValues(alpha: 0.12),
                                          foregroundColor: colorGreen,
                                        )
                                      else
                                        _BadgePill(
                                          icon: Icons.remove_circle_outline_rounded,
                                          label: "Sem pedidos",
                                          backgroundColor: colorScheme.onSurface.withValues(alpha: 0.07),
                                          foregroundColor: colorGreyDark,
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "${e.value.title}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                      color: colorScheme.onSurface,
                                      height: 1.3,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.calendar_today_outlined,
                                        size: 13,
                                        color: colorGreyDark,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        DateFormat("dd/MM/yyyy").format(DateTime.parse(e.value.term!)),
                                        style: const TextStyle(
                                          color: colorGreyDark,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _BadgePill extends StatelessWidget {
  const _BadgePill({
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: foregroundColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: foregroundColor,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}
