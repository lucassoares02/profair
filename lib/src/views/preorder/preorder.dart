// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:profair/generated/l10n.dart';
import 'package:profair/src/components/spacing.dart';
import 'package:profair/src/components/button.dart';
import 'package:profair/src/models/login_model.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:profair/src/views/home/home_controller.dart';

import '../../state/state_app.dart';

class PreOrder extends StatefulWidget {
  PreOrder({super.key, required this.homeController});

  HomeController homeController;

  @override
  State<PreOrder> createState() => _PreOrderState();
}

class _PreOrderState extends State<PreOrder> {
  ValueNotifier<String> teste = ValueNotifier("");
  TextEditingController codigo = TextEditingController();

  String codes = "";

  scannerQrCode() async {
    try {
      String code = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666",
        "Cancelar",
        false,
        ScanMode.DEFAULT,
      );
      if (code != "-1") {
        LoginModel? response = await widget.homeController.findClient(code);
        int codeUser = response!.userCode ?? 0;
        if (codeUser != 0) {
          navigatorRoutes("selectstore", {"client": response, "codeProvider": widget.homeController.data!.codCompany});
        } else {
          Fluttertoast.showToast(
              msg: "Código inválido!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      }
    } on PlatformException {
      debugPrint('Error scanning qrcode');
      Fluttertoast.showToast(
          msg: "Código inválido!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  loginCode() async {
    try {
      LoginModel? response = await widget.homeController.findClient(codigo.text);
      int codeUser = response!.userCode ?? 0;
      print(response);
      if (codeUser != null) {
        navigatorRoutes("selectstore", {"client": response, "codeProvider": widget.homeController.data!.codCompany});
      } else {}
    } catch (e) {
      debugPrint('Error scanning qrcodesssss: $e');
      Fluttertoast.showToast(
          msg: "Código inválido!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
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
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.symmetric(vertical: appPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: colorBlack,
                    size: 20,
                  ),
                ),
              ],
            ),
            const AppSpacing(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: appPadding),
              child: Column(
                children: [
                  const Text(
                    "Peça para que o associado informe o código!",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const AppSpacing(),
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
                      valueListenable: widget.homeController.stateStore,
                      builder: (context, value, child) {
                        return AppButton(
                          onPressButton: () {
                            loginCode();
                          },
                          type: 'filled',
                          label: "Digite o código",
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
                    valueListenable: widget.homeController.stateStore,
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
            ),
            const AppSpacing(),
          ],
        ),
      )),
    );
  }
}
