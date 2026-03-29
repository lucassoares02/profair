import 'package:flutter/material.dart';
import 'package:profair/src/utils/colors.dart';

class AppBadge extends StatelessWidget {
  const AppBadge({
    super.key,
    required this.child,
    this.borderRadius,
    this.color,
    this.padding,
  });

  final Widget? child;
  final Color? color;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: color ?? colorPrimary,
        borderRadius: BorderRadius.circular(borderRadius ?? 5),
      ),
      child: child,
    );
  }
}
