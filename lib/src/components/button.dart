import 'package:profair/src/components/progress_indicator.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton({super.key, this.label, this.type, this.colorButton, this.iconButton, required this.onPressButton, this.loading = false, this.colorLoading});

  final String? label;
  final String? type;
  final Color? colorButton;
  final IconData? iconButton;
  final Function()? onPressButton;
  final bool loading;
  final Color? colorLoading;

  @override
  Widget build(BuildContext context) {
    final witdh = MediaQuery.of(context).size.width;
    const SizedBox marginWidget = SizedBox(width: appMargin);

    return SizedBox(
      height: 50,
      width: witdh,
      child: TextButton(
          onPressed: loading ? null : onPressButton,
          style: ElevatedButton.styleFrom(
            backgroundColor: type == 'filled' ? transparent : colorButton ?? colorPrimary,
            foregroundColor: type == 'filled' ? colorGrey : colorWhite,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(appRadius),
              side: BorderSide(color: type == 'filled' ? colorButton ?? colorPrimary : transparent, width: 2),
            ),
          ),
          child: loading
              ? Center(child: AppProgressIndicator(colorItem: colorLoading))
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      iconButton,
                      color: type == 'filled'
                          ? colorButton ?? colorSecondary
                          : colorButton != colorWhite
                              ? colorWhite
                              : colorSecondary,
                    ),
                    if (iconButton != null) marginWidget,
                    Text(
                      '$label',
                      style: TextStyle(
                        color: type == 'filled'
                            ? colorButton ?? colorSecondary
                            : colorButton != colorWhite
                                ? colorWhite
                                : colorSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )),
    );
  }
}
