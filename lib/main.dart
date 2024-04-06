// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/services.dart';
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
        ),
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
      theme: ThemeData(fontFamily: 'Sf'),
      darkTheme: darkTheme,
      routerDelegate: Modular.routerDelegate,
      routeInformationParser: Modular.routeInformationParser,
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_modular/flutter_modular.dart';
// import 'package:profair/src/app_module.dart';
// import 'package:profair/src/components/button.dart';
// import 'package:profair/src/notification/notification_model.dart';
// import 'package:profair/src/notification/notification_service.dart';
// import 'package:provider/provider.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MultiProvider(
//       providers: [
//         Provider<NotificationService>(
//           create: (context) => NotificationService(),
//         ),
//       ],
//       child: ModularApp(
//         module: AppModule(),
//         child: MyApp(),
//       )));
// }

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

//   @override
//   void initState() {
//     super.initState();
//     print("Iniciando");
//     _firebaseMessaging.requestPermission();
//     _firebaseMessaging.getToken().then((token) {
//       print("FCM Token: $token");
//     });

//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print("onMessage: ${message.notification?.body}");
//       showNotification(message.notification?.title, message.notification?.body);
//     });

//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print("onMessageOpenedApp: ${message.notification?.body}");
//       showNotification(message.notification?.title, message.notification?.body);
//     });
//   }

//   showNotification(String? title, String? body) async {
//     try {
//       Provider.of<NotificationService>(context, listen: false).showNotification(
//         CustomNotification(
//           id: 1,
//           title: title,
//           body: body,
//           payload: "/home",
//         ),
//       );
//     } catch (e) {
//       print("Error Show Notification: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('FCM Example'),
//         ),
//         body: Center(
//           child: Column(
//             children: [
//               Text('Flutter with FCM'),
//               AppButton(
//                 onPressButton: () {
//                   showNotification("Teste", "Lucas");
//                 },
//                 label: "Notificação",
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
