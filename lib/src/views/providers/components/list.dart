import 'dart:developer';

import 'package:profair/src/controllers/providers_controller.dart';
import 'package:profair/src/utils/format_currency.dart';
import 'package:profair/src/views/home/state_management.dart';
import 'package:profair/src/components/loading_list.dart';
import 'package:profair/src/components/header_list.dart';
import 'package:profair/src/models/providers_model.dart';
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
    required this.providersController,
    required this.codeClient,
    required this.codeBranch,
  });

  Iterable<ProvidersModel> listItems;
  final String? description;
  final ValueListenable state;
  final int? codeProvider;
  final ProvidersController providersController;
  final int? codeClient;
  final int? codeBranch;

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
      widgetLoading: LoadingList(icon: Icons.groups_2_sharp, label: widget.description),
      component: Column(
        children: [
          HeaderList(
            icon: Icons.groups_2_sharp,
            onSearch: (String? value) {
              widget.providersController.search(value);
            },
            label: widget.description,
          ),
          ValueListenableBuilder(
              valueListenable: widget.providersController.stateSearchProviders,
              builder: (context, value, child) {
                return Column(
                    children: widget.providersController.providersList.map((e) {
                  return InkWell(
                    onTap: () {
                      dynamic data;
                      if (widget.codeBranch != 0) {
                        data = {
                          "codeBranch": widget.codeBranch,
                          "codeClient": widget.codeClient,
                          "codeProvider": e.codeProvider,
                        };
                      } else {
                        data = {
                          "codeBranch": widget.codeClient,
                          "codeClient": 0,
                          "codeProvider": e.codeProvider,
                        };
                      }
                      Navigator.of(context).pushNamed(
                        "selectnegotiation",
                        arguments: data,
                      );
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
                            e.nameProvider!.length < 28 ? '${e.nameProvider}' : "${e.nameProvider!.substring(0, 25)}...",
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          const SizedBox(height: appMargin),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                formatCurrency(e.totalValue!),
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
