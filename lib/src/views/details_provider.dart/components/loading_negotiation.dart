import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
            return const Skeletonizer(
              effect: ShimmerEffect(),
              child: Card(
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  height: 80,
                  width: 80,
                ),
              ),
            );
          }),
    );
  }
}
