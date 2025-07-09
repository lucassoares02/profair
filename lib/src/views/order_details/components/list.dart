import 'package:profair/src/components/card_product.dart';
import 'package:profair/src/components/spacing.dart';
import 'package:profair/src/controllers/order_details_controller.dart';
import 'package:profair/src/controllers/trading_products_controller.dart';
import 'package:profair/src/repositories/order_details_model.dart';
import 'package:profair/src/repositories/requests_stores_model.dart';
import 'package:profair/src/repositories/trading_products_repository.dart';
import 'package:profair/src/state/state_app.dart';
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
  TradingProductsController tradingProductsController = TradingProductsController(StateApp.start, TradingProductsRepository());

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return StateManagement(
      width: width,
      listenable: widget.state,
      widgetLoading: LoadingList(
        icon: Icons.shopping_basket_rounded,
        label: 'Detalhes',
      ),
      component: Column(
        children: [
          HeaderList(
            icon: Icons.shopping_basket_rounded,
            aditionAction: Row(
              children: [
                IconButton(
                    onPressed: () {
                      tradingProductsController.exportData(widget.codeProvider, widget.order.codeNegotiation, widget.order.codeBranch);
                    },
                    icon: const Icon(
                      Icons.share_rounded,
                    ))
              ],
            ),
            onSearch: (String? value) {
              widget.orderDetailsController.search(value);
            },
            onSort: () {
              widget.orderDetailsController.sort();
            },
            label: "Detalhes",
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CardInfo(order: widget.order),
              ValueListenableBuilder(
                  valueListenable: widget.orderDetailsController.stateSearchProducts,
                  builder: (context, value, child) {
                    return Column(
                        children: widget.orderDetailsController.orderDetails.map((e) {
                      return CardProduct(
                          factor: e.coefficient!,
                          packing: e.packing!,
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
            ],
          )
        ],
      ),
    );
  }
}
