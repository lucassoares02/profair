import 'package:profair/src/repositories/requests_stores_repository.dart';
import 'package:profair/src/views/home/home_controller.dart';
import 'package:profair/src/views/requests_stores/components/list.dart';
import 'package:profair/src/controllers/requests_stores_controller.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:profair/generated/l10n.dart';
import 'package:flutter/material.dart';

class RequestsStores extends StatefulWidget {
  const RequestsStores({
    super.key,
    required this.codeProvider,
    required this.userCode,
    this.homeController,
    this.visibleBuyers = true,
    this.codeNegotiation,
  });

  final int? codeProvider;
  final int? codeNegotiation;
  final bool? visibleBuyers;
  final int? userCode;
  final HomeController? homeController;

  @override
  State<RequestsStores> createState() => _RequestsStoresState();
}

class _RequestsStoresState extends State<RequestsStores> {
  final RequestsStoresController storesController =
      RequestsStoresController(StateApp.start, RequestsStoresRepository());
  @override
  void initState() {
    storesController.findRequestsStores(widget.codeProvider, widget.userCode, widget.codeNegotiation);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: ValueListenableBuilder(
            valueListenable: storesController.stateStores,
            builder: (context, value, child) {
              return ComponentList(
                  description: S.of(context).text_select_branch,
                  state: storesController.stateStores,
                  codeProvider: widget.codeProvider,
                  codeNegotiation: widget.codeNegotiation,
                  listItems: storesController.requestsStores,
                  requestsStoresController: storesController,
                  homeController: widget.homeController,
                  visibleBuyers: widget.visibleBuyers,
                  userCode: widget.userCode);
            },
          ),
        ),
      ),
    );
  }
}
