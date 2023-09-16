import 'package:profair/src/components/header_list.dart';
import 'package:profair/src/components/spacing.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:profair/src/views/home/home_controller.dart';
import 'package:profair/src/views/ticket/ticket_controller.dart';
import 'package:profair/src/views/ticket/ticket_repository.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Ticket extends StatefulWidget {
  const Ticket({super.key, required this.homeController});

  final HomeController homeController;

  @override
  State<Ticket> createState() => _TicketState();
}

class _TicketState extends State<Ticket> {
  final TicketController profileController = TicketController(StateApp.start, TicketRepository());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderList(label: "Detalhes", activeSearch: false),
              Container(
                padding: const EdgeInsets.all(appPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(appPadding),
                      decoration: const BoxDecoration(
                        color: colorTertiary,
                        borderRadius: BorderRadius.all(
                          Radius.circular(appRadius),
                        ),
                      ),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Organização",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const AppSpacing(),
                              Image.asset("assets/images/logo-client.png", width: 200),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const AppSpacing(),
                    const AppSpacing(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Código:",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: colorGrey,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              widget.homeController.data!.userCode.toString(),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                          decoration: const BoxDecoration(
                            color: colorGreen,
                            borderRadius: BorderRadius.all(
                              Radius.circular(appRadius),
                            ),
                          ),
                          child: const Text(
                            "Associado",
                            style: TextStyle(
                              color: colorWhite,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const AppSpacing(),
                    const Text(
                      "Nome:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: colorGrey,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      widget.homeController.data!.nameUser!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const AppSpacing(),
                    const Divider(),
                    const AppSpacing(),
                    const Text(
                      "Código da Loja:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: colorGrey,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      widget.homeController.data!.codCompany.toString(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const AppSpacing(),
                    const Text(
                      "Razão:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: colorGrey,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      widget.homeController.data!.nameCompany!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const AppSpacing(),
                    const Divider(),
                    const AppSpacing(),
                    const Text(
                      "Agilize seus pedidos",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const AppSpacing(),
                    const Text(
                      "Utilize o código abaixo, para que o fornecedor possa identificar o seu acesso!",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: colorGreyDark,
                      ),
                    ),
                    const AppSpacing(),
                    Container(
                      padding: const EdgeInsets.all(appPadding),
                      decoration: BoxDecoration(
                        color: colorGreyLigth.withOpacity(0.5),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(appRadius),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                Icons.qr_code_rounded,
                                color: colorSecondary,
                              ),
                              AppSpacing(),
                              Text(
                                "Ações do Fornecedor",
                                style: TextStyle(color: colorBlack, fontWeight: FontWeight.bold),
                              ),
                              AppSpacing(),
                              Text(
                                "1. Aponte a câmera.",
                                style: TextStyle(color: colorBlack, fontWeight: FontWeight.w500),
                              ),
                              AppSpacing(),
                              Text(
                                "2. Realize a leitura.",
                                style: TextStyle(color: colorBlack, fontWeight: FontWeight.w500),
                              ),
                              AppSpacing(),
                              Text(
                                "3. Confirme os dados.",
                                style: TextStyle(color: colorBlack, fontWeight: FontWeight.w500),
                              ),
                              AppSpacing(),
                              Text(
                                "4. Faça o pedido.",
                                style: TextStyle(color: colorBlack, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          QrImageView(
                            data: widget.homeController.data!.codAccess!,
                            size: 200,
                            version: QrVersions.auto,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
