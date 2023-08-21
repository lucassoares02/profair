import 'dart:developer';

import 'package:profair/src/components/header_list.dart';
import 'package:profair/src/components/loading_list.dart';
import 'package:profair/src/models/clients_model.dart';
import 'package:profair/src/models/login_model.dart';
import 'package:profair/src/views/home/state_management.dart';
import 'package:profair/src/components/spacing.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:profair/generated/l10n.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ComponentList extends StatefulWidget {
  const ComponentList({super.key, this.description, required this.listItems, required this.state, required this.codeProvider, required this.client});

  final List<ClientsModel> listItems;
  final String? description;
  final ValueListenable state;
  final int? codeProvider;
  final LoginModel? client;

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
      widgetLoading: LoadingList(icon: Icons.store_mall_directory_outlined, label: S.of(context).text_store),
      component: Column(
        children: [
          HeaderList(
            icon: Icons.store_mall_directory_outlined,
            activeSearch: false,
            label: S.of(context).text_store,
          ),
          Container(
            width: width,
            padding: const EdgeInsets.all(appPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: width,
                  padding: const EdgeInsets.all(appPadding),
                  decoration: const BoxDecoration(
                    color: colorLight,
                    borderRadius: BorderRadius.all(
                      Radius.circular(appRadius),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Dê as boas vindas a"),
                          const SizedBox(height: appMargin / 2),
                          Row(
                            children: [
                              Text(
                                "${widget.client!.nameUser}",
                                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: appMargin / 2),
                              const Icon(
                                Icons.verified,
                                color: colorSecondary,
                                size: 18,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Column(
              children: widget.listItems.map((e) {
            return InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(
                  'selectnegotiation',
                  arguments: {
                    "codeProvider": widget.codeProvider,
                    "nameBranch": e.nameCompany,
                    "codeBranch": e.relationshipCode,
                    "codeClient": widget.client!.userCode,
                  },
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
                child: Row(
                  children: [
                    const AppSpacing(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          e.nameCompany!.length < 28 ? '${e.nameCompany}' : e.nameCompany!.substring(0, 25),
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          '${e.documentCompany}',
                          style: const TextStyle(color: colorGreyDark),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList())
        ],
      ),
    );
  }
}
