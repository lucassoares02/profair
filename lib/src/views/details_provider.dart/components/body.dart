import 'package:flutter/services.dart';
import 'package:profair/src/components/best_selling_productcard.dart';
import 'package:profair/src/components/card_product.dart';
import 'package:profair/src/components/card_product_top.dart';
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
import 'package:skeletonizer/skeletonizer.dart';

import '../../reports/components/chart_negotiation.dart';

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
  ValueNotifier<int> indexTab = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    List<String> listHeader = ["Destaques", widget.codeBranch == 0 ? "Pedidos" : "Meus pedidos", "Negociações", "Consultores"];
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: widget.color != null ? Color(int.parse(widget.color!)) : colorPrimary,
      ),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // HeaderList(
                //   label: "Fornecedor",
                //   onCloseInfo: () {
                //     setState(() {
                //       headerProvider = !headerProvider;
                //     });
                //   },
                //   activeSearch: true,
                //   onSearch: (value) => widget.detailsProviderController.search(value),
                //   onSort: () => widget.detailsProviderController.sort(),
                // ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (headerProvider)
                      ClipPath(
                        clipper: InvertedArcClipper(),
                        child: Container(
                          decoration: BoxDecoration(
                            color: widget.color != null ? Color(int.parse(widget.color!)) : colorPrimary,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.arrow_back_ios_new, color: colorWhite), // Altere o ícone aqui
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              if (widget.image != null)
                                Container(
                                  height: 120,
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
                                      style: const TextStyle(color: colorWhite, fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      widget.nameProvider,
                                      overflow: TextOverflow.fade,
                                      softWrap: true,
                                      style: const TextStyle(color: colorWhite, fontSize: 20, fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                              const AppSpacing(),
                              const AppSpacing(),
                              const AppSpacing(),
                              const AppSpacing(),
                            ],
                          ),
                        ),
                      ),
                    const AppSpacing(),
                    ValueListenableBuilder(
                        valueListenable: indexTab,
                        builder: (context, valueIndex, child) {
                          return Container(
                            height: 45,
                            child: ListView.separated(
                              separatorBuilder: (context, index) => Container(
                                width: appMargin,
                              ),
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: listHeader.length,
                              itemBuilder: (context, index) {
                                return TextButton(
                                  style: index != indexTab.value
                                      ? ButtonStyle(foregroundColor: MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.onSurface))
                                      : ButtonStyle(
                                          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                                            const EdgeInsets.symmetric(horizontal: appPadding * 1.5),
                                          ),
                                          foregroundColor: MaterialStateProperty.all<Color>(colorWhite),
                                          backgroundColor: MaterialStateProperty.all<Color>(
                                            widget.color != null ? Color(int.parse(widget.color!)) : colorPrimary,
                                          ),
                                        ),
                                  onPressed: () {
                                    indexTab.value = index;
                                  },
                                  child: Text(
                                    listHeader[index],
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }),
                    const AppSpacing(),
                    const AppSpacing(),
                    SizedBox(
                      width: double.infinity,
                      child: ValueListenableBuilder<int>(
                        valueListenable: indexTab,
                        builder: (context, value, child) {
                          if (value == 0) {
                            widget.detailsProviderController.findTopMerchandises(widget.codeProvider);
                          } else if (value == 1) {
                            // widget.detailsProviderController.findRequestStores(widget.codeBranch, widget.codeProvider);
                            widget.detailsProviderController.findRequestStoresOrOrg(widget.codeBranch, widget.codeProvider);
                            // widget.detailsProviderController.findNegotiations(widget.codeBranch, widget.codeProvider);
                          } else if (value == 2) {
                            // widget.detailsProviderController.findMerchandises(widget.codeBranch, widget.codeProvider, widget.detailsProviderController.request!.codeNegotiation!);
                            widget.detailsProviderController.findNegotiations(widget.codeBranch, widget.codeProvider);
                          } else if (value == 3) {
                            widget.detailsProviderController.findConsults(widget.codeProvider);
                          }

                          final List<Widget> pages = [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: appPadding),
                              child: ValueListenableBuilder(
                                valueListenable: widget.detailsProviderController.stateTopMerchandises,
                                builder: (context, valueTop, childTop) {
                                  return valueTop == StateApp.loading
                                      ? const Skeletonizer(
                                          effect: ShimmerEffect(),
                                          child: Card(
                                            margin: EdgeInsets.symmetric(horizontal: 16),
                                            child: SizedBox(
                                              height: 400,
                                              width: double.maxFinite,
                                            ),
                                          ),
                                        )
                                      : Column(
                                          children: [
                                            BestSellingProductCard(
                                              onTap: () {},
                                            ),
                                            const AppSpacing(),
                                            widget.detailsProviderController.topMerchandises[9].total == 0
                                                ? const Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "As métricas ainda estão sendo calculadas",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                          "Em breve você terá informações detalhadas das mercadorias mais negociadas por esse fornecedor. Essas métricas podem variar ao decorrer do evento. E os dados não são recomendações de compra."),
                                                    ],
                                                  )
                                                : Column(
                                                    children: [
                                                      SizedBox(
                                                        height: 300,
                                                        child: BarChartSample1(
                                                          legendValue: false,
                                                          barColor: widget.color != null ? Color(int.parse(widget.color!)) : colorPrimary,
                                                          reportsProducts: widget.detailsProviderController.topMerchandises,
                                                        ),
                                                      ),
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: widget.detailsProviderController.topMerchandises.asMap().entries.map((e) {
                                                          return CardProductTop(
                                                            barcode: e.value.barcode.toString(),
                                                            description: e.value.title!,
                                                            code: e.value.codeProduct.toString(),
                                                            brand: e.value.brand!,
                                                            complement: e.value.complement!,
                                                            price: (e.value.price != null) ? formatCurrency(e.value.price!) : "",
                                                            unitPrice: e.value.unitPrice != null ? formatCurrency(e.value.unitPrice!) : "",
                                                            amount: "",
                                                            total: "",
                                                            negotiation: e.value.negotiation,
                                                            packing: e.value.packing!,
                                                            factor: e.value.coefficient!,
                                                            color: widget.color != null ? Color(int.parse(widget.color!)) : colorPrimary,
                                                            position: e.key,
                                                          );
                                                        }).toList(),
                                                      ),
                                                    ],
                                                  ),
                                          ],
                                        );
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: appPadding),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Pedidos", style: styleTitle),
                                  const AppSpacing(),
                                  ValueListenableBuilder(
                                      valueListenable: widget.detailsProviderController.stateRequestStores,
                                      builder: (context, stateRequest, child) {
                                        return Column(
                                          children: widget.detailsProviderController.requestsStores.map(
                                            (e) {
                                              return e.codeForn != widget.codeProvider
                                                  ? Container()
                                                  : stateRequest == StateApp.loading
                                                      ? LoadingList(loadingHeader: false)
                                                      : InkWell(
                                                          onTap: stateRequest == StateApp.success
                                                              ? () async {
                                                                  Navigator.of(context).pushNamed(
                                                                    "orderdetails",
                                                                    arguments: {
                                                                      "order": e,
                                                                    },
                                                                  );
                                                                }
                                                              : null,
                                                          child: Container(
                                                            margin: const EdgeInsets.only(bottom: appMargin),
                                                            decoration: BoxDecoration(
                                                              border: Border.all(color: Colors.grey.withOpacity(0.3)),
                                                              borderRadius: BorderRadius.circular(appRadius),
                                                            ),
                                                            padding: const EdgeInsets.symmetric(horizontal: appPadding, vertical: appPadding),
                                                            child: Row(
                                                              children: [
                                                                Expanded(
                                                                  child: Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Text(e.codeNegotiation.toString()),
                                                                      Text(widget.codeBranch == 0 ? e.razaoClient! : e.descriptionNegotiation!),
                                                                      stateRequest == StateApp.loading
                                                                          ? const Skeletonizer(
                                                                              effect: ShimmerEffect(),
                                                                              child: Card(
                                                                                margin: EdgeInsets.symmetric(horizontal: 16),
                                                                                child: SizedBox(
                                                                                  height: appPadding,
                                                                                  width: 50,
                                                                                ),
                                                                              ),
                                                                            )
                                                                          : stateRequest == StateApp.success
                                                                              ? widget.detailsProviderController.request != null
                                                                                  ? Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      children: [
                                                                                        Text(
                                                                                          formatCurrency(e.value!),
                                                                                          style: const TextStyle(fontWeight: FontWeight.w600),
                                                                                        ),
                                                                                        Text(e.hour!),
                                                                                      ],
                                                                                    )
                                                                                  : Container()
                                                                              : Container(),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                            },
                                          ).toList(),
                                        );
                                      })
                                ],
                              ),
                            ),
                            Column(
                              children: [
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
                                                        style: styleTitle,
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
                                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: colorGreyDark),
                                                  ),
                                                ),
                                                Column(
                                                  children: widget.detailsProviderController.merchandises.map((e) {
                                                    return CardProduct(
                                                        visibleActions: (widget.codeBranch == 0),
                                                        packing: e.packing!,
                                                        factor: e.coefficient!,
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
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: appPadding),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Consultores", style: styleTitle),
                                  ValueListenableBuilder(
                                      valueListenable: widget.detailsProviderController.stateConsults,
                                      builder: (context, stateConsult, child) {
                                        return stateConsult == StateApp.loading
                                            ? LoadingList(loadingHeader: false)
                                            : Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: widget.detailsProviderController.consults.map((e) {
                                                  return Container(
                                                    margin: const EdgeInsets.only(top: appMargin),
                                                    width: double.maxFinite,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(color: colorGrey.withOpacity(0.3)),
                                                      borderRadius: BorderRadius.circular(appRadius),
                                                    ),
                                                    padding: const EdgeInsets.symmetric(horizontal: appPadding, vertical: appPadding),
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Container(
                                                          width: 40,
                                                          height: 40,
                                                          margin: const EdgeInsets.only(right: appMargin),
                                                          decoration: BoxDecoration(
                                                            color: widget.color != null ? Color(int.parse(widget.color!)) : colorPrimary,
                                                            borderRadius: BorderRadius.circular(50),
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              e.nameUser!.substring(0, 1),
                                                              style: const TextStyle(
                                                                color: colorWhite,
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 20,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Text(e.nameUser!)
                                                      ],
                                                    ),
                                                  );
                                                }).toList());
                                      }),
                                ],
                              ),
                            )
                          ];

                          return pages[value];
                        },
                      ),
                    ),
                  ],
                ),
                const AppSpacing(),
                const AppSpacing()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InvertedArcClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height); // Início no canto inferior esquerdo
    path.quadraticBezierTo(
      size.width / 2, size.height - 50, // Ponto de controle no meio
      size.width, size.height, // Final no canto inferior direito
    );
    path.lineTo(size.width, 0); // Sobe para o canto superior direito
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
