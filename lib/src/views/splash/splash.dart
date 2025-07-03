import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:profair/src/components/progress_indicator.dart';
import 'package:profair/src/components/spacing.dart';
import 'package:profair/src/controllers/splash_controller.dart';
import 'package:profair/src/notification/notification_service.dart';
import 'package:profair/src/repositories/login_repository.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      FirebaseMessaging messaging = FirebaseMessaging.instance;

      await NotificationService.initialize();

      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        final a = await messaging.getAPNSToken();

        print('APNS Token: $a');

        Timer(const Duration(seconds: 4), () {});

        String? fcmToken = await messaging.getToken();
        if (fcmToken != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('tokenFcm', fcmToken);
        }
      } else {
        print('Permissão de notificação negada pelo usuário.');
      }

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
