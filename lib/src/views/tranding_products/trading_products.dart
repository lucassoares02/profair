import 'package:profair/generated/l10n.dart';
import 'package:profair/src/controllers/trading_products_controller.dart';
import 'package:profair/src/models/nogotiation_model.dart';
import 'package:profair/src/repositories/trading_products_repository.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:profair/src/views/tranding_products/components/list.dart';
import 'package:flutter/material.dart';

class TradingProducts extends StatefulWidget {
  const TradingProducts(
      {super.key, required this.codeProvider, required this.codeBranch, required this.codeTrading, this.nameBranch, required this.codeClient, required this.tradings});

  final int? codeProvider;
  final int? codeBranch;
  final int? codeTrading;
  final int? codeClient;
  final String? nameBranch;
  final List<NegotiationModel> tradings;

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
                  listItems: tradingProductsController.productsTrading,
                  state: tradingProductsController.stateProductsTrading,
                  description: S.of(context).text_select_branch,
                  tradingProductsController: tradingProductsController,
                  codeProvider: widget.codeProvider,
                  codeBranch: widget.codeBranch,
                  codeTrading: widget.codeTrading,
                  codeClient: widget.codeClient,
                  nameBranch: widget.nameBranch,
                  tradings: widget.tradings);
            },
          ),
        ),
      ),
    );
  }
}
