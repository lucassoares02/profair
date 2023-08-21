// ignore_for_file: depend_on_referenced_packages

import 'package:profair/src/notification/notification_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:profair/src/app_module.dart';
import 'package:profair/src/shared/themes/themes.dart';
import 'package:profair/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
      providers: [
        Provider<NotificationService>(
          create: (context) => NotificationService(),
        )
      ],
      child: ModularApp(
        module: AppModule(),
        child: const MyApp(),
      )));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
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
      theme: ThemeData(fontFamily: 'Sf'),
      darkTheme: darkTheme,
      routerDelegate: Modular.routerDelegate,
      routeInformationParser: Modular.routeInformationParser,
    );
  }
}
