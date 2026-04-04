import 'package:profair/src/components/spacing.dart';
import 'package:profair/src/controllers/requests_stores_controller.dart';
import 'package:profair/src/repositories/requests_stores_model.dart';
import 'package:profair/src/components/header_list.dart';
import 'package:profair/src/components/loading_list.dart';
import 'package:profair/src/utils/format_currency.dart';
import 'package:profair/src/views/home/components/categories.dart';
import 'package:profair/src/views/home/home_controller.dart';
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
    this.codeNegotiation,
    this.homeController,
    this.visibleBuyers,
    required this.requestsStoresController,
  });

  Iterable<RequestsStoresModel> listItems;
  final String? description;
  final ValueListenable state;
  final int? codeProvider;
  final int? codeNegotiation;
  final int? userCode;
  final bool? visibleBuyers;
  final HomeController? homeController;
  final RequestsStoresController requestsStoresController;

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
      widgetLoading: LoadingList(label: "Pedidos", icon: Icons.handshake),
      component: Column(
        children: [
          HeaderList(
            icon: Icons.handshake,
            onSearch: (String? value) {
              widget.requestsStoresController.search(value);
            },
            onOpenSearch: () {
              widget.requestsStoresController.filterValue.value = 0;
              widget.requestsStoresController.visibleSearch.value = true;
              widget.requestsStoresController.filter(0);
            },
            onCloseInfo: () {
              widget.requestsStoresController.visibleSearch.value = false;
            },
            label: "Pedidos",
          ),
          ValueListenableBuilder(
              valueListenable: widget.requestsStoresController.stateSearchStore,
              builder: (context, stateSearch, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.homeController != null && widget.homeController!.buyers.length > 2 && (widget.visibleBuyers != null && widget.visibleBuyers! == true))
                      ValueListenableBuilder(
                        valueListenable: widget.requestsStoresController.visibleSearch,
                        builder: (context, bool searchActive, child) {
                          return searchActive
                              ? Container()
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(appMargin, appMargin, appMargin, 0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).cardColor,
                                          borderRadius: BorderRadius.circular(14),
                                          border: Border.all(color: Colors.grey.withValues(alpha: 0.12)),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withValues(alpha: 0.05),
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(appPadding, appPadding, appPadding, 4),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets.all(7),
                                                    decoration: BoxDecoration(
                                                      color: colorBlueAccent.withValues(alpha: 0.1),
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                    child: const Icon(Icons.people_alt_rounded, size: 16, color: colorBlueAccent),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  const Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "Consultores",
                                                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                                                      ),
                                                      Text(
                                                        "Filtre os pedidos por consultor",
                                                        style: TextStyle(fontSize: 11, color: Colors.grey),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            ValueListenableBuilder(
                                              valueListenable: widget.requestsStoresController.filterValue,
                                              builder: (context, int? indexFilter, child) {
                                                return Categories(
                                                  index: indexFilter,
                                                  homeController: widget.homeController!,
                                                  filter: (value) {
                                                    widget.requestsStoresController.filter(value);
                                                  },
                                                );
                                              },
                                            ),
                                            const SizedBox(height: 8),
                                            Divider(height: 1, color: Colors.grey.withValues(alpha: 0.12)),
                                            Material(
                                              color: Colors.transparent,
                                              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(14)),
                                              child: InkWell(
                                                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(14)),
                                                onTap: () {
                                                  Navigator.of(context).pushNamed(
                                                    "consultants",
                                                    arguments: {
                                                      "provider": widget.codeProvider.toString(),
                                                    },
                                                  );
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: appPadding, vertical: 12),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        padding: const EdgeInsets.all(6),
                                                        decoration: BoxDecoration(
                                                          gradient: const LinearGradient(
                                                            colors: [colorBlueAccent, colorPrimary],
                                                            begin: Alignment.topLeft,
                                                            end: Alignment.bottomRight,
                                                          ),
                                                          borderRadius: BorderRadius.circular(7),
                                                        ),
                                                        child: const Icon(Icons.groups_rounded, size: 14, color: Colors.white),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      const Expanded(
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              "Atendimentos da equipe",
                                                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                                                            ),
                                                            Text(
                                                              "Ver sessões de atendimento da equipe",
                                                              style: TextStyle(fontSize: 11, color: Colors.grey),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const Icon(Icons.arrow_forward_ios_rounded, size: 13, color: Colors.grey),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const AppSpacing(),
                                    const Divider(),
                                  ],
                                );
                        },
                      ),
                    if (widget.homeController != null && widget.homeController!.buyers.length > 2 && (widget.visibleBuyers != null && widget.visibleBuyers! == true))
                      Padding(
                        padding: const EdgeInsets.fromLTRB(appPadding, appPadding, appPadding, 4),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: colorBlueAccent.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: const Icon(Icons.handshake_outlined, size: 14, color: colorBlueAccent),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              "Pedidos",
                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    Column(
                        children: widget.requestsStoresController.requestsStores.map((e) {
                      return InkWell(
                        onTap: () {
                          if (widget.userCode != 0) {
                            Navigator.of(context).pushNamed('selectprovider', arguments: {
                              "codeClient": 0,
                              "codeBranch": e.codeBranch,
                              "codeBuyer": 0,
                            });
                          } else if (widget.codeNegotiation != null) {
                            Navigator.of(context).pushNamed('tradingproducts', arguments: {
                              "codeProvider": widget.codeProvider,
                              "codeBranch": e.codeClient,
                              "nameBranch": "widget.nameBranch",
                              "codeClient": 0,
                              "codeTrading": widget.codeNegotiation,
                              "tradings": null,
                              "listBranchs": null,
                              "codeConsult": null,
                            });
                          } else if (widget.codeProvider != 0) {
                            Navigator.of(context).pushNamed('selectnegotiation', arguments: {
                              "codeBranch": e.codeClient,
                              "codeClient": 0,
                              "codeProvider": widget.codeProvider,
                              "balance": true,
                            });
                          } else {
                            Navigator.of(context).pushNamed(
                              "orderdetails",
                              arguments: {
                                "order": e,
                              },
                            );
                          }
                        },
                        child: Container(
                          width: double.maxFinite,
                          margin: const EdgeInsets.symmetric(horizontal: appMargin, vertical: 4),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(appPadding),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(9),
                                  decoration: BoxDecoration(
                                    color: colorBlueAccent.withValues(alpha: 0.08),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(Icons.storefront_outlined, size: 20, color: colorBlueAccent),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        e.razaoClient!,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                      ),
                                      if (e.nameForn != null) ...[
                                        const SizedBox(height: 2),
                                        Text(
                                          e.nameForn!,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 12, color: colorGreyDark),
                                        ),
                                      ],
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                            decoration: BoxDecoration(
                                              color: colorBlueAccent.withValues(alpha: 0.1),
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              formatCurrency(e.value!),
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                                color: colorBlueAccent,
                                              ),
                                            ),
                                          ),
                                          if (e.termNegotiation != null && e.termNegotiation!.isNotEmpty) ...[
                                            const SizedBox(width: 6),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                                              decoration: BoxDecoration(
                                                color: Colors.grey.withValues(alpha: 0.1),
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              child: Text(
                                                e.termNegotiation!,
                                                style: const TextStyle(fontSize: 11, color: colorGreyDark),
                                              ),
                                            ),
                                          ],
                                          const Spacer(),
                                          Row(
                                            children: [
                                              const Icon(Icons.access_time_rounded, size: 12, color: colorGreyDark),
                                              const SizedBox(width: 3),
                                              Text(
                                                '${e.hour}',
                                                style: const TextStyle(fontSize: 11, color: colorGreyDark),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.arrow_forward_ios_rounded, size: 13, color: colorGreyDark),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList()),
                  ],
                );
              })
        ],
      ),
    );
  }
}
