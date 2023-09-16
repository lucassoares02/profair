import 'package:flutter/material.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:profair/src/views/details_provider.dart/details_provider_controller.dart';

class ListNegotiations extends StatefulWidget {
  const ListNegotiations({super.key, required this.detailsProviderController});

  final DetailsProviderController detailsProviderController;

  @override
  State<ListNegotiations> createState() => _ListNegotiationsState();
}

class _ListNegotiationsState extends State<ListNegotiations> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: widget.detailsProviderController.negotiations.map((e) {
        return Container(
          width: 200,
          padding: const EdgeInsets.all(appPadding),
          // margin: EdgeInsets.only(right: index == widget.detailsProviderController.negotiations.length - 1 ? appMargin : 0),
          decoration: const BoxDecoration(
            color: colorSecondary,
            borderRadius: BorderRadius.all(
              Radius.circular(appRadius),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.handshake_outlined,
                color: colorWhite,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                '${e.negotiation}',
                style: const TextStyle(
                  color: colorWhite,
                  fontSize: 12,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                e.title!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: colorWhite,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
