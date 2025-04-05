import 'package:profair/src/controllers/clients_product_controller.dart';
import 'package:profair/src/repositories/products_provider_model.dart';
import 'package:profair/src/utils/format_currency.dart';
import 'package:profair/src/views/home/state_management.dart';
import 'package:profair/src/components/loading_list.dart';
import 'package:profair/src/components/header_list.dart';
import 'package:profair/src/models/clients_product_model.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:profair/generated/l10n.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ComponentList extends StatefulWidget {
  ComponentList({super.key, this.product, required this.listItems, required this.state, required this.clientsProductController});

  Iterable<ClientsProductModel> listItems;
  final ProductsProviderModel? product;
  final ValueListenable state;
  final ClientsProductController clientsProductController;

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
      widgetLoading: LoadingList(icon: Icons.shopping_cart_checkout_rounded, label: "Clientes Solicitantes"),
      component: Column(
        children: [
          HeaderList(
            icon: Icons.shopping_cart_checkout_rounded,
            onSearch: (String? value) {
              widget.clientsProductController.search(value);
            },
            label: "Clientes Solicitantes",
          ),
          ValueListenableBuilder(
              valueListenable: widget.clientsProductController.stateSearchClientProduct,
              builder: (context, value, child) {
                return Column(
                    children: widget.clientsProductController.clientsProductList.map((e) {
                  return InkWell(
                    onTap: () {},
                    child: Container(
                      width: width,
                      height: 90,
                      padding: const EdgeInsets.all(appMargin),
                      margin: const EdgeInsets.symmetric(horizontal: appMargin),
                      decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: colorGrey)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${e.codeClient}- ${e.nameClient!}",
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${e.coefficient} ${e.packing}',
                                style: TextStyle(
                                  color: (e.totalValue != "0") ? colorGreyDark : colorGrey,
                                ),
                              ),
                              Text(
                                formatCurrency(e.totalValue!),
                                style: const TextStyle(color: colorGreyDark, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList());
              })
        ],
      ),
    );
  }
}
