import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:profair/src/components/spacing.dart';
import 'package:profair/src/controllers/login_controller.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:lottie/lottie.dart';
import 'package:profair/src/utils/spacing.dart'; // Adicione isso no pubspec.yaml

class BarcodeScannerSimple extends StatefulWidget {
  const BarcodeScannerSimple({super.key, required this.loginController});

  final LoginController? loginController;

  @override
  State<BarcodeScannerSimple> createState() => _BarcodeScannerSimpleState();
}

class _BarcodeScannerSimpleState extends State<BarcodeScannerSimple> {
  // Barcode? _barcode;
  bool _scanned = false;

  void _handleBarcode(BarcodeCapture barcodes) async {
    if (_scanned) return;

    final String code = barcodes.barcodes.first.rawValue ?? "-1";

    if (code != "-1") {
      setState(() {
        _scanned = true;
      });
      String? token = await FirebaseMessaging.instance.getToken();
      print("((((((((((((((((((((((((((((((((((((((((token))))))))))))))))))))))))))))))))))))))))");
      print(token);

      final data = {"codacesso": code, "token": token};
      bool response = await widget.loginController!.stateLoginQr(data);

      if (widget.loginController!.stateLogin.value == StateApp.success) {
        navigatorRoutes(true);
      } else {
        Fluttertoast.showToast(
          msg: "Não foi possível realizar login!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        Navigator.of(context).pushNamedAndRemoveUntil('login', (route) => false);
      }
    }
  }

  navigatorRoutes(response) {
    if (response) {
      Navigator.of(context).pushNamedAndRemoveUntil('home', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(
            onDetect: _handleBarcode,
            fit: BoxFit.cover,
            controller: MobileScannerController(
              facing: CameraFacing.back,
              torchEnabled: false,
              detectionSpeed: DetectionSpeed.noDuplicates,
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.3), // leve escurecimento
          ),
          Column(
            children: [
              const AppSpacing(),
              const AppSpacing(),
              Container(
                margin: const EdgeInsets.only(top: appPadding, left: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, color: colorWhite), // Altere o ícone aqui
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
              ),
              const AppSpacing(),
              Center(
                child: Image.asset(
                  'assets/images/logo.png', // sua logo aqui
                  height: 60,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.qr_code_scanner, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Aponte a câmera para o QR Code',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              if (_scanned)
                Lottie.asset(
                  'assets/images/success.json',
                  height: 120,
                  repeat: false,
                  onLoaded: (composition) {
                    Future.delayed(const Duration(seconds: 1), () {
                      // Aguarda animação e navega
                    });
                  },
                ),
            ],
          ),
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: colorPrimary, width: 2),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Column(
              children: const [
                Icon(Icons.info_outline, color: Colors.white),
                SizedBox(height: 5),
                Text(
                  'O login será feito automaticamente após leitura.',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
