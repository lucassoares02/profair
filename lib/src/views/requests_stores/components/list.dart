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
                    if (widget.homeController != null &&
                        widget.homeController!.buyers.length > 2 &&
                        (widget.visibleBuyers != null && widget.visibleBuyers! == true))
                      ValueListenableBuilder(
                        valueListenable: widget.requestsStoresController.visibleSearch,
                        builder: (context, bool searchActive, child) {
                          return searchActive
                              ? Container()
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(appPadding),
                                      child: Text(
                                        "Consultores",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
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
                                        }),
                                    if (widget.homeController != null && widget.homeController!.buyers.length > 1)
                                      const AppSpacing(),
                                    const Divider(),
                                  ],
                                );
                        },
                      ),
                    if (widget.homeController != null &&
                        widget.homeController!.buyers.length > 2 &&
                        (widget.visibleBuyers != null && widget.visibleBuyers! == true))
                      const Padding(
                        padding: EdgeInsets.only(left: appPadding),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Pedidos",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                                fontSize: 18,
                              ),
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
                          height: 100,
                          padding: const EdgeInsets.all(appMargin),
                          margin: const EdgeInsets.symmetric(horizontal: appMargin),
                          decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: colorGrey.withOpacity(0.3))),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                e.razaoClient!,
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 5),
                              if (e.nameForn != null)
                                Text(
                                  e.nameForn!,
                                  style: const TextStyle(color: colorGreyDark),
                                ),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    formatCurrency(e.value!),
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '${e.hour}',
                                    style: const TextStyle(color: colorGreyDark),
                                  ),
                                ],
                              ),
                            ],
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
