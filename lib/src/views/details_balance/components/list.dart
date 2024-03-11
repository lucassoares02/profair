import 'dart:developer';

import 'package:profair/src/controllers/details_balance_controller.dart';
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
      widgetLoading: LoadingList(label: S.of(context).text_orders_placed, icon: Icons.handshake),
      component: Column(
        children: [
          HeaderList(
            icon: Icons.handshake,
            onSearch: (String? value) {
              widget.balanceController.search(value);
            },
            label: S.of(context).text_orders_placed,
          ),
          ValueListenableBuilder(
              valueListenable: widget.balanceController.stateSearchStore,
              builder: (context, value, child) {
                return Column(
                    children: widget.balanceController.requestsStores.map((e) {
                  return InkWell(
                    onTap: () {},
                    child: Container(
                      width: width,
                      height: 100,
                      padding: const EdgeInsets.all(appMargin),
                      margin: const EdgeInsets.symmetric(horizontal: appMargin),
                      decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: colorGrey)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                e.descriptionNegotiation!,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ],
                          ),
                          Text(
                            e.nameForn!,
                            style: const TextStyle(color: colorGreyDark),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                e.hour!,
                                style: const TextStyle(color: colorGreyDark, fontWeight: FontWeight.w300),
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
