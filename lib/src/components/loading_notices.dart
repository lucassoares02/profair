import 'package:profair/src/utils/spacing.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter/material.dart';

class LoadingNotice extends StatefulWidget {
  LoadingNotice({super.key, this.cardHeigth, this.cardWidth});

  double? cardHeigth;
  double? cardWidth;

  @override
  State<LoadingNotice> createState() => _LoadingNoticeState();
}

class _LoadingNoticeState extends State<LoadingNotice> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Skeletonizer(
          effect: const ShimmerEffect(),
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              height: appPadding,
              width: width / 2,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 5),
          height: widget.cardHeigth ?? 300,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: 3,
              itemBuilder: (context, index) {
                return Skeletonizer(
                  effect: const ShimmerEffect(),
                  child: Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      height: widget.cardHeigth ?? 300,
                      width: widget.cardWidth ?? 200,
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }
}

class Tuple2 {}
