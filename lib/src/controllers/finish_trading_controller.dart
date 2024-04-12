import 'package:profair/src/models/nogotiation_model.dart';
import 'package:profair/src/models/product_model.dart';
import 'package:profair/src/repositories/finish_trading_repository.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:flutter/material.dart';

import '../models/clients_select_stores_model.dart';

class FinishTradingController extends ValueNotifier<StateApp> {
  final stateFinishTrading = ValueNotifier<StateApp>(StateApp.start);
  final stateTradings = ValueNotifier<bool>(false);
  final stateCheckList = ValueNotifier<StateApp>(StateApp.start);
  final stateShare = ValueNotifier<StateApp>(StateApp.start);

  final FinishTradingRepository _negotiationsRepository;

  FinishTradingController(super.value, this._negotiationsRepository);
  List<dynamic> actualList = [];

  double totalValue = 0.0;
  int totalVolume = 0;
  int totalChecked = 0;
  int totalCheckedBranch = 0;

  Future sendOrder(List<ProductModel> products, List<NegotiationModel> tradings, int? codeBranch, int? codeProvider,
      int? codeClient, List<ClientsSelectStoreModel> listBranchs, int? codeConsult) async {
    stateFinishTrading.value = StateApp.loading;

    try {
      await _negotiationsRepository.postTradingNew(
        products: actualList,
        tradings: tradings,
        codeBranch: codeBranch,
        codeProvider: codeProvider,
        codeClient: codeClient,
        listBranchs: listBranchs,
        codeConsult: codeConsult,
      );
    } catch (e) {
      print("Error save order: $e");
      stateFinishTrading.value = StateApp.error;
    }
    stateFinishTrading.value = StateApp.success;
  }

  updateTrading() {
    stateTradings.value = !stateTradings.value;
  }

  insertInList(List<ProductModel> products, List<ProductModel> initialListProducts) async {
    for (int j = 0; j < products.length; j++) {
      if (int.parse(products[j].amount!) > 0 || int.parse(initialListProducts[j].amount!) > 0) {
        actualList.add(products[j].toJson());
      }
    }
  }

  Future exportData(int? codeProvider, int? codeNegotiation, int? codeBranch) async {
    stateShare.value = StateApp.loading;
    try {
      await _negotiationsRepository.exportDataProvider(
          codeProvider: codeProvider, codeNegotiation: codeNegotiation, codeBranch: codeBranch);
    } catch (e) {
      stateShare.value = StateApp.error;
    }
    stateShare.value = StateApp.success;
  }

  checkListItems(
      List<ProductModel> listItems, List<NegotiationModel> tradings, List<ClientsSelectStoreModel>? listBranchs) {
    for (int i = 0; i < tradings.length; i++) {
      if (tradings[i].checked!) {
        totalChecked += 1;
      }
    }
    for (int i = 0; i < listBranchs!.length; i++) {
      if (listBranchs[i].checked!) {
        totalCheckedBranch += 1;
      }
    }
    stateCheckList.value = StateApp.loading;
    double? total;
    try {
      for (int j = 0; j < listItems.length; j++) {
        if (listItems[j].amount! != "0") {
          totalVolume = totalVolume + int.parse(listItems[j].amount!);

          total = int.parse(listItems[j].amount!) * listItems[j].price!;

          totalValue = totalValue + total;
        }
      }
      stateCheckList.value = StateApp.success;
    } catch (e) {
      stateCheckList.value = StateApp.error;
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
}
