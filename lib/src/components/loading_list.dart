import 'package:profair/src/components/header_list.dart';
import 'package:profair/src/components/spacing.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter/material.dart';

class LoadingList extends StatefulWidget {
  LoadingList({super.key, this.label, this.icon, this.loadingHeader = true, this.color, this.iconColor});

  String? label;
  IconData? icon;
  bool loadingHeader;
  Color? color;
  Color? iconColor;

  @override
  State<LoadingList> createState() => _LoadingListState();
}

class _LoadingListState extends State<LoadingList> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      child: Column(
        children: [
          if (widget.loadingHeader)
            HeaderList(
              color: widget.color,
              iconColor: widget.iconColor,
              icon: widget.icon,
              label: widget.label,
              activeSearch: false,
            ),
          ListView.builder(
              shrinkWrap: true,
              itemCount: 7,
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: appMargin, horizontal: appMargin),
                  margin: const EdgeInsets.symmetric(vertical: appMargin, horizontal: appMargin),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Skeletonizer(
                      effect: const ShimmerEffect(),
                      child: Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        child: SizedBox(
                          height: 12,
                          width: width / 1.5,
                        ),
                      ),
                    ),
                    const AppSpacing(),
                    Skeletonizer(
                      effect: const ShimmerEffect(),
                      child: Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        child: SizedBox(
                          height: 12,
                          width: width / 1.5,
                        ),
                      ),
                    ),
                    // Skeleton.replace(
                    //   style:
                    //       SkeletonAvatarStyle(height: 12, width: width / 1.5, borderRadius: BorderRadius.circular(10)),
                    // ),
                    // const AppSpacing(),
                    // SkeletonAvatar(
                    //   style: SkeletonAvatarStyle(height: 12, width: width / 3, borderRadius: BorderRadius.circular(10)),
                    // )
                  ]),
                );
              }),
        ],
      ),
    );
  }
}

class Tuple2 {}
