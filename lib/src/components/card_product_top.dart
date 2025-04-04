import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:profair/src/utils/spacing.dart';

class CardProductTop extends StatefulWidget {
  CardProductTop(
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
      required this.negotiation,
      required this.barcode,
      required this.position,
      this.color = colorPrimary,
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
  int position;
  Color? color;
  String total;
  String? barcode;
  String? negotiation;
  bool visibleActions;
  Function()? action;

  @override
  State<CardProductTop> createState() => _CardProductTopState();
}

class _CardProductTopState extends State<CardProductTop> {
  List<Color> topProductColors = [
    Colors.amber, // 🥇 1º - Ouro (Destaque máximo)
    Colors.grey, // 🥈 2º - Prata (Destaque forte)
    Colors.brown, // 🥉 3º - Bronze (Reconhecimento)
  ];

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.action,
      child: Container(
        padding: const EdgeInsets.only(bottom: appPadding * 2),
        margin: const EdgeInsets.only(top: appPadding),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: colorGrey.withOpacity(0.3))),
        ),
        child: Row(
          children: [
            // Container(
            //   width: 70,
            //   height: 70,
            //   decoration: BoxDecoration(
            //       color: colorWhite,
            //       borderRadius: BorderRadius.circular(
            //         appRadius,
            //       )),
            //   padding: const EdgeInsets.all(appPadding / 3),
            //   margin: const EdgeInsets.only(right: appMargin, left: appMargin),
            //   child: CachedNetworkImage(
            //     imageUrl: widget.barcode != null ? 'http://www.eanpictures.com.br:9000/api/gtin/${widget.barcode}' : '',
            //     width: 70,
            //     fit: BoxFit.cover,
            //     errorWidget: (context, url, error) => const Icon(Icons.error),
            //   ),
            // ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${widget.code} - ${widget.complement} ",
                      style: const TextStyle(color: colorGreyDark, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "${widget.packing} | ${widget.factor} - Negociação: ${widget.negotiation}",
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                          margin: const EdgeInsets.only(right: 5),
                          decoration: BoxDecoration(
                            color: widget.position == 0 || widget.position == 1 || widget.position == 2 ? topProductColors[widget.position] : widget.color,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: Text(
                            "${widget.position + 1}º ${widget.position <= 2 ? 'lugar' : ''} ",
                            style: const TextStyle(color: colorWhite, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                          decoration: BoxDecoration(
                            border: Border.all(color: colorGreen.withOpacity(0.5), width: 1),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: Text(
                            widget.brand,
                            style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w500),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                          decoration: BoxDecoration(
                            border: Border.all(color: colorBlue.withOpacity(0.5), width: 1),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: Text(
                            widget.unitPrice,
                            style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w500),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                          decoration: BoxDecoration(
                            border: Border.all(color: colorPrimary.withOpacity(0.5), width: 1),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: Text(
                            widget.price,
                            style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w500),
                          ),
                        ),
                        const SizedBox(width: 5),
                      ],
                    ),
                    // const Icon(
                    //   Icons.trending_up,
                    //   color: colorGrey,
                    // )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
