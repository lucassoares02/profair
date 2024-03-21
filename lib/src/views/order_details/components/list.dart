import 'package:profair/src/components/card_product.dart';
import 'package:profair/src/components/spacing.dart';
import 'package:profair/src/controllers/order_details_controller.dart';
import 'package:profair/src/repositories/order_details_model.dart';
import 'package:profair/src/repositories/requests_stores_model.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:profair/src/views/order_details/components/card_info.dart';
import 'package:profair/src/views/home/state_management.dart';
import 'package:profair/src/components/loading_list.dart';
import 'package:profair/src/components/header_list.dart';
import 'package:profair/src/utils/format_currency.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ComponentList extends StatefulWidget {
  ComponentList({
    super.key,
    this.description,
    required this.listItems,
    required this.state,
    required this.codeProvider,
    required this.orderDetailsController,
    required this.order,
  });

  List<OrderDetailsModel> listItems;
  final String? description;
  final ValueListenable state;
  final int? codeProvider;
  final OrderDetailsController orderDetailsController;
  final RequestsStoresModel order;

  @override
  State<ComponentList> createState() => _ComponentListState();
}

class _ComponentListState extends State<ComponentList> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return StateManagement(
      width: width,
      listenable: widget.state,
      widgetLoading: LoadingList(
        icon: Icons.shopping_basket_rounded,
        label: 'Detalhes do pedido',
      ),
      component: Column(
        children: [
          HeaderList(
            icon: Icons.shopping_basket_rounded,
            onSearch: (String? value) {
              widget.orderDetailsController.search(value);
            },
            onSort: () {
              widget.orderDetailsController.sort();
            },
            label: "Detalhes do pedido",
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppSpacing(),
              CardInfo(order: widget.order),
              Container(
                margin: const EdgeInsets.all(appMargin),
                decoration:
                    BoxDecoration(color: Colors.grey.withOpacity(0.05), borderRadius: BorderRadius.circular(appRadius)),
                child: ValueListenableBuilder(
                    valueListenable: widget.orderDetailsController.stateSearchProducts,
                    builder: (context, value, child) {
                      return Column(
                          children: widget.orderDetailsController.orderDetails.map((e) {
                        return CardProduct(
                            description: e.title!,
                            code: e.codeProduct.toString(),
                            brand: e.brand!,
                            complement: e.complement!,
                            price: formatCurrency(e.price!),
                            unitPrice: formatCurrency(e.unitPrice!),
                            amount: e.amount!,
                            total: formatCurrency(e.total!),
                            action: () {});
                      }).toList());
                    }),
              ),
            ],
          )
        ],
      ),
    );
  }
}
