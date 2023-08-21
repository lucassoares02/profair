import 'package:profair/src/controllers/tradings_controller.dart';
import 'package:profair/src/views/home/state_management.dart';
import 'package:profair/src/components/loading_list.dart';
import 'package:profair/src/components/header_list.dart';
import 'package:profair/src/models/tradings_model.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:profair/generated/l10n.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ComponentList extends StatefulWidget {
  ComponentList({super.key, this.description, required this.listItems, required this.state, required this.codeProvider, required this.tradingsController});

  Iterable<TradingsModel> listItems;
  final String? description;
  final ValueListenable state;
  final int? codeProvider;
  final TradingsController tradingsController;

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
      widgetLoading: LoadingList(icon: Icons.groups_2_sharp, label: S.of(context).text_customers),
      component: Column(
        children: [
          HeaderList(
            icon: Icons.groups_2_sharp,
            onSearch: (String? value) {
              widget.tradingsController.search(value);
            },
            label: S.of(context).text_customers,
          ),
          ValueListenableBuilder(
              valueListenable: widget.tradingsController.stateSearchTrandings,
              builder: (context, value, child) {
                return Column(
                    children: widget.tradingsController.tradingList.map((e) {
                  return InkWell(
                    onTap: () {},
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
                            e.title!.length < 28 ? '${e.title}' : "${e.title!.substring(0, 25)}...",
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          const SizedBox(height: appMargin),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${e.provider} ',
                                style: const TextStyle(color: colorGreyDark),
                              ),
                              Text(
                                '${e.totalVolume} | R\$ ${e.totalValue}',
                                style: TextStyle(color: (e.totalVolume != "0") ? colorGreyDark : colorGrey, fontWeight: FontWeight.bold),
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
