import 'package:profair/src/repositories/products_provider_repository.dart';
import 'package:profair/src/repositories/products_provider_model.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:flutter/material.dart';

class ProductsProviderController extends ValueNotifier<StateApp> {
  Iterable<ProductsProviderModel> productsProvider = [];
  Iterable<ProductsProviderModel> requests = [];

  final stateSearchProducts = ValueNotifier<StateApp>(StateApp.start);

  final stateProducts = ValueNotifier<StateApp>(StateApp.start);

  final ProductsProviderRepository _productsProviderRepository;

  ProductsProviderController(super.value, this._productsProviderRepository);

  Future findProductsProvider(int? codeProvider, int? codeClient) async {
    stateProducts.value = StateApp.loading;
    try {
      productsProvider = await _productsProviderRepository.getProductsProvider(codeProvider, codeClient);
      requests = productsProvider;

      stateProducts.value = StateApp.success;
    } catch (e) {
      stateProducts.value = StateApp.error;
    }
  }

  search(String? value) async {
    stateSearchProducts.value = StateApp.loading;
    try {
      if (value! == "") {
        productsProvider = requests;
      }
      productsProvider = requests.where((item) {
        return item.nameProduct!.toLowerCase().contains(value.toLowerCase());
      });

      stateSearchProducts.value = StateApp.success;
    } catch (e) {
      print("Error search Requests Stores: $e");
      stateSearchProducts.value = StateApp.error;
    }
  }
}
