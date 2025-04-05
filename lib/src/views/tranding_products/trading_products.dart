import 'package:profair/generated/l10n.dart';
import 'package:profair/src/controllers/trading_products_controller.dart';
import 'package:profair/src/models/nogotiation_model.dart';
import 'package:profair/src/repositories/trading_products_repository.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:profair/src/views/tranding_products/components/list.dart';
import 'package:flutter/material.dart';

import '../../models/clients_select_stores_model.dart';

class TradingProducts extends StatefulWidget {
  const TradingProducts({
    super.key,
    required this.codeProvider,
    required this.codeBranch,
    required this.codeTrading,
    this.nameBranch,
    this.codeConsult,
    required this.codeClient,
    required this.tradings,
    required this.listBranchs,
  });

  final int? codeProvider;
  final int? codeBranch;
  final int? codeTrading;
  final int? codeClient;
  final int? codeConsult;
  final String? nameBranch;
  final List<NegotiationModel>? tradings;
  final List<ClientsSelectStoreModel>? listBranchs;

  @override
  State<TradingProducts> createState() => _TradingProductsState();
}

class _TradingProductsState extends State<TradingProducts> {
  final TradingProductsController tradingProductsController = TradingProductsController(StateApp.start, TradingProductsRepository());

  @override
  void initState() {
    tradingProductsController.findTradingProducts(widget.codeBranch, widget.codeProvider, widget.codeTrading, widget.codeClient);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: ValueListenableBuilder(
            valueListenable: tradingProductsController.stateProductsTrading,
            builder: (context, value, child) {
              return ComponentList(
                state: tradingProductsController.stateProductsTrading,
                description: "Selecione a Filial",
                tradingProductsController: tradingProductsController,
                codeProvider: widget.codeProvider,
                codeBranch: widget.codeBranch,
                codeTrading: widget.codeTrading,
                codeClient: widget.codeClient,
                nameBranch: widget.nameBranch,
                tradings: widget.tradings,
                listBranchs: widget.listBranchs,
                codeConsult: widget.codeConsult,
              );
            },
          ),
        ),
      ),
    );
  }
}
