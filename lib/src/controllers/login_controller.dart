import 'dart:developer';
import 'package:profair/provider/appwriter.dart';
import 'package:profair/src/models/login_model.dart';
import 'package:profair/src/repositories/login_repository.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends ValueNotifier<StateApp> {
  LoginController(super.value, this._loginRepository);

  final AppWrite _loginRepository;

  final stateLogin = ValueNotifier<StateApp>(StateApp.start);
  final stateLoginCode = ValueNotifier<StateApp>(StateApp.start);
  LoginModel? dataUser;
  LoginRepository loginRepository = LoginRepository();

  Future requestLogin(Object data) async {
    stateLoginCode.value = StateApp.loading;
    try {
      LoginModel? response = await loginRepository.getLogin(data);
      final responseShared = await moduleSharedPreferences("codacesso", "${response!.codAccess}");
      if (responseShared) {
        await auth(response.email!, response.codAccess!, response.nameUser);
      }

      stateLoginCode.value = StateApp.success;
      return false;
    } catch (e) {
      print("$e");

      stateLoginCode.value = StateApp.error;
      return false;
    }
  }

  Future stateLoginQr(Object data) async {
    stateLogin.value = StateApp.loading;
    try {
      LoginModel? response = await loginRepository.getLogin(data);
      final responseShared = await moduleSharedPreferences("codacesso", "${response!.codAccess}");
      inspect(response);

      if (responseShared) {
        await auth(response.email!, response.codAccess!, response.nameUser);
      }
      stateLogin.value = StateApp.success;
      return false;
    } catch (e) {
      print("$e");
      stateLogin.value = StateApp.error;
      return false;
    }
  }

  Future auth(String email, String password, String? nameUser) async {
    stateLogin.value = StateApp.loading;
    try {
      final response = await _loginRepository.initSessionUser(email, password);

      if (response.toString().contains("user_invalid_credentials")) {
        await _loginRepository.createUser(nameUser!, password, email);
        await _loginRepository.initSessionUser(email, password);
      }
      stateLogin.value = StateApp.success;
      return true;
    } catch (e) {
      print("Error return AppWrite $e");
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
