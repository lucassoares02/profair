import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:profair/src/components/spacing.dart';
import 'package:profair/src/controllers/reports_controller.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CardPercentage extends StatefulWidget {
  CardPercentage({
    super.key,
    required this.reportsController,
    required this.title,
    this.content,
    required this.value,
    this.backgroundColor = colorBlueDark,
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
  bool visibleContent = false;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () {
        setState(() {
          visibleContent = !visibleContent;
        });
      },
      child: Container(
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
            if (visibleContent)
              Column(
                children: [
                  const AppSpacing(),
                  if (widget.content != null)
                    Text(
                      "${widget.content}",
                      style: const TextStyle(fontSize: 16, color: colorWhite),
                    ),
                  const AppSpacing(),
                ],
              ),
            const AppSpacing(),
            ValueListenableBuilder(
                valueListenable: widget.reportsController.statePercentageClients,
                builder: (context, value, child) {
                  return value == StateApp.loading
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Skeletonizer(
                              effect: const ShimmerEffect(),
                              child: Card(
                                margin: const EdgeInsets.symmetric(horizontal: 16),
                                child: SizedBox(
                                  height: 20,
                                  width: width,
                                ),
                              ),
                            ),
                            const AppSpacing(),
                            const Skeletonizer(
                              effect: ShimmerEffect(),
                              child: Card(
                                margin: EdgeInsets.symmetric(horizontal: 16),
                                child: SizedBox(
                                  height: 15,
                                  width: 30,
                                ),
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
                                "${double.parse(widget.value.toString()).toStringAsFixed(0)}%",
                                style: const TextStyle(color: colorWhite, fontSize: 12),
                              ),
                              animationDuration: 500,
                              padding: const EdgeInsets.only(right: 10),
                              lineHeight: visibleContent ? 8 : 10,
                              barRadius: const Radius.circular(5),
                              percent: (double.parse("${widget.value}") / 100),
                              backgroundColor: Colors.white24,
                              progressColor: colorWhite,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "${widget.footer}",
                              style: const TextStyle(
                                fontSize: 12,
                                color: colorWhite,
                              ),
                            ),
                          ],
                        );
                }),
          ],
        ),
      ),
    );
  }
}
