import 'package:profair/src/controllers/reports_controller.dart';
import 'package:profair/src/repositories/reports_repository.dart';
import 'package:profair/src/views/reports/components/list.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Reports extends StatefulWidget {
  Reports({super.key, required this.codeProvider, required this.accessTargeting});

  int? codeProvider;
  int? accessTargeting;

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  final ReportsController reportsController = ReportsController(StateApp.start, ReportsRepository());

  @override
  void initState() {
    reportsController.findPercentageClients(widget.codeProvider, widget.accessTargeting);
    reportsController.findTotalValueClients(widget.codeProvider, widget.accessTargeting);
    reportsController.findTotalValueProducts(widget.codeProvider, widget.accessTargeting!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: colorSecondary,
      //   foregroundColor: colorWhite,
      //   title: const Text(
      //     "Relatórios",
      //   ),
      // ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(statusBarColor: colorSecondary),
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            child: ValueListenableBuilder(
              valueListenable: reportsController.statePercentageClients,
              builder: (context, value, child) {
                return ComponentList(
                  reportsController: reportsController,
                  codeProvider: widget.codeProvider,
                  accessTargeting: widget.accessTargeting,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
