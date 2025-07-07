import 'dart:developer';
import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:profair/src/shared/http_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

final httpService = HttpService();

Future<String> _downloadAndSaveFile(String url, String fileName) async {
  final directory = await getApplicationDocumentsDirectory();
  final filePath = '${directory.path}/$fileName';
  final response = await http.get(Uri.parse(url));
  final file = File(filePath);
  await file.writeAsBytes(response.bodyBytes);
  return filePath;
}

class NotificationService {
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    try {
      log('[NotificationService] Inicializando…');

      const androidInit = AndroidInitializationSettings('ic_launcher_notification');
      const iosInit = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const initSettings = InitializationSettings(
        android: androidInit,
        iOS: iosInit,
      );

      await _localNotificationsPlugin.initialize(
        initSettings,
        onDidReceiveNotificationResponse: (response) {
          final payload = response.payload;
          if (payload != null) {
            log('[NotificationService] Clique em notificação local: $payload');
            handleNotificationClick(payload);
          }
        },
      );

      const channel = AndroidNotificationChannel(
        'high_importance_channel',
        'Notificações Importantes',
        description: 'Canal para notificações importantes.',
        importance: Importance.high,
      );

      await _localNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);

      FirebaseMessaging.onMessage.listen(_onMessageForeground);

      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        log('[NotificationService] App aberto via onMessageOpenedApp: ${message.data}');
        if (message.data.isNotEmpty) {
          handleNotificationClick(_buildPayload(message.data));
        }
      });

      RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

      if (initialMessage != null && initialMessage.data.isNotEmpty) {
        log('[NotificationService] App iniciado via getInitialMessage: ${initialMessage.data}');
        handleNotificationClick(_buildPayload(initialMessage.data));
      }

      log('[NotificationService] Inicializado com sucesso.');
    } catch (e, s) {
      log('[NotificationService] Erro na inicialização', error: e, stackTrace: s);
    }
  }

  static void _onMessageForeground(RemoteMessage message) async {
    log('[NotificationService] Notificação em foreground recebida: ${message.data}');

    final notification = message.notification;

    final String title = message.data['title'] ?? notification?.title ?? 'Notificação Profair';
    final String body = message.data['body'] ?? notification?.body ?? 'Abra e veja mais detalhes.';
    final String? imageUrl = message.data['imageUrl'];

    try {
      NotificationDetails details;

      if (imageUrl != null && imageUrl.isNotEmpty) {
        log('[NotificationService] Baixando imagem: $imageUrl');
        final bigPicPath = await _downloadAndSaveFile(imageUrl, 'notif_image');
        final largeIconPath = await _downloadAndSaveFile(imageUrl, 'logo_thumb');

        details = NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'Notificações Importantes',
            channelDescription: 'Canal para notificações importantes.',
            styleInformation: BigPictureStyleInformation(
              FilePathAndroidBitmap(bigPicPath),
              largeIcon: FilePathAndroidBitmap(largeIconPath),
              contentTitle: title,
              summaryText: body,
            ),
            importance: Importance.high,
            priority: Priority.high,
            icon: 'ic_launcher_notification',
          ),
          iOS: const DarwinNotificationDetails(),
        );
      } else {
        log('[NotificationService] Nenhuma imagem enviada, exibindo notificação simples.');
        details = const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'Notificações Importantes',
            importance: Importance.high,
            priority: Priority.high,
            icon: 'ic_launcher_notification',
          ),
          iOS: DarwinNotificationDetails(),
        );
      }

      await _localNotificationsPlugin.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title,
        body,
        details,
        payload: _buildPayload(message.data),
      );

      log('[NotificationService] Notificação exibida com sucesso.');
    } catch (e, s) {
      log('[NotificationService] Erro ao exibir notificação', error: e, stackTrace: s);
    }
  }

  static String _buildPayload(Map<String, dynamic> data) {
    return "${data['notificationId']}|${data['provider']}|${data['direct']}";
  }

  static Future<void> handleNotificationClick(String? payload) async {
    if (payload == null || payload.isEmpty) {
      log('[NotificationService] Payload inválido: $payload');
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("tokenFcm");
    final direct = prefs.getString("direct");
    final codeBranch = prefs.getString("company");

    if (token == null || token.isEmpty) {
      log('[NotificationService] Token FCM não encontrado nos SharedPreferences');
      return;
    }

    List<String> payloadParts = payload.split('|');
    final notificationId = payloadParts[0];
    final provider = payloadParts[1];
    final directFromPayload = payloadParts[2];

    log('[NotificationService] Payload recebido => id: $notificationId, provider: $provider, direct: $directFromPayload');

    try {
      await httpService.post(
        "notification/opened",
        {
          "notificationId": notificationId,
          "tokenFcm": token,
        },
      );

      if (provider.isNotEmpty) {
        final response = await httpService.get('providerdetails/$provider');

        if (directFromPayload == "2" && direct == "2") {
          log('[NotificationService] Navegando para detalhes do provedor $provider');

          Modular.to.pushNamed(
            "detailsprovider",
            arguments: {
              "imageProvider": response.data["image"],
              "color": response.data["color"],
              "nameProvider": response.data["nomeForn"],
              "codeBranch": int.parse(codeBranch!),
              "codeProvider": int.parse(provider),
            },
          );
        } else {
          Modular.to.pushNamed(
            "detailsattraction",
            arguments: {
              "id": int.parse(notificationId),
            },
          );
        }
      }

      log('[NotificationService] Notificação marcada como aberta com sucesso.');
    } catch (e, s) {
      log('[NotificationService] Erro ao processar clique na notificação', error: e, stackTrace: s);
    }
  }
}
