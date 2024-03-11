import 'package:profair/src/utils/colors.dart';
import 'package:flutter/material.dart';

class AppProgressIndicator extends StatelessWidget {
  AppProgressIndicator({
    super.key,
    this.colorItem,
    this.size = 20,
  });

  Color? colorItem;
  double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        color: colorItem ?? colorSecondary,
        strokeWidth: 2,
      ),
    );
  }
}
