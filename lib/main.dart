import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:profair/src/app_module.dart';
import 'package:profair/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  Modular.setInitialRoute('/splash');

  runApp(ModularApp(
    module: AppModule(),
    child: const MyApp(),
  )
      // )
      );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      builder: (context, child) {
        return MediaQuery(data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)), child: child!);
      },
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
