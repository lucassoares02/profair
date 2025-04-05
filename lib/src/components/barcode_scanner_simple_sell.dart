import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:profair/src/models/login_model.dart';
import 'package:profair/src/views/home/home_controller.dart';

class BarcodeScannerSimpleSell extends StatefulWidget {
  const BarcodeScannerSimpleSell({super.key, required this.homeController});

  final HomeController homeController;

  @override
  State<BarcodeScannerSimpleSell> createState() => _BarcodeScannerSimpleSellState();
}

class _BarcodeScannerSimpleSellState extends State<BarcodeScannerSimpleSell> {
  Barcode? _barcode;

  void _handleBarcode(BarcodeCapture barcodes) async {
    final String codeD = barcodes.barcodes.first.rawValue ?? "-1";

    if (codeD != "-1") {
      String code = codeD.replaceAll("0x9E89738274392874.", "");
      code = code.replaceAll(".9327329847372939", "");

      LoginModel? response = await widget.homeController.findClient(code);
      int codeUser = response!.userCode ?? 0;

      int active = response.active ?? 0;

      if (active == 0) {
        Fluttertoast.showToast(
            msg: "Período de negociações não iniciado ou encerrado!!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        return;
      } else {
        if (codeUser != 0) {
          navigatorRoutes("selectstore", {"client": response, "codeProvider": widget.homeController.data!.codCompany, "consult": widget.homeController.data!.userCode});
        } else {
          Fluttertoast.showToast(
              msg: "Código inválido!", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.red, textColor: Colors.white, fontSize: 16.0);
        }
      }
    } else {
      navigatorRoutes("preorder", widget.homeController);
    }
  }

  navigatorRoutes(route, data) {
    Navigator.of(context).pushNamed(
      route,
      arguments: data,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        ],
      ),
    );
  }
}
