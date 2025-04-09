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
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: colorGrey.withOpacity(0.3))),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Container(
            //   width: 80,
            //   height: 80,
            //   decoration: const BoxDecoration(
            //     borderRadius: BorderRadius.all(Radius.circular(appRadius)),
            //   ),
            //   child: Image.network(
            //     "http://www.eanpictures.com.br:9000/api/gtin/${widget.barcode}",
            //     fit: BoxFit.cover,
            //   ),
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${widget.code} - ${widget.complement}",
                  style: const TextStyle(color: colorGreyDark, fontWeight: FontWeight.w500),
                ),
                Text(
                  "${widget.packing} | ${widget.factor}",
                  style: const TextStyle(color: colorGreyDark, fontWeight: FontWeight.w500),
                ),
              ],
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
                  decoration: BoxDecoration(color: colorGreen.withOpacity(0.5), borderRadius: const BorderRadius.all(Radius.circular(10))),
                  child: Text(
                    widget.brand,
                    style: const TextStyle(color: colorWhite, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(width: 5),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                  decoration: BoxDecoration(color: colorBlue.withOpacity(0.5), borderRadius: const BorderRadius.all(Radius.circular(10))),
                  child: Text(
                    widget.unitPrice,
                    style: const TextStyle(color: colorWhite, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(width: 5),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                  decoration: const BoxDecoration(color: colorBlue, borderRadius: BorderRadius.all(Radius.circular(10))),
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
