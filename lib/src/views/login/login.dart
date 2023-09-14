import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:profair/generated/l10n.dart';

import 'package:profair/provider/appwriter.dart';
import 'package:profair/src/controllers/login_controller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:profair/src/components/spacing.dart';
import 'package:profair/src/components/button.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:profair/src/utils/colors.dart';
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
  ValueNotifier<String> teste = ValueNotifier("");
  TextEditingController codigo = TextEditingController();

  @override
  void initState() {
    loginController = LoginController(StateApp.start, Provider.of<AppWrite>(context, listen: false));
    super.initState();
  }

  String codes = "";

  scannerQrCode() async {
    dynamic permission = await accessCamPermission();
    if (permission == PermissionStatus.granted) {
      String code = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666",
        "Cancelar",
        false,
        ScanMode.DEFAULT,
      );

      if (code != "-1") {
        final data = {"codacesso": code};
        try {
          bool response = await loginController!.stateLoginQr(data);

          // navigatorRoutes(response);
          loginFunc();
        } catch (e) {
          debugPrint('$e');
        }
      }
    }
  }

  loginCode() async {
    final data = {"codacesso": codigo.text};
    try {
      await loginController!.requestLogin(data);
      if (loginController!.stateLoginCode.value == StateApp.success) {
        loginFunc();
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

  loginFunc() async {
    // bool response = await loginController!.auth("teste@profair.com", "12345678");
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
      codigo.text = "";
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const AppSpacing(),
            Image.asset(
              'assets/images/logo.png',
              height: 60,
            ),
            Column(
              children: [
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
                        type: "filled",
                        onPressButton: () {
                          loginCode();
                        },
                        label: "Acesse com código",
                        colorButton: colorSecondary,
                        iconButton: Icons.numbers,
                        loading: value == StateApp.loading,
                      );
                    }),
                const AppSpacing(),
                const AppSpacing(),
                Text("ou"),
                const AppSpacing(),
                const AppSpacing(),
                ValueListenableBuilder(
                  valueListenable: loginController!.stateLogin,
                  builder: (context, value, child) {
                    return ValueListenableBuilder(
                        valueListenable: teste,
                        builder: (context, values, child) {
                          return values != ""
                              ? Container()
                              : AppButton(
                                  onPressButton: () {
                                    // loginFunc();
                                    scannerQrCode();
                                    // testteInter();
                                  },
                                  label: S.of(context).text_scanner,
                                  colorButton: colorSecondary,
                                  iconButton: Icons.qr_code_rounded,
                                  loading: value == StateApp.loading,
                                );
                        });
                  },
                ),
              ],
            ),
            const AppSpacing(),
          ],
        ),
      )),
    );
  }
}
