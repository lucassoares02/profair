import 'package:flutter/material.dart';
import 'package:profair/src/components/button.dart';
import 'package:profair/src/components/spacing.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:profair/src/utils/spacing.dart';

class TradingSucess extends StatelessWidget {
  const TradingSucess({super.key, required this.value, required this.hour});

  final String value;
  final String hour;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(appPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    const Text(
                      "Para acompanhar os detalhes do pedido acesse a lista de pedidos na tela inicial.",
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
                            value,
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
                          "Agora mesmo • $hour",
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    )
                  ],
                ),
                const AppSpacing(),
                Divider(
                  color: Colors.grey.withOpacity(0.1),
                ),
                const AppSpacing(),
                const AppSpacing(),
                AppButton(
                  label: "Concluir",
                  colorButton: Colors.green,
                  iconButton: Icons.check,
                  loading: false,
                  onPressButton: () {
                    Navigator.of(context).pushNamedAndRemoveUntil("/home", (route) => false);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
