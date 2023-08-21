import 'package:profair/src/repositories/clients_product_repository.dart';
import 'package:profair/src/controllers/clients_product_controller.dart';
import 'package:profair/src/views/clients_product/components/list.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:profair/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ClientsProducts extends StatefulWidget {
  const ClientsProducts({super.key, required this.codeProduct});

  final int? codeProduct;

  @override
  State<ClientsProducts> createState() => _ClientsProductsState();
}

class _ClientsProductsState extends State<ClientsProducts> {
  final ClientsProductController clientsProductController = ClientsProductController(StateApp.start, ClientsProductRepository());

  @override
  void initState() {
    clientsProductController.findClientProduct(widget.codeProduct);
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
              valueListenable: clientsProductController.stateClientProduct,
              builder: (context, value, child) {
                return ComponentList(
                  description: S.of(context).text_select_branch,
                  state: clientsProductController.stateClientProduct,
                  listItems: clientsProductController.clientsProductList,
                  clientsProductController: clientsProductController,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
