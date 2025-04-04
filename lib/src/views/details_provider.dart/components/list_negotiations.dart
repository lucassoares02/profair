import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:profair/src/components/spacing.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:profair/src/utils/format_currency.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:profair/src/views/details_provider.dart/details_provider_controller.dart';
import 'package:skeletons/skeletons.dart';

class ListNegotiations extends StatefulWidget {
  const ListNegotiations({super.key, required this.detailsProviderController, required this.codeProvider, required this.codeBranch});

  final DetailsProviderController detailsProviderController;
  final int codeProvider;
  final int codeBranch;

  @override
  State<ListNegotiations> createState() => _ListNegotiationsState();
}

class _ListNegotiationsState extends State<ListNegotiations> {
  final DateFormat formatter = DateFormat('dd/MM/yyyy');
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: widget.detailsProviderController.indexNegotiationSelected,
        builder: (context, negotiationIndex, value) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 130,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: widget.detailsProviderController.negotiations.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 300,
                      padding: const EdgeInsets.symmetric(horizontal: appPadding, vertical: appPadding),
                      margin: EdgeInsets.only(right: index == widget.detailsProviderController.negotiations.length - 1 ? appMargin : 0, left: appMargin),
                      decoration: BoxDecoration(
                        color: negotiationIndex == index ? colorBlue : Colors.grey.withOpacity(0.2),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(appRadius),
                        ),
                      ),
                      child: InkWell(
                        onTap: () async {
                          if (!(widget.detailsProviderController.stateMerchandises.value == StateApp.loading)) {
                            widget.detailsProviderController.indexNegotiationSelected.value = index;
                            widget.detailsProviderController.searchNegotiation(widget.detailsProviderController.negotiations[index].negotiation!);
                            await widget.detailsProviderController.findMerchandises(widget.codeBranch, widget.codeProvider, widget.detailsProviderController.negotiations[index].negotiation!);
                          }
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.detailsProviderController.negotiations[index].negotiation.toString(),
                                  style: TextStyle(color: negotiationIndex == index ? colorWhite : null, fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  formatter.format(
                                    DateTime.parse(
                                      widget.detailsProviderController.negotiations[index].term!,
                                    ),
                                  ),
                                  style: TextStyle(color: negotiationIndex == index ? colorWhite : null, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            const Divider(),
                            Text(
                              widget.detailsProviderController.negotiations[index].title!,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: negotiationIndex == index ? colorWhite : null),
                            ),
                            Column(
                              children: [
                                Text(
                                  widget.detailsProviderController.negotiations[index].observation!,
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(color: negotiationIndex == index ? colorWhite : null, fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const AppSpacing(),
              if (widget.detailsProviderController.negotiations[widget.detailsProviderController.indexNegotiationSelected.value].confirm != null)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: appMargin),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(appRadius),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: appPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.check_circle_rounded,
                                size: 20,
                                color: colorGreen,
                              ),
                              const SizedBox(width: 5),
                              const Text(
                                "Pedido realizado ",
                                overflow: TextOverflow.clip,
                              ),
                              ValueListenableBuilder(
                                  valueListenable: widget.detailsProviderController.stateRequestStores,
                                  builder: (context, stateRequest, value) {
                                    return stateRequest == StateApp.loading
                                        ? const SkeletonLine(
                                            style: SkeletonLineStyle(width: 50, height: 15, borderRadius: BorderRadius.all(Radius.circular(10))),
                                          )
                                        : stateRequest == StateApp.success
                                            ? widget.detailsProviderController.request != null
                                                ? Text(
                                                    formatCurrency(
                                                      widget.detailsProviderController.request!.value!,
                                                    ),
                                                    style: const TextStyle(fontWeight: FontWeight.w600),
                                                  )
                                                : Container()
                                            : Container();
                                  })
                            ],
                          ),
                          ValueListenableBuilder(
                              valueListenable: widget.detailsProviderController.stateRequestStores,
                              builder: (context, stateRequest, value) {
                                return stateRequest == StateApp.success
                                    ? TextButton(
                                        onPressed: () async {
                                          inspect(widget.detailsProviderController.request);
                                          Navigator.of(context).pushNamed(
                                            "orderdetails",
                                            arguments: {
                                              "order": widget.detailsProviderController.request,
                                            },
                                          );
                                        },
                                        child: const Text(
                                          "Saiba mais",
                                          style: TextStyle(color: colorBlue),
                                        ),
                                      )
                                    : const Padding(
                                        padding: EdgeInsets.all(appPadding),
                                        child: Text(
                                          "Saiba mais",
                                          style: TextStyle(fontWeight: FontWeight.w500),
                                        ),
                                      );
                              }),
                        ],
                      ),
                    ],
                  ),
                ),
              // const AppSpacing(),
              // Container(
              //   margin: const EdgeInsets.symmetric(horizontal: appPadding),
              //   width: double.maxFinite,
              //   // padding: const EdgeInsets.all(appMargin),
              //   // decoration: BoxDecoration(
              //   //     borderRadius: BorderRadius.circular(appRadius),
              //   //     border: Border.all(
              //   //       width: 2,
              //   //       color: colorBlue,
              //   //     )),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           const Text(
              //             "Código ",
              //             style: TextStyle(
              //               fontWeight: FontWeight.bold,
              //             ),
              //           ),
              //           Text(widget.detailsProviderController
              //               .negotiations[widget.detailsProviderController.indexNegotiationSelected.value].negotiation
              //               .toString()),
              //         ],
              //       ),
              //       const AppSpacing(),
              //       if (widget.detailsProviderController
              //               .negotiations[widget.detailsProviderController.indexNegotiationSelected.value].term !=
              //           null)
              //         Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             const Text(
              //               "Prazo de Entrega: ",
              //               style: TextStyle(
              //                 fontWeight: FontWeight.bold,
              //               ),
              //             ),
              //             Row(
              //               crossAxisAlignment: CrossAxisAlignment.center,
              //               children: [
              //                 const SizedBox(width: 3),
              //                 Text(
              //                   formatter.format(DateTime.parse(widget
              //                       .detailsProviderController
              //                       .negotiations[widget.detailsProviderController.indexNegotiationSelected.value]
              //                       .term!)),
              //                 ),
              //               ],
              //             ),
              //           ],
              //         ),
              //       const AppSpacing(),
              //       if (widget
              //               .detailsProviderController
              //               .negotiations[widget.detailsProviderController.indexNegotiationSelected.value]
              //               .observation !=
              //           null)
              //         Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             const Text(
              //               "Observação",
              //               style: TextStyle(
              //                 fontWeight: FontWeight.bold,
              //               ),
              //             ),
              //             Text(widget
              //                 .detailsProviderController
              //                 .negotiations[widget.detailsProviderController.indexNegotiationSelected.value]
              //                 .observation!),
              //           ],
              //         ),
              //     ],
              //   ),
              // ),
            ],
          );
        });
  }
}
