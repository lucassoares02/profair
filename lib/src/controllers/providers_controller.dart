import 'package:fluttertoast/fluttertoast.dart';
import 'package:profair/src/models/providers_model.dart';
import 'package:profair/src/repositories/providers_repository.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:flutter/material.dart';

class ProvidersController extends ValueNotifier<StateApp> {
  List<ProvidersModel> providersList = [];
  List<ProvidersModel> providers = [];

  final stateSearchProviders = ValueNotifier<StateApp>(StateApp.start);
  List<int> sellCounts = [0, 0, 0];

  final stateProviders = ValueNotifier<StateApp>(StateApp.start);
  final stateMap = ValueNotifier<StateApp>(StateApp.start);
  String? mapUrl;
  int? codOrg;

  final ProvidersRepository _providersRepository;

  ProvidersController(super.value, this._providersRepository);

  Future findProviders({int? codeClient, int? codeBuyer, int? codeBranch}) async {
    stateProviders.value = StateApp.loading;
    try {
      providersList = await _providersRepository.getProviders(codeClient!, codeBuyer, codeBranch);
      providers = providersList;
      sellCounts = [
        providersList.length,
        providersList.where((item) => item.totalValue! > 0.0).length,
        providersList.where((item) => item.totalValue! == 0.0).length,
      ];
      stateProviders.value = StateApp.success;
    } catch (e) {
      stateProviders.value = StateApp.error;
    }
  }

  Future findProvidersByGroup({int? codeClient}) async {
    stateProviders.value = StateApp.loading;
    try {
      providersList = await _providersRepository.getProvidersByGroup(codeClient);
      providers = providersList;

      stateProviders.value = StateApp.success;
    } catch (e) {
      stateProviders.value = StateApp.error;
    }
  }

  Future findMap() async {
    stateMap.value = StateApp.loading;
    try {
      final mapData = await _providersRepository.getMapData();
      mapUrl = mapData["map"];
      codOrg = mapData["codOrg"];
      print("Map URL: $mapUrl | codOrg: $codOrg");

      stateMap.value = StateApp.success;
    } catch (e) {
      stateMap.value = StateApp.error;
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
      }).toList();

      stateSearchProviders.value = StateApp.success;
    } catch (e) {
      print("Error search Requests Stores: $e");
      stateSearchProviders.value = StateApp.error;
    }
  }

  sort(int sortInt) async {
    stateSearchProviders.value = StateApp.loading;
    String? message = "";
    try {
      if (sortInt == 2) {
        providersList.sort(((a, b) => a.nameProvider!.compareTo(b.nameProvider!)));
        message = "Ordenado por ordem alfabética!";
      } else if (sortInt == 1) {
        providersList.sort(((a, b) => int.parse(b.totalVolume!) - int.parse(a.totalVolume!)));
        message = "Ordenado volume vendido!";
      } else if (sortInt == 0) {
        providersList.sort(((a, b) => b.totalValue!.compareTo(a.totalValue!)));
        message = "Ordenado por valor total de vendas!";
      }

      Fluttertoast.showToast(msg: message, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, textColor: Colors.white, fontSize: 16.0);

      stateSearchProviders.value = StateApp.success;
    } catch (e) {
      print("Error Sort Stores: $e");
      stateSearchProviders.value = StateApp.error;
    }
  }

  providerSelling(int status) async {
    stateSearchProviders.value = StateApp.loading;
    try {
      if (status == 0) {
        providersList = providers.toList();
      } else if (status == 1) {
        providersList = providers.where((item) => item.totalValue! == 0.0).toList();
      } else {
        providersList = providers.where((item) => item.totalValue! > 0.0).toList();
      }
      stateSearchProviders.value = StateApp.success;
    } catch (e) {
      print("Error search Requests Stores: $e");
      stateSearchProviders.value = StateApp.error;
    }
  }
}
