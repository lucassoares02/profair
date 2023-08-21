import 'package:profair/src/components/header_list.dart';
import 'package:profair/src/components/spacing.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:skeletons/skeletons.dart';
import 'package:flutter/material.dart';

class LoadingList extends StatefulWidget {
  LoadingList({super.key, this.label, this.icon, this.loadingHeader = true});

  String? label;
  IconData? icon;
  bool loadingHeader;

  @override
  State<LoadingList> createState() => _LoadingListState();
}

class _LoadingListState extends State<LoadingList> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        if (widget.loadingHeader)
          HeaderList(
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
                  SkeletonAvatar(
                    style: SkeletonAvatarStyle(height: 12, width: width / 1.5, borderRadius: BorderRadius.circular(10)),
                  ),
                  const AppSpacing(),
                  SkeletonAvatar(
                    style: SkeletonAvatarStyle(height: 12, width: width / 3, borderRadius: BorderRadius.circular(10)),
                  )
                ]),
              );
            }),
      ],
    );
  }
}

class Tuple2 {}
