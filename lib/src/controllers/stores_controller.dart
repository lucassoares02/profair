import 'package:profair/src/models/clients_model.dart';
import 'package:profair/src/repositories/stores_repository.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:flutter/material.dart';

class StoresController extends ValueNotifier<StateApp> {
  List<ClientsModel> stores = [];
  int? codeProvider;

  final stateStores = ValueNotifier<StateApp>(StateApp.start);

  final StoresRepository _storesRepository;

  StoresController(super.value, this._storesRepository);

  Future findStores(String? codeAcess) async {
    stateStores.value = StateApp.loading;
    try {
      stores = await _storesRepository.getStores(codeAcess);
      stateStores.value = StateApp.success;
    } catch (e) {
      stateStores.value = StateApp.error;
    }
  }
}
