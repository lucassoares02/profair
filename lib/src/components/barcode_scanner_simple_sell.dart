import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:profair/src/components/spacing.dart';
import 'package:profair/src/models/login_model.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:profair/src/views/home/home_controller.dart';

class BarcodeScannerSimpleSell extends StatefulWidget {
  const BarcodeScannerSimpleSell({super.key, required this.homeController});

  final HomeController homeController;

  @override
  State<BarcodeScannerSimpleSell> createState() => _BarcodeScannerSimpleSellState();
}

class _BarcodeScannerSimpleSellState extends State<BarcodeScannerSimpleSell> {
  Barcode? _barcode;
  bool _scanned = false;

  @override
  void setState(VoidCallback fn) {
    _scanned = false;
    super.setState(fn);
  }

  void _handleBarcode(BarcodeCapture barcodes) async {
    print(barcodes);
    if (_scanned) return; // impede múltiplas leituras

    // setState(() => _scanned = true); // marca como já escaneado

    final String codeD = barcodes.barcodes.first.rawValue ?? "-1";
    if (codeD == "-1") return;

    String code = codeD.replaceAll("0x9E89738274392874.", "").replaceAll(".9327329847372939", "");
    LoginModel? response = await widget.homeController.findClient(code);
    int codeUser = response?.userCode ?? 0;
    int active = response?.active ?? 0;

    if (active == 0) {
      Fluttertoast.showToast(msg: "Período de negociações não iniciado ou encerrado!", backgroundColor: Colors.red, textColor: Colors.white);
      setState(() => _scanned = false); // libera nova leitura
      return;
    }

    if (codeUser != 0) {
      navigatorRoutes("selectstore", {"client": response, "codeProvider": widget.homeController.data!.codCompany, "consult": widget.homeController.data!.userCode});
    } else {
      Fluttertoast.showToast(msg: "Código inválido!", backgroundColor: Colors.red, textColor: Colors.white);
      setState(() => _scanned = false); // libera nova leitura
    }
  }

  navigatorRoutes(route, data) {
    Navigator.of(context).pop();
    Navigator.of(context).pushNamed(route, arguments: data).then((_) {});
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
              const Row(
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
          Positioned(
            bottom: 120,
            left: 0,
            right: 0,
            child: Column(
              children: [
                TextButton(
                    onPressed: () {
                      // Navegar pra PreOrder passando widget.homeController
                      Navigator.of(context).pushNamed("preorder", arguments: widget.homeController);
                    },
                    child: const Text("Digitar o código")),
              ],
            ),
          ),
          const Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Icon(Icons.info_outline, color: Colors.white),
                SizedBox(height: 5),
                Text(
                  'Solicite o código ao associado.',
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
