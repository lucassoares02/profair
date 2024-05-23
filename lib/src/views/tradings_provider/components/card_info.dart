import 'package:profair/src/utils/colors.dart';
import 'package:profair/src/utils/fonts.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:flutter/material.dart';

class CardInfo extends StatefulWidget {
  const CardInfo({super.key, this.description, this.body, this.clean});

  final String? description;
  final Widget? body;
  final bool? clean;

  @override
  State<CardInfo> createState() => _CardInfoState();
}

class _CardInfoState extends State<CardInfo> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: (widget.clean == null) ? appPadding : 0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.description != null)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: (widget.clean == null) ? 0 : appPadding),
              child: Text(widget.description ?? '', style: textTitleCard),
            ),
          Container(
            width: width,
            padding: EdgeInsets.all(widget.clean == null ? appPadding : 0),
            margin: const EdgeInsets.symmetric(vertical: appMargin),
            decoration: BoxDecoration(
              color: widget.clean == null ? colorLight : Colors.transparent,
              borderRadius: BorderRadius.circular(appRadius),
            ),
            child: widget.body ?? Container(),
          ),
        ],
      ),
    );
  }
}
