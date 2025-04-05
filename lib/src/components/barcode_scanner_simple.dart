import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:profair/src/controllers/login_controller.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:profair/src/utils/colors.dart';

class BarcodeScannerSimple extends StatefulWidget {
  const BarcodeScannerSimple({super.key, required this.loginController});

  final LoginController? loginController;

  @override
  State<BarcodeScannerSimple> createState() => _BarcodeScannerSimpleState();
}

class _BarcodeScannerSimpleState extends State<BarcodeScannerSimple> {
  Barcode? _barcode;

  Widget _buildBarcode(Barcode? value) {
    if (value == null) {
      return const Text(
        'No barcode detected',
        overflow: TextOverflow.fade,
        style: TextStyle(color: colorWhite),
      );
    }
    return Text(
      value.displayValue ?? 'Sem valor',
      overflow: TextOverflow.fade,
      style: const TextStyle(color: colorWhite),
    );
  }

  void _handleBarcode(BarcodeCapture barcodes) async {
    final String code = barcodes.barcodes.first.rawValue ?? "-1";

    if (code != "-1") {
      final data = {"codacesso": code};

      bool response = await widget.loginController!.stateLoginQr(data);

      if (widget.loginController!.stateLogin.value == StateApp.success) {
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

        Navigator.of(context).pushNamedAndRemoveUntil('login', (Route<dynamic> route) => false);
      }
    }
  }

  navigatorRoutes(response) {
    if (response) {
      Navigator.of(context).pushNamedAndRemoveUntil('home', (Route<dynamic> route) => false);
    }
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
