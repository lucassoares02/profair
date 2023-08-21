import 'package:profair/src/repositories/requests_stores_repository.dart';
import 'package:profair/src/views/requests_stores/components/list.dart';
import 'package:profair/src/controllers/requests_stores.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:profair/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RequestsStores extends StatefulWidget {
  const RequestsStores({super.key, required this.codeProvider});

  final int? codeProvider;

  @override
  State<RequestsStores> createState() => _RequestsStoresState();
}

class _RequestsStoresState extends State<RequestsStores> {
  final RequestsStoresController storesController = RequestsStoresController(StateApp.start, RequestsStoresRepository());

  @override
  void initState() {
    storesController.findRequestsStores(widget.codeProvider.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(statusBarColor: colorSecondary),
        child: SafeArea(
          child: SingleChildScrollView(
            child: ValueListenableBuilder(
              valueListenable: storesController.stateStores,
              builder: (context, value, child) {
                return ComponentList(
                  description: S.of(context).text_select_branch,
                  state: storesController.stateStores,
                  codeProvider: widget.codeProvider,
                  listItems: storesController.requestsStores,
                  requestsStoresController: storesController,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
