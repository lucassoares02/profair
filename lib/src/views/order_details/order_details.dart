import 'package:profair/src/controllers/order_details_controller.dart';
import 'package:profair/src/repositories/order_details_repository.dart';
import 'package:profair/src/repositories/requests_stores_model.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:profair/generated/l10n.dart';
import 'package:profair/src/views/order_details/components/list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OrderDetails extends StatefulWidget {
  const OrderDetails({super.key, required this.order});

  final RequestsStoresModel order;

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  final OrderDetailsController orderDetailsController =
      OrderDetailsController(StateApp.start, OrderDetailsRepository());

  @override
  void initState() {
    orderDetailsController.findOrderDetails(
        widget.order.codeBranch, widget.order.codeForn, widget.order.codeNegotiation);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(statusBarColor: colorSecondary),
        child: SafeArea(
          child: SingleChildScrollView(
            child: ValueListenableBuilder(
              valueListenable: orderDetailsController.stateProducts,
              builder: (context, value, child) {
                return ComponentList(
                  description: S.of(context).text_select_branch,
                  state: orderDetailsController.stateProducts,
                  codeProvider: widget.order.codeForn,
                  listItems: orderDetailsController.orderDetails,
                  orderDetailsController: orderDetailsController,
                  order: widget.order,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
