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
                if (homeController.data!.accessTargeting == 3)
                  Column(
                    children: [
                      Categories(homeController: homeController),
                      const AppSpacing(),
                      const AppSpacing(),
                    ],
                  ),
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


// Container(
//                   width: double.maxFinite,
//                   padding: EdgeInsets.all(appPadding),
//                   margin: EdgeInsets.all(appMargin),
//                   decoration: BoxDecoration(
//                     border: Border.all(color: colorGrey),
//                     borderRadius: BorderRadius.all(
//                       Radius.circular(appRadius),
//                     ),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Container(
//                         decoration: BoxDecoration(border: Border(bottom: BorderSide(color: colorGrey))),
//                         padding: EdgeInsets.symmetric(vertical: appMargin),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               "Teste de lyaout",
//                               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
//                             ),
//                             Text(
//                               "Novo",
//                               style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green),
//                             ),
//                           ],
//                         ),
//                       ),
//                       AppSpacing(),
//                       Container(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text("10 de Janeiro de 2024"),
//                             SizedBox(height: 10),
//                             Text(
//                               "Hoje é 10 de janeiro, estamos realizando teste desse layhout, parece que tudo está indo bem!",
//                               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
//                             ),
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                 ),