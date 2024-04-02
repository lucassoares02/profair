import 'package:profair/src/components/header_list.dart';
import 'package:profair/src/components/loading_list.dart';
import 'package:profair/src/models/nogotiation_model.dart';
import 'package:profair/src/views/home/state_management.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:profair/generated/l10n.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../models/clients_select_stores_model.dart';

class ComponentList extends StatefulWidget {
  ComponentList({
    super.key,
    required this.listItems,
    this.description,
    this.codeBranch,
    this.codeProvider,
    this.codeClient,
    this.nameBranch,
    this.codeConsult,
    required this.state,
    this.balance = true,
    required this.listBranchs,
  });

  List<NegotiationModel> listItems;
  final String? description;
  final ValueListenable state;
  final int? codeBranch;
  final int? codeConsult;
  final String? nameBranch;
  final int? codeProvider;
  final int? codeClient;
  final bool balance;
  final List<ClientsSelectStoreModel>? listBranchs;

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
            activeSearch: false,
            label: "Negociações",
          ),
          Column(
              children: widget.listItems.asMap().entries.map((e) {
            return e.value.confirm == null && widget.balance
                ? Container()
                : InkWell(
                    onTap: () {
                      for (var i = 0; i < widget.listItems.length; i++) {
                        if (i == e.key) {
                          widget.listItems[e.key].checked = true;
                        } else {
                          widget.listItems[i].checked = false;
                        }
                      }
                      Navigator.of(context).pushNamed('tradingproducts', arguments: {
                        "codeProvider": widget.codeProvider,
                        "codeBranch": widget.codeBranch,
                        "nameBranch": widget.nameBranch,
                        "codeClient": widget.codeClient,
                        "codeTrading": e.value.negotiation,
                        "tradings": widget.listItems,
                        "listBranchs": widget.listBranchs,
                        "codeConsult": widget.codeConsult,
                      });
                    },
                    child: Container(
                      height: 90,
                      padding: const EdgeInsets.all(appMargin),
                      margin: const EdgeInsets.symmetric(horizontal: appMargin),
                      decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: colorGrey)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            e.value.title!.length < 28 ? '${e.value.title}' : e.value.title!.substring(0, 25),
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${e.value.negotiation}',
                                style: const TextStyle(color: colorGreyDark),
                              ),
                              if (e.value.confirm != null)
                                const Icon(
                                  Icons.done_all,
                                  color: colorBlue,
                                  size: appPadding,
                                )
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
