import 'dart:developer';

import 'package:profair/generated/l10n.dart';
import 'package:profair/src/controllers/finish_trading_controller.dart';
import 'package:profair/src/models/nogotiation_model.dart';
import 'package:profair/src/models/product_model.dart';
import 'package:profair/src/repositories/finish_trading_repository.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:profair/src/views/finish_trading/components/list.dart';
import 'package:flutter/material.dart';

import '../../models/clients_select_stores_model.dart';

class FinishTrading extends StatefulWidget {
  FinishTrading({
    super.key,
    required this.codeProvider,
    required this.codeBranch,
    required this.codeTrading,
    required this.codeClient,
    this.codeConsult,
    required this.nameBranch,
    required this.productsTrading,
    required this.tradings,
    required this.initialListProducts,
    this.listBranchs,
  });

  final int? codeProvider;
  final int? codeBranch;
  final int? codeTrading;
  final int? codeConsult;
  final String? nameBranch;
  final int? codeClient;
  final List<ProductModel> productsTrading;
  final List<ProductModel> initialListProducts;
  List<NegotiationModel> tradings;
  List<ClientsSelectStoreModel>? listBranchs;

  @override
  State<FinishTrading> createState() => _FinishTradingState();
}

class _FinishTradingState extends State<FinishTrading> {
  final FinishTradingController finishTradingController =
      FinishTradingController(StateApp.start, FinishTradingRepository());

  @override
  void initState() {
    finishTradingController.checkListItems(widget.productsTrading, widget.tradings, widget.listBranchs);
    finishTradingController.insertInList(widget.productsTrading, widget.initialListProducts);
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
                  listBranchs: widget.listBranchs,
                  codeConsult: widget.codeConsult,
                  tradings: widget.tradings);
            },
          ),
        ),
      ),
    );
  }
}
