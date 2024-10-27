import 'package:flutter/material.dart';
import 'package:profair/src/components/button.dart';
import 'package:profair/src/components/spacing.dart';
import 'package:profair/src/controllers/finish_trading_controller.dart';
import 'package:profair/src/models/login_model.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:profair/src/utils/spacing.dart';

class TradingSucess extends StatefulWidget {
  const TradingSucess({
    super.key,
    required this.value,
    required this.client,
    required this.consult,
    required this.hour,
    required this.finishTradingController,
    required this.trading,
    required this.provider,
    required this.branch,
    this.clientModel,
  });

  final String value;
  final String hour;
  final int trading;
  final int client;
  final int consult;
  final int provider;
  final int branch;
  final LoginModel? clientModel;
  final FinishTradingController finishTradingController;

  @override
  State<TradingSucess> createState() => _TradingSucessState();
}

class _TradingSucessState extends State<TradingSucess> {
  @override
  void initState() {
    try {
      widget.finishTradingController.findClient("${widget.client}");
    } catch (e) {
      debugPrint("initState (Trading Success) Error: $e");
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(appPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      "https://cdn-icons-png.freepik.com/512/6815/6815090.png",
                      width: 100,
                    ),
                    const AppSpacing(),
                    const AppSpacing(),
                    const AppSpacing(),
                    const Text(
                      "Pedido Realizado com sucesso!",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const AppSpacing(),
                    const Text(
                      "Para acompanhar os detalhes do pedido acesse a lista de pedidos na tela inicial.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const AppSpacing(),
                    Divider(
                      color: Colors.grey.withOpacity(0.1),
                    ),
                    const AppSpacing(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            widget.value,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                          ),
                        ),
                      ],
                    ),
                    const AppSpacing(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 5),
                        Text(
                          "Agora mesmo • ${widget.hour}",
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    const AppSpacing(),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     InkWell(
                    //       onTap: () {
                    //         widget.finishTradingController.exportData(widget.provider, widget.trading, widget.branch);
                    //       },
                    //       child: Container(
                    //         padding: const EdgeInsets.symmetric(horizontal: appPadding, vertical: 10),
                    //         decoration: BoxDecoration(
                    //             borderRadius: BorderRadius.circular(50),
                    //             border: Border.all(color: Theme.of(context).colorScheme.onBackground)),
                    //         child: const Row(
                    //           children: [
                    //             Icon(
                    //               Icons.share,
                    //               size: 15,
                    //             ),
                    //             SizedBox(width: 5),
                    //             Text(
                    //               "Comprovante",
                    //               style: TextStyle(fontWeight: FontWeight.w500),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
                const AppSpacing(),
                const AppSpacing(),
                const AppSpacing(),
                Divider(
                  color: Colors.grey.withOpacity(0.1),
                ),
                const AppSpacing(),
                const AppSpacing(),
                Column(
                  children: [
                    ValueListenableBuilder(
                      valueListenable: widget.finishTradingController.stateClient,
                      builder: (context, value, child) {
                        return value != null
                            ? AppButton(
                                label: "Novo pedido",
                                iconButton: Icons.add,
                                type: "filled",
                                colorButton: colorSecondary,
                                onPressButton: () {
                                  // Navigator.of(context).pushNamed("/selectstore", arguments: {"client": widget.clientModel!, "codeProvider": widget.provider, "consult": widget.consult});
                                  Navigator.of(context).pushNamedAndRemoveUntil("/selectstore", (route) => false,
                                      arguments: {"client": widget.clientModel!, "codeProvider": widget.provider, "consult": widget.consult});
                                },
                              )
                            : Container();
                      },
                    ),
                    const AppSpacing(),
                    AppButton(
                      label: "Concluir",
                      colorButton: Colors.green,
                      iconButton: Icons.check,
                      loading: false,
                      onPressButton: () {
                        Navigator.of(context).pushNamedAndRemoveUntil("/home", (route) => false);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
