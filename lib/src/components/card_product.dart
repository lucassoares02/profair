import 'package:flutter/material.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:profair/src/utils/spacing.dart';

class CardProduct extends StatefulWidget {
  CardProduct(
      {super.key,
      required this.description,
      required this.code,
      required this.brand,
      required this.complement,
      required this.price,
      required this.unitPrice,
      required this.amount,
      required this.total,
      required this.packing,
      required this.factor,
      this.barcode,
      this.visibleActions = true,
      this.highlight = false,
      this.tag,
      this.selected = false,
      this.onLongPress,
      this.action});

  String description;
  String code;
  String brand;
  String complement;
  String price;
  String unitPrice;
  String amount;
  String packing;
  int factor;
  String total;
  String? barcode;
  bool visibleActions;
  bool highlight;
  String? tag;
  bool selected;
  Function()? onLongPress;
  Function()? action;

  @override
  State<CardProduct> createState() => _CardProductState();
}

class _CardProductState extends State<CardProduct> {
  // Tons dourados para o destaque premium
  static const Color _gold = Color(0xFFE0A400);

  @override
  Widget build(BuildContext context) {
    final bool isHighlight = widget.highlight;
    final bool hasTag = widget.tag != null && widget.tag!.trim().isNotEmpty;
    final bool isSelected = widget.selected;

    BoxDecoration decoration;
    if (isSelected) {
      decoration = BoxDecoration(
        color: colorSecondary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(appRadius),
        border: Border.all(color: colorSecondary, width: 1.4),
      );
    } else if (isHighlight) {
      decoration = BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(appRadius),
        border: Border.all(color: _gold.withOpacity(0.55), width: 1.3),
        boxShadow: [
          BoxShadow(
            color: _gold.withOpacity(0.12),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      );
    } else {
      decoration = BoxDecoration(
        border: Border(bottom: BorderSide(color: colorGrey.withOpacity(0.3))),
      );
    }

    return InkWell(
      onTap: widget.action,
      onLongPress: widget.onLongPress,
      child: Container(
        padding: const EdgeInsets.all(appMargin),
        margin: const EdgeInsets.only(
            left: appMargin, right: appMargin, top: appMargin),
        decoration: decoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${widget.code} - ${widget.complement}",
                  style: const TextStyle(
                      color: colorGreyDark, fontWeight: FontWeight.w500),
                ),
                Text(
                  "${widget.packing} | ${widget.factor}",
                  style: const TextStyle(
                      color: colorGreyDark, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isSelected) ...[
                  const Icon(Icons.check_circle_rounded,
                      size: 18, color: colorSecondary),
                  const SizedBox(width: 4),
                ] else if (isHighlight) ...[
                  const Icon(Icons.star_rounded, size: 18, color: _gold),
                  const SizedBox(width: 4),
                ],
                Expanded(
                  child: Text(
                    widget.description,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                  decoration: BoxDecoration(
                      color: colorGreen.withOpacity(0.5),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  child: Text(
                    widget.brand,
                    style: const TextStyle(
                        color: colorWhite, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(width: 5),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                  decoration: BoxDecoration(
                      color: colorBlue.withOpacity(0.5),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  child: Text(
                    widget.unitPrice,
                    style: const TextStyle(
                        color: colorWhite, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(width: 5),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                  decoration: const BoxDecoration(
                      color: colorBlue,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Text(
                    widget.price,
                    style: const TextStyle(
                        color: colorWhite, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(width: 5),
              ],
            ),
            const SizedBox(height: 20),
            if (widget.visibleActions)
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  "Quantidade: ",
                                  style: TextStyle(
                                      color: colorGreyDark,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  widget.amount,
                                  style: const TextStyle(
                                      color: colorGreyDark,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (hasTag) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 7),
                                decoration: BoxDecoration(
                                  color: colorSecondary.withValues(alpha: 0.1),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(6)),
                                  border: Border.all(
                                      color: colorSecondary.withValues(
                                          alpha: 0.25)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.local_offer_outlined,
                                        color: colorSecondary, size: 10),
                                    const SizedBox(width: 3),
                                    Text(
                                      widget.tag!,
                                      style: const TextStyle(
                                          color: colorSecondary,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 10),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                            ],
                            Text(
                              widget.total,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
          ],
        ),
      ),
    );
  }
}
