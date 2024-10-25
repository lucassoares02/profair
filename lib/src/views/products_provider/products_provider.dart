import 'package:profair/src/controllers/products_provider.dart';
import 'package:profair/src/repositories/products_provider_repository.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:profair/generated/l10n.dart';
import 'package:profair/src/views/products_provider/components/list.dart';
import 'package:flutter/material.dart';

class ProductsProvider extends StatefulWidget {
  const ProductsProvider({super.key, required this.codeProvider, this.codeClient, this.nextScreen = true});

  final int? codeProvider;
  final int? codeClient;
  final bool nextScreen;

  @override
  State<ProductsProvider> createState() => _ProductsProviderState();
}

class _ProductsProviderState extends State<ProductsProvider> {
  final ProductsProviderController productsProviderController = ProductsProviderController(StateApp.start, ProductsProviderRepository());

  @override
  void initState() {
    productsProviderController.findProductsProvider(widget.codeProvider, widget.codeClient);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: ValueListenableBuilder(
            valueListenable: productsProviderController.stateProducts,
            builder: (context, value, child) {
              return ComponentList(
                  description: S.of(context).text_select_branch,
                  state: productsProviderController.stateProducts,
                  codeProvider: widget.codeProvider,
                  listItems: productsProviderController.productsProvider,
                  productsProviderController: productsProviderController,
                  nextScreen: widget.nextScreen);
            },
          ),
        ),
      ),
    );
  }
}
