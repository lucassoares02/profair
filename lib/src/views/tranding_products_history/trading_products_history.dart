import 'package:profair/src/controllers/trading_products_controller.dart';
import 'package:profair/src/repositories/trading_products_repository.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:profair/src/views/tranding_products_history/components/list.dart';
import 'package:flutter/material.dart';

class TradingProductsHistory extends StatefulWidget {
  const TradingProductsHistory({super.key, required this.codeProvider, required this.codeBranch, required this.codeTrading, this.comprador, this.vendedor, this.date});

  final int? codeProvider;
  final int? codeBranch;
  final int? codeTrading;
  final String? comprador;
  final String? vendedor;
  final String? date;

  @override
  State<TradingProductsHistory> createState() => _TradingProductsHistoryState();
}

class _TradingProductsHistoryState extends State<TradingProductsHistory> {
  final TradingProductsController tradingProductsController = TradingProductsController(StateApp.start, TradingProductsRepository());

  @override
  void initState() {
    tradingProductsController.findTradingProductsHistory(widget.codeBranch, widget.codeProvider, widget.codeTrading);
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
                tradingProductsController: tradingProductsController,
                codeProvider: widget.codeProvider,
                codeBranch: widget.codeBranch,
                codeTrading: widget.codeTrading,
                codeClient: 0,
                comprador: widget.comprador,
                vendedor: widget.vendedor,
                date: widget.date,
              );
            },
          ),
        ),
      ),
    );
  }
}
