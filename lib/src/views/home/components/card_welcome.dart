import 'package:profair/src/components/progress_indicator.dart';
import 'package:profair/src/components/spacing.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:profair/src/views/home/home_controller.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:profair/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class CardWelcome extends StatefulWidget {
  CardWelcome({super.key, required this.homeController});

  HomeController homeController;

  @override
  State<CardWelcome> createState() => _CardWelcomeState();
}

class _CardWelcomeState extends State<CardWelcome> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    bool valor = false;

    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed('profile');
      },
      child: Container(
        margin: const EdgeInsets.only(top: appPadding),
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(appRadius),
        ),
        padding: const EdgeInsets.all(appPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ValueListenableBuilder(
                valueListenable: widget.homeController.stateData,
                builder: (context, value, child) {
                  return value == StateApp.loading
                      ? SkeletonAvatar(
                          style: SkeletonAvatarStyle(height: 15, width: width / 2, borderRadius: BorderRadius.circular(10)),
                        )
                      : Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ' ${widget.homeController.data!.nameUser}',
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  ' ${widget.homeController.data!.nameCompany}',
                                  style: const TextStyle(fontSize: 16, color: colorGreyDark),
                                ),
                              ],
                            ),
                          ],
                        );
                }),
            // Stack(
            //   children: [
            //     const Icon(Icons.face, size: 30),
            //     Positioned(
            //       right: 0,
            //       child: Container(
            //         decoration: const BoxDecoration(shape: BoxShape.circle, color: colorPrimary),
            //         width: appRadius / 1.5,
            //         height: appRadius / 1.5,
            //       ),
            //     ),
            //   ],
            // )
          ],
        ),
      ),
    );
  }
}
