import 'package:profair/src/controllers/providers_controller.dart';
import 'package:profair/src/repositories/providers_repository.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:profair/generated/l10n.dart';
import 'package:profair/src/views/providers_by_group/components/list.dart';
import 'package:flutter/material.dart';

class ProvidersByGroup extends StatefulWidget {
  const ProvidersByGroup({super.key, required this.codeClient});

  final int? codeClient;

  @override
  State<ProvidersByGroup> createState() => _ProvidersByGroupState();
}

class _ProvidersByGroupState extends State<ProvidersByGroup> {
  final ProvidersController clientsController = ProvidersController(StateApp.start, ProvidersRepository());

  @override
  void initState() {
    clientsController.findProvidersByGroup(codeClient: widget.codeClient);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: ValueListenableBuilder(
            valueListenable: clientsController.stateProviders,
            builder: (context, value, child) {
              return ComponentList(
                  description: S.of(context).text_select_provider,
                  state: clientsController.stateProviders,
                  codeProvider: widget.codeClient,
                  listItems: clientsController.providersList,
                  providersController: clientsController,
                  codeClient: widget.codeClient);
            },
          ),
        ),
      ),
    );
  }
}
