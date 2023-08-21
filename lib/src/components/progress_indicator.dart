import 'package:profair/src/utils/colors.dart';
import 'package:flutter/material.dart';

class AppProgressIndicator extends StatelessWidget {
  AppProgressIndicator({super.key, this.colorItem});

  Color? colorItem;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(
        color: colorItem ?? colorSecondary,
        strokeWidth: 2,
      ),
    );
  }
}
