import 'dart:developer';

import 'package:profair/src/controllers/requests_stores.dart';
import 'package:profair/src/repositories/requests_stores_model.dart';
import 'package:profair/src/components/header_list.dart';
import 'package:profair/src/components/loading_list.dart';
import 'package:profair/src/utils/format_currency.dart';
import 'package:profair/src/views/home/state_management.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:profair/generated/l10n.dart';
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
    required this.requestsStoresController,
  });

  Iterable<RequestsStoresModel> listItems;
  final String? description;
  final ValueListenable state;
  final int? codeProvider;
  final int? userCode;
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
      widgetLoading: LoadingList(label: S.of(context).text_orders_placed, icon: Icons.handshake),
      component: Column(
        children: [
          HeaderList(
            icon: Icons.handshake,
            onSearch: (String? value) {
              widget.requestsStoresController.search(value);
            },
            label: S.of(context).text_orders_placed,
          ),
          ValueListenableBuilder(
              valueListenable: widget.requestsStoresController.stateSearchStore,
              builder: (context, value, child) {
                return Column(
                    children: widget.requestsStoresController.requestsStores.map((e) {
                  return InkWell(
                    onTap: () {
                      inspect(e);
                      if (widget.userCode != 0) {
                        Navigator.of(context).pushNamed('selectprovider', arguments: {
                          "codeClient": 0,
                          "codeBranch": e.codeBranch,
                          "codeBuyer": 0,
                        });
                      } else if (widget.codeProvider != 0) {
                        Navigator.of(context).pushNamed('selectnegotiation', arguments: {
                          "codeBranch": e.codeClient,
                          "codeClient": 0,
                          "codeProvider": widget.codeProvider,
                        });
                      }
                    },
                    child: Container(
                      width: width,
                      height: 90,
                      padding: const EdgeInsets.all(appMargin),
                      margin: const EdgeInsets.symmetric(horizontal: appMargin),
                      decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: colorGrey)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            e.razaoClient!.length < 28 ? '${e.razaoClient}' : e.razaoClient!.substring(0, 25),
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${e.documentCompany}',
                                style: const TextStyle(color: colorGreyDark),
                              ),
                              Text(
                                formatCurrency(e.value!),
                                style: const TextStyle(color: colorGreyDark),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList());
              })
        ],
      ),
    );
  }
}
