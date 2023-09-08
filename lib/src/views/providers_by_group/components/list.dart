import 'package:profair/src/components/spacing.dart';
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
  });

  Iterable<ProvidersModel> listItems;
  final String? description;
  final ValueListenable state;
  final int? codeProvider;
  final ProvidersController providersController;
  final int? codeClient;

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
                      // if (widget.codeBranch != 0) {
                      Navigator.of(context).pushNamed(
                        "productsprovider",
                        arguments: {
                          "codeClient": widget.codeClient,
                          "codeProvider": e.codeProvider,
                        },
                      );
                      // } else {
                      //   Navigator.of(context).pushNamed(
                      //     "selectnegotiation",
                      //     arguments: {
                      //       "codeBranch": widget.codeClient,
                      //       "codeClient": 0,
                      //       "codeProvider": e.codeProvider,
                      //     },
                      //   );
                      // }
                    },
                    child: Container(
                      width: width,
                      padding: const EdgeInsets.symmetric(horizontal: appMargin, vertical: appPadding),
                      margin: const EdgeInsets.symmetric(horizontal: appMargin),
                      decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: colorGreyLigth)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(50)),
                              color: e.totalValue != 0.0 ? colorSecondary : colorGreyLigth,
                            ),
                            child: const Center(
                                child: Icon(
                              Icons.domain_rounded,
                              color: colorWhite,
                              size: 20,
                            )),
                          ),
                          const AppSpacing(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    e.nameProvider!.length < 35 ? '${e.nameProvider}' : "${e.nameProvider!.substring(0, 34)}...",
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      // const Icon(Icons.paid, color: colorPrimary, size: 20),
                                      Text(
                                        // formatCurrency(e.totalValue!),
                                        e.socialName!,
                                        style: const TextStyle(color: colorGreyDark),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.start,
                              //   children: [
                              //     TextButton(
                              //         style: TextButton.styleFrom(padding: EdgeInsets.zero),
                              //         onPressed: () {
                              //           Navigator.of(context).pushNamed(
                              //             "selectnegotiation",
                              //             // arguments: {
                              //             //   "codeBranch": widget.codeClient,
                              //             //   "codeClient": 0,
                              //             //   "codeProvider": e.codeProvider,
                              //             // },
                              //             arguments: {
                              //               "codeBranch": widget.codeBranch,
                              //               "codeClient": 0,
                              //               "codeProvider": e.codeProvider,
                              //             },
                              //           );
                              //         },
                              //         child: const Text(
                              //           "Negociações",
                              //           style: TextStyle(fontWeight: FontWeight.w600),
                              //         )),
                              //     if (widget.codeBranch != 0) const AppSpacing(),
                              //     if (widget.codeBranch != 0)
                              //       TextButton(
                              //         onPressed: () {
                              //           Navigator.of(context).pushNamed(
                              //             "productsprovider",
                              //             arguments: {
                              //               "codeClient": widget.codeBranch,
                              //               "codeProvider": e.codeProvider,
                              //             },
                              //           );
                              //         },
                              //         child: const Text(
                              //           "Mercadorias",
                              //           style: TextStyle(fontWeight: FontWeight.w600),
                              //         ),
                              //       ),
                              //   ],
                              // )
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
