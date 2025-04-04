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
            onSort: () {
              widget.providersController.sort();
            },
            label: "Fornecedores",
          ),
          ValueListenableBuilder(
              valueListenable: widget.providersController.stateSearchProviders,
              builder: (context, value, child) {
                return Column(
                    children: widget.providersController.providersList.map((e) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        "detailsprovider",
                        arguments: {"codeProvider": e.codeProvider, "imageProvider": e.image, "nameProvider": e.nameProvider, "codeBranch": widget.codeBranch, "color": e.color},
                      );
                    },
                    child: Container(
                      width: width,
                      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: colorGrey.withOpacity(0.3)))),
                      // height: 90,
                      padding: const EdgeInsets.symmetric(horizontal: appMargin, vertical: appPadding),
                      // height: 100,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (e.image != null)
                            Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(color: e.color != null ? Color(int.parse(e.color!)) : colorTertiary, borderRadius: BorderRadius.circular(50)),
                              child: Container(
                                height: 55,
                                width: 55,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    border: Border.all(color: colorWhite, width: 2), color: e.color != null ? Color(int.parse(e.color!)) : colorTertiary, borderRadius: BorderRadius.circular(50)),
                                child: Image.network(
                                  e.image!,
                                  width: 30,
                                ),
                              ),
                            ),
                          const SizedBox(width: appMargin),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  e.codeProvider.toString(),
                                  style: const TextStyle(fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  e.nameProvider!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      formatCurrency(e.totalValue!),
                                      style: const TextStyle(color: colorGreyDark, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // ),
                    ),
                  );
                }).toList());
              })
        ],
      ),
    );
  }
}
