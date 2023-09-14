import 'package:appwrite/models.dart';
import 'package:profair/src/components/loading_notices.dart';
import 'package:profair/src/components/spacing.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:profair/src/views/home/home_controller.dart';

class Notices extends StatefulWidget {
  const Notices({
    super.key,
    this.cardWidth,
    this.cardHeigth,
    this.title,
    required this.homeController,
  });

  final String? title;
  final double? cardWidth;
  final double? cardHeigth;
  final HomeController homeController;

  @override
  State<Notices> createState() => _NoticesState();
}

class _NoticesState extends State<Notices> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: widget.homeController.stateAlert,
        builder: (context, value, child) {
          return value == StateApp.loading
              ? LoadingNotice(cardHeigth: 90, cardWidth: 340)
              : Column(
                  children: [
                    if (widget.title != null)
                      Container(
                        padding: const EdgeInsets.only(left: appPadding, right: appPadding, bottom: appMargin),
                        child: Row(
                          children: [
                            Text(
                              '${widget.title}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: colorGreyDark),
                            )
                          ],
                        ),
                      ),
                    SizedBox(
                      height: widget.cardHeigth ?? 300,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: widget.homeController.alerts!.total,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                // Navigator.of(context).pushNamed('detailsrecipe', arguments: widget.listItems[index]);
                              },
                              child: Container(
                                width: widget.cardWidth ?? 200,
                                decoration: BoxDecoration(
                                  color: colorGrey.withOpacity(0.5),
                                  borderRadius: const BorderRadius.all(Radius.circular(appRadius)),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: appMargin / 1.7),
                                margin: EdgeInsets.only(left: appPadding, right: (widget.homeController.alerts!.total - 1 == index) ? appPadding : 0),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 5,
                                      height: double.maxFinite,
                                      decoration: BoxDecoration(
                                        color: widget.homeController.alerts!.documents[index].data["priority"] == 5
                                            ? colorRed
                                            : widget.homeController.alerts!.documents[index].data["priority"] == 4
                                                ? colorTertiary
                                                : colorGreyDark,
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(appRadius),
                                          bottomLeft: Radius.circular(appRadius),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: appMargin),
                                    Container(
                                      width: 60,
                                      height: 60,
                                      // padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: widget.homeController.alerts!.documents[index].data["priority"] == 5
                                            ? colorRed
                                            : widget.homeController.alerts!.documents[index].data["priority"] == 4
                                                ? colorTertiary
                                                : colorGreyDark,
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(50),
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.notifications_none_rounded,
                                        color: colorWhite,
                                        size: 30,
                                      ),
                                    ),
                                    const AppSpacing(),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${widget.homeController.alerts!.documents[index].data["title"]}',
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                          ),
                                          Text(
                                            '${widget.homeController.alerts!.documents[index].data["description"]}',
                                            style: const TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                  ],
                );
        });
  }
}
