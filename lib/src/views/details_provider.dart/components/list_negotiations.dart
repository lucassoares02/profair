import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:profair/src/components/spacing.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:profair/src/views/details_provider.dart/details_provider_controller.dart';

class ListNegotiations extends StatefulWidget {
  const ListNegotiations(
      {super.key, required this.detailsProviderController, required this.codeProvider, required this.codeBranch});

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
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: widget.detailsProviderController.negotiations.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: appPadding * 1.5),
                      margin: EdgeInsets.only(
                          right: index == widget.detailsProviderController.negotiations.length - 1 ? appMargin : 0,
                          left: appMargin),
                      decoration: BoxDecoration(
                        color: negotiationIndex == index ? colorBlue : Colors.grey.withOpacity(0.2),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(30),
                        ),
                      ),
                      child: InkWell(
                        onTap: () async {
                          if (!(widget.detailsProviderController.stateMerchandises.value == StateApp.loading)) {
                            widget.detailsProviderController.indexNegotiationSelected.value = index;
                            await widget.detailsProviderController.findMerchandises(widget.codeBranch,
                                widget.codeProvider, widget.detailsProviderController.negotiations[index].negotiation!);
                          }
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.detailsProviderController.negotiations[index].title!,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: negotiationIndex == index ? colorWhite : null),
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
              Container(
                margin: const EdgeInsets.symmetric(horizontal: appPadding),
                width: double.maxFinite,
                // padding: const EdgeInsets.all(appMargin),
                // decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(appRadius),
                //     border: Border.all(
                //       width: 2,
                //       color: colorBlue,
                //     )),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget
                            .detailsProviderController
                            .negotiations[widget.detailsProviderController.indexNegotiationSelected.value]
                            .observation !=
                        null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Observação: ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(widget
                              .detailsProviderController
                              .negotiations[widget.detailsProviderController.indexNegotiationSelected.value]
                              .observation!),
                        ],
                      ),
                    const SizedBox(height: 10),
                    if (widget.detailsProviderController
                            .negotiations[widget.detailsProviderController.indexNegotiationSelected.value].term !=
                        null)
                      Container(
                        padding: const EdgeInsets.all(appMargin),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(appRadius),
                            border: Border.all(
                              color: colorGrey,
                            )),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.date_range_rounded,
                              size: 20,
                            ),
                            const SizedBox(width: 3),
                            const Text(
                              "Prazo de Entrega: ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              formatter.format(DateTime.parse(widget
                                  .detailsProviderController
                                  .negotiations[widget.detailsProviderController.indexNegotiationSelected.value]
                                  .term!)),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          );
        });
  }
}
