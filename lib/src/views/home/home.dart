import 'dart:async';
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:profair/src/notification/notification_service.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:profair/src/views/home/components/app_actions.dart';
import 'package:profair/src/views/home/components/card_count.dart';
import 'package:profair/src/views/home/components/card_notice.dart';
import 'package:profair/src/views/home/components/card_welcome.dart';
import 'package:profair/src/views/home/components/categories.dart';
import 'package:profair/src/views/home/components/last_requests.dart';
import 'package:profair/src/views/home/components/list_providers.dart';
import 'package:profair/src/views/home/home_controller.dart';
import 'package:profair/src/views/home/home_repository.dart';
import 'package:profair/src/components/loading_list.dart';
import 'package:profair/src/components/spacing.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeController homeController = HomeController(StateApp.start, HomeRepository());

  @override
  void initState() {
    super.initState();

    homeController.findData();
    homeController.findCampaign();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initFCM();
    });

    FirebaseMessaging.instance.onTokenRefresh.listen((String token) async {
      print('==========================================================');
      print('FCM Token Refresh: $token');
      print('==========================================================');

      homeController.postTokenFcm(homeController.data!.userCode!.toString(), token.toString());

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("tokenFcm", token.toString());
    });
  }

  reloadScreen() async {
    homeController.findData();
    homeController.findCampaign();
  }

  Future<void> _initFCM() async {
    final prefs = await SharedPreferences.getInstance();
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    await NotificationService.initialize();

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      String? fcmToken = await messaging.getToken();
      if (fcmToken != null) {
        final prefs = await SharedPreferences.getInstance();
        homeController.postTokenFcm(homeController.data!.userCode!.toString(), fcmToken);
        await prefs.setString('tokenFcm', fcmToken);
      }
    } else {
      print('Permissão de notificação negada pelo usuário.');
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      inspect(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    Brightness currentBrightness = MediaQuery.of(context).platformBrightness;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent, statusBarIconBrightness: currentBrightness == Brightness.light ? Brightness.dark : null),
        child: SafeArea(
          bottom: false,
          child: SizedBox(
            width: width,
            child: RefreshIndicator(
              onRefresh: () => reloadScreen(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppSpacing(),
                    ValueListenableBuilder(
                      valueListenable: homeController.stateData,
                      builder: (context, value, child) {
                        return value == StateApp.loading
                            ? Container(
                                padding: const EdgeInsets.only(top: appMargin * 2),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const AppSpacing(),
                                    Skeletonizer(
                                      effect: const ShimmerEffect(),
                                      child: Card(
                                        margin: const EdgeInsets.symmetric(horizontal: appPadding),
                                        child: SizedBox(
                                          width: width / 3,
                                          height: 10,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Skeletonizer(
                                      effect: const ShimmerEffect(),
                                      child: Card(
                                        margin: const EdgeInsets.symmetric(horizontal: appPadding),
                                        child: SizedBox(
                                          height: 15,
                                          width: width / 2,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    const Skeletonizer(
                                      effect: ShimmerEffect(),
                                      child: Card(
                                        margin: EdgeInsets.symmetric(horizontal: appPadding),
                                        child: SizedBox(
                                          height: 45,
                                          width: double.maxFinite,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: appPadding)
                                  ],
                                ),
                              )
                            : CardWelcome(
                                homeController: homeController,
                                action: () {
                                  reloadScreen();
                                },
                              );
                      },
                    ),
                    const AppSpacing(),
                    ValueListenableBuilder(
                        valueListenable: homeController.stateCampaign,
                        builder: (context, value, child) {
                          return value == StateApp.loading
                              ? const Skeletonizer(
                                  effect: ShimmerEffect(),
                                  child: Card(
                                    margin: EdgeInsets.symmetric(horizontal: appPadding),
                                    child: SizedBox(
                                      height: 240, // altura desejada pro esqueleto
                                      width: double.infinity,
                                    ),
                                  ),
                                )
                              : CardNotice(homeController: homeController);
                        }),
                    CardCount(homeController: homeController),
                    ValueListenableBuilder(
                      valueListenable: homeController.stateData,
                      builder: (context, value, child) {
                        return value == StateApp.loading
                            ? Container(
                                margin: const EdgeInsets.only(bottom: appPadding),
                                padding: const EdgeInsets.symmetric(horizontal: appPadding),
                                child: Row(
                                  children: [
                                    Skeletonizer(
                                      effect: const ShimmerEffect(),
                                      child: Card(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                                        margin: const EdgeInsets.only(bottom: appPadding, right: appPadding),
                                        child: const SizedBox(
                                          height: 70,
                                          width: 70,
                                        ),
                                      ),
                                    ),
                                    Skeletonizer(
                                      effect: const ShimmerEffect(),
                                      child: Card(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                                        margin: const EdgeInsets.only(bottom: appPadding, right: appPadding),
                                        child: const SizedBox(
                                          height: 70,
                                          width: 70,
                                        ),
                                      ),
                                    ),
                                    Skeletonizer(
                                      effect: const ShimmerEffect(),
                                      child: Card(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                                        margin: const EdgeInsets.only(bottom: appPadding, right: appPadding),
                                        child: const SizedBox(
                                          height: 70,
                                          width: 70,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : homeController.data!.accessTargeting == 3 || homeController.data!.accessTargeting == 1
                                ? Column(
                                    children: [
                                      AppActions(homeController: homeController),
                                      const AppSpacing(),
                                    ],
                                  )
                                : Container();
                      },
                    ),
                    const AppSpacing(),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed("reports", arguments: {
                          "accessTargeting": homeController.data!.accessTargeting,
                          "codeProvider": homeController.data!.accessTargeting == 2 ? homeController.data!.userCode : homeController.data!.codCompany
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: appMargin),
                        decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2), borderRadius: BorderRadius.circular(appRadius)),
                        padding: const EdgeInsets.all(appPadding * 1.1),
                        child: const Row(children: [
                          Icon(
                            Icons.bar_chart,
                          ),
                          AppSpacing(),
                          Text(
                            "Suas estastísticas no evento",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ]),
                      ),
                    ),
                    const AppSpacing(),
                    ValueListenableBuilder(
                        valueListenable: homeController.stateData,
                        builder: (context, value, child) {
                          return value == StateApp.loading
                              ? Padding(
                                  padding: const EdgeInsets.all(appPadding),
                                  child: LoadingList(loadingHeader: false),
                                )
                              : homeController.data!.accessTargeting == 3
                                  ? Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: appPadding, bottom: appPadding),
                                          child: Text(
                                            homeController.data!.accessTargeting == 3 ? "Carteiras" : "Consultores",
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: colorGreyDark),
                                          ),
                                        ),
                                        Categories(homeController: homeController),
                                        const AppSpacing(),
                                        const AppSpacing(),
                                      ],
                                    )
                                  : Container();
                        }),
                    Container(
                      margin: const EdgeInsets.only(bottom: appPadding),
                      child: ValueListenableBuilder(
                        valueListenable: homeController.stateData,
                        builder: (context, value, child) {
                          return value == StateApp.loading
                              ? LoadingList(loadingHeader: false)
                              : homeController.data!.accessTargeting == 2
                                  ? Column(
                                      children: [
                                        ListProviders(
                                          homeController: homeController,
                                          description: "Fornecedores",
                                        ),
                                        // const Divider(),
                                      ],
                                    )
                                  : Container();
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: appPadding, right: appPadding, bottom: appPadding),
                      child: ValueListenableBuilder(
                        valueListenable: homeController.stateData,
                        builder: (context, value, child) {
                          return value == StateApp.loading
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: appPadding),
                                  child: LoadingList(loadingHeader: false),
                                )
                              : homeController.data!.accessTargeting == 1 || homeController.data!.accessTargeting == 2
                                  ? LastRequests(
                                      description: "Últimos pedidos",
                                      listItems: homeController.requestStores,
                                      state: homeController.stateRequestsStore,
                                      homeController: homeController,
                                    )
                                  : Container();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
