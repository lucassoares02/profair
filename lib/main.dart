import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:profair/firebase_options.dart';
import 'package:profair/src/app_module.dart';
import 'package:profair/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

Future<void> setupFirebaseNotifications() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // 1. Pedir permissão
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('Permissão de notificação concedida pelo usuário.');

    // 2. Tentar obter o token FCM
    // O método getToken() no iOS já aguarda internamente o token APNs.
    // A chamada explícita ao getAPNSToken() que você fez antes é uma boa prática
    // para debug, mas não estritamente necessária se a configuração estiver correta.
    String? fcmToken = await messaging.getToken();
    print('==========================================================');
    print('FCM Token (na inicialização): $fcmToken');
    print('==========================================================');

    if (fcmToken != null) {
      // Opcional: Salvar o token aqui para uso futuro sem precisar chamar o getToken novamente.
      // final prefs = await SharedPreferences.getInstance();
      // await prefs.setString('fcm_token', fcmToken);
    }
  } else {
    print('Permissão de notificação negada pelo usuário.');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: Platform.isAndroid ? null : DefaultFirebaseOptions.currentPlatform,
  );

  await setupFirebaseNotifications();

  runApp(ModularApp(
    module: AppModule(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    Modular.setInitialRoute('/splash');

    return MaterialApp.router(
      title: "profair",
      localizationsDelegates: const [
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        S.delegate,
      ],
      debugShowCheckedModeBanner: false,
      supportedLocales: S.delegate.supportedLocales,
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: "Plus",
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: "Plus",
        primarySwatch: Colors.blue,
      ),
      themeMode: ThemeMode.system,
      routerDelegate: Modular.routerDelegate,
      routeInformationParser: Modular.routeInformationParser,
    );
  }
}
