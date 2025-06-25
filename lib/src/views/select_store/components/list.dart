import 'package:profair/src/components/header_list.dart';
import 'package:profair/src/components/loading_list.dart';
import 'package:profair/src/components/spacing.dart';
import 'package:profair/src/models/clients_select_stores_model.dart';
import 'package:profair/src/models/login_model.dart';
import 'package:profair/src/views/home/state_management.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:profair/generated/l10n.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ComponentList extends StatefulWidget {
  const ComponentList({super.key, this.description, required this.listItems, required this.state, required this.codeProvider, this.consult, required this.client});

  final List<ClientsSelectStoreModel> listItems;
  final String? description;
  final ValueListenable state;
  final int? codeProvider;
  final int? consult;
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
      widgetLoading: LoadingList(icon: Icons.store_mall_directory_outlined, label: "Lojas"),
      component: Column(
        children: [
          // HeaderList(
          //   onBackButton: () {
          //     Navigator.of(context).pushNamedAndRemoveUntil("/home", (route) => false);
          //   },
          //   icon: Icons.store_mall_directory_outlined,
          //   activeSearch: false,
          //   label: "Associado",
          // ),
          Container(
            width: width,
            decoration: const BoxDecoration(
              color: colorPrimary,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, color: colorWhite), // Altere o ícone aqui
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const AppSpacing(),
                const AppSpacing(),
                const AppSpacing(),
                const AppSpacing(),
                Container(
                  padding: const EdgeInsets.all(appPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Dê as boas vindas a",
                        style: TextStyle(color: colorWhite),
                      ),
                      const SizedBox(height: appMargin / 2),
                      Text(
                        "${widget.client!.nameUser}",
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: colorWhite),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(appPadding),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Lojas",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
          ),
          Column(
              children: widget.listItems.asMap().entries.map((e) {
            return InkWell(
              onTap: () {
                for (var i = 0; i < widget.listItems.length; i++) {
                  if (i == e.key) {
                    widget.listItems[e.key].checked = true;
                  } else {
                    widget.listItems[i].checked = false;
                  }
                }
                Navigator.of(context).pushNamed(
                  'selectnegotiation',
                  arguments: {
                    "new": 1,
                    "codeProvider": widget.codeProvider,
                    "nameBranch": e.value.nameCompany,
                    "codeBranch": e.value.relationshipCode,
                    "codeClient": widget.client!.userCode,
                    "client": widget.client,
                    "listBranchs": widget.listItems,
                    "consult": widget.consult,
                  },
                );
              },
              child: Container(
                width: width,
                height: 90,
                padding: const EdgeInsets.all(appMargin),
                margin: const EdgeInsets.symmetric(horizontal: appMargin),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: colorGrey.withValues(alpha: 0.3))),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${e.value.documentCompany}',
                      style: const TextStyle(color: colorGreyDark),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "${e.value.nameCompany}",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
