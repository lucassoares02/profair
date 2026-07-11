import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:profair/src/components/header_list.dart';
import 'package:profair/src/components/loading_list.dart';
import 'package:profair/src/models/nogotiation_model.dart';
import 'package:profair/src/views/home/state_management.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../models/clients_select_stores_model.dart';

class ComponentList extends StatefulWidget {
  ComponentList({
    super.key,
    required this.listItems,
    this.description,
    this.codeGroup,
    this.codeProvider,
    this.codeClient,
    this.nameBranch,
    this.codeConsult,
    this.getOrderObservation,
    this.stateOrderObservation,
    required this.state,
    this.balance = true,
    required this.listBranchs,
  });

  List<NegotiationModel> listItems;
  final String? description;
  final ValueListenable state;
  final int? codeGroup;
  final int? codeConsult;
  final String Function()? getOrderObservation;
  final ValueListenable? stateOrderObservation;
  final String? nameBranch;
  final int? codeProvider;
  final int? codeClient;
  final bool balance;
  final List<ClientsSelectStoreModel>? listBranchs;

  @override
  State<ComponentList> createState() => _ComponentListState();
}

class _ComponentListState extends State<ComponentList> {
  Widget _buildOrderObservation(BuildContext context) {
    final listenable = widget.stateOrderObservation;
    if (listenable == null) return const SizedBox.shrink();

    return ValueListenableBuilder(
      valueListenable: listenable,
      builder: (context, value, child) {
        final observation = widget.getOrderObservation?.call().trim() ?? "";
        if (observation.isEmpty) return const SizedBox.shrink();

        final colorScheme = Theme.of(context).colorScheme;
        return Container(
          width: double.maxFinite,
          margin: const EdgeInsets.fromLTRB(appMargin, 0, appMargin, appMargin),
          padding: const EdgeInsets.symmetric(vertical: appPadding),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                  color: colorScheme.onSurface.withValues(alpha: 0.08)),
              bottom: BorderSide(
                  color: colorScheme.onSurface.withValues(alpha: 0.08)),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Observação",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface.withValues(alpha: 0.82),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                observation,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.35,
                  color: colorScheme.onSurface.withValues(alpha: 0.68),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return StateManagement(
      width: width,
      listenable: widget.state,
      widgetLoading:
          LoadingList(icon: Icons.swap_horiz_rounded, label: "Negociações"),
      component: Column(
        children: [
          HeaderList(
            icon: Icons.swap_horiz_rounded,
            activeSearch: false,
            label: "Negociações",
          ),
          _buildOrderObservation(context),
          Column(
              children: widget.listItems.asMap().entries.map((e) {
            return e.value.confirm == null && widget.balance
                ? Container()
                : Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: appMargin, vertical: appMargin * 0.3),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.08),
                        width: 1,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        splashColor: colorSecondary.withOpacity(0.06),
                        highlightColor: colorSecondary.withOpacity(0.03),
                        onTap: () {
                          for (var i = 0; i < widget.listItems.length; i++) {
                            if (i == e.key) {
                              widget.listItems[e.key].checked = true;
                            } else {
                              widget.listItems[i].checked = false;
                            }
                          }
                          if (e.value.confirm != null) {
                            Navigator.of(context)
                                .pushNamed('tradingproducts', arguments: {
                              "codeProvider": widget.codeProvider,
                              "codeBranch": e.value.codAssoc,
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
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: appMargin * 1.1,
                              vertical: appMargin * 0.9),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Conteúdo principal
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${e.value.negotiation}',
                                          style: TextStyle(
                                            color:
                                                colorGreyDark.withOpacity(0.7),
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 0.4,
                                          ),
                                        ),
                                        if (e.value.confirm != null)
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 7, vertical: 3),
                                            decoration: BoxDecoration(
                                              color:
                                                  colorGreen.withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              border: Border.all(
                                                  color: colorGreen
                                                      .withOpacity(0.2),
                                                  width: 1),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(Icons.check_circle_rounded,
                                                    color: colorGreen,
                                                    size: 10),
                                                const SizedBox(width: 3),
                                                Text(
                                                  'Confirmado',
                                                  style: TextStyle(
                                                    color: colorGreen,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w600,
                                                    letterSpacing: 0.2,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),

                                    const SizedBox(height: 5),

                                    // Linha 2: Título principal (maior hierarquia)
                                    Text(
                                      '${e.value.title}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15,
                                        letterSpacing: 0.1,
                                        height: 1.2,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),

                                    const SizedBox(height: 5),

                                    // Linha 3: Código + Razão do associado (hierarquia secundária)
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: colorSecondary
                                                .withOpacity(0.08),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            '${e.value.codAssoc}',
                                            style: TextStyle(
                                              color: colorSecondary,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: 0.3,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: Text(
                                            '${e.value.razaoAssociado}',
                                            style: TextStyle(
                                              color: colorGreyDark
                                                  .withOpacity(0.85),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 5),

                                    // Linha 4: Data
                                    Row(
                                      children: [
                                        Icon(Icons.calendar_today_outlined,
                                            size: 11,
                                            color:
                                                colorGreyDark.withOpacity(0.5)),
                                        const SizedBox(width: 4),
                                        Text(
                                          DateFormat("dd/MM/yyyy").format(
                                              DateTime.parse(e.value.term!)),
                                          style: TextStyle(
                                            color:
                                                colorGreyDark.withOpacity(0.6),
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(width: appMargin * 0.5),
                              Icon(Icons.chevron_right_rounded,
                                  color: colorGreyDark.withOpacity(0.3),
                                  size: 18),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
          }).toList())
        ],
      ),
    );
  }
}
