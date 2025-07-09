import 'package:profair/src/components/spacing.dart';
import 'package:profair/src/controllers/providers_controller.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:profair/src/utils/format_currency.dart';
import 'package:profair/src/views/home/state_management.dart';
import 'package:profair/src/components/loading_list.dart';
import 'package:profair/src/components/header_list.dart';
import 'package:profair/src/models/providers_model.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
  int selling = 0;

  @override
  void initState() {
    super.initState();
    widget.providersController.findMap();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return StateManagement(
      width: width,
      listenable: widget.state,
      widgetLoading: LoadingList(icon: Icons.groups_2_sharp, label: widget.description),
      component: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
              valueListenable: widget.providersController.stateMap,
              builder: (context, stateM, child) {
                return stateM == StateApp.loading
                    ? const Skeletonizer(
                        child: SizedBox(
                          height: 100,
                          width: double.infinity,
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      )
                    : (widget.providersController.mapUrl != null && widget.providersController.mapUrl != "null" && widget.providersController.mapUrl != "")
                        ? Column(
                            children: [
                              const AppSpacing(),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                    "mapevent",
                                    arguments: {"map": widget.providersController.mapUrl},
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 16),
                                  padding: const EdgeInsets.all(appPadding),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.blue.withOpacity(0.1),
                                    border: Border.all(color: Colors.blue.withOpacity(0.9)),
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(Icons.map_outlined, color: Colors.blue),
                                      AppSpacing(),
                                      // Aqui: Column agora fica dentro de um Expanded
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Mapa do Evento"),
                                            SizedBox(height: 4),
                                            Text(
                                              "Acesse o mapa do evento para ver os stands dos fornecedores.",
                                              softWrap: true,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const AppSpacing(),
                            ],
                          )
                        : Container();
              }),
          ValueListenableBuilder(
              valueListenable: widget.providersController.stateProviders,
              builder: (context, stateSell, child) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: appMargin),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              selling = 0;
                            });
                            widget.providersController.providerSelling(selling);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(left: appPadding),
                            decoration: BoxDecoration(
                              color: selling == 0 ? colorSecondary.withValues(alpha: 0.6) : Theme.of(context).colorScheme.onSurface.withValues(alpha: .1),
                              borderRadius: BorderRadius.circular(40),
                              border: Border.all(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: .2), width: 1),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: appPadding, vertical: appPadding / 2),
                            child: Row(
                              children: [
                                Text(
                                  "Todos",
                                  style: TextStyle(color: selling == 0 ? colorWhite : Theme.of(context).colorScheme.onSurface.withValues(alpha: .7), fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  widget.providersController.sellCounts[0].toString(),
                                  style: TextStyle(color: selling == 0 ? colorWhite : Theme.of(context).colorScheme.onSurface.withValues(alpha: .7)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        InkWell(
                          onTap: () {
                            setState(() {
                              selling = 2;
                            });
                            widget.providersController.providerSelling(selling);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: selling == 2 ? colorSecondary.withValues(alpha: 0.6) : Theme.of(context).colorScheme.onSurface.withValues(alpha: .1),
                              borderRadius: BorderRadius.circular(40),
                              border: Border.all(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: .2), width: 1),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: appPadding, vertical: appPadding / 2),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Com pedido",
                                  style: TextStyle(color: selling == 2 ? colorWhite : Theme.of(context).colorScheme.onSurface.withValues(alpha: .7), fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  widget.providersController.sellCounts[1].toString(),
                                  style: TextStyle(color: selling == 2 ? colorWhite : Theme.of(context).colorScheme.onSurface.withValues(alpha: .7)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        InkWell(
                          onTap: () {
                            setState(() {
                              selling = 1;
                            });
                            widget.providersController.providerSelling(selling);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: selling == 1 ? colorSecondary.withValues(alpha: 0.6) : Theme.of(context).colorScheme.onSurface.withValues(alpha: .1),
                              borderRadius: BorderRadius.circular(40),
                              border: Border.all(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: .2), width: 1),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: appPadding, vertical: appPadding / 2),
                            child: Row(
                              children: [
                                Text(
                                  "Sem pedido",
                                  style: TextStyle(color: selling == 1 ? colorWhite : Theme.of(context).colorScheme.onSurface.withValues(alpha: .7), fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  widget.providersController.sellCounts[2].toString(),
                                  style: TextStyle(color: selling == 1 ? colorWhite : Theme.of(context).colorScheme.onSurface.withValues(alpha: .7)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
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
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: colorGrey.withOpacity(0.3),
                          ),
                        ),
                      ),
                      // height: 90,
                      padding: const EdgeInsets.symmetric(horizontal: appMargin, vertical: appPadding),
                      // height: 100,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (e.image != null)
                            Stack(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: e.color != null ? Color(int.parse(e.color!)) : colorTertiary,
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(
                                      color: e.totalValue! == 0.0 ? Color(int.parse(e.color!)) : Colors.green,
                                      width: 3,
                                    ),
                                  ),
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    padding: const EdgeInsets.all(4),
                                    child: Image.network(
                                      e.image!,
                                      width: 30,
                                    ),
                                  ),
                                ),
                                e.totalValue! != 0.0
                                    ? Positioned(
                                        top: 45,
                                        right: 0,
                                        child: Container(
                                          width: 20,
                                          height: 20,
                                          decoration: const BoxDecoration(
                                            color: Colors.green,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.done_all_rounded,
                                            color: Colors.white,
                                            size: 15,
                                          ),
                                        ),
                                      )
                                    : Container(),
                              ],
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
                                      style: TextStyle(color: e.totalValue! == 0.0 ? colorGreyDark : null, fontWeight: FontWeight.bold),
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
