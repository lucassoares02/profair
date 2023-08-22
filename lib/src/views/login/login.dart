import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:profair/provider/appwriter.dart';
import 'package:profair/src/repositories/login_repository.dart';
import 'package:profair/src/controllers/login_controller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:profair/src/components/spacing.dart';
import 'package:profair/src/components/button.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:profair/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/state_app.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginController? loginController;

  @override
  void initState() {
    loginController = LoginController(StateApp.start, Provider.of<AppWrite>(context, listen: false));
    super.initState();
  }

  String codes = "";

  // scannerQrCode() async {
  //   dynamic permission = await accessCamPermission();
  //   if (permission == PermissionStatus.granted) {
  //     String code = await FlutterBarcodeScanner.scanBarcode(
  //       "#ff6666",
  //       "Cancelar",
  //       false,
  //       ScanMode.DEFAULT,
  //     );

  //     if (code != "-1") {
  //       final data = {"codacesso": code};
  //       try {
  //         bool response = await loginController.requestLogin(data);

  //         navigatorRoutes(response);
  //       } catch (e) {
  //         debugPrint('$e');
  //       }
  //     }
  //   }
  // }

  loginFunc() async {
    bool response = await loginController!.auth("lucas.soares@profair.com", "12345678");
    navigatorRoutes(response);
  }

  // testteInter() async {
  //   final data = {"codacesso": "1000000024212"};
  //   // final data = {"codacesso": "1000000063011"};
  //   // final data = {"codacesso": "1000000059091"};
  //   try {
  //     bool response = await loginController.requestLogin(data);

  //     navigatorRoutes(response);
  //   } catch (e) {
  //     debugPrint('$e');
  //   }
  // }

  navigatorRoutes(response) {
    if (response) {
      Navigator.of(context).pushNamed('home');
    }
  }

  accessCamPermission() async {
    final PermissionStatus status = await Permission.camera.request();
    return status;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.all(appPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const AppSpacing(),
            Image.asset(
              'assets/images/logo.png',
              height: 60,
            ),
            ValueListenableBuilder(
              valueListenable: loginController!.stateLogin,
              builder: (context, value, child) {
                return AppButton(
                  onPressButton: () {
                    loginFunc();
                    // scannerQrCode();
                    // testteInter();
                  },
                  label: S.of(context).text_scanner,
                  colorButton: colorSecondary,
                  type: 'filled',
                  iconButton: FontAwesomeIcons.qrcode,
                  loading: value == StateApp.loading,
                );
              },
            ),
            const AppSpacing(),
          ],
        ),
      )),
    );
  }
}
