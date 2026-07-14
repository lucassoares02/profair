import 'package:flutter/services.dart';
import 'package:profair/src/controllers/stores_controller.dart';
import 'package:profair/src/models/login_model.dart';
import 'package:profair/src/repositories/stores_repository.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:profair/src/views/select_store/components/list.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:flutter/material.dart';

class SelectStore extends StatefulWidget {
  const SelectStore({super.key, required this.client, required this.codeProvider, required this.codeConsult, this.fromSuccess = false});

  final LoginModel? client;
  final int? codeProvider;
  final int? codeConsult;

  /// true quando a tela foi aberta pelo botão "Novo pedido" (o usuário concluiu
  /// um pedido). Nesse caso o botão voltar vai para "/home" em vez de dar pop.
  final bool fromSuccess;

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
    // Sem PopScope: em todos os fluxos a SelectStore é empilhada por cima da
    // home (scanner/QR e também o "Novo pedido", que reseta para [home,
    // selectstore]). Assim o voltar nativo do iOS faz pop para a home real que
    // está embaixo, renderizando-a normalmente — sem tela preta. Interceptar com
    // canPop:false bloqueava o pop nativo e deixava a transição do gesto preta.
    return Scaffold(
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
                    consult: widget.codeConsult,
                    fromSuccess: widget.fromSuccess);
              },
            ),
          ),
        ),
      ),
    );
  }
}
