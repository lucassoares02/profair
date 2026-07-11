import 'package:profair/src/controllers/negotiation_controller.dart';
import 'package:profair/src/repositories/negotiation_repository.dart';
import 'package:profair/src/views/select_negotiation_group/components/list.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:flutter/material.dart';

import '../../models/clients_select_stores_model.dart';

class SelectNegotiationGroup extends StatefulWidget {
  const SelectNegotiationGroup({
    super.key,
    required this.codeProvider,
    required this.codeGroup,
    this.codeConsult,
    required this.nameBranch,
    required this.codeClient,
    this.listBranchs,
    this.balance,
  });

  final int? codeProvider;
  final int? codeGroup;
  final String? nameBranch;
  final int? codeClient;
  final int? codeConsult;
  final List<ClientsSelectStoreModel>? listBranchs;
  final bool? balance;

  @override
  State<SelectNegotiationGroup> createState() => _SelectNegotiationGroupState();
}

class _SelectNegotiationGroupState extends State<SelectNegotiationGroup> {
  final NegotiationController negotiationController =
      NegotiationController(StateApp.start, NegotiationRepository());

  @override
  void initState() {
    super.initState();
    _loadNegotiations();
  }

  Future<void> _loadNegotiations() async {
    await negotiationController.findNegotiationsGroup(
        widget.codeGroup, widget.codeProvider);
    await negotiationController.findOrderObservation(
      codeProvider: widget.codeProvider,
      codeConsultSeller: widget.codeConsult,
      codeConsultBuyer: widget.codeClient,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: ValueListenableBuilder(
            valueListenable: negotiationController.stateNegotiations,
            builder: (context, value, child) {
              return ComponentList(
                listItems: negotiationController.negotiations,
                getOrderObservation: () =>
                    negotiationController.orderObservation,
                stateOrderObservation:
                    negotiationController.stateOrderObservation,
                state: negotiationController.stateNegotiations,
                description: "Selecione a Filial",
                codeGroup: widget.codeGroup,
                codeProvider: widget.codeProvider,
                codeClient: widget.codeClient,
                nameBranch: widget.nameBranch,
                balance: widget.balance ?? false,
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
