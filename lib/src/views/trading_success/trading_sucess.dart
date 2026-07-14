import 'package:flutter/material.dart';
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
      body: Stack(
        children: [
          Positioned(
            top: -80,
            left: -80,
            right: -80,
            child: Container(
              height: 360,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    colorSecondary.withValues(alpha: 0.12),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: appPadding * 1.2, vertical: appPadding),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 128,
                          height: 128,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 128,
                                height: 128,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.green.withValues(alpha: 0.12),
                                    width: 1,
                                  ),
                                ),
                              ),
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.green.withValues(alpha: 0.22),
                                    width: 1,
                                  ),
                                ),
                              ),
                              Container(
                                width: 74,
                                height: 74,
                                decoration: BoxDecoration(
                                  color: Colors.green.withValues(alpha: 0.14),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check_rounded,
                                  color: Colors.green,
                                  size: 38,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                          decoration: BoxDecoration(
                            color: colorSecondary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            "Pedido realizado",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: colorSecondary,
                              letterSpacing: 0.4,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          widget.value,
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -1.5,
                            height: 1,
                          ),
                        ),
                        const SizedBox(height: 36),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.07),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // _infoCell(
                              //   icon: Icons.receipt_long_rounded,
                              //   label: "Número",
                              //   value: "#${widget.trading}",
                              // ),
                              // Container(
                              //   width: 1,
                              //   height: 36,
                              //   color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08),
                              // ),
                              _infoCell(
                                icon: Icons.check_circle_outline_rounded,
                                label: "Status",
                                value: "Confirmado",
                                valueColor: Colors.green,
                              ),
                              Container(
                                width: 1,
                                height: 36,
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08),
                              ),
                              _infoCell(
                                icon: Icons.access_time_rounded,
                                label: "Horário",
                                value: widget.hour,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      ValueListenableBuilder(
                        valueListenable: widget.finishTradingController.stateClient,
                        builder: (context, value, child) {
                          final client = widget.clientModel ?? widget.finishTradingController.client;

                          // Só exibe "Novo pedido" com o cliente carregado; navegar
                          // com client nulo derruba a SelectStore (tela cinza no iOS).
                          return client != null
                              ? Column(
                                  children: [
                                    _outlinedButton(
                                      label: "Novo pedido",
                                      icon: Icons.add_rounded,
                                      color: colorSecondary,
                                      onPressed: () {
                                        if (!context.mounted) return;
                                        // Correção nº 1: usa o client resolvido (o mesmo que
                                        // liberou o botão), nunca widget.clientModel! — que é
                                        // nulo no fluxo principal (finish_trading não envia
                                        // "clientModel"), causando crash/tela cinza no iOS.
                                        //
                                        // Correção nº 2: reseta a pilha para a home (mesmo
                                        // padrão do "Concluir"/splash, comprovadamente estável
                                        // com o flutter_modular) e empilha a seleção de loja
                                        // por cima. A cada "Novo pedido" a pilha fica sempre
                                        // [home, selectstore] — home embaixo evita a tela preta
                                        // no voltar do iOS, e o reset evita o acúmulo de rotas.
                                        // (popUntil desincronizava o RouterDelegate do Modular.)
                                        // NavigatorState é estável entre pushes/pops, então as
                                        // duas chamadas na mesma referência são seguras.
                                        final navigator = Navigator.of(context);
                                        navigator.pushNamedAndRemoveUntil("/home", (route) => false);
                                        navigator.pushNamed(
                                          "/selectstore",
                                          arguments: {
                                            "client": client,
                                            "codeProvider": widget.provider,
                                            "consult": widget.consult,
                                          },
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 12),
                                  ],
                                )
                              : const SizedBox.shrink();
                        },
                      ),
                      _filledButton(
                        label: "Concluir",
                        icon: Icons.check_rounded,
                        color: Colors.green,
                        onPressed: () {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            Navigator.of(context).pushNamedAndRemoveUntil("/home", (route) => false);
                          });
                        },
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCell({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Colors.grey, height: 1),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _filledButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _outlinedButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: color.withValues(alpha: 0.07),
          foregroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(color: color.withValues(alpha: 0.25), width: 1.5),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
