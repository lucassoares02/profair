import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:profair/src/components/loading_list.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:profair/src/views/home/home_controller.dart';
import 'package:profair/src/views/ticket/ticket_controller.dart';
import 'package:profair/src/views/ticket/ticket_repository.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class Ticket extends StatefulWidget {
  const Ticket({super.key, required this.homeController});

  final HomeController homeController;

  @override
  State<Ticket> createState() => _TicketState();
}

class _TicketState extends State<Ticket> {
  final TicketController profileController = TicketController(StateApp.start, TicketRepository());

  // URL dos Termos de Privacidade
  final String privacyPolicyUrl = 'https://profair-site.onrender.com/demo-it-business-privacy-policy.html';

  // Função para abrir o link no navegador
  Future<void> _launchPrivacyPolicyUrl() async {
    final Uri url = Uri.parse(privacyPolicyUrl);

    // Usar o navegador externo
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication, // Abre no navegador
    )) {
      throw 'Não foi possível abrir o link $url';
    }
  }

  Timer? negotiationTimer;

  @override
  void initState() {
    super.initState();
    // profileController.getWindowNegotiation(widget.homeController.data!.userCode!);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ValueListenableBuilder(
        valueListenable: profileController.stateDetailsProvider,
        builder: (context, stateDetails, child) {
          return stateDetails == StateApp.loading
              ? LoadingList()
              : AnnotatedRegion(
                  value: const SystemUiOverlayStyle(
                    statusBarColor: colorSecondary,
                    statusBarIconBrightness: Brightness.light,
                  ),
                  child: Scaffold(
                    backgroundColor: colorLight,
                    body: SafeArea(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            widget.homeController.data!.accessTargeting == 2 ? _buildAssociateView(size) : _buildProviderView(size),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
        });
  }

  // ─── ASSOCIATE VIEW (accessTargeting == 2) ───────────────────────────────

  Widget _buildAssociateView(Size size) {
    return ValueListenableBuilder(
      valueListenable: profileController.stateWindowNegotiation,
      builder: (context, stateWindowNegotiation, child) {
        return Column(
          children: [
            _buildHeader(isAssociate: true),
            const SizedBox(height: 16),

            // Name + badge
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: appPadding),
              child: Column(
                children: [
                  Text(
                    widget.homeController.data!.nameUser!,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: colorTertiary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // QR Code card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: appPadding),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: colorWhite,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: colorSecondary.withValues(alpha: 0.12),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      "QR Code de Acesso",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: colorGreyDark,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: colorLight,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: colorGreyLigth, width: 1),
                      ),
                      child: Animate(
                        effects: const [
                          ShimmerEffect(
                            delay: Duration(milliseconds: 500),
                            duration: Duration(milliseconds: 1000),
                          )
                        ],
                        child: QrImageView(
                          data: "0x9E89738274392874.${widget.homeController.data!.codAccess!}.9327329847372939",
                          size: size.width - 130,
                          version: QrVersions.auto,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [colorSecondary, colorPrimary],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        widget.homeController.data!.codAccess!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: colorWhite,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Apresente este código ao fornecedor",
                      style: TextStyle(
                        fontSize: 12,
                        color: colorGreyDark,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
            _buildInfoSection(),
            const SizedBox(height: 20),
            _buildFooter(),
            const SizedBox(height: 36),
          ],
        );
      },
    );
  }

  // ─── PROVIDER VIEW ────────────────────────────────────────────────────────

  Widget _buildProviderView(Size size) {
    return Column(
      children: [
        _buildHeader(isAssociate: false),
        const SizedBox(height: 56),

        // Name
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: appPadding),
          child: Text(
            widget.homeController.data!.nameUser!,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: colorTertiary,
            ),
            textAlign: TextAlign.center,
          ),
        ),

        const SizedBox(height: 28),

        // Code card highlight
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: appPadding),
          child: _buildInfoCard(
            icon: Icons.qr_code_rounded,
            label: "Código de Acesso",
            value: widget.homeController.data!.codAccess!,
            highlighted: true,
          ),
        ),

        const SizedBox(height: 12),
        _buildInfoSection(),
        const SizedBox(height: 20),
        _buildFooter(),
        const SizedBox(height: 36),
      ],
    );
  }

  // ─── SHARED COMPONENTS ────────────────────────────────────────────────────

  Widget _buildHeader({required bool isAssociate}) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Gradient background
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(bottom: 56),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [colorSecondary, colorPrimary],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(36),
              bottomRight: Radius.circular(36),
            ),
          ),
          child: Column(
            children: [
              // Back button
              Padding(
                padding: EdgeInsets.only(top: appPadding, left: 5),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, color: colorWhite, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Logo
              Image.asset("assets/images/logowhite.png", width: 120),
              const SizedBox(height: 16),
              const Text(
                "Meu Perfil",
                style: TextStyle(
                  color: colorWhite,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                isAssociate ? "Acesso de Associado" : "Acesso de Fornecedor",
                style: TextStyle(
                  color: colorWhite.withValues(alpha: 0.7),
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: appPadding),
          child: _buildInfoCard(
            icon: Icons.business_center_outlined,
            label: "Código Empresa",
            value: widget.homeController.data!.codCompany.toString(),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: appPadding),
          child: _buildInfoCard(
            icon: Icons.store_mall_directory_outlined,
            label: "Razão Social",
            value: widget.homeController.data!.nameCompany!,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    bool highlighted = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: colorWhite,
        borderRadius: BorderRadius.circular(16),
        border: highlighted ? Border.all(color: colorSecondary.withValues(alpha: 0.25), width: 1.5) : null,
        boxShadow: [
          BoxShadow(
            color: colorGreyLigth.withValues(alpha: 0.7),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: highlighted ? colorSecondary.withValues(alpha: 0.1) : colorLight,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              icon,
              color: highlighted ? colorSecondary : colorGreyDark,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: colorGreyDark,
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: highlighted ? colorSecondary : colorTertiary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: appPadding),
      child: Column(
        children: [
          // Privacy link row
          GestureDetector(
            onTap: _launchPrivacyPolicyUrl,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              decoration: BoxDecoration(
                color: colorWhite,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: colorGreyLigth.withValues(alpha: 0.7),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: colorLight,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: const Icon(
                      Icons.privacy_tip_outlined,
                      color: colorGreyDark,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Text(
                      "Termos e Privacidade",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: colorTertiary,
                      ),
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded, color: colorGrey, size: 22),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Logout button
          GestureDetector(
            onTap: () async {
              FirebaseMessaging messaging = FirebaseMessaging.instance;

              // 🔥 Força a geração de um novo token
              await messaging.deleteToken();
              widget.homeController.logout();
              if (!mounted) return;
              Navigator.of(context).pushNamedAndRemoveUntil("/login", (route) => false);
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                color: colorRed.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: colorRed.withValues(alpha: 0.18),
                  width: 1.5,
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout_rounded, color: colorRed, size: 20),
                  SizedBox(width: 10),
                  Text(
                    "Sair da conta",
                    style: TextStyle(
                      color: colorRed,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
