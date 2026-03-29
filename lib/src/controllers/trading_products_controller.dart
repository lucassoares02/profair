import 'package:fluttertoast/fluttertoast.dart';
import 'package:profair/src/models/product_model.dart';
import 'package:profair/src/repositories/trading_products_repository.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:flutter/material.dart';

class DetailsSell {
  num? volume;
  num? quantity;

  DetailsSell({this.volume, this.quantity});
}

class TradingProductsController extends ValueNotifier<StateApp> {
  List<ProductModel> productsTrading = [];
  List<ProductModel> products = [];
  List<ProductModel> initialListproducts = [];

  ValueNotifier<bool> visibleText = ValueNotifier(false);
  ValueNotifier<int> itemSelected = ValueNotifier(-1);
  DetailsSell? detailsSell = DetailsSell(volume: 0, quantity: 0);

  final stateProductsTrading = ValueNotifier<StateApp>(StateApp.start);
  final stateSearchProductsTrading = ValueNotifier<StateApp>(StateApp.start);
  final stateShare = ValueNotifier<StateApp>(StateApp.start);
  final itemTotal = ValueNotifier<StateApp>(StateApp.start);
  int sortInt = 0;

  final TradingProductsRepository _negotiationsRepository;

  TradingProductsController(super.value, this._negotiationsRepository);

  Future findTradingProducts(int? codeBranch, int? codeProvider, int? codeTrading, int? codeClient) async {
    stateProductsTrading.value = StateApp.loading;
    try {
      productsTrading = await _negotiationsRepository.getTradingProducts(codeBranch, codeProvider, codeTrading, codeClient);
      products = productsTrading;
      initialListproducts = productsTrading.map<ProductModel>((product) => ProductModel.clone(product)).toList();
      for (var element in products) {
        detailsSell!.volume = detailsSell!.volume! + int.parse(element.amount!);
      }
      detailsSell!.quantity = products.length;
      stateProductsTrading.value = StateApp.success;
    } catch (e) {
      stateProductsTrading.value = StateApp.error;
    }
  }

  Future findTradingProductsHistory(int? codeBranch, int? codeProvider, int? codeTrading) async {
    stateProductsTrading.value = StateApp.loading;
    try {
      productsTrading = await _negotiationsRepository.findTradingProductsHistory(codeBranch, codeProvider, codeTrading);
      products = productsTrading;
      initialListproducts = productsTrading.map<ProductModel>((product) => ProductModel.clone(product)).toList();
      for (var element in products) {
        detailsSell!.volume = detailsSell!.volume! + int.parse(element.amount!);
      }
      detailsSell!.quantity = products.length;
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

  sort() async {
    print("sort");
    stateProductsTrading.value = StateApp.loading;
    String? message = "";
    try {
      print("SortInt: $sortInt");
      if (sortInt == 0) {
        message = "Ordenado por valor de vendas!";
        productsTrading.sort(((a, b) => (double.parse(b.amount!) * b.price!).compareTo(double.parse(a.amount!) * a.price!)));
      } else if (sortInt == 1) {
        message = "Ordenado volume vendido!";
        productsTrading.sort(((a, b) => int.parse(b.amount!) - int.parse(a.amount!)));
      } else if (sortInt == 2) {
        message = "Ordem alfabética!";
        productsTrading.sort(((a, b) => a.title!.compareTo(b.title!)));
      }
      if (sortInt == 2) {
        sortInt = 0;
      } else {
        sortInt += 1;
      }
      Fluttertoast.showToast(msg: message, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, textColor: Colors.white, fontSize: 16.0);

      stateProductsTrading.value = StateApp.success;
    } catch (e) {
      print("Error Sort Products: $e");
      stateProductsTrading.value = StateApp.error;
    }
  }

  Future exportData(int? codeProvider, int? codeNegotiation, int? codeBranch) async {
    stateShare.value = StateApp.loading;
    try {
      await _negotiationsRepository.exportDataProvider(codeProvider: codeProvider, codeNegotiation: codeNegotiation, codeBranch: codeBranch);
    } catch (e) {
      stateShare.value = StateApp.error;
    }
    stateShare.value = StateApp.success;
  }
}
