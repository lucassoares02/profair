import 'package:profair/src/models/providers_model.dart';
import 'package:profair/src/repositories/providers_repository.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:flutter/material.dart';

class ProvidersController extends ValueNotifier<StateApp> {
  Iterable<ProvidersModel> providersList = [];
  Iterable<ProvidersModel> providers = [];

  final stateSearchProviders = ValueNotifier<StateApp>(StateApp.start);

  final stateProviders = ValueNotifier<StateApp>(StateApp.start);

  final ProvidersRepository _providersRepository;

  ProvidersController(super.value, this._providersRepository);

  Future findProviders({int? codeClient, int? codeBuyer, int? codeBranch}) async {
    stateProviders.value = StateApp.loading;
    try {
      providersList = await _providersRepository.getProviders(codeClient!, codeBuyer, codeBranch);
      providers = providersList;

      stateProviders.value = StateApp.success;
    } catch (e) {
      stateProviders.value = StateApp.error;
    }
  }

  search(String? value) async {
    stateSearchProviders.value = StateApp.loading;
    try {
      if (value! == "") {
        providersList = providers;
      }
      providersList = providers.where((item) {
        return item.nameProvider!.toLowerCase().contains(value.toLowerCase());
      });

      stateSearchProviders.value = StateApp.success;
    } catch (e) {
      print("Error search Requests Stores: $e");
      stateSearchProviders.value = StateApp.error;
    }
  }
}
