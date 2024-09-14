import 'package:intl/intl.dart';
import 'package:profair/src/controllers/tradings_controller.dart';
import 'package:profair/src/views/home/home_controller.dart';
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
  ComponentList({super.key, this.description, required this.listItems, required this.state, required this.homeController, this.codeNegotiation, required this.tradingsController});

  Iterable<TradingsModel> listItems;
  final String? description;
  final ValueListenable state;
  final HomeController homeController;
  final int? codeNegotiation;
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
      widgetLoading: LoadingList(icon: Icons.swap_horiz_rounded, label: S.of(context).text_trading),
      component: Column(
        children: [
          HeaderList(
            icon: Icons.swap_horiz_rounded,
            onSearch: (String? value) {
              widget.tradingsController.search(value);
            },
            label: "Negociações",
          ),
          ValueListenableBuilder(
              valueListenable: widget.tradingsController.stateSearchTrandings,
              builder: (context, value, child) {
                return Column(
                    children: widget.tradingsController.tradingList.map((e) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed('listrequestsstores',
                          arguments: {"codeProvider": e.provider, "userCode": 0, "codeNegotiation": e.code, "homeController": widget.homeController, "visibleBuyers": false});
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
                            '${e.code}',
                            style: const TextStyle(color: colorGreyDark),
                          ),
                          Text(
                            "${e.title}",
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.date_range,
                                    size: 18,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    DateFormat("dd/MM/yyyy").format(DateTime.parse(e.term!)),
                                    style: TextStyle(
                                      color: (e.totalVolume != "0") ? colorGreyDark : colorGrey,
                                    ),
                                  ),
                                ],
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
