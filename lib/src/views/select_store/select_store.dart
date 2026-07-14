import 'package:flutter/services.dart';
import 'package:profair/src/controllers/stores_controller.dart';
import 'package:profair/src/models/login_model.dart';
import 'package:profair/src/repositories/stores_repository.dart';
import 'package:profair/src/utils/colors.dart';
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
    // Blindagem: navegar até aqui com dados nulos derrubava a tela no primeiro
    // frame (null check operator), virando tela cinza em release no iOS.
    if (widget.client != null && widget.codeConsult != null && widget.codeProvider != null) {
      storesController.findStores(widget.client!.userCode.toString(), widget.codeConsult!, widget.codeProvider!);
    } else {
      debugPrint("SelectStore: argumentos nulos (client/consult/provider) — voltando para a home.");
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        Navigator.of(context).pushNamedAndRemoveUntil("/home", (route) => false);
      });
    }
    storesController.codeProvider = widget.codeProvider;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // Correção nº 3 (blindagem): sempre intercepta e nós mesmos decidimos para
      // onde ir. Não depende de canPop (avaliado só no build e por isso stale) e
      // cobre o caso de a tela estar sozinha na pilha (fluxo "Novo pedido"),
      // evitando o frame preto no gesto de voltar do iOS.
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        final navigator = Navigator.of(context);
        if (navigator.canPop()) {
          navigator.pop();
        } else {
          navigator.pushNamedAndRemoveUntil("/home", (route) => false);
        }
      },
      child: Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light.copyWith(statusBarColor: colorSecondary),
          child: SafeArea(
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
        ),
      ),
    );
  }
}
