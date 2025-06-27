import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:profair/src/shared/http_service.dart';

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
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('ic_launcher_notification');

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _localNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        final payload = response.payload;
        if (payload != null) {
          await _handleNotificationClick(payload);
        }
      },
    );

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'Notificações Importantes',
      description: 'Este canal é usado para notificações importantes.',
      importance: Importance.high,
    );

    await _localNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      final notification = message.notification;
      final android = message.notification?.android;
      final String? imageUrl = android?.imageUrl;

      if (notification != null && android != null) {
        final bigPicture = imageUrl != null
            ? BigPictureStyleInformation(
                FilePathAndroidBitmap(await _downloadAndSaveFile(imageUrl, 'notif_image')),
                largeIcon: FilePathAndroidBitmap(await _downloadAndSaveFile(imageUrl, 'logo_thumb')),
                contentTitle: notification.title,
                summaryText: notification.body,
              )
            : null;

        await _localNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              styleInformation: bigPicture,
              largeIcon: FilePathAndroidBitmap(
                await _downloadAndSaveFile(imageUrl ?? "https://play-lh.googleusercontent.com/6FINLIOgGm5UN2MuqBIYnqhydb71JlO55aOG1ox_S7WtSGvo-72p5pWkL2OufnIjBbY=w240-h480-rw", 'logo_thumb'),
              ),
              importance: Importance.high,
              priority: Priority.high,
              icon: 'ic_launcher_notification',
            ),
          ),
          payload: "${message.data["notificationId"]} - ${message.data["userId"]}",
        );
      }
    });
  }

  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'profair_channel',
      'Notificações Profair',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails generalNotificationDetails = NotificationDetails(android: androidDetails);

    await _localNotificationsPlugin.show(
      id,
      title,
      body,
      generalNotificationDetails,
      payload: payload,
    );
  }

  static Future<void> _handleNotificationClick(Object payload) async {
    try {
      final response = await httpService.post("notification/opened", {"notification_id": payload});
      // final response = await http.post(
      //   Uri.parse('http://192.168.100.86:3001/notification/opened'),
      //   headers: {
      //     'Content-Type': 'application/json',
      //   },
      //   body: '{"notification_id": "$payload"}',
      // );
      print('Notificação marcada como aberta:');
    } catch (e) {
      print('Erro ao enviar notificação aberta: $e');
    }
  }
}
