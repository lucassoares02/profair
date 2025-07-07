import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart' as AppSettings;
import 'package:profair/src/components/header_list.dart';
import 'package:profair/src/components/loading_list.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:profair/src/utils/count_hour.dart';
import 'package:profair/src/utils/count_hour_separated.dart';
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

    homeController.findNotifications();
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

    String? token = await FirebaseMessaging.instance.getToken();
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
        body: SafeArea(
      child: SingleChildScrollView(
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
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.red.withValues(alpha: 0.1),
                        border: Border.all(
                          color: Colors.red.withValues(alpha: 0.9),
                        ),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.warning, color: Colors.red),
                        title: const Text("Permissão de notificações"),
                        subtitle: const Text("Não perca as novidades do evento, ative as notificações!"),
                        trailing: IconButton(
                          icon: const Icon(Icons.settings_outlined),
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
            ValueListenableBuilder(
              valueListenable: homeController.stateNotifications,
              builder: (context, stateNotifications, child) {
                return stateNotifications == StateApp.loading
                    ? LoadingList(loadingHeader: false)
                    : Column(
                        children: homeController.notifications.map((notification) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Container(
                            child: ListTile(
                              shape: Border(
                                bottom: BorderSide(
                                  color: Colors.grey.withValues(alpha: 0.1),
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(vertical: 10),
                              title: Text(notification.title ?? "Sem título"),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(notification.body!.length > 40 ? "${notification.body!.substring(0, 40)}..." : notification.body!),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        notification.method == 1 ? countHour(notification.createdAt.toString()) : countHourSeparet(notification.hour!, notification.minutes!),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              onTap: () {
                                try {
                                  Navigator.of(context).pushNamed(
                                    "/detailsattraction",
                                    arguments: {
                                      "id": notification.id,
                                    },
                                  );
                                } catch (e) {
                                  print('Erro ao navegar para detalhes: $e');
                                }
                              },
                            ),
                          ),
                        );
                      }).toList());
              },
            ),
          ],
        ),
      ),
    ));
  }
}
