import 'package:firebase_core/firebase_core.dart';
import 'package:profair/src/components/progress_indicator.dart';
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
    initApp();
  }

  // initApp() async {
  //   bool response = await splashController.initApplication();
  //   navigatorRoute(response);
  // }

  initApp() async {
    try {
      await Firebase.initializeApp();
      await NotificationService.initialize();

      bool response = await splashController.initApplication();
      navigatorRoute(response);
    } catch (e) {
      debugPrint("Erro na inicialização: $e");

      if (!mounted) return;

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text("Erro ao iniciar o app"),
          content: Text("Ocorreu um erro ao inicializar o aplicativo:\n\n$e"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                initApp(); // tentar novamente
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
