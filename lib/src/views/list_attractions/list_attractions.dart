import 'package:profair/src/controllers/list_attractions_controller.dart';
import 'package:profair/src/repositories/list_attractions_repository.dart';
import 'package:profair/src/views/list_attractions/components/list.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:profair/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ListAttractions extends StatefulWidget {
  const ListAttractions({super.key});

  @override
  State<ListAttractions> createState() => _ListAttractionsState();
}

class _ListAttractionsState extends State<ListAttractions> {
  final ListAttractionsController listAttractionsController = ListAttractionsController(StateApp.start, ListAttractionsRepository());

  @override
  void initState() {
    listAttractionsController.findAttractions();
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
              valueListenable: listAttractionsController.stateAttractions,
              builder: (context, value, child) {
                return ComponentList(
                  description: S.of(context).text_select_branch,
                  state: listAttractionsController.stateAttractions,
                  listItems: listAttractionsController.listAttractions,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
