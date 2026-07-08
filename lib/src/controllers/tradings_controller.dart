import 'package:profair/src/models/tradings_model.dart';
import 'package:profair/src/repositories/tradings_repository.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:flutter/material.dart';

class TradingsController extends ValueNotifier<StateApp> {
  Iterable<TradingsModel> tradingList = [];
  Iterable<TradingsModel> tradings = [];

  final stateSearchTrandings = ValueNotifier<StateApp>(StateApp.start);

  final stateTradings = ValueNotifier<StateApp>(StateApp.start);

  final stateSaveOrder = ValueNotifier<StateApp>(StateApp.start);

  final TradingsRepository _tradingsRepository;

  TradingsController(super.value, this._tradingsRepository);

  Future findTradings(String? codeProvider) async {
    stateTradings.value = StateApp.loading;
    try {
      tradingList = await _tradingsRepository.getTradings(codeProvider);
      tradings = tradingList;

      stateTradings.value = StateApp.success;
    } catch (e) {
      stateTradings.value = StateApp.error;
    }
  }

  // Reordena localmente a lista movendo o item de [oldIndex] para [newIndex]
  void reorder(int oldIndex, int newIndex) {
    final list = tradingList.toList();
    if (newIndex > oldIndex) newIndex -= 1;
    final item = list.removeAt(oldIndex);
    list.insert(newIndex, item);
    tradingList = list;
    tradings = list;
  }

  // Persiste a ordem atual da lista atribuindo o sort_order conforme a posição
  Future<bool> saveOrder() async {
    stateSaveOrder.value = StateApp.loading;
    try {
      final orders = <Map<String, dynamic>>[];
      int position = 0;
      for (final trading in tradingList) {
        orders.add({"codNegociacao": trading.code, "sortOrder": position});
        trading.sortOrder = position;
        position++;
      }

      final success = await _tradingsRepository.updateOrder(orders);
      stateSaveOrder.value = success ? StateApp.success : StateApp.error;
      return success;
    } catch (e) {
      print("Error saving tradings order: $e");
      stateSaveOrder.value = StateApp.error;
      return false;
    }
  }

  search(String? value) async {
    stateSearchTrandings.value = StateApp.loading;
    try {
      if (value! == "") {
        tradingList = tradings;
      }
      tradingList = tradings.where((item) {
        return item.title!.toLowerCase().contains(value.toLowerCase());
      });

      stateSearchTrandings.value = StateApp.success;
    } catch (e) {
      print("Error search Requests Stores: $e");
      stateSearchTrandings.value = StateApp.error;
    }
  }
}
