import 'dart:ui';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:profair/src/components/barcode_scanner_simple.dart';
import 'package:profair/src/controllers/login_controller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:profair/src/components/button.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../state/state_app.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginController? loginController;
  ValueNotifier<String> teste = ValueNotifier("");
  ValueNotifier<bool> enterCode = ValueNotifier(true);
  TextEditingController codigo = TextEditingController();
  bool logoVisible = true;
  int count = 0;

  @override
  void initState() {
    printScreenDensity();
    loginController = LoginController(StateApp.start);
    super.initState();
  }

  String codes = "";
  String? code = "";

  navigatorRoutes(response) {
    if (response) {
      codigo.text = "";
      Navigator.of(context).pushNamed('home');
    }
  }

  void printScreenDensity() async {
    final pixelRatio = window.devicePixelRatio;
    final size = window.physicalSize;

    print('Device Pixel Ratio: $pixelRatio');
    print('Screen Resolution: ${size.width} x ${size.height}');
  }

  accessCamPermission() async {
    final PermissionStatus status = await Permission.camera.request();
    return status;
  }

  loginCode() async {
    // String? token = await FirebaseMessaging.instance.getToken();

    final data = {"codacesso": codigo.text};
    try {
      await loginController!.requestLogin(data);
      if (loginController!.stateLoginCode.value == StateApp.success) {
        navigatorRoutes(true);
      } else {
        Fluttertoast.showToast(
            msg: "Não foi possível realizar login!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e) {
      debugPrint('$e');
    }
  }

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

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF130430),
              colorSecondary,
              colorBlueAccent,
            ],
            stops: [0.0, 0.52, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Background texture
            Positioned.fill(
              child: Image.asset(
                "assets/images/background.jpg",
                fit: BoxFit.cover,
                opacity: const AlwaysStoppedAnimation(0.06),
              ),
            ),
            // Glow top-right
            Positioned(
              top: -110,
              right: -90,
              child: Container(
                width: 320,
                height: 320,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      colorPrimary.withValues(alpha: 0.28),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            // Glow bottom-left
            Positioned(
              bottom: 80,
              left: -130,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      colorBlueAccent.withValues(alpha: 0.22),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            // Main layout
            SafeArea(
              child: Column(
                children: [
                  // Logo area — shrinks toward the card
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Image.asset(
                          'assets/images/logowhite.png',
                          width: width * 0.48,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Venda mais. Negocie melhor.",
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 16,
                            letterSpacing: 0.4,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Pedidos e negociações na palma da mão",
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.4),
                            fontSize: 12,
                            letterSpacing: 0.8,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                  // Login card
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      20,
                      0,
                      20,
                      MediaQuery.of(context).viewInsets.bottom + 20,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.18),
                              width: 1.5,
                            ),
                          ),
                          padding: const EdgeInsets.fromLTRB(24, 28, 24, 8),
                          child: ValueListenableBuilder(
                            valueListenable: enterCode,
                            builder: (context, bool value, child) {
                              return value == true || width >= 700 ? _buildCodeInput(width) : _buildQrCode();
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCodeInput(double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Badge
        _buildBadge(Icons.lock_outline_rounded, "Acesso Seguro"),
        const SizedBox(height: 18),
        const Text(
          "Bem-vindo",
          style: TextStyle(
            color: colorWhite,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "Digite seu código de acesso para continuar",
          style: TextStyle(
            color: colorWhite.withValues(alpha: 0.5),
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 24),
        // Code field
        TextFormField(
          onChanged: (t) {
            teste.value = t;
          },
          keyboardType: TextInputType.number,
          controller: codigo,
          style: const TextStyle(
            color: colorWhite,
            fontSize: 22,
            fontWeight: FontWeight.w700,
            letterSpacing: 8,
          ),
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.08),
            hintText: "• • • • • •",
            hintStyle: TextStyle(
              color: colorWhite.withValues(alpha: 0.22),
              fontSize: 22,
              letterSpacing: 8,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.15), width: 1.5),
              borderRadius: BorderRadius.circular(16),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.15), width: 1.5),
              borderRadius: BorderRadius.circular(16),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: colorPrimary, width: 2),
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
          ),
        ),
        const SizedBox(height: 22),
        // Primary button
        ValueListenableBuilder(
          valueListenable: loginController!.stateLoginCode,
          builder: (context, value, child) {
            return AppButton(
              onPressButton: () {
                loginCode();
              },
              colorLoading: colorWhite,
              label: "Acessar",
              colorButton: colorWhite,
              iconButton: Icons.arrow_forward_rounded,
              loading: value == StateApp.loading,
            );
          },
        ),
        // Secondary QR option
        if (width < 700)
          Center(
            child: TextButton.icon(
              onPressed: () {
                enterCode.value = !enterCode.value;
              },
              icon: Icon(Icons.qr_code_rounded, size: 15, color: colorWhite.withValues(alpha: 0.9)),
              label: Text(
                "Acessar com QR Code",
                style: TextStyle(
                  color: colorWhite.withValues(alpha: 0.9),
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        // Privacy link
        Center(
          child: TextButton(
            onPressed: () {
              _launchPrivacyPolicyUrl();
            },
            child: Text(
              'Termos e Privacidade',
              style: TextStyle(
                color: colorWhite.withValues(alpha: 0.3),
                decoration: TextDecoration.underline,
                decorationColor: colorWhite.withValues(alpha: 0.3),
                fontSize: 11,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQrCode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildBadge(Icons.qr_code_rounded, "QR Code"),
        const SizedBox(height: 18),
        const Text(
          "Escanear QR Code",
          style: TextStyle(
            color: colorWhite,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "Aponte a câmera para o QR Code e acesse instantaneamente",
          style: TextStyle(
            color: colorWhite.withValues(alpha: 0.5),
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 24),
        ValueListenableBuilder(
          valueListenable: loginController!.stateLogin,
          builder: (context, value, child) {
            return Column(
              children: [
                AppButton(
                  onPressButton: () {
                    // loginFunc();
                    // scannerQrCode();
                    // testteInter();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BarcodeScannerSimple(loginController: loginController!),
                      ),
                    );
                  },
                  colorLoading: colorWhite,
                  label: "Escanear QR Code",
                  colorButton: colorWhite,
                  iconButton: Icons.qr_code_scanner_rounded,
                  loading: value == StateApp.loading,
                ),
                if (value != StateApp.loading)
                  Center(
                    child: TextButton.icon(
                      onPressed: () {
                        enterCode.value = !enterCode.value;
                      },
                      icon: Icon(Icons.pin_outlined, size: 15, color: colorWhite.withValues(alpha: 0.9)),
                      label: Text(
                        "Digitar o código",
                        style: TextStyle(
                          color: colorWhite.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        Center(
          child: TextButton(
            onPressed: () {
              _launchPrivacyPolicyUrl();
            },
            child: Text(
              'Termos e Privacidade',
              style: TextStyle(
                color: colorWhite.withValues(alpha: 0.3),
                decoration: TextDecoration.underline,
                decorationColor: colorWhite.withValues(alpha: 0.3),
                fontSize: 11,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBadge(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: colorPrimary.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorPrimary.withValues(alpha: 0.32),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: colorPrimary, size: 12),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              color: colorPrimary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
