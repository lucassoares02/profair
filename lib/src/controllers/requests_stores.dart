import 'package:profair/src/repositories/requests_stores_repository.dart';
import 'package:profair/src/repositories/requests_stores_model.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:flutter/material.dart';

class RequestsStoresController extends ValueNotifier<StateApp> {
  Iterable<RequestsStoresModel> requestsStores = [];
  Iterable<RequestsStoresModel> requests = [];

  final stateSearchStore = ValueNotifier<StateApp>(StateApp.start);

  final stateStores = ValueNotifier<StateApp>(StateApp.start);

  final RequestsStoresRepository _requestsStoresRepository;

  RequestsStoresController(super.value, this._requestsStoresRepository);

  Future findRequestsStores(int? codeProvider, int? userCode) async {
    stateStores.value = StateApp.loading;
    try {
      requestsStores = await _requestsStoresRepository.getRequestsStores(codeProvider, userCode);
      requests = requestsStores;

      stateStores.value = StateApp.success;
    } catch (e) {
      stateStores.value = StateApp.error;
    }
  }

  search(String? value) async {
    stateSearchStore.value = StateApp.loading;
    try {
      if (value! == "") {
        requestsStores = requests;
      }
      requestsStores = requests.where((item) {
        return item.razaoClient!.toLowerCase().contains(value.toLowerCase());
      });

      stateSearchStore.value = StateApp.success;
    } catch (e) {
      print("Error search Requests Stores: $e");
      stateSearchStore.value = StateApp.error;
    }
  }
}
