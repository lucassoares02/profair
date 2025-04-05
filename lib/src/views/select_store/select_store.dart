import 'package:profair/generated/l10n.dart';
import 'package:profair/src/controllers/stores_controller.dart';
import 'package:profair/src/models/login_model.dart';
import 'package:profair/src/repositories/stores_repository.dart';
import 'package:profair/src/views/select_store/components/list.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:flutter/material.dart';

class SelectStore extends StatefulWidget {
  const SelectStore({super.key, required this.client, required this.codeProvider, required this.codeConsult});

  final LoginModel? client;
  final int? codeProvider;
  final int? codeConsult;

  @override
  State<SelectStore> createState() => _SelectStoreState();
}

class _SelectStoreState extends State<SelectStore> {
  final StoresController storesController = StoresController(StateApp.start, StoresRepository());

  @override
  void initState() {
    storesController.findStores(widget.client!.userCode.toString());
    storesController.codeProvider = widget.codeProvider;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          // ALTERAR COR NOTIFICATIONBAR
          // AnnotatedRegion<SystemUiOverlayStyle>(
          //   value: SystemUiOverlayStyle.light.copyWith(statusBarColor: colorSecondary),
          //   child:

          SafeArea(
        child: SingleChildScrollView(
          child: ValueListenableBuilder(
            valueListenable: storesController.stateStores,
            builder: (context, value, child) {
              return ComponentList(
                  description: "Selecione a Filial",
                  state: storesController.stateStores,
                  codeProvider: widget.codeProvider,
                  listItems: storesController.stores,
                  client: widget.client,
                  consult: widget.codeConsult);
            },
          ),
        ),
      ),
    );
    //   ),
    // );
  }
}
