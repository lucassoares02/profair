import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart' as app_settings;
import 'package:profair/src/components/header_list.dart';
import 'package:profair/src/components/loading_list.dart';
import 'package:profair/src/notification/notification_model.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:profair/src/utils/count_hour.dart';
import 'package:profair/src/utils/count_hour_separated.dart';
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
    homeController.postTokenFcm(homeController.data!.userCode!.toString(), token.toString());

    await prefs.setString("tokenFcm", token.toString());

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {});
  }

  Future<void> _markAllAsRead() async {
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
  }

  Future<void> _openNotification(CustomNotification notification) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("tokenFcm");
    try {
      homeController.updateNotification({
        "notificationId": notification.id,
        "tokenFcm": token,
      });

      for (final n in homeController.notifications.where((n) => n.id == notification.id)) {
        n.viewed = 1; // Atualiza o estado local
      }

      homeController.findNotifications();

      if (!mounted) return;
      Navigator.of(context).pushNamed(
        "/detailsattraction",
        arguments: {"id": notification.id},
      );
    } catch (e) {
      print('Erro ao navegar para detalhes: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderList(label: "Notificações", activeSearch: false),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: homeController.stateNotifications,
                builder: (context, state, child) {
                  if (state == StateApp.loading) {
                    return LoadingList(loadingHeader: false);
                  }

                  final notifications = homeController.notifications;
                  final unread = notifications.where((n) => n.viewed == 0).length;
                  final showMarkAll = widget.notificationsPeding && unread > 0;

                  return ListView(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    children: [
                      _permissionBanner(),
                      _sectionHeader(unread: unread, showMarkAll: showMarkAll),
                      const SizedBox(height: 12),
                      if (notifications.isEmpty)
                        _emptyState()
                      else
                        ...notifications.map(_notificationCard),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Banner de permissão ─────────────────────────────────────────────────
  Widget _permissionBanner() {
    return FutureBuilder<NotificationSettings>(
      future: FirebaseMessaging.instance.getNotificationSettings(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();
        final status = snapshot.data!.authorizationStatus;
        if (status != AuthorizationStatus.denied && status != AuthorizationStatus.notDetermined) {
          return const SizedBox.shrink();
        }
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: colorRed.withValues(alpha: 0.08),
            border: Border.all(color: colorRed.withValues(alpha: 0.25)),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colorRed.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.notifications_off_rounded, color: colorRed, size: 20),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Notificações desativadas", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    SizedBox(height: 2),
                    Text(
                      "Ative para não perder as novidades do evento.",
                      style: TextStyle(fontSize: 12.5, color: colorGreyDark),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () => app_settings.openAppSettings(),
                style: TextButton.styleFrom(
                  backgroundColor: colorRed,
                  foregroundColor: colorWhite,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("Ativar", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              ),
            ],
          ),
        );
      },
    );
  }

  // ── Cabeçalho da seção ──────────────────────────────────────────────────
  Widget _sectionHeader({required int unread, required bool showMarkAll}) {
    return Row(
      children: [
        const Text("Recentes", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        if (unread > 0) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: colorSecondary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "$unread não lida${unread > 1 ? 's' : ''}",
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: colorSecondary),
            ),
          ),
        ],
        const Spacer(),
        if (showMarkAll)
          Material(
            color: colorSecondary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(40),
            child: InkWell(
              borderRadius: BorderRadius.circular(40),
              onTap: _markAllAsRead,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.done_all_rounded, size: 16, color: colorSecondary),
                    const SizedBox(width: 6),
                    const Text(
                      "Marcar todas",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: colorSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  // ── Card de notificação ─────────────────────────────────────────────────
  Widget _notificationCard(CustomNotification notification) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final surface = Theme.of(context).colorScheme.surface;
    final unread = notification.viewed == 0;
    final time = notification.method == 1
        ? countHour(notification.createdAt.toString())
        : countHourSeparet(notification.hour ?? 0, notification.minutes ?? 0);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: unread ? colorSecondary.withValues(alpha: 0.055) : surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: unread ? colorSecondary.withValues(alpha: 0.22) : onSurface.withValues(alpha: 0.08),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _openNotification(notification),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: unread ? colorSecondary.withValues(alpha: 0.14) : onSurface.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(
                    unread ? Icons.notifications_active_rounded : Icons.notifications_none_rounded,
                    size: 21,
                    color: unread ? colorSecondary : onSurface.withValues(alpha: 0.45),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title ?? "Sem título",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: unread ? FontWeight.bold : FontWeight.w600,
                                color: unread ? onSurface : onSurface.withValues(alpha: 0.75),
                              ),
                            ),
                          ),
                          if (unread) ...[
                            const SizedBox(width: 8),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(color: colorSecondary, shape: BoxShape.circle),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification.body ?? "",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.35,
                          color: onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.schedule_rounded, size: 13, color: onSurface.withValues(alpha: 0.4)),
                          const SizedBox(width: 4),
                          Text(
                            time,
                            style: TextStyle(fontSize: 11.5, color: onSurface.withValues(alpha: 0.5)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Estado vazio ────────────────────────────────────────────────────────
  Widget _emptyState() {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 72),
      child: Column(
        children: [
          Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              color: colorSecondary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.notifications_none_rounded, size: 40, color: colorSecondary.withValues(alpha: 0.7)),
          ),
          const SizedBox(height: 18),
          const Text("Nenhuma notificação", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(
            "Você está em dia! As novidades do\nevento vão aparecer aqui.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, height: 1.4, color: onSurface.withValues(alpha: 0.5)),
          ),
        ],
      ),
    );
  }
}
