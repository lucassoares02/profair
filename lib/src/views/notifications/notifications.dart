import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart' as AppSettings;
import 'package:profair/src/components/header_list.dart';
import 'package:profair/src/components/loading_list.dart';
import 'package:profair/src/notification/notification_user_model.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:profair/src/utils/count_hour.dart';
import 'package:profair/src/utils/count_hour_separated.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:profair/src/views/home/home_controller.dart';
import 'package:profair/src/views/home/home_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Notifications extends StatefulWidget {
  Notifications({
    super.key,
    required this.notificationsPeding,
  });

  final bool notificationsPeding;

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
                builder: (context, stateNoti, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (widget.notificationsPeding! && homeController.notifications.any((notification) => notification.viewed == 0))
                        InkWell(
                          onTap: () async {
                            await homeController.sendCheckNotificationsUser();
                            await homeController.findNotifications();
                            Fluttertoast.showToast(
                              msg: "Todas as notificações marcadas como lidas.",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(left: appPadding),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              border: Border.all(color: colorSecondary.withValues(alpha: .9), width: 1),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: appPadding, vertical: appPadding / 2),
                            child: const Text(
                              "Marcar todas como lidas",
                              style: TextStyle(color: colorSecondary, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                    ],
                  );
                }),
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
                              contentPadding: const EdgeInsets.symmetric(vertical: 10),
                              title: Row(
                                children: [
                                  if (notification.viewed == 0)
                                    Row(
                                      children: [
                                        Container(
                                          width: 9,
                                          height: 9,
                                          decoration: const BoxDecoration(
                                            color: Colors.red,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                      ],
                                    ),
                                  Text(
                                    notification.title ?? "Sem título",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: notification.viewed != 0 ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7) : Theme.of(context).colorScheme.onSurface,
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    notification.body!.length > 40 ? "${notification.body!.substring(0, 40)}..." : notification.body!,
                                    style: TextStyle(
                                      color: notification.viewed != 0 ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6) : Theme.of(context).colorScheme.onSurface,
                                    ),
                                  ),
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
                              onTap: () async {
                                final prefs = await SharedPreferences.getInstance();
                                final token = prefs.getString("tokenFcm");
                                try {
                                  homeController.updateNotification({
                                    "notificationId": notification.id,
                                    "tokenFcm": token,
                                  });

                                  homeController.notifications.where((n) => n.id == notification.id).forEach((n) {
                                    n.viewed = 1; // Atualiza o estado local
                                  });

                                  homeController.findNotifications();

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
