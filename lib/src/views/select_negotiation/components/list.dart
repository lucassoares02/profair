import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
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
      widgetLoading: LoadingList(icon: Icons.swap_horiz_rounded, label: "Negociações"),
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
                      if (e.value.confirm != null) {
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
                      } else {
                        Fluttertoast.showToast(
                          msg: "Negociação não possui pedidos!",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      }
                    },
                    child: Container(
                      height: 90,
                      padding: const EdgeInsets.all(appMargin),
                      margin: const EdgeInsets.symmetric(horizontal: appMargin),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3))),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${e.value.negotiation}',
                                style: const TextStyle(color: colorGreyDark),
                              ),
                              if (e.value.confirm != null)
                                const Icon(
                                  Icons.check_circle,
                                  color: colorGreen,
                                  size: appPadding,
                                )
                            ],
                          ),
                          Text(
                            "${e.value.title}",
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            DateFormat("dd/MM/yyyy").format(DateTime.parse(e.value.term!)),
                            style: const TextStyle(color: colorGreyDark),
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
