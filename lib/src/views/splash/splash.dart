import 'package:profair/src/components/progress_indicator.dart';
import 'package:profair/src/controllers/splash_controller.dart';
import 'package:profair/src/repositories/login_repository.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final SplashController splashController = SplashController(StateApp.start, LoginRepository());

  @override
  void initState() {
    super.initState();
    initApp();
  }

  initApp() async {
    bool response = await splashController.initApplication();
    navigatorRoute(response);
  }

  navigatorRoute(response) {
    if (response) {
      Navigator.of(context).pushNamedAndRemoveUntil("/home", (route) => false);
    } else {
      Navigator.of(context).pushNamedAndRemoveUntil("/login", (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorWhite,
      body: SafeArea(
        bottom: false,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/iconblue.png',
                height: 100,
              ),
              AppProgressIndicator(colorItem: colorPrimary),
            ],
          ),
        ),
      ),
    );
  }
}
