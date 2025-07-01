import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:profair/firebase_options.dart';
import 'package:profair/src/components/progress_indicator.dart';
import 'package:profair/src/components/spacing.dart';
import 'package:profair/src/controllers/splash_controller.dart';
import 'package:profair/src/notification/notification_service.dart';
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
    start();
  }

  void start() async {
    try {
      await Firebase.initializeApp(
        options: Platform.isAndroid ? null : DefaultFirebaseOptions.currentPlatform,
      );

      // await NotificationService.initialize();

      bool response = await splashController.initApplication();
      navigatorRoute(response);
    } catch (e) {
      if (!mounted) return;

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text("Erro ao iniciar o app"),
          content: Text("Erro ao configurar o aplicativo:\n\n$e"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                start(); // tentar novamente
              },
              child: const Text("Tentar novamente"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamedAndRemoveUntil("/login", (_) => false);
              },
              child: const Text("Ir para login"),
            ),
          ],
        ),
      );
    }
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: 200,
              ),
              const AppSpacing(),
              const AppSpacing(),
              AppProgressIndicator(colorItem: colorPrimary),
            ],
          ),
        ),
      ),
    );
  }
}
