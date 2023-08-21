import 'package:profair/src/models/login_model.dart';
import 'package:profair/src/repositories/login_repository.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashController extends ValueNotifier<StateApp> {
  final stateLogin = ValueNotifier<StateApp>(StateApp.start);

  final LoginRepository _loginRepository;

  SplashController(super.value, this._loginRepository);

  LoginModel? dataUser;

  Future initApplication() async {
    // Obtain shared preferences.
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    stateLogin.value = StateApp.loading;
    try {
      final code = sharedPreferences.getString("codacesso");
      if (code != null) {
        return true;
      }
      stateLogin.value = StateApp.success;
      return false;
    } catch (e) {
      stateLogin.value = StateApp.error;
      return false;
    }
  }
}
