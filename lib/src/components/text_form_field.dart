import 'package:profair/src/utils/colors.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:flutter/material.dart';

class AppTextFormField extends StatelessWidget {
  const AppTextFormField({super.key, this.label, this.type});

  final String? label;
  final TextInputType? type;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: type,
      cursorColor: colorGreyDark,
      decoration: InputDecoration(
        labelText: label,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(appRadius),
          borderSide: const BorderSide(color: colorPrimary, width: 2),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(appRadius),
          borderSide: const BorderSide(color: colorPrimary, width: 2),
        ),
      ),
    );
  }
}
