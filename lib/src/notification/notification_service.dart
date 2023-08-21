import 'package:profair/src/app_module.dart';
import 'package:profair/src/notification/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class NotificationService {
  late FlutterLocalNotificationsPlugin localNotificationsPlugin;
  late AndroidNotificationDetails androidDetails;

  NotificationService() {
    localNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _setupNotifications();
  }

  _setupNotifications() async {
    await _setupTimezone();
    await _initializeNotifications();
  }

  Future<void> _setupTimezone() async {
    tz.initializeTimeZones();
    final String? timeZoneName = (await FlutterNativeTimezone.getAvailableTimezones()) as String?;
    tz.setLocalLocation(tz.getLocation(timeZoneName!));
  }

  _initializeNotifications() async {
    const android = AndroidInitializationSettings("@mipmap/ic_launcher");

    await localNotificationsPlugin.initialize(
      const InitializationSettings(
        android: android,
      ),
      onDidReceiveNotificationResponse: _onSelectNotification,
    );
  }

  _onSelectNotification(NotificationResponse? payload) {
    if (payload != null) {
      Navigator.of(AppModule.navigatorKey!.currentContext!).pushReplacementNamed("${payload.payload}");
    }
  }

  showNotification(CustomNotification notification) {
    androidDetails = const AndroidNotificationDetails(
      "lembretes_notification_x",
      "Lembretes",
      channelDescription: "Este canal é para lembrete",
      importance: Importance.max,
      icon: "@mipmap/ic_launcher",
      priority: Priority.max,
      enableVibration: true,
    );

    localNotificationsPlugin.show(
        notification.id,
        notification.title,
        notification.body,
        NotificationDetails(
          android: androidDetails,
        ),
        payload: notification.payload);
  }

  checkForNotification() async {
    final details = await localNotificationsPlugin.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {
      _onSelectNotification(details.notificationResponse);
    }
  }
}
