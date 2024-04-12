import 'package:profair/src/controllers/clients_controller.dart';
import 'package:profair/src/utils/format_currency.dart';
import 'package:profair/src/views/home/state_management.dart';
import 'package:profair/src/components/loading_list.dart';
import 'package:profair/src/components/header_list.dart';
import 'package:profair/src/models/clients_model.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:profair/generated/l10n.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ComponentList extends StatefulWidget {
  ComponentList(
      {super.key,
      this.description,
      required this.listItems,
      required this.state,
      required this.codeProvider,
      required this.clientsController,
      this.onClickCard = true,
      required this.accessTargenting});

  Iterable<ClientsModel> listItems;
  final String? description;
  final ValueListenable state;
  final int? codeProvider;
  final ClientsController clientsController;
  final int accessTargenting;
  final bool onClickCard;

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
      widgetLoading: LoadingList(icon: Icons.groups_2_sharp, label: "Lojas"),
      component: Column(
        children: [
          HeaderList(
            icon: Icons.groups_2_sharp,
            onSort: () {
              widget.clientsController.sort();
            },
            onSearch: (String? value) {
              widget.clientsController.search(value);
            },
            label: "Lojas",
          ),
          ValueListenableBuilder(
              valueListenable: widget.clientsController.stateSearchClients,
              builder: (context, value, child) {
                return Column(
                    children: widget.clientsController.clientsList.map((e) {
                  return InkWell(
                    onTap: () {
                      if (widget.onClickCard) {
                        if (e.totalValue != 0) {
                          if (widget.accessTargenting == 3 || widget.accessTargenting == 0) {
                            Navigator.of(context).pushNamed(
                              "selectprovider",
                              arguments: {"codeClient": 0, "codeBuyer": 0, "codeBranch": e.codeBranch},
                            );
                          } else {
                            Navigator.of(context).pushNamed(
                              "selectnegotiation",
                              arguments: {
                                "codeBranch": e.codeBranch,
                                "codeClient": 0,
                                "codeProvider": widget.codeProvider,
                              },
                            );
                          }
                        } else {
                          Fluttertoast.showToast(
                              msg: "Cliente não possui pedidos!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      }
                    },
                    child: Container(
                      width: width,
                      height: 100,
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
                            "${e.codeBranch}",
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            "${e.nameCompany}",
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    "Volume de compra: ${e.totalVolume!}",
                                    style: const TextStyle(color: colorGreyDark),
                                  ),
                                ],
                              ),
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
