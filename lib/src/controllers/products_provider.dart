import 'package:fluttertoast/fluttertoast.dart';
import 'package:profair/src/repositories/products_provider_repository.dart';
import 'package:profair/src/repositories/products_provider_model.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:flutter/material.dart';

class ProductsProviderController extends ValueNotifier<StateApp> {
  List<ProductsProviderModel> productsProvider = [];
  List<ProductsProviderModel> requests = [];
  int sortInt = 0;

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
      final query = value.toLowerCase();
      productsProvider = requests.where((item) {
        final name = (item.nameProduct ?? "").toLowerCase();
        final tag = (item.tag ?? "").toLowerCase();
        return name.contains(query) || tag.contains(query);
      }).toList();

      stateSearchProducts.value = StateApp.success;
    } catch (e) {
      print("Error search Requests Stores: $e");
      stateSearchProducts.value = StateApp.error;
    }
  }

  sort() async {
    print("sort");
    stateSearchProducts.value = StateApp.loading;
    String? message = "";
    try {
      if (sortInt == 0) {
        productsProvider.sort(((a, b) => b.totalValue!.compareTo(a.totalValue!)));
        message = "Ordenado por valor total de vendas!";
      } else if (sortInt == 1) {
        productsProvider.sort(((a, b) => int.parse(b.totalVolume!) - int.parse(a.totalVolume!)));
        message = "Ordenado volume vendido!";
      } else if (sortInt == 2) {
        productsProvider.sort(((a, b) => a.nameProduct!.compareTo(b.nameProduct!)));
        message = "Ordenado por ordem alfabética!";
      }
      if (sortInt == 2) {
        sortInt = 0;
      } else {
        sortInt += 1;
      }
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);

      stateSearchProducts.value = StateApp.success;
    } catch (e) {
      print("Error Sort Stores: $e");
      stateSearchProducts.value = StateApp.error;
    }
  }
}
