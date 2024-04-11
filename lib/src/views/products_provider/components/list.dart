import 'package:fluttertoast/fluttertoast.dart';
import 'package:profair/src/components/card_product.dart';
import 'package:profair/src/controllers/products_provider.dart';
import 'package:profair/src/repositories/products_provider_model.dart';
import 'package:profair/src/views/home/state_management.dart';
import 'package:profair/src/components/loading_list.dart';
import 'package:profair/src/components/header_list.dart';
import 'package:profair/src/utils/format_currency.dart';
import 'package:profair/generated/l10n.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ComponentList extends StatefulWidget {
  ComponentList({
    super.key,
    this.description,
    required this.listItems,
    required this.state,
    required this.codeProvider,
    required this.productsProviderController,
    required this.nextScreen,
  });

  List<ProductsProviderModel> listItems;
  final String? description;
  final ValueListenable state;
  final int? codeProvider;
  final ProductsProviderController productsProviderController;
  final bool nextScreen;

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
            onSort: () {
              widget.productsProviderController.sort();
            },
            label: S.of(context).text_avaiable_products,
          ),
          ValueListenableBuilder(
              valueListenable: widget.productsProviderController.stateSearchProducts,
              builder: (context, value, child) {
                return Column(
                    children: widget.productsProviderController.productsProvider.map((e) {
                  return CardProduct(
                      description: e.nameProduct!,
                      code: e.codeProduct.toString(),
                      brand: e.brand!,
                      packing: e.packing!,
                      factor: e.coefficient!,
                      complement: e.complement!,
                      price: formatCurrency(e.productPrice!),
                      unitPrice: formatCurrency(e.unitPrice!),
                      amount: e.totalVolume!,
                      total: formatCurrency(e.totalValue!),
                      action: () {
                        if (widget.nextScreen) {
                          if (e.totalVolume != "0") {
                            Navigator.of(context).pushNamed(
                              "/clientsproduct",
                              arguments: e,
                            );
                          } else {
                            Fluttertoast.showToast(
                                msg: "Produto não possui pedidos!",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                        }
                      });

                  //     InkWell(
                  //       onTap: () {
                  //         if (widget.nextScreen) {
                  //           if (e.totalVolume != "0") {
                  //             Navigator.of(context).pushNamed(
                  //               "/clientsproduct",
                  //               arguments: e.codeProduct,
                  //             );
                  //           } else {
                  //             Fluttertoast.showToast(
                  //                 msg: "Produto não possui pedidos!",
                  //                 toastLength: Toast.LENGTH_SHORT,
                  //                 gravity: ToastGravity.CENTER,
                  //                 timeInSecForIosWeb: 1,
                  //                 backgroundColor: Colors.red,
                  //                 textColor: Colors.white,
                  //                 fontSize: 16.0);
                  //           }
                  //         }
                  //       },
                  //       child: Container(
                  //         width: width,
                  //         padding: const EdgeInsets.symmetric(horizontal: appMargin, vertical: appPadding),
                  //         margin: const EdgeInsets.symmetric(horizontal: appMargin),
                  //         decoration: const BoxDecoration(
                  //           border: Border(bottom: BorderSide(color: colorGrey)),
                  //         ),
                  //         child: Column(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //           children: [
                  //             Row(
                  //               children: [
                  //                 Container(
                  //                   width: 4,
                  //                   height: 40,
                  //                   decoration: BoxDecoration(
                  //                     color: e.totalVolume != "0" ? colorSecondary : colorGreyLigth,
                  //                     borderRadius: const BorderRadius.all(Radius.circular(appRadius)),
                  //                   ),
                  //                 ),
                  //                 // Container(
                  //                 //   decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.all(Radius.circular(50))),
                  //                 //   width: 50,
                  //                 //   child: Image.network("https://gifs.eco.br/wp-content/uploads/2023/05/imagens-de-agua-mineral-png-0.png"),
                  //                 // ),
                  //                 const SizedBox(width: 10),
                  //                 Column(
                  //                   crossAxisAlignment: CrossAxisAlignment.start,
                  //                   children: [
                  //                     Text(
                  //                       // e.nameProduct!.length < 35 ? '${e.nameProduct}' : "${e.nameProduct!.substring(0, 35)}...",
                  //                       "${e.nameProduct}",
                  //                       style: const TextStyle(fontWeight: FontWeight.bold),
                  //                     ),
                  //                     const SizedBox(height: 8),
                  //                     Text(
                  //                       // '${e.packing} | ${e.coefficient} | ${e.productPrice}',
                  //                       "${e.packing!} | ${e.coefficient} | ${formatCurrency(e.unitPrice!)}",
                  //                       style: const TextStyle(color: colorGreyDark, fontWeight: FontWeight.w500),
                  //                     ),
                  //                     // const SizedBox(height: 5),
                  //                     // Text(
                  //                     //   // '${e.packing} | ${e.coefficient} | ${e.productPrice}',
                  //                     //   formatCurrency(e.productPrice!),
                  //                     //   style: const TextStyle(color: colorGreyDark, fontWeight: FontWeight.w500),
                  //                     // ),
                  //                   ],
                  //                 ),
                  //               ],
                  //             ),
                  //             const AppSpacing(),
                  //             Row(
                  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //               children: [
                  //                 Text(
                  //                   // '${e.totalVolume} | R\$ ${e.totalValue}',
                  //                   // '${e.totalVolume ?? 0} | R\$ ${formatCurrency(e.totalValue!)}',
                  //                   "${formatCurrency(e.productPrice!)} | ${e.totalVolume}",
                  //                   style: const TextStyle(fontWeight: FontWeight.w500),
                  //                 ),
                  //                 Text(
                  //                   // '${e.totalVolume} | R\$ ${e.totalValue}',
                  //                   // '${e.totalVolume ?? 0} | R\$ ${formatCurrency(e.totalValue!)}',
                  //                   formatCurrency(e.totalValue!),
                  //                   style: const TextStyle(
                  //                     fontWeight: FontWeight.w500,
                  //                   ),
                  //                 ),
                  //               ],
                  //             )
                  //             // Flexible(
                  //             //   flex: 1,
                  //             //   child: Row(
                  //             //     mainAxisAlignment: MainAxisAlignment.end,
                  //             //     children: [
                  //             //       Text(
                  //             //         // '${e.totalVolume} | R\$ ${e.totalValue}',
                  //             //         // '${e.totalVolume ?? 0} | R\$ ${formatCurrency(e.totalValue!)}',
                  //             //         formatCurrency(e.totalValue!),
                  //             //         style: const TextStyle(fontWeight: FontWeight.bold),
                  //             //       ),
                  //             //     ],
                  //             //   ),
                  //             // ),
                  //           ],
                  //         ),
                  //       ),
                  //     );
                }).toList());
              })
        ],
      ),
    );
  }
}
