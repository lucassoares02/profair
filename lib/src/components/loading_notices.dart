import 'package:profair/src/utils/spacing.dart';
import 'package:skeletons/skeletons.dart';
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
        Container(
            margin: const EdgeInsets.only(left: appPadding, bottom: appMargin),
            child: SkeletonLine(
              style: SkeletonLineStyle(width: width / 2, height: 15, borderRadius: const BorderRadius.all(Radius.circular(10))),
            )),
        Container(
          margin: const EdgeInsets.only(left: 5),
          height: widget.cardHeigth ?? 300,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: 3,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(left: appMargin, right: appPadding, top: appMargin),
                  child: SkeletonAvatar(
                    style: SkeletonAvatarStyle(
                      height: widget.cardHeigth ?? 300,
                      width: widget.cardWidth ?? 200,
                      borderRadius: BorderRadius.circular(appRadius),
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
