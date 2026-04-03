import 'package:profair/src/controllers/clients_controller.dart';
import 'package:profair/src/repositories/clients_repository.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:profair/src/views/clients/components/list.dart';
import 'package:flutter/material.dart';

class Clients extends StatefulWidget {
  const Clients({
    super.key,
    required this.codeProvider,
    this.accessTargenting,
    this.merchandise,
    this.trading,
    this.groups,
  });

  final int? codeProvider;
  final int? accessTargenting;
  final int? merchandise;
  final int? trading;
  final int? groups;

  @override
  State<Clients> createState() => _ClientsState();
}

class _ClientsState extends State<Clients> {
  final ClientsController clientsController = ClientsController(StateApp.start, ClientsRepository());

  @override
  void initState() {
    clientsController.findPercentageClients(widget.codeProvider!);
    clientsController.findClients(
      codeProvider: widget.codeProvider.toString(),
      accessTargenting: widget.accessTargenting,
      trading: widget.trading,
      merchandise: widget.merchandise,
      groups: widget.groups,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: ValueListenableBuilder(
            valueListenable: clientsController.stateClients,
            builder: (context, value, child) {
              return ComponentList(
                  description: "Selecione a Filial",
                  state: clientsController.stateClients,
                  codeProvider: widget.codeProvider,
                  listItems: clientsController.clientsList,
                  clientsController: clientsController,
                  group: widget.groups,
                  onClickCard: true,
                  accessTargenting: widget.accessTargenting!);
            },
          ),
        ),
      ),
    );
  }
}
