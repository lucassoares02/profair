import 'package:profair/src/controllers/clients_product_controller.dart';
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
  ComponentList({super.key, this.description, required this.listItems, required this.state, required this.clientsProductController});

  Iterable<ClientsProductModel> listItems;
  final String? description;
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
      widgetLoading: LoadingList(icon: Icons.shopping_cart_checkout_rounded, label: S.of(context).text_requesting_customers),
      component: Column(
        children: [
          HeaderList(
            icon: Icons.shopping_cart_checkout_rounded,
            onSearch: (String? value) {
              widget.clientsProductController.search(value);
            },
            label: S.of(context).text_requesting_customers,
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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            e.nameClient!.length < 28 ? '${e.nameClient}' : "${e.nameClient!.substring(0, 25)}...",
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          const SizedBox(height: appMargin),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'R\$ ${e.totalValue}',
                                style: const TextStyle(color: colorGreyDark),
                              ),
                              Text(
                                '${e.coefficient} | ${e.packing}',
                                style: TextStyle(color: (e.totalValue != "0") ? colorGreyDark : colorGrey, fontWeight: FontWeight.bold),
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
