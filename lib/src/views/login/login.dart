import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:profair/generated/l10n.dart';
import 'package:profair/src/controllers/login_controller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:profair/src/components/spacing.dart';
import 'package:profair/src/components/button.dart';
import 'package:profair/src/utils/spacing.dart';
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
  ValueNotifier<bool> enterCode = ValueNotifier(false);
  TextEditingController codigo = TextEditingController();
  bool logoVisible = true;

  @override
  void initState() {
    loginController = LoginController(StateApp.start);
    super.initState();
  }

  String codes = "";
  String? code = "";

  scannerQrCode() async {
    // dynamic permission = await accessCamPermission();
    // if (permission == PermissionStatus.granted) {

    try {
      code = await FlutterBarcodeScanner.scanBarcode(
        "#66ff66",
        "Cancelar",
        true,
        ScanMode.DEFAULT,
      );

      if (code != "-1") {
        final data = {"codacesso": code};
        bool response = await loginController!.stateLoginQr(data);
        if (loginController!.stateLogin.value == StateApp.success) {
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
      }
    } on PlatformException {
      code = "Failed to get platform version.";
    }
    // }
  }

  navigatorRoutes(response) {
    if (response) {
      codigo.text = "";
      Navigator.of(context).pushNamed('home');
    }
  }

  accessCamPermission() async {
    final PermissionStatus status = await Permission.camera.request();
    return status;
  }

  loginCode() async {
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
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/images/background.jpg"), fit: BoxFit.cover, opacity: 0.5),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              colorSecondary,
              colorBlueAccent,
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Image.asset(
              'assets/images/logowhite.png',
              width: width / 1.5,
            ),
            Padding(
              padding: const EdgeInsets.all(appPadding),
              child: Column(
                children: [
                  const AppSpacing(),
                  ValueListenableBuilder(
                    valueListenable: enterCode,
                    builder: (context, bool value, child) {
                      return value == false && width < 700
                          ? Column(
                              children: [
                                Lottie.asset("assets/images/qrcode2.json"),
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Faça login com QrCode",
                                      style: TextStyle(
                                        color: colorWhite,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    AppSpacing(),
                                    Text(
                                      "Escaneie o QR Code com facilidade e tenha acesso imediato a todas as suas informações essenciais do evento!",
                                      style: TextStyle(
                                        color: colorGreyLigth,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                const AppSpacing(),
                                ValueListenableBuilder(
                                  valueListenable: loginController!.stateLogin,
                                  builder: (context, value, child) {
                                    return Column(
                                      children: [
                                        AppButton(
                                          onPressButton: () {
                                            // loginFunc();
                                            scannerQrCode();
                                            // testteInter();
                                          },
                                          colorLoading: colorWhite,
                                          label: S.of(context).text_scanner,
                                          colorButton: colorWhite,
                                          iconButton: Icons.qr_code_rounded,
                                          loading: value == StateApp.loading,
                                        ),
                                        const AppSpacing(),
                                        if (value != StateApp.loading)
                                          TextButton(
                                            onPressed: () {
                                              enterCode.value = !enterCode.value;
                                            },
                                            child: const Text(
                                              "Digitar o código",
                                              style: TextStyle(color: colorWhite, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                      ],
                                    );
                                  },
                                ),
                                TextButton(
                                  onPressed: () {
                                    _launchPrivacyPolicyUrl();
                                  },
                                  child: const Text(
                                    'Termos e Privacidade',
                                    style: TextStyle(
                                      color: Colors.white, // Cor do texto
                                      decoration: TextDecoration.underline, // Sublinhar o texto
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                const AppSpacing(),
                                const AppSpacing(),
                                TextFormField(
                                  onChanged: (t) {
                                    teste.value = t;
                                  },
                                  keyboardType: TextInputType.number,
                                  controller: codigo,
                                  decoration: InputDecoration(
                                    filled: true,
                                    focusColor: colorSecondary,
                                    border: const OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(appRadius),
                                      ),
                                    ),
                                    fillColor: colorGrey.withOpacity(0.5),
                                    hintText: "...",
                                  ),
                                ),
                                const AppSpacing(),
                                const AppSpacing(),
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
                                        iconButton: Icons.numbers,
                                        loading: value == StateApp.loading,
                                      );
                                    }),
                                const AppSpacing(),
                                if (width < 700)
                                  TextButton(
                                    onPressed: () {
                                      enterCode.value = !enterCode.value;
                                    },
                                    child: const Text(
                                      "Acessar com QrCode",
                                      style: TextStyle(color: colorWhite, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                              ],
                            );
                    },
                  ),
                ],
              ),
            ),
            // const AppSpacing(),
          ],
        ),
      ),
    );
  }
}
