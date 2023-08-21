import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:profair/src/components/spacing.dart';
import 'package:profair/src/controllers/reports_controller.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class CardPercentage extends StatefulWidget {
  CardPercentage({
    super.key,
    required this.reportsController,
    required this.title,
    this.content,
    required this.value,
    this.backgroundColor = colorSecondary,
    required this.footer,
  });

  ReportsController reportsController;
  String? title;
  String? content;
  String? value;
  String? footer;
  Color? backgroundColor;

  @override
  State<CardPercentage> createState() => _CardPercentageState();
}

class _CardPercentageState extends State<CardPercentage> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      padding: const EdgeInsets.all(appPadding),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(appRadius)),
        color: widget.backgroundColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${widget.title}",
            style: const TextStyle(
              fontSize: 18,
              color: colorWhite,
              fontWeight: FontWeight.bold,
            ),
          ),
          const AppSpacing(),
          if (widget.content != null)
            Text(
              "${widget.content}",
              style: const TextStyle(fontSize: 12, color: colorGreyLigth),
            ),
          const AppSpacing(),
          const AppSpacing(),
          ValueListenableBuilder(
              valueListenable: widget.reportsController.statePercentageClients,
              builder: (context, value, child) {
                return value == StateApp.loading
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SkeletonAvatar(
                            style: SkeletonAvatarStyle(
                              height: 20,
                              width: width,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          const AppSpacing(),
                          SkeletonAvatar(
                            style: SkeletonAvatarStyle(
                              height: 15,
                              width: 30,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LinearPercentIndicator(
                            animation: true,
                            trailing: Text(
                              "${widget.value}",
                              style: const TextStyle(color: colorWhite, fontSize: 12),
                            ),
                            animationDuration: 500,
                            padding: const EdgeInsets.only(right: 10),
                            lineHeight: 8.0,
                            barRadius: const Radius.circular(5),
                            percent: (double.parse("${widget.reportsController.percentageClients!.percentage}") / 100),
                            backgroundColor: Colors.white24,
                            progressColor: colorWhite,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "${widget.footer}",
                            style: const TextStyle(
                              fontSize: 12,
                              color: colorGreyLigth,
                            ),
                          ),
                        ],
                      );
              }),
        ],
      ),
    );
  }
}
