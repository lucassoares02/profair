import 'package:profair/src/components/card_product.dart';
import 'package:profair/src/components/header_list.dart';
import 'package:profair/src/components/loading_list.dart';
import 'package:profair/src/components/loading_notices.dart';
import 'package:profair/src/components/spacing.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:profair/src/utils/format_currency.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:flutter/material.dart';
import 'package:profair/src/views/details_provider.dart/components/list_negotiations.dart';
import 'package:profair/src/views/details_provider.dart/details_provider_controller.dart';

class DetailsProviderScreen extends StatefulWidget {
  const DetailsProviderScreen({
    super.key,
    required this.detailsProviderController,
    required this.codeBranch,
    required this.codeProvider,
    this.image,
    this.color,
    required this.nameProvider,
  });

  final DetailsProviderController detailsProviderController;
  final int codeBranch;
  final int codeProvider;
  final String? image;
  final String? color;
  final String nameProvider;

  @override
  State<DetailsProviderScreen> createState() => _DetailsProviderState();
}

class _DetailsProviderState extends State<DetailsProviderScreen> {
  bool headerProvider = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              HeaderList(
                  label: "Fornecedor",
                  onCloseInfo: () {
                    setState(() {
                      headerProvider = !headerProvider;
                    });
                  },
                  activeSearch: true,
                  onSearch: (value) => widget.detailsProviderController.search(value),
                  onSort: () => widget.detailsProviderController.sort()),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (headerProvider)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.image != null)
                          Container(
                            height: 250,
                            padding: const EdgeInsets.symmetric(horizontal: appPadding),
                            decoration: BoxDecoration(
                              color: widget.color != null ? Color(int.parse(widget.color!)) : colorPrimary,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.network(
                                  widget.image!,
                                  width: 150,
                                ),
                              ],
                            ),
                          ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: appPadding),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 5),
                              const SizedBox(height: 5),
                              Text(
                                "${widget.codeProvider}",
                                style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                widget.nameProvider,
                                overflow: TextOverflow.fade,
                                softWrap: true,
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  if (headerProvider)
                    const Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: appPadding),
                          child: Row(
                            children: [
                              Text(
                                "Responsável ",
                                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                "",
                                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        AppSpacing(),
                        Divider(),
                        AppSpacing(),
                      ],
                    ),
                  if (headerProvider)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ValueListenableBuilder(
                          valueListenable: widget.detailsProviderController.stateNegotiations,
                          builder: (context, value, child) {
                            return value == StateApp.loading
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 0),
                                    child: LoadingNotice(cardHeigth: 120, cardWidth: 300),
                                  )
                                : Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.symmetric(horizontal: appPadding),
                                        child: Text(
                                          "Negociações / Prazos",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold, fontSize: 16, color: colorGreyDark),
                                        ),
                                      ),
                                      const AppSpacing(),
                                      ListNegotiations(
                                        codeBranch: widget.codeBranch,
                                        codeProvider: widget.codeProvider,
                                        detailsProviderController: widget.detailsProviderController,
                                      ),
                                    ],
                                  );
                          },
                        ),
                        const AppSpacing(),
                        const Divider(),
                      ],
                    ),
                  ValueListenableBuilder(
                      valueListenable: widget.detailsProviderController.stateMerchandises,
                      builder: (context, value, child) {
                        final noEmptyList = widget.detailsProviderController.merchandises.isNotEmpty;
                        return value == StateApp.loading
                            ? LoadingList(loadingHeader: false)
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: appPadding, left: appPadding),
                                    child: Text(
                                      noEmptyList ? "Mercadorias" : "Nenhum resultado!",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold, fontSize: 16, color: colorGreyDark),
                                    ),
                                  ),
                                  Column(
                                    children: widget.detailsProviderController.merchandises.map((e) {
                                      return CardProduct(
                                          visibleActions: false,
                                          description: e.nameProduct!,
                                          code: e.codeProduct.toString(),
                                          brand: e.brand!,
                                          complement: e.complement!,
                                          price: formatCurrency(e.productPrice!),
                                          unitPrice: formatCurrency(e.unitPrice!),
                                          amount: e.totalVolume!,
                                          total: formatCurrency(e.totalValue!),
                                          action: () {});
                                    }).toList(),
                                  ),
                                ],
                              );
                      }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
