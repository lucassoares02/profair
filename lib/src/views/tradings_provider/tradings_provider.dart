import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:profair/src/components/button.dart';
import 'package:profair/src/components/loading_list.dart';
import 'package:profair/src/components/spacing.dart';
import 'package:profair/src/controllers/finish_trading_controller.dart';
import 'package:profair/src/controllers/tradings_provider_controller.dart';
import 'package:profair/src/models/clients_select_stores_model.dart';
import 'package:profair/src/models/login_model.dart';
import 'package:profair/src/repositories/finish_trading_repository.dart';
import 'package:profair/src/repositories/tradings_provider_repository.dart';
import 'package:profair/src/components/header_actions.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:profair/src/utils/format_currency.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:flutter/material.dart';
import 'package:profair/src/views/tradings_provider/components/list.dart';

class TradingsProvider extends StatefulWidget {
  const TradingsProvider({
    super.key,
    required this.codeProvider,
    required this.codeBranch,
    this.codeConsult,
    required this.nameBranch,
    required this.codeClient,
    this.listBranchs,
    this.balance,
    this.client,
  });

  final int? codeProvider;
  final int? codeBranch;
  final String? nameBranch;
  final int? codeClient;
  final int? codeConsult;
  final List<ClientsSelectStoreModel>? listBranchs;
  final bool? balance;
  final LoginModel? client;

  @override
  State<TradingsProvider> createState() => _TradingsProviderState();
}

class _TradingsProviderState extends State<TradingsProvider> with SingleTickerProviderStateMixin {
  final TradingsProviderController tradingsProviderController = TradingsProviderController(StateApp.start, TradingsProviderRepository());
  final FinishTradingController finishTradingController = FinishTradingController(StateApp.start, FinishTradingRepository());

  @override
  void initState() {
    getFindTradingsProvider();
    super.initState();
  }

  saveOrder() async {
    try {
      await tradingsProviderController.insertInList(
        widget.codeBranch!,
        widget.codeProvider!,
        widget.codeClient!,
        widget.listBranchs!,
        widget.codeConsult!,
      );
      navigatorHome();
    } catch (e) {
      debugPrint("Error saveOrder: $e");
      Fluttertoast.showToast(
          msg: "Pedido não foi salvo!", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.red, textColor: Colors.white, fontSize: 16.0);
    }
  }

  navigatorHome() {
    Navigator.of(context).pushNamed("/tradingsuccess", arguments: {
      "client": widget.codeClient,
      "consult": widget.codeConsult,
      "trading": 0,
      "provider": widget.codeProvider,
      "branch": widget.codeBranch,
      "clientModel": widget.client,
      "finishTradingController": finishTradingController,
      "value": formatCurrency(tradingsProviderController.totalValue),
      "hour": DateFormat.Hm().format(DateTime.now()).toString()
    });
  }

  getFindTradingsProvider() async {
    await tradingsProviderController.findTradingsProvider(widget.codeBranch!, widget.codeProvider!);
    tradingsProviderController.tabController = TabController(vsync: this, length: tradingsProviderController.negotiations.length);
  }

// Intercepta a ação de voltar
  onPop(Size size) async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            elevation: 0.1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(appRadius),
            ),
            title: const Text('Deseja realmente sair?'),
            content: SizedBox(width: size.width * 1, child: const Text('Caso você volte as informações que foram digitadas serão perdidas, para que isso não aconteça finalize o pedido primeiro!')),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Cancelar"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text("Confirmar"),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return PopScope(
      canPop: false,
      onPopInvoked: (value) {
        onPop(size);
      },
      child: ValueListenableBuilder(
          valueListenable: tradingsProviderController.stateRequest,
          builder: (context, value, child) {
            return value == StateApp.loading
                ? Scaffold(
                    body: LoadingList(
                      loadingHeader: false,
                    ),
                  )
                : value == StateApp.success
                    ? Scaffold(
                        appBar: AppBar(
                          leading: Container(),
                          actions: [
                            ValueListenableBuilder(
                                valueListenable: tradingsProviderController.itemTotal,
                                builder: (context, value, child) {
                                  return HeaderActions(
                                    activeSearch: tradingsProviderController.tabSelected == (tradingsProviderController.negotiations.length - 1) ? false : true,
                                    label: tradingsProviderController.totalValue == 0.0 || (tradingsProviderController.tabController.index == (tradingsProviderController.negotiations.length - 1))
                                        ? "Negociações"
                                        : formatCurrency(tradingsProviderController.totalValue),
                                    onSearch: tradingsProviderController.tabSelected == (tradingsProviderController.negotiations.length - 1)
                                        ? null
                                        : (value) {
                                            tradingsProviderController.search(value);
                                          },
                                    alertClose: true,
                                    onSort: tradingsProviderController.tabSelected == (tradingsProviderController.negotiations.length - 1)
                                        ? null
                                        : () {
                                            tradingsProviderController.sort();
                                          },
                                    onCloseInfo: () {
                                      tradingsProviderController.updateTrading();
                                    },
                                  );
                                }),
                          ],
                          bottom: TabBar(
                            isScrollable: true,
                            tabAlignment: TabAlignment.start,
                            onTap: (value) {
                              tradingsProviderController.search("");
                              FocusScope.of(context).unfocus();
                              tradingsProviderController.tabSelected = value;
                              tradingsProviderController.itemTotal.value = StateApp.loading;
                              tradingsProviderController.itemTotal.value = StateApp.success;
                              tradingsProviderController.itemSelected.value = -1;
                            },
                            controller: tradingsProviderController.tabController,
                            indicatorColor: colorSecondary,
                            labelColor: colorSecondary,
                            tabs: tradingsProviderController.negotiations.asMap().entries.map((negotiation) {
                              return Container(
                                padding: const EdgeInsets.all(appPadding),
                                width: negotiation.key == (tradingsProviderController.negotiations.length - 1) ? size.width * 0.97 : null,
                                child: Row(
                                  children: [
                                    Text("${negotiation.value.title}"),
                                    if (negotiation.value.confirm != null) const SizedBox(width: 5),
                                    if (negotiation.value.confirm != null) Badge(alignment: Alignment.centerLeft, offset: Offset.fromDirection(3), backgroundColor: colorRed, smallSize: 8),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        body: TabBarView(
                          physics: const NeverScrollableScrollPhysics(),
                          controller: tradingsProviderController.tabController,
                          children: tradingsProviderController.negotiations.asMap().entries.map((negotiation) {
                            return negotiation.key == (tradingsProviderController.negotiations.length - 1)
                                ? ValueListenableBuilder(
                                    valueListenable: tradingsProviderController.itemTotal,
                                    builder: (context, value, child) {
                                      return SingleChildScrollView(
                                        child: Container(
                                          padding: const EdgeInsets.all(appPadding),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            formatCurrency(tradingsProviderController.totalValue),
                                                            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: colorSecondary),
                                                          ),
                                                          Text("${tradingsProviderController.totalVolume}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          const Text(
                                                            "para ",
                                                            style: TextStyle(fontSize: 14, color: colorGreyDark),
                                                          ),
                                                          Text(
                                                            "${widget.listBranchs!.first.nameUser}",
                                                            style: const TextStyle(fontSize: 14, color: colorGreyDark, fontWeight: FontWeight.bold),
                                                          ),
                                                        ],
                                                      ),
                                                      Text(
                                                        // "${DateTime.now().hour}:${DateTime.now().minute}",
                                                        DateFormat.Hm().format(DateTime.now()),
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          color: colorGreyDark,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const AppSpacing(),
                                                  Container(
                                                    decoration: const BoxDecoration(
                                                      border: Border(bottom: BorderSide(color: colorGrey)),
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        Column(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                          children: [
                                                            ValueListenableBuilder(
                                                                valueListenable: tradingsProviderController.stateTradings,
                                                                builder: (context, value, child) {
                                                                  return Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: widget.listBranchs!.asMap().entries.map((e) {
                                                                      return e.value.checked!
                                                                          ? Container(
                                                                              width: double.maxFinite,
                                                                              margin: const EdgeInsets.symmetric(vertical: appMargin),
                                                                              child: Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Text(
                                                                                    e.value.documentCompany!,
                                                                                    style: const TextStyle(fontSize: 14, color: colorGreyDark),
                                                                                    overflow: TextOverflow.fade,
                                                                                  ),
                                                                                  // const SizedBox(height: 5),
                                                                                  // Text(
                                                                                  //   e.value.documentCompany.toString(),
                                                                                  //   style: const TextStyle(fontSize: 14, color: colorGreyDark),
                                                                                  // ),
                                                                                ],
                                                                              ),
                                                                            )
                                                                          : Container();
                                                                    }).toList(),
                                                                  );
                                                                }),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const AppSpacing(),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      const Text(
                                                        "Negociações",
                                                        style: TextStyle(color: colorGreyDark, fontWeight: FontWeight.bold),
                                                      ),
                                                      const AppSpacing(),
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: tradingsProviderController.negotiationResume.map((negotiation) {
                                                          return Container(
                                                            margin: const EdgeInsets.only(bottom: appMargin),
                                                            padding: const EdgeInsets.all(appPadding),
                                                            decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(appRadius),
                                                                border: Border.all(
                                                                  width: 1,
                                                                  color: colorGrey,
                                                                )),
                                                            child: Column(
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      "${negotiation.negotiation} - ${negotiation.title}",
                                                                      style: const TextStyle(fontSize: 14, color: colorGreyDark, fontWeight: FontWeight.bold),
                                                                    ),
                                                                  ],
                                                                ),
                                                                const Divider(),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    Text("Volume: ${negotiation.volume}"),
                                                                    Text(
                                                                      "Valor total: ${formatCurrency(negotiation.value)}",
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        }).toList(),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  if (widget.listBranchs!.length > 1)
                                                    ExpansionTile(
                                                      title: const Text(
                                                        "Deseja adicionar outras lojas?",
                                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                                      ),
                                                      collapsedIconColor: Colors.grey,
                                                      tilePadding: const EdgeInsets.all(0),
                                                      shape: const Border.symmetric(horizontal: BorderSide(color: Colors.transparent)),
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Container(
                                                              padding: const EdgeInsets.all(appMargin),
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(appRadius),
                                                                border: Border.all(
                                                                  color: Colors.grey,
                                                                ),
                                                              ),
                                                              child: const Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    "Importante! Caso outras opções sejam selecionadas, o mesmo pedido será replicado para as demais filiais, confira a diferença de valor na sessão acima.",
                                                                    style: TextStyle(fontSize: 14),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: size.width,
                                                              child: Column(
                                                                children: widget.listBranchs!.asMap().entries.map(
                                                                  (e) {
                                                                    return InkWell(
                                                                      onTap: () {
                                                                        if (e.value.checked! && tradingsProviderController.totalCheckedBranch > 1) {
                                                                          tradingsProviderController.totalCheckedBranch -= 1;
                                                                          widget.listBranchs![e.key].checked = !e.value.checked!;
                                                                        } else if (e.value.checked! == false) {
                                                                          tradingsProviderController.totalCheckedBranch += 1;
                                                                          widget.listBranchs![e.key].checked = !e.value.checked!;
                                                                        }
                                                                        tradingsProviderController.updateTrading();
                                                                      },
                                                                      child: Container(
                                                                        width: double.maxFinite,
                                                                        decoration: const BoxDecoration(
                                                                          border: Border(bottom: BorderSide(color: colorGrey)),
                                                                        ),
                                                                        child: Row(
                                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                          children: [
                                                                            ValueListenableBuilder(
                                                                                valueListenable: tradingsProviderController.stateTradings,
                                                                                builder: (context, bool value, child) {
                                                                                  return Checkbox(
                                                                                    activeColor: colorSecondary,
                                                                                    value: e.value.checked,
                                                                                    side: const BorderSide(color: colorGrey),
                                                                                    shape: const RoundedRectangleBorder(
                                                                                      borderRadius: BorderRadius.all(
                                                                                        Radius.circular(4),
                                                                                      ),
                                                                                    ),
                                                                                    onChanged: (value) {
                                                                                      if (e.value.checked! && tradingsProviderController.totalCheckedBranch > 1) {
                                                                                        tradingsProviderController.totalCheckedBranch -= 1;
                                                                                        widget.listBranchs![e.key].checked = !e.value.checked!;
                                                                                      } else if (e.value.checked! == false) {
                                                                                        tradingsProviderController.totalCheckedBranch += 1;
                                                                                        widget.listBranchs![e.key].checked = !e.value.checked!;
                                                                                      }
                                                                                      tradingsProviderController.updateTrading();
                                                                                    },
                                                                                  );
                                                                                }),
                                                                            Text(
                                                                              e.value.nameCompany!.length < 28 ? '${e.value.nameCompany}' : e.value.nameCompany!.substring(0, 25),
                                                                              style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                ).toList(),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  const SizedBox(height: appMargin),
                                                  ValueListenableBuilder(
                                                      valueListenable: tradingsProviderController.stateFinishTrading,
                                                      builder: (context, value, child) {
                                                        return AppButton(
                                                          label: "Finalizar Pedido",
                                                          colorButton: colorSecondary,
                                                          state: tradingsProviderController.stateFinishTrading.value,
                                                          iconButton: Icons.done_all,
                                                          loading: value == StateApp.loading,
                                                          onPressButton: () {
                                                            saveOrder();
                                                          },
                                                        );
                                                      }),
                                                  const AppSpacing()
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    })
                                : ComponentList(
                                    tradingsProviderController: tradingsProviderController,
                                    negotiation: negotiation.value,
                                    index: negotiation.key,
                                    codeBranch: widget.codeBranch!,
                                    codeClient: widget.codeClient!,
                                    listBranchs: widget.listBranchs,
                                  );
                          }).toList(),
                        ),
                      )
                    : Container();
          }),
    );
  }
}
