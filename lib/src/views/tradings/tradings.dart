import 'package:profair/src/repositories/tradings_repository.dart';
import 'package:profair/src/controllers/tradings_controller.dart';
import 'package:profair/src/views/tradings/components/list.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:profair/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Tradings extends StatefulWidget {
  const Tradings({super.key, required this.codeProvider});

  final int? codeProvider;

  @override
  State<Tradings> createState() => _TradingsState();
}

class _TradingsState extends State<Tradings> {
  final TradingsController tradingsController = TradingsController(StateApp.start, TradingsRepository());

  @override
  void initState() {
    tradingsController.findTradings(widget.codeProvider.toString());
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
              valueListenable: tradingsController.stateTradings,
              builder: (context, value, child) {
                return ComponentList(
                  description: S.of(context).text_select_branch,
                  state: tradingsController.stateTradings,
                  codeProvider: widget.codeProvider,
                  listItems: tradingsController.tradingList,
                  tradingsController: tradingsController,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
