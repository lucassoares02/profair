import 'package:profair/src/repositories/details_balance_repository.dart';
import 'package:profair/src/views/details_balance/components/list.dart';
import 'package:profair/src/controllers/details_balance_controller.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:profair/generated/l10n.dart';
import 'package:flutter/material.dart';

class DetailsBalance extends StatefulWidget {
  const DetailsBalance({super.key, required this.codeProvider, required this.userCode});

  final int? codeProvider;
  final int? userCode;

  @override
  State<DetailsBalance> createState() => _DetailsBalanceState();
}

class _DetailsBalanceState extends State<DetailsBalance> {
  final DetailsBalanceController balanceController = DetailsBalanceController(StateApp.start, DetailsBalanceRepository());

  @override
  void initState() {
    balanceController.findRequests(widget.codeProvider, widget.userCode);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: ValueListenableBuilder(
            valueListenable: balanceController.stateStores,
            builder: (context, value, child) {
              return ComponentList(
                  description: "Selecione a Filial",
                  state: balanceController.stateStores,
                  codeProvider: widget.codeProvider,
                  listItems: balanceController.requestsStores,
                  balanceController: balanceController,
                  userCode: widget.userCode);
            },
          ),
        ),
      ),
    );
  }
}
