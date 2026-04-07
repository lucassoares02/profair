import 'dart:developer';

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
import 'package:shared_preferences/shared_preferences.dart';

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
  int? history;

  @override
  void initState() {
    getFindTradingsProvider();
    loadHistory();
    super.initState();
  }

  loadHistory() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    history = sharedPreferences.getInt("history");
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
      tradingsProviderController.stateFinishTrading.value = StateApp.success;
    } catch (e) {
      debugPrint("Error saveOrder: $e");
      Fluttertoast.showToast(msg: "Pedido não foi salvo!", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, textColor: Colors.white, fontSize: 16.0);
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
      },
    );
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
                                  addIcon: history == 1
                                      ? Padding(
                                          padding: const EdgeInsets.only(right: 6),
                                          child: IconButton(
                                              onPressed: () {
                                                Navigator.of(context).pushNamed(
                                                  "/history-clients-tradings",
                                                  arguments: {
                                                    "provider": widget.codeProvider,
                                                    "client": widget.codeBranch,
                                                  },
                                                );
                                              },
                                              icon: const Icon(Icons.history_outlined)),
                                        )
                                      : null,
                                );
                              },
                            ),
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
                                      return Column(
                                        children: [
                                          Expanded(
                                            child: SingleChildScrollView(
                                              child: Padding(
                                                padding: const EdgeInsets.all(appPadding),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    // ── Hero Card ────────────────────────────────────────────
                                                    Container(
                                                      width: double.maxFinite,
                                                      padding: const EdgeInsets.all(appPadding + 4),
                                                      decoration: BoxDecoration(
                                                        gradient: const LinearGradient(
                                                          colors: [colorSecondary, colorPrimary],
                                                          begin: Alignment.topLeft,
                                                          end: Alignment.bottomRight,
                                                        ),
                                                        borderRadius: BorderRadius.circular(appRadius),
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text(
                                                                "RESUMO DO PEDIDO",
                                                                style: TextStyle(
                                                                  fontSize: 11,
                                                                  color: Colors.white.withValues(alpha: 0.75),
                                                                  letterSpacing: 1.2,
                                                                  fontWeight: FontWeight.w600,
                                                                ),
                                                              ),
                                                              Text(
                                                                DateFormat.Hm().format(DateTime.now()),
                                                                style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors.white.withValues(alpha: 0.75),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(height: 10),
                                                          Text(
                                                            formatCurrency(tradingsProviderController.totalValue),
                                                            style: const TextStyle(
                                                              fontSize: 34,
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.white,
                                                              letterSpacing: -0.5,
                                                            ),
                                                          ),
                                                          const SizedBox(height: 10),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Icon(Icons.person_outline, size: 14, color: Colors.white.withValues(alpha: 0.75)),
                                                                  const SizedBox(width: 4),
                                                                  Text(
                                                                    "para ",
                                                                    style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.7)),
                                                                  ),
                                                                  Text(
                                                                    "${widget.listBranchs!.first.nameUser}",
                                                                    style: const TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w600),
                                                                  ),
                                                                ],
                                                              ),
                                                              Container(
                                                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                                decoration: BoxDecoration(
                                                                  color: Colors.white.withValues(alpha: 0.15),
                                                                  borderRadius: BorderRadius.circular(20),
                                                                ),
                                                                child: Row(
                                                                  mainAxisSize: MainAxisSize.min,
                                                                  children: [
                                                                    const Icon(Icons.inventory_2_outlined, size: 14, color: Colors.white),
                                                                    const SizedBox(width: 5),
                                                                    Text(
                                                                      "${tradingsProviderController.totalVolume} volumes",
                                                                      style: const TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w600),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const AppSpacing(),

                                                    // ── Lojas selecionadas ────────────────────────────────
                                                    const Text(
                                                      "Lojas selecionadas",
                                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                                    ),
                                                    const SizedBox(height: 8),
                                                    ValueListenableBuilder(
                                                        valueListenable: tradingsProviderController.stateTradings,
                                                        builder: (context, value, child) {
                                                          return Column(
                                                            children: widget.listBranchs!.asMap().entries.map((e) {
                                                              return e.value.checked!
                                                                  ? Container(
                                                                      width: double.maxFinite,
                                                                      margin: const EdgeInsets.only(bottom: 8),
                                                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                                                      decoration: BoxDecoration(
                                                                        color: colorSecondary.withValues(alpha: 0.06),
                                                                        borderRadius: BorderRadius.circular(appRadius),
                                                                        border: Border.all(color: colorSecondary.withValues(alpha: 0.2)),
                                                                      ),
                                                                      child: Row(
                                                                        children: [
                                                                          const Icon(Icons.store_outlined, size: 16, color: colorSecondary),
                                                                          const SizedBox(width: 10),
                                                                          Expanded(
                                                                            child: Text(
                                                                              e.value.documentCompany!,
                                                                              style: const TextStyle(fontSize: 13, color: colorSecondary, fontWeight: FontWeight.w500),
                                                                              overflow: TextOverflow.ellipsis,
                                                                              maxLines: 2,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    )
                                                                  : const SizedBox.shrink();
                                                            }).toList(),
                                                          );
                                                        }),

                                                    // ── Duplicar para outras lojas ────────────────────────
                                                    if (widget.listBranchs!.length > 1) ...[
                                                      const AppSpacing(),
                                                      Container(
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(appRadius),
                                                          border: Border.all(
                                                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08),
                                                          ),
                                                        ),
                                                        child: ExpansionTile(
                                                          leading: Container(
                                                            width: 36,
                                                            height: 36,
                                                            decoration: BoxDecoration(
                                                              color: colorSecondary.withValues(alpha: 0.1),
                                                              borderRadius: BorderRadius.circular(8),
                                                            ),
                                                            child: const Icon(Icons.store_outlined, color: colorSecondary, size: 18),
                                                          ),
                                                          title: const Text(
                                                            "Duplicar para outras lojas",
                                                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                                          ),
                                                          subtitle: Text(
                                                            "Replique este pedido para filiais",
                                                            style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.45)),
                                                          ),
                                                          tilePadding: const EdgeInsets.symmetric(horizontal: appPadding, vertical: 4),
                                                          shape: const Border.symmetric(horizontal: BorderSide(color: Colors.transparent)),
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.fromLTRB(appPadding, 0, appPadding, appPadding),
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Divider(
                                                                    height: 1,
                                                                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08),
                                                                  ),
                                                                  const SizedBox(height: appMargin),
                                                                  Row(
                                                                    children: [
                                                                      Icon(Icons.info_outline, size: 13, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4)),
                                                                      const SizedBox(width: 6),
                                                                      Expanded(
                                                                        child: Text(
                                                                          "O pedido será replicado para as filiais selecionadas.",
                                                                          style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.45)),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  const SizedBox(height: appPadding),
                                                                  Column(
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
                                                                          borderRadius: BorderRadius.circular(appRadius),
                                                                          child: ValueListenableBuilder(
                                                                            valueListenable: tradingsProviderController.stateTradings,
                                                                            builder: (context, bool stateValue, child) {
                                                                              inspect(e.value);
                                                                              return AnimatedContainer(
                                                                                duration: const Duration(milliseconds: 180),
                                                                                margin: const EdgeInsets.only(bottom: 8),
                                                                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                                                                decoration: BoxDecoration(
                                                                                  color: e.value.checked!
                                                                                      ? colorSecondary.withValues(alpha: 0.07)
                                                                                      : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.03),
                                                                                  borderRadius: BorderRadius.circular(appRadius),
                                                                                  border: Border.all(
                                                                                    color: e.value.checked!
                                                                                        ? colorSecondary.withValues(alpha: 0.35)
                                                                                        : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.07),
                                                                                    width: e.value.checked! ? 1.5 : 1,
                                                                                  ),
                                                                                ),
                                                                                child: Row(
                                                                                  children: [
                                                                                    Container(
                                                                                      width: 32,
                                                                                      height: 32,
                                                                                      decoration: BoxDecoration(
                                                                                        color: e.value.checked!
                                                                                            ? colorSecondary.withValues(alpha: 0.15)
                                                                                            : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.06),
                                                                                        borderRadius: BorderRadius.circular(8),
                                                                                      ),
                                                                                      child: Icon(
                                                                                        e.value.checked! ? Icons.store : Icons.store_outlined,
                                                                                        size: 15,
                                                                                        color: e.value.checked! ? colorSecondary : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.35),
                                                                                      ),
                                                                                    ),
                                                                                    const SizedBox(width: 12),
                                                                                    Expanded(
                                                                                      child: Column(
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                          Text(
                                                                                            '${e.value.nameCompany}',
                                                                                            style: TextStyle(
                                                                                              fontSize: 13,
                                                                                              fontWeight: FontWeight.w600,
                                                                                              color: e.value.checked!
                                                                                                  ? Theme.of(context).colorScheme.onSurface
                                                                                                  : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.55),
                                                                                            ),
                                                                                            overflow: TextOverflow.ellipsis,
                                                                                            maxLines: 1,
                                                                                          ),
                                                                                          Text(
                                                                                            '${e.value.relationshipCode}',
                                                                                            style: TextStyle(
                                                                                              fontSize: 11,
                                                                                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    Checkbox(
                                                                                      activeColor: colorSecondary,
                                                                                      value: e.value.checked,
                                                                                      side: const BorderSide(color: colorGrey),
                                                                                      shape: const RoundedRectangleBorder(
                                                                                        borderRadius: BorderRadius.all(Radius.circular(4)),
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
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              );
                                                                            },
                                                                          ),
                                                                        );
                                                                      },
                                                                    ).toList(),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],

                                                    const AppSpacing(),
                                                    Divider(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1)),
                                                    const AppSpacing(),

                                                    // ── Negociações ───────────────────────────────────────
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        const Text(
                                                          "Negociações",
                                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                                        ),
                                                        Tooltip(
                                                          message: "Clique na negociação e navegue até a aba para confirmar os itens pedidos.",
                                                          child: Icon(
                                                            Icons.info_outline,
                                                            size: 18,
                                                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: tradingsProviderController.negotiationResume.map((negotiation) {
                                                        return InkWell(
                                                          onTap: () {
                                                            // search index position negotiation per id and navigate to tab
                                                            int index = tradingsProviderController.negotiations.indexWhere((element) => element.negotiation == negotiation.negotiation);
                                                            if (index != -1) {
                                                              tradingsProviderController.tabController.animateTo(index);
                                                              tradingsProviderController.itemSelected.value = index;
                                                              tradingsProviderController.tabSelected = index;
                                                              tradingsProviderController.tabController.index = index;
                                                              tradingsProviderController.updateTrading();
                                                            }
                                                          },
                                                          borderRadius: BorderRadius.circular(appRadius),
                                                          child: Container(
                                                            margin: const EdgeInsets.only(bottom: appMargin),
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(appRadius),
                                                              border: Border.all(
                                                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08),
                                                              ),
                                                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.03),
                                                            ),
                                                            child: Row(
                                                              children: [
                                                                Container(
                                                                  width: 4,
                                                                  height: 68,
                                                                  decoration: const BoxDecoration(
                                                                    color: colorSecondary,
                                                                    borderRadius: BorderRadius.only(
                                                                      topLeft: Radius.circular(appRadius),
                                                                      bottomLeft: Radius.circular(appRadius),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                                                    child: Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Text(
                                                                          "${negotiation.negotiation} · ${negotiation.title}",
                                                                          style: TextStyle(
                                                                            fontSize: 13,
                                                                            color: Theme.of(context).colorScheme.onSurface,
                                                                            fontWeight: FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                        const SizedBox(height: 6),
                                                                        Row(
                                                                          children: [
                                                                            Icon(Icons.inventory_2_outlined, size: 13, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.45)),
                                                                            const SizedBox(width: 4),
                                                                            Text(
                                                                              "${negotiation.volume} itens",
                                                                              style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.55)),
                                                                            ),
                                                                            const SizedBox(width: 16),
                                                                            Text(
                                                                              formatCurrency(negotiation.value),
                                                                              style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.55)),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets.only(right: 12),
                                                                  child: Icon(
                                                                    Icons.arrow_forward_ios,
                                                                    size: 13,
                                                                    color: colorSecondary.withValues(alpha: 0.6),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      }).toList(),
                                                    ),

                                                    const AppSpacing(),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          // ── Finalizar Pedido (footer fixo) ───────────────────
                                          Container(
                                            padding: const EdgeInsets.fromLTRB(appPadding, appPadding, appPadding, appPadding),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).scaffoldBackgroundColor,
                                              border: Border(
                                                top: BorderSide(
                                                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08),
                                                ),
                                              ),
                                            ),
                                            child: SafeArea(
                                              top: false,
                                              child: ValueListenableBuilder(
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
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
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
