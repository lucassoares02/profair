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
  });

  final DetailsProviderController detailsProviderController;
  final int codeBranch;
  final int codeProvider;

  @override
  State<DetailsProviderScreen> createState() => _DetailsProviderState();
}

class _DetailsProviderState extends State<DetailsProviderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              HeaderList(label: "Informações", activeSearch: false),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ValueListenableBuilder(
                    valueListenable: widget.detailsProviderController.stateNegotiations,
                    builder: (context, value, child) {
                      return value == StateApp.loading
                          ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: appPadding),
                              child: LoadingNotice(cardHeigth: 120, cardWidth: 200),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(appPadding),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Negociações", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                                  const AppSpacing(),
                                  ListNegotiations(
                                    detailsProviderController: widget.detailsProviderController,
                                  ),
                                ],
                              ),
                            );
                    },
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: appPadding),
                    child: HeaderList(
                        activeSearch: true,
                        label: "Mercadorias",
                        activePop: false,
                        onSearch: (value) => widget.detailsProviderController.search(value),
                        onSort: () => widget.detailsProviderController.sort()),
                  ),
                  ValueListenableBuilder(
                      valueListenable: widget.detailsProviderController.stateMerchandises,
                      builder: (context, value, child) {
                        return value == StateApp.loading
                            ? LoadingList(loadingHeader: false)
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      padding: const EdgeInsets.symmetric(horizontal: appPadding * 2),
                                      child: Text(
                                        "${widget.detailsProviderController.merchandises.length} resultados",
                                        style: const TextStyle(color: colorGrey),
                                      )),
                                  Column(
                                    children: widget.detailsProviderController.merchandises.map((e) {
                                      return CardProduct(
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
