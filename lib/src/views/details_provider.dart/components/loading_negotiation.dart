import 'package:flutter/material.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:skeletons/skeletons.dart';

class LoadingNegotiations extends StatelessWidget {
  const LoadingNegotiations({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10),
      height: 80,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: 6,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.only(left: 10),
              child: SkeletonAvatar(
                style: SkeletonAvatarStyle(height: 80, width: 80, borderRadius: BorderRadius.circular(appRadius)),
              ),
            );
          }),
    );
  }
}
