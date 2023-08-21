import 'package:profair/src/models/nogotiation_model.dart';
import 'package:profair/src/models/product_model.dart';
import 'package:profair/src/repositories/finish_trading_repository.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:flutter/material.dart';

class FinishTradingController extends ValueNotifier<StateApp> {
  final stateFinishTrading = ValueNotifier<StateApp>(StateApp.start);
  final stateTradings = ValueNotifier<bool>(false);
  final stateCheckList = ValueNotifier<StateApp>(StateApp.start);

  final FinishTradingRepository _negotiationsRepository;

  FinishTradingController(super.value, this._negotiationsRepository);

  double totalValue = 0.0;
  int totalVolume = 0;
  int totalChecked = 0;

  Future sendOrder(List<ProductModel> products, List<NegotiationModel> tradings, int? codeBranch, int? codeProvider, int? codeClient) async {
    stateFinishTrading.value = StateApp.loading;
    try {
      await _negotiationsRepository.postTrading(products: products, tradings: tradings, codeBranch: codeBranch, codeProvider: codeProvider, codeClient: codeClient);
    } catch (e) {
      print("Error save order: ====> $e");
      stateFinishTrading.value = StateApp.error;
    }
    stateFinishTrading.value = StateApp.success;
  }

  updateTrading() {
    stateTradings.value = !stateTradings.value;
  }

  checkListItems(List<ProductModel> listItems, List<NegotiationModel> tradings) {
    for (int i = 0; i < tradings.length; i++) {
      if (tradings[i].checked!) {
        totalChecked += 1;
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
