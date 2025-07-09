import 'package:permission_handler/permission_handler.dart';
import 'package:profair/src/components/progress_indicator.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:flutter/material.dart';

class SpecialButton extends StatelessWidget {
  SpecialButton({super.key, this.label, this.state, this.type, this.colorButton, this.iconButton, required this.onPressButton, this.loading = false, this.colorLoading});

  final String? label;
  final String? type;
  final Color? colorButton;
  final IconData? iconButton;
  final Function()? onPressButton;
  final bool loading;
  final Color? colorLoading;
  StateApp? state;

  @override
  Widget build(BuildContext context) {
    final witdh = MediaQuery.of(context).size.width;
    const SizedBox marginWidget = SizedBox(width: 3);

    return Flexible(
      flex: 1,
      child: SizedBox(
        height: 50,
        child: TextButton(
            onPressed: loading ? null : onPressButton,
            style: ElevatedButton.styleFrom(
              backgroundColor: type == 'filled' ? transparent : colorButton ?? colorPrimary,
              foregroundColor: type == 'filled' ? colorGrey : colorWhite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(appRadius),
                side: BorderSide(color: type == 'filled' ? colorButton ?? colorPrimary : transparent, width: 1),
              ),
            ),
            child: loading
                ? Center(child: AppProgressIndicator(colorItem: colorLoading))
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        state == StateApp.error ? Icons.error_outline : iconButton,
                        color: type == 'filled'
                            ? colorButton ?? colorSecondary
                            : colorButton != colorWhite
                                ? colorWhite
                                : colorSecondary,
                      ),
                      if (iconButton != null) marginWidget,
                      Text(
                        state == StateApp.error ? 'Tentar novamente' : '$label',
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
      ),
    );
  }
}
