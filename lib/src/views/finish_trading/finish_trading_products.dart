import 'package:profair/generated/l10n.dart';
import 'package:profair/src/controllers/finish_trading_controller.dart';
import 'package:profair/src/models/nogotiation_model.dart';
import 'package:profair/src/models/product_model.dart';
import 'package:profair/src/repositories/finish_trading_repository.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:profair/src/views/finish_trading/components/list.dart';
import 'package:flutter/material.dart';

class FinishTrading extends StatefulWidget {
  FinishTrading(
      {super.key,
      required this.codeProvider,
      required this.codeBranch,
      required this.codeTrading,
      required this.codeClient,
      required this.nameBranch,
      required this.productsTrading,
      required this.tradings});

  final int? codeProvider;
  final int? codeBranch;
  final int? codeTrading;
  final String? nameBranch;
  final int? codeClient;
  final List<ProductModel> productsTrading;
  List<NegotiationModel> tradings;

  @override
  State<FinishTrading> createState() => _FinishTradingState();
}

class _FinishTradingState extends State<FinishTrading> {
  final FinishTradingController finishTradingController = FinishTradingController(StateApp.start, FinishTradingRepository());

  @override
  void initState() {
    finishTradingController.checkListItems(widget.productsTrading, widget.tradings);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: ValueListenableBuilder(
            valueListenable: finishTradingController.stateFinishTrading,
            builder: (context, value, child) {
              return ComponentList(
                  listItems: widget.productsTrading,
                  description: S.of(context).text_select_branch,
                  finishTradingController: finishTradingController,
                  codeBranch: widget.codeBranch,
                  codeProvider: widget.codeProvider,
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
