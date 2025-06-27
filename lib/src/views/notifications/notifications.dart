import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart' as AppSettings;
import 'package:profair/src/components/header_list.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:profair/src/views/home/home_controller.dart';
import 'package:profair/src/views/home/home_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  HomeController homeController = HomeController(StateApp.start, HomeRepository());

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initFCM();
    });
  }

  Future<void> _initFCM() async {
    final prefs = await SharedPreferences.getInstance();

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    final settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('Permissão concedida');
    } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
      print('Permissão negada');
    } else if (settings.authorizationStatus == AuthorizationStatus.notDetermined) {
      print('Permissão não determinada');
    }

    String? token = await messaging.getToken();
    print('==========================================================');
    print('FCM Token: $token');
    print('==========================================================');

    homeController.postTokenFcm(homeController.data!.userCode!.toString(), token.toString());

    await prefs.setString("tokenFcm", token.toString());

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderList(label: "Notificações", activeSearch: false),
          FutureBuilder<NotificationSettings>(
            future: FirebaseMessaging.instance.getNotificationSettings(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const SizedBox.shrink();

              final settings = snapshot.data!;
              if (settings.authorizationStatus == AuthorizationStatus.denied || settings.authorizationStatus == AuthorizationStatus.notDetermined) {
                return Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Card(
                    color: Colors.red.withValues(alpha: 0.1),
                    child: ListTile(
                      leading: const Icon(Icons.warning, color: Colors.red),
                      title: const Text("Permissão de notificações"),
                      subtitle: const Text("Para receber notificações, ative as permissões"),
                      trailing: IconButton(
                        icon: const Icon(Icons.settings),
                        onPressed: () {
                          // Alternativas:
                          // 1. Fechar o app (como você usou com SystemNavigator.pop)
                          // 2. Abrir configurações do sistema (opcional)
                          AppSettings.openAppSettings();
                          // _initFCM();
                        },
                      ),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink(); // Não exibe nada se estiver autorizado
            },
          ),
        ],
      )),
    ));
  }
}
