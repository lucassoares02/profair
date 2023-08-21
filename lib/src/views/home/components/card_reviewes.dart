import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:profair/generated/l10n.dart';
import 'package:flutter/material.dart';

class CardReviewes extends StatefulWidget {
  const CardReviewes({super.key});

  @override
  State<CardReviewes> createState() => _CardReviewesState();
}

class _CardReviewesState extends State<CardReviewes> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed('profile');
      },
      child: Container(
        margin: const EdgeInsets.only(top: appPadding),
        decoration: const BoxDecoration(color: colorWhite, borderRadius: BorderRadius.all(Radius.circular(appRadius))),
        width: width,
        padding: const EdgeInsets.all(appPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Avaliações",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: const [
                    Text(
                      "Ordenar por mais relevantes",
                      style: TextStyle(fontSize: 10, color: colorGreyDark),
                    ),
                    Icon(Icons.keyboard_arrow_down_rounded, size: appPadding, color: colorGreyDark)
                  ],
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.star_rate_rounded,
                      size: 24,
                      color: colorTertiary,
                    ),
                    Text(
                      "4,6",
                      style: TextStyle(color: colorTertiary, fontSize: 24, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "345 avaliações",
                      style: TextStyle(fontSize: 10, color: colorGreyDark),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
