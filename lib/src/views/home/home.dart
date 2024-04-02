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
import 'package:profair/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeController homeController = HomeController(StateApp.start, HomeRepository());

  @override
  void initState() {
    homeController.findData();
    homeController.findCampaign();
    super.initState();
  }

  reloadScreen() async {
    await homeController.findData();
    homeController.findCampaign();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
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
                                padding: const EdgeInsets.symmetric(horizontal: appPadding, vertical: appMargin * 2),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SkeletonAvatar(
                                      style: SkeletonAvatarStyle(
                                          height: 15, width: width / 2, borderRadius: BorderRadius.circular(10)),
                                    ),
                                    const SizedBox(height: 10),
                                    SkeletonAvatar(
                                      style: SkeletonAvatarStyle(
                                          height: 10, width: width / 3, borderRadius: BorderRadius.circular(10)),
                                    ),
                                  ],
                                ),
                              )
                            : CardWelcome(
                                homeController: homeController,
                                action: () {
                                  reloadScreen();
                                },
                              );
                      }),
                  ValueListenableBuilder(
                      valueListenable: homeController.stateCampaign,
                      builder: (context, value, child) {
                        return value == StateApp.loading
                            ? Container(
                                margin: const EdgeInsets.symmetric(horizontal: appPadding),
                                child: SkeletonAvatar(
                                  style: SkeletonAvatarStyle(
                                    height: 240,
                                    width: double.maxFinite,
                                    borderRadius: BorderRadius.circular(appRadius),
                                  ),
                                ),
                              )
                            : CardNotice(homeController: homeController);
                      }),
                  CardCount(homeController: homeController),
                  const AppSpacing(),
                  ValueListenableBuilder(
                      valueListenable: homeController.stateData,
                      builder: (context, value, child) {
                        return value == StateApp.loading
                            ? LoadingList(loadingHeader: false)
                            : homeController.data!.accessTargeting == 3 || homeController.data!.accessTargeting == 1
                                ? Column(
                                    children: [
                                      AppActions(homeController: homeController),
                                      const AppSpacing(),
                                    ],
                                  )
                                : Container();
                      }),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed("reports", arguments: {
                        "accessTargeting": homeController.data!.accessTargeting,
                        "codeProvider": homeController.data!.accessTargeting == 2
                            ? homeController.data!.userCode
                            : homeController.data!.codCompany
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.all(appMargin),
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2), borderRadius: BorderRadius.circular(appRadius)),
                      padding: const EdgeInsets.all(appPadding * 1.1),
                      child: const Row(children: [
                        Icon(
                          Icons.bar_chart,
                        ),
                        AppSpacing(),
                        Text(
                          "Acompanhe suas estastísticas no evento",
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
                            ? LoadingList(loadingHeader: false)
                            : homeController.data!.accessTargeting == 3
                                ? Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: appPadding, bottom: appPadding),
                                        child: Text(
                                          homeController.data!.accessTargeting == 3 ? "Carteiras" : "Consultores",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold, fontSize: 16, color: colorGreyDark),
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
                                      const AppSpacing(),
                                      const Divider(),
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
