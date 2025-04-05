import 'package:profair/src/repositories/tradings_repository.dart';
import 'package:profair/src/controllers/tradings_controller.dart';
import 'package:profair/src/views/home/home_controller.dart';
import 'package:profair/src/views/tradings/components/list.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:profair/generated/l10n.dart';
import 'package:flutter/material.dart';

class Tradings extends StatefulWidget {
  const Tradings({super.key, required this.homeController});

  final HomeController homeController;

  @override
  State<Tradings> createState() => _TradingsState();
}

class _TradingsState extends State<Tradings> {
  final TradingsController tradingsController = TradingsController(StateApp.start, TradingsRepository());

  @override
  void initState() {
    tradingsController.findTradings(widget.homeController.data!.codCompany.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: ValueListenableBuilder(
            valueListenable: tradingsController.stateTradings,
            builder: (context, value, child) {
              return ComponentList(
                description: "Selecione a Filial",
                state: tradingsController.stateTradings,
                homeController: widget.homeController,
                listItems: tradingsController.tradingList,
                tradingsController: tradingsController,
              );
            },
          ),
        ),
      ),
    );
  }
}
