import 'dart:developer';

import 'package:appwrite/models.dart';
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
      print("response login model");
      print(response);
      final responseShared = await moduleSharedPreferences("codacesso", "${response!.codAccess}");
      if (responseShared) {
        // return true;
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
      print("response login model");
      print(response);
      final responseShared = await moduleSharedPreferences("codacesso", "${response!.codAccess}");
      if (responseShared) {
        // return true;
      }
      stateLogin.value = StateApp.success;
      return false;
    } catch (e) {
      print("$e");
      stateLogin.value = StateApp.error;

      return false;
    }
  }

  Future auth(String email, String password) async {
    stateLogin.value = StateApp.loading;
    try {
      await _loginRepository.initSessionUser(email, password);
      User user = await _loginRepository.getUser();
      // inspect(user);
      // print(user);
      // print(user.prefs.data["code"]);
      // final teste = await requestLogin({"codacesso": user.prefs.data["code"]});

      stateLogin.value = StateApp.success;
      return true;
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
