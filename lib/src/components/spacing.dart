import 'package:profair/src/utils/spacing.dart';
import 'package:flutter/material.dart';

class AppSpacing extends StatelessWidget {
  const AppSpacing({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: appPadding,
      width: appPadding,
    );
  }
}
