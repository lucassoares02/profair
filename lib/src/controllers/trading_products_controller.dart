import 'package:profair/src/models/product_model.dart';
import 'package:profair/src/repositories/trading_products_repository.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:flutter/material.dart';

class TradingProductsController extends ValueNotifier<StateApp> {
  List<ProductModel> productsTrading = [];
  Iterable<ProductModel> products = [];

  ValueNotifier<bool> visibleText = ValueNotifier(false);
  ValueNotifier<int> itemSelected = ValueNotifier(-1);
  final stateProductsTrading = ValueNotifier<StateApp>(StateApp.start);
  final stateSearchProductsTrading = ValueNotifier<StateApp>(StateApp.start);
  final itemTotal = ValueNotifier<StateApp>(StateApp.start);

  final TradingProductsRepository _negotiationsRepository;

  TradingProductsController(super.value, this._negotiationsRepository);

  Future findTradingProducts(int? codeBranch, int? codeProvider, int? codeTrading, int? codeClient) async {
    stateProductsTrading.value = StateApp.loading;
    try {
      productsTrading = await _negotiationsRepository.getTradingProducts(codeBranch, codeProvider, codeTrading, codeClient);
      products = productsTrading;
      stateProductsTrading.value = StateApp.success;
    } catch (e) {
      stateProductsTrading.value = StateApp.error;
    }
  }

  String formatCurrency(double amount) {
    String formattedAmount = amount.toStringAsFixed(2);
    formattedAmount = formattedAmount.replaceAll('.', ',');
    List<String> parts = formattedAmount.split(',');
    String integerPart = parts[0];
    String decimalPart = parts[1];

    String formattedIntegerPart = '';
    for (int i = integerPart.length - 1, count = 0; i >= 0; i--, count++) {
      if (count != 0 && count % 3 == 0) {
        formattedIntegerPart = ".$formattedIntegerPart";
      }
      formattedIntegerPart = integerPart[i] + formattedIntegerPart;
    }

    return 'R\$$formattedIntegerPart,$decimalPart';
  }

  updateProductsTrading(String? value, int index) {
    itemTotal.value = StateApp.loading;
    try {
      value = value != "" ? value : "0";
      productsTrading.elementAt(index).amount = value;
      itemTotal.value = StateApp.success;
    } catch (e) {
      debugPrint("$e");
    }
  }

  search(String? value) async {
    stateSearchProductsTrading.value = StateApp.loading;
    try {
      if (value! == "") {
        productsTrading = products.toList();
      }
      productsTrading = products.where((item) {
        return item.title!.toLowerCase().contains(value.toLowerCase());
      }).toList();

      stateSearchProductsTrading.value = StateApp.success;
    } catch (e) {
      print("Error search Requests Stores: $e");
      stateSearchProductsTrading.value = StateApp.error;
    }
  }
}
