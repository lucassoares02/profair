import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:profair/src/models/history_clients_model.dart';
import 'package:profair/src/models/history_clients_summary_model.dart';
import 'package:profair/src/repositories/history_clients_repository.dart';
import 'package:profair/src/state/state_app.dart';

class HistoryClientsController extends ValueNotifier<StateApp> {
  HistoryClientsController(super.value, this._historyClientsRepository);

  final HistoryClientsRepository _historyClientsRepository;

  List<HistoryClientsModel> historyClients = [];
  List<HistoryClientsModel> historyProviders = [];
  List<HistoryClientsSummaryModel> historySummaryClients = [];
  List<HistoryClientsModel> historyClientsList = [];
  List<HistoryClientsModel> historyProvidersList = [];
  final stateHistoryClients = ValueNotifier<StateApp>(StateApp.start);
  final stateHistoryProviders = ValueNotifier<StateApp>(StateApp.start);
  final stateHistorySummaryClients = ValueNotifier<StateApp>(StateApp.start);
  int sortInt = 0;

  Future findHistoryClients(int provider) async {
    stateHistoryClients.value = StateApp.loading;
    try {
      historyClientsList = await _historyClientsRepository.findHistoryClients(provider);
      historyClients = historyClientsList;
      stateHistoryClients.value = StateApp.success;
    } catch (e) {
      stateHistoryClients.value = StateApp.error;
    }
  }

  Future findHistoryProviders() async {
    stateHistoryProviders.value = StateApp.loading;
    try {
      historyProvidersList = await _historyClientsRepository.findHistoryProviders();
      historyProviders = historyProvidersList;
      stateHistoryProviders.value = StateApp.success;
    } catch (e) {
      stateHistoryProviders.value = StateApp.error;
    }
  }

  Future findHistorySummaryClients(int provider) async {
    stateHistorySummaryClients.value = StateApp.loading;
    try {
      historySummaryClients = await _historyClientsRepository.findHistorySummaryClients(provider);
      stateHistorySummaryClients.value = StateApp.success;
    } catch (e) {
      stateHistorySummaryClients.value = StateApp.error;
    }
  }

  int sortProvidersInt = 0;

  search(String? value) async {
    stateHistoryClients.value = StateApp.loading;
    try {
      if (value! == "") {
        historyClientsList = historyClients;
      }
      historyClientsList = historyClients.where((item) {
        return item.razao!.toLowerCase().contains(value.toLowerCase());
      }).toList();

      stateHistoryClients.value = StateApp.success;
    } catch (e) {
      print("Error search Requests Stores: $e");
    }
  }

  searchProviders(String? value) async {
    stateHistoryProviders.value = StateApp.loading;
    try {
      if (value! == "") {
        historyProvidersList = historyProviders;
      } else {
        historyProvidersList = historyProviders.where((item) {
          return item.razao!.toLowerCase().contains(value.toLowerCase());
        }).toList();
      }
      stateHistoryProviders.value = StateApp.success;
    } catch (e) {
      print("Error search Providers: $e");
    }
  }

  sort() async {
    stateHistoryClients.value = StateApp.loading;
    String? message = "";
    try {
      if (sortInt == 0) {
        historyClientsList.sort(((a, b) => b.total!.compareTo(a.total!)));
        message = "Ordenado por valor total de vendas!";
      } else if (sortInt == 1) {
        historyClientsList.sort(((a, b) => a.razao!.compareTo(b.razao!)));
        message = "Ordenado por ordem alfabética!";
      }
      if (sortInt == 1) {
        sortInt = 0;
      } else {
        sortInt += 1;
      }
      Fluttertoast.showToast(msg: message, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, textColor: Colors.white, fontSize: 16.0);

      stateHistoryClients.value = StateApp.success;
    } catch (e) {
      stateHistoryClients.value = StateApp.error;
    }
  }

  sortProviders() async {
    stateHistoryProviders.value = StateApp.loading;
    String? message = "";
    try {
      if (sortProvidersInt == 0) {
        historyProvidersList.sort(((a, b) => b.total!.compareTo(a.total!)));
        message = "Ordenado por valor total de vendas!";
      } else if (sortProvidersInt == 1) {
        historyProvidersList.sort(((a, b) => a.razao!.compareTo(b.razao!)));
        message = "Ordenado por ordem alfabética!";
      }
      if (sortProvidersInt == 1) {
        sortProvidersInt = 0;
      } else {
        sortProvidersInt += 1;
      }
      Fluttertoast.showToast(msg: message, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, textColor: Colors.white, fontSize: 16.0);

      stateHistoryProviders.value = StateApp.success;
    } catch (e) {
      stateHistoryProviders.value = StateApp.error;
    }
  }
}
