import 'package:profair/src/controllers/providers_controller.dart';
import 'package:profair/src/repositories/providers_repository.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:profair/generated/l10n.dart';
import 'package:profair/src/views/providers/components/list.dart';
import 'package:flutter/material.dart';

class Providers extends StatefulWidget {
  const Providers({super.key, required this.codeClient, this.codeBuyer, this.codeBranch});

  final int? codeClient;
  final int? codeBuyer;
  final int? codeBranch;

  @override
  State<Providers> createState() => _ProvidersState();
}

class _ProvidersState extends State<Providers> {
  final ProvidersController clientsController = ProvidersController(StateApp.start, ProvidersRepository());

  @override
  void initState() {
    clientsController.findProviders(codeClient: widget.codeClient, codeBuyer: widget.codeBuyer, codeBranch: widget.codeBranch);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: ValueListenableBuilder(
            valueListenable: clientsController.stateProviders,
            builder: (context, value, child) {
              return ComponentList(
                  description: "Fornecedores",
                  state: clientsController.stateProviders,
                  codeProvider: widget.codeClient,
                  listItems: clientsController.providersList,
                  providersController: clientsController,
                  codeClient: widget.codeClient,
                  codeBranch: widget.codeBranch);
            },
          ),
        ),
      ),
    );
  }
}
