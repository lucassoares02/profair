import 'package:profair/src/controllers/products_provider.dart';
import 'package:profair/src/repositories/products_provider_model.dart';
import 'package:profair/src/views/home/state_management.dart';
import 'package:profair/src/components/loading_list.dart';
import 'package:profair/src/components/header_list.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:profair/src/utils/format_currency.dart';
import 'package:profair/generated/l10n.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ComponentList extends StatefulWidget {
  ComponentList({super.key, this.description, required this.listItems, required this.state, required this.codeProvider, required this.productsProviderController});

  Iterable<ProductsProviderModel> listItems;
  final String? description;
  final ValueListenable state;
  final int? codeProvider;
  final ProductsProviderController productsProviderController;

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
      widgetLoading: LoadingList(icon: Icons.shopping_basket_rounded, label: S.of(context).text_avaiable_products),
      component: Column(
        children: [
          HeaderList(
            icon: Icons.shopping_basket_rounded,
            onSearch: (String? value) {
              widget.productsProviderController.search(value);
            },
            label: S.of(context).text_avaiable_products,
          ),
          ValueListenableBuilder(
              valueListenable: widget.productsProviderController.stateSearchProducts,
              builder: (context, value, child) {
                return Column(
                    children: widget.productsProviderController.productsProvider.map((e) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        "/clientsproduct",
                        arguments: e.codeProduct,
                      );
                    },
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
                            e.nameProduct!.length < 28 ? '${e.nameProduct}' : "${e.nameProduct!.substring(0, 25)}...",
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          const SizedBox(height: appMargin),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${e.packing} | ${e.coefficient}',
                                style: const TextStyle(color: colorGreyDark),
                              ),
                              Text(
                                // '${e.totalVolume} | R\$ ${e.totalValue}',
                                '${e.totalVolume ?? 0} | R\$ ${formatCurrency(e.totalValue!)}',
                                style: TextStyle(color: (e.totalVolume != "0") ? colorGreyDark : colorGrey, fontWeight: FontWeight.bold),
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
