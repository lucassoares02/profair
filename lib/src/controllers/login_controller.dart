import 'package:profair/src/models/login_model.dart';
import 'package:profair/src/repositories/login_repository.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends ValueNotifier<StateApp> {
  LoginController(super.value);

  final stateLogin = ValueNotifier<StateApp>(StateApp.start);
  final stateLoginCode = ValueNotifier<StateApp>(StateApp.start);
  LoginModel? dataUser;
  LoginRepository loginRepository = LoginRepository();

  Future requestLogin(Object data) async {
    stateLoginCode.value = StateApp.loading;
    try {
      LoginModel? response = await loginRepository.getLogin(data);
      final responseShared = await moduleSharedPreferences("codacesso", "${response!.codAccess}");
      await moduleSharedPreferences("direct", "${response.accessTargeting}");
      await moduleSharedPreferences("company", "${response.codCompany}");
      if (responseShared) {
        debugPrint("Request Login (Login Controller) $responseShared");
      }

      stateLoginCode.value = StateApp.success;
      return false;
    } catch (e) {
      debugPrint("$e");
      stateLoginCode.value = StateApp.error;
      return false;
    }
  }

  Future stateLoginQr(Object data) async {
    stateLogin.value = StateApp.loading;
    try {
      LoginModel? response = await loginRepository.getLogin(data);
      final responseShared = await moduleSharedPreferences("codacesso", "${response!.codAccess}");
      await moduleSharedPreferences("direct", "${response.accessTargeting}");
      await moduleSharedPreferences("company", "${response.codCompany}");

      if (responseShared) {
        debugPrint("State Login QR (Login Controller) $responseShared");
      }
      stateLogin.value = StateApp.success;
      return false;
    } catch (e) {
      stateLogin.value = StateApp.error;
      return false;
    }
  }

  moduleSharedPreferences(String description, String item) async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    try {
      if ((item != "" || item != "null") && description != "") {
        await sharedPreferences.setString(description, item);
        return true;
      }
    } catch (e) {
      debugPrint("Error Save Shared Preferences: $e");
      return false;
    }
  }
}
