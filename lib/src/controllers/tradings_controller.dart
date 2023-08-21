import 'package:profair/src/models/tradings_model.dart';
import 'package:profair/src/repositories/tradings_repository.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:flutter/material.dart';

class TradingsController extends ValueNotifier<StateApp> {
  Iterable<TradingsModel> tradingList = [];
  Iterable<TradingsModel> tradings = [];

  final stateSearchTrandings = ValueNotifier<StateApp>(StateApp.start);

  final stateTradings = ValueNotifier<StateApp>(StateApp.start);

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
