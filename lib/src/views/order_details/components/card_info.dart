import 'package:flutter/material.dart';
import 'package:profair/src/components/spacing.dart';
import 'package:profair/src/repositories/requests_stores_model.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:profair/src/utils/format_currency.dart';
import 'package:profair/src/utils/spacing.dart';

class CardInfo extends StatelessWidget {
  const CardInfo({
    super.key,
    required this.order,
  });

  final RequestsStoresModel order;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: appPadding),
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.05),
            // border: Border.all(color: Colors.grey),
            // borderRadius: BorderRadius.circular(appRadius),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: appPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        overflow: TextOverflow.fade,
                        order.nameForn!,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                    const Icon(Icons.verified, color: colorBlue, size: 20),
                  ],
                ),
              ),
              const Divider(),
              const AppSpacing(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Cliente",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          order.razaoClient!,
                        ),
                      ],
                    ),
                    const AppSpacing(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Negociação",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${order.codeNegotiation} - ${order.descriptionNegotiation!}",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const AppSpacing(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Responsável",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(order.nameClient!),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Horário",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(order.hour!),
                      ],
                    ),
                  ],
                ),
              ),
              const AppSpacing(),
              const Divider(),
              Padding(
                padding: const EdgeInsets.only(bottom: appPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total:",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      formatCurrency(order.value!),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: appPadding, left: appPadding, right: appPadding),
          child: Text(
            "Mercadorias",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 16),
          ),
        )
      ],
    );
  }
}
