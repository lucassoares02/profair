import 'package:profair/src/utils/format_currency.dart';
import 'package:profair/src/views/home/home_controller.dart';
import 'package:profair/src/views/home/state_management.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter/material.dart';

class ListProviders extends StatefulWidget {
  const ListProviders({
    super.key,
    this.description,
    required this.homeController,
  });

  final String? description;
  final HomeController homeController;

  @override
  State<ListProviders> createState() => _ListProvidersState();
}

class _ListProvidersState extends State<ListProviders> {
  @override
  void initState() {
    super.initState();
    widget.homeController.findTopProviders();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return ValueListenableBuilder(
        valueListenable: widget.homeController.stateTopProvider,
        builder: (context, state, child) {
          return StateManagement(
            width: width,
            listenable: widget.homeController.stateTopProvider,
            widgetLoading: Column(
              children: [
                Skeletonizer(
                  effect: const ShimmerEffect(),
                  child: Card(
                    child: SizedBox(
                      width: width / 2,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: 7,
                      itemBuilder: (context, index) {
                        return Skeletonizer(
                          effect: const ShimmerEffect(),
                          child: Card(
                            child: SizedBox(
                              height: 90,
                              width: width,
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
            component: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: appMargin, left: appPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.description ?? "",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: colorGreyDark),
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                              "selectprovider",
                              arguments: {
                                "codeClient": 0,
                                "codeBuyer": 0,
                                "codeBranch": widget.homeController.data!.codCompany,
                              },
                            );
                          },
                          icon: const Icon(Icons.arrow_forward))
                    ],
                  ),
                ),
                widget.homeController.topProviders.isEmpty
                    ? Container(
                        padding: const EdgeInsets.only(left: appPadding),
                        child: const Row(
                          children: [
                            Text(
                              "Não possui Fornecedores!",
                              style: TextStyle(color: colorGreyDark, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      )
                    : SizedBox(
                        height: 210,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.homeController.topProviders.length,
                            itemBuilder: ((context, index) {
                              final lastItem = widget.homeController.topProviders.length - 1 == index;
                              return InkWell(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                    "detailsprovider",
                                    arguments: {
                                      "codeProvider": widget.homeController.topProviders[index].codeProvider,
                                      "imageProvider": widget.homeController.topProviders[index].image,
                                      "nameProvider": widget.homeController.topProviders[index].nameProvider,
                                      "codeBranch": widget.homeController.data!.codCompany,
                                      "color": widget.homeController.topProviders[index].color
                                    },
                                  );
                                },
                                child: Container(
                                  width: 250,
                                  margin: EdgeInsets.only(left: appMargin, right: lastItem ? appMargin : 0),
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(appRadius),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 120,
                                              padding: const EdgeInsets.symmetric(vertical: appPadding),
                                              decoration: BoxDecoration(
                                                  color: widget.homeController.topProviders[index].color != null ? Color(int.parse(widget.homeController.topProviders[index].color!)) : colorPrimary,
                                                  borderRadius: BorderRadius.circular(5)),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  widget.homeController.topProviders[index].image != null
                                                      ? Image.network(
                                                          widget.homeController.topProviders[index].image!,
                                                          width: 80,
                                                        )
                                                      : Container(
                                                          width: 100,
                                                          height: 100,
                                                          child: Icon(
                                                            Icons.image_not_supported_outlined,
                                                            color: colorWhite.withOpacity(0.3),
                                                          ),
                                                        )
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.all(appMargin),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${widget.homeController.topProviders[index].nameProvider}",
                                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                                    overflow: TextOverflow.fade,
                                                  ),
                                                  Text(
                                                    formatCurrency(widget.homeController.topProviders[index].totalValue!),
                                                    style: const TextStyle(fontSize: 12),
                                                    overflow: TextOverflow.fade,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            })),
                      )
                // : Row(
                //     children: widget.listItems.map((e) {
                //     return InkWell(
                //       onTap: () {
                //         // Navigator.of(context).pushNamed('detailsrecipe', arguments: e);
                //       },
                //       child: Container(
                //         width: 250,
                //         height: 150,
                //         padding: const EdgeInsets.symmetric(horizontal: appMargin),
                //         margin: const EdgeInsets.symmetric(vertical: appMargin / 2),
                //         decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(appRadius)),
                //         child: Row(
                //           children: [
                //             Expanded(
                //               child: Column(
                //                 crossAxisAlignment: CrossAxisAlignment.start,
                //                 mainAxisAlignment: MainAxisAlignment.center,
                //                 children: [
                //                   Row(
                //                     children: [
                //                       Text(
                //                         "Teste",
                //                         style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                //                       ),
                //                     ],
                //                   ),
                //                   const SizedBox(height: 5),
                //                   Row(
                //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //                     children: [
                //                       Text(
                //                         formatCurrency(e.totalValue!),
                //                         style: const TextStyle(
                //                             // color: colorGreyDark,
                //                             ),
                //                       ),
                //                     ],
                //                   ),
                //                 ],
                //               ),
                //             ),
                //           ],
                //         ),
                //       ),
                //     );
                //   }).toList())
              ],
            ),
          );
        });
  }
}
