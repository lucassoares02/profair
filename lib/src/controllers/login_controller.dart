import 'package:profair/src/models/login_model.dart';
import 'package:profair/src/repositories/login_repository.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends ValueNotifier<StateApp> {
  final stateLogin = ValueNotifier<StateApp>(StateApp.start);

  final LoginRepository _loginRepository;

  LoginController(super.value, this._loginRepository);

  LoginModel? dataUser;

  Future requestLogin(Object data) async {
    stateLogin.value = StateApp.loading;
    try {
      LoginModel? response = await _loginRepository.getLogin(data);
      final responseShared = await moduleSharedPreferences("codacesso", "${response!.codAccess}");
      if (responseShared) {
        return true;
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
