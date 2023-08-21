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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController homeController = HomeController(StateApp.start, HomeRepository());

  @override
  void initState() {
    homeController.findNotices();
    homeController.findData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: width,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppSpacing(),
                CardWelcome(homeController: homeController),
                const CardNotice(),
                const AppSpacing(),
                CardCount(homeController: homeController),
                const AppSpacing(),
                AppActions(homeController: homeController),
                const AppSpacing(),
                const AppSpacing(),
                ValueListenableBuilder(
                    valueListenable: homeController.stateData,
                    builder: (context, value, child) {
                      return homeController.data!.accessTargeting == 3
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
                  valueListenable: homeController.stateNotices,
                  builder: (context, value, child) {
                    return Notices(
                      listItems: homeController.notices,
                      state: homeController.stateNotices,
                      title: S.of(context).text_notifications,
                      cardHeigth: 90,
                      cardWidth: 340,
                    );
                  },
                ),
                const AppSpacing(),
                ValueListenableBuilder(
                  valueListenable: homeController.stateData,
                  builder: (context, value, child) {
                    return value == StateApp.loading
                        ? LoadingList(loadingHeader: false)
                        : homeController.data!.accessTargeting == 2
                            ? LastRequests(
                                description: S.of(context).text_last_orders,
                                listItems: homeController.requestStores,
                                state: homeController.stateRequestsStore,
                              )
                            : Container();
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
