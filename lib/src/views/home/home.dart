import 'package:profair/provider/appwriter.dart';
import 'package:profair/src/components/loading_notices.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:profair/src/views/home/components/app_actions.dart';
import 'package:profair/src/views/home/components/card_count.dart';
import 'package:profair/src/views/home/components/card_notice.dart';
import 'package:profair/src/views/home/components/card_welcome.dart';
import 'package:profair/src/views/home/components/categories.dart';
import 'package:profair/src/views/home/components/last_requests.dart';
import 'package:profair/src/views/home/components/notices.dart';
import 'package:profair/src/views/home/home_controller.dart';
import 'package:profair/src/views/home/home_repository.dart';
import 'package:profair/src/components/loading_list.dart';
import 'package:profair/src/components/spacing.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:profair/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeController homeController = HomeController(StateApp.start, HomeRepository());
  AppWrite? appwrite;

  @override
  void initState() {
    appwrite = Provider.of<AppWrite>(context, listen: false);
    homeController.findData(appwrite!);
    testeAppwrite();

    super.initState();
  }

  testeAppwrite() async {
    homeController.findDoc(appwrite!);
    homeController.getNoticeAppWrite(appwrite!);
    // homeController.findAlert(appwrite!);
  }

  testeNewRequset() async {
    await homeController.findData(appwrite!);
    testeAppwrite();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: width,
          child: RefreshIndicator(
            onRefresh: () => testeNewRequset(),
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
                                padding: const EdgeInsets.symmetric(horizontal: appPadding, vertical: appMargin * 2),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SkeletonAvatar(
                                      style: SkeletonAvatarStyle(height: 15, width: width / 2, borderRadius: BorderRadius.circular(10)),
                                    ),
                                    const SizedBox(height: 10),
                                    SkeletonAvatar(
                                      style: SkeletonAvatarStyle(height: 10, width: width / 3, borderRadius: BorderRadius.circular(10)),
                                    ),
                                  ],
                                ),
                              )
                            : CardWelcome(
                                homeController: homeController,
                                action: () {
                                  testeNewRequset();
                                },
                              );
                      }),
                  ValueListenableBuilder(
                      valueListenable: homeController.stateNoticesAppWrite,
                      builder: (context, value, child) {
                        return value == StateApp.loading
                            ? Container(
                                margin: const EdgeInsets.symmetric(horizontal: appPadding),
                                child: SkeletonAvatar(
                                  style: SkeletonAvatarStyle(
                                    height: 300,
                                    width: double.maxFinite,
                                    borderRadius: BorderRadius.circular(appRadius),
                                  ),
                                ),
                              )
                            : CardNotice(homeController: homeController);
                      }),
                  const AppSpacing(),
                  CardCount(homeController: homeController),
                  const AppSpacing(),
                  AppActions(homeController: homeController),
                  const AppSpacing(),
                  const AppSpacing(),
                  ValueListenableBuilder(
                      valueListenable: homeController.stateData,
                      builder: (context, value, child) {
                        return value == StateApp.loading
                            ? LoadingList(loadingHeader: false)
                            : homeController.data!.accessTargeting == 3
                                ? Column(
                                    children: [
                                      Categories(homeController: homeController),
                                      const AppSpacing(),
                                      const AppSpacing(),
                                    ],
                                  )
                                : Container();
                      }),
                  ValueListenableBuilder(
                    valueListenable: homeController.stateData,
                    builder: (context, value, child) {
                      return value == StateApp.loading
                          ? LoadingNotice(cardHeigth: 90, cardWidth: 340)
                          : Notices(
                              homeController: homeController,
                              title: S.of(context).text_notifications,
                              cardHeigth: 90,
                              cardWidth: 340,
                            );
                    },
                  ),
                  const AppSpacing(),
                  Container(
                    padding: const EdgeInsets.only(left: appPadding, right: appPadding, bottom: appPadding),
                    child: ValueListenableBuilder(
                      valueListenable: homeController.stateData,
                      builder: (context, value, child) {
                        return value == StateApp.loading
                            ? LoadingList(loadingHeader: false)
                            : homeController.data!.accessTargeting == 1 || homeController.data!.accessTargeting == 2
                                ? LastRequests(
                                    description: S.of(context).text_last_orders,
                                    listItems: homeController.requestStores,
                                    state: homeController.stateRequestsStore,
                                  )
                                : Container();
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
