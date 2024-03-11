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
      this.visibleActions = true,
      this.action});

  String description;
  String code;
  String brand;
  String complement;
  String price;
  String unitPrice;
  String amount;
  String total;
  bool visibleActions;
  Function()? action;

  @override
  State<CardProduct> createState() => _CardProductState();
}

class _CardProductState extends State<CardProduct> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.action,
      child: Container(
        padding: const EdgeInsets.all(appMargin),
        margin: const EdgeInsets.only(left: appMargin, right: appMargin, top: appMargin),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: colorGrey)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${widget.code} - ${widget.complement}",
              style: const TextStyle(color: colorGreyDark, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 5),
            Text(
              widget.description,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 5),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                  decoration: BoxDecoration(
                      color: colorGreen.withOpacity(0.5), borderRadius: const BorderRadius.all(Radius.circular(10))),
                  child: Text(
                    widget.brand,
                    style: const TextStyle(color: colorWhite, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(width: 5),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                  decoration: BoxDecoration(
                      color: colorBlue.withOpacity(0.5), borderRadius: const BorderRadius.all(Radius.circular(10))),
                  child: Text(
                    widget.unitPrice,
                    style: const TextStyle(color: colorWhite, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(width: 5),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                  decoration:
                      const BoxDecoration(color: colorBlue, borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Text(
                    widget.price,
                    style: const TextStyle(color: colorWhite, fontWeight: FontWeight.w500),
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
                                  style: TextStyle(color: colorGreyDark, fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  widget.amount,
                                  style: const TextStyle(color: colorGreyDark, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Text(
                          widget.total,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
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
