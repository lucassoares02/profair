import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:profair/src/models/login_model.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:profair/src/views/home/home_controller.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CardWelcome extends StatefulWidget {
  CardWelcome({super.key, required this.homeController, required this.action});

  HomeController homeController;
  Function()? action;

  @override
  State<CardWelcome> createState() => _CardWelcomeState();
}

class _CardWelcomeState extends State<CardWelcome> {
  String? selectedItem;

  @override
  void initState() {
    selectedItem = widget.homeController.data!.nameCompany;
    super.initState();
  }

  Future<void> moduleSharedPreferences(String description, String item) async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    try {
      if ((item.isNotEmpty || item != "null") && description.isNotEmpty) {
        await sharedPreferences.setString(description, item);
      }
    } catch (e) {
      debugPrint("Error saving to SharedPreferences: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      margin: const EdgeInsets.all(appPadding),
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(appRadius),
        // color: Colors.grey[200],
      ),
      // padding: const EdgeInsets.all(appPadding),
      child: ValueListenableBuilder(
          valueListenable: widget.homeController.stateData,
          builder: (context, value, child) {
            return value == StateApp.loading
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Skeletonizer(
                        effect: const ShimmerEffect(),
                        child: Card(
                          child: SizedBox(
                            height: 15,
                            width: width / 2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Skeletonizer(
                        effect: const ShimmerEffect(),
                        child: Card(
                          child: SizedBox(
                            height: 10,
                            width: width / 3,
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // const AppSpacing(),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  "ticket",
                                  arguments: widget.homeController,
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Seja Bem-vindo!',
                                    style: TextStyle(fontSize: 16, color: Colors.grey),
                                  ),
                                  Text(
                                    '${widget.homeController.data!.nameUser}',
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          ValueListenableBuilder(
                              valueListenable: widget.homeController.stateNotificationsPending,
                              builder: (context, value, child) {
                                return InkWell(
                                  onTap: () async {
                                    // widget.homeController.sendCheckNotificationsUser();
                                    Navigator.of(context).pushNamed(
                                      "/notifications",
                                      arguments: widget.homeController.notificationsPeding.isNotEmpty,
                                    );
                                  },
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      const SizedBox(
                                        width: 40,
                                        height: 40,
                                        child: Icon(Icons.notifications),
                                      ),
                                      if (widget.homeController.notificationsPeding.isNotEmpty)
                                        Positioned(
                                          top: 12,
                                          right: 22,
                                          child: Container(
                                            width: 9,
                                            height: 9,
                                            decoration: const BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                );
                              })
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Stack(
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                widget.homeController.moreData!.length > 1
                                    ? Container(
                                        padding: const EdgeInsets.symmetric(horizontal: appMargin),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).colorScheme.onSurface.withValues(
                                                alpha: 0.1,
                                              ),
                                          borderRadius: BorderRadius.circular(appRadius),
                                        ),
                                        child: DropdownButton<LoginModel>(
                                          borderRadius: const BorderRadius.all(Radius.circular(appRadius)),
                                          underline: Container(color: Colors.transparent),
                                          isExpanded: true,
                                          icon: const Icon(Icons.keyboard_arrow_down_sharp, size: 25),
                                          hint: Text(
                                            "${widget.homeController.data!.codCompany} - ${widget.homeController.data!.nameCompany!.length > 35 ? "${widget.homeController.data!.nameCompany!.substring(0, 35)}..." : widget.homeController.data!.nameCompany!}",
                                            style: TextStyle(color: Theme.of(context).colorScheme.onBackground, fontWeight: FontWeight.w500),
                                          ),
                                          value: widget.homeController.moreData![widget.homeController.indexSelected],
                                          items: widget.homeController.moreData!.map((e) {
                                            return DropdownMenuItem<LoginModel>(
                                              value: e,
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  const Icon(
                                                    Icons.business_rounded,
                                                    size: 25,
                                                    color: colorGreyDark,
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Text(
                                                    e.nameCompany!.length > 30 ? "${e.nameCompany!.substring(0, 30)}..." : e.nameCompany!,
                                                    style: const TextStyle(fontWeight: FontWeight.w600),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            int indexSelected = widget.homeController.moreData!.indexOf(value!);
                                            widget.homeController.indexSelected = indexSelected;
                                            setState(() {
                                              selectedItem = value.nameCompany;
                                            });
                                            widget.action!();
                                            moduleSharedPreferences("company", "${value.codCompany}");
                                          },
                                        ),
                                      )
                                    : Container(
                                        width: double.maxFinite,
                                        padding: const EdgeInsets.symmetric(horizontal: appMargin, vertical: appPadding),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).colorScheme.onSurface.withValues(
                                                alpha: 0.1,
                                              ),
                                          borderRadius: BorderRadius.circular(appRadius),
                                        ),
                                        child: Text(
                                          '${widget.homeController.data!.codCompany} - ${widget.homeController.data!.nameCompany}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Theme.of(context).colorScheme.onBackground,
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
          }),
    );
  }
}
