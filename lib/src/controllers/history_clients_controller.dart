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

  String _sumVolumes(String? first, String? second) {
    final firstValue = int.tryParse(first ?? "0") ?? 0;
    final secondValue = int.tryParse(second ?? "0") ?? 0;
    return (firstValue + secondValue).toString();
  }

  List<HistoryClientsModel> _aggregateByEntityAndEvent(
      List<HistoryClientsModel> items) {
    final grouped = <int, HistoryClientsModel>{};
    final withoutId = <HistoryClientsModel>[];

    for (final item in items) {
      final id = item.id;
      if (id == null) {
        withoutId.add(item);
        continue;
      }

      final current = grouped[id];
      if (current == null) {
        grouped[id] = item;
        continue;
      }

      current.total = (current.total ?? 0) + (item.total ?? 0);
      current.volume = _sumVolumes(current.volume, item.volume);
      item.eventValues.forEach((event, value) {
        current.eventValues[event] = (current.eventValues[event] ?? 0) + value;
      });
      current.totalEvent1 = current.eventValues[1];
      current.totalEvent2 = current.eventValues[2];
    }

    return [...grouped.values, ...withoutId];
  }

  void _completeEventValues() {
    final events =
        historySummaryClients.map((summary) => summary.event).whereType<int>();
    for (final client in historyClients) {
      client.completeMissingEventValues(events);
    }
    for (final provider in historyProviders) {
      provider.completeMissingEventValues(events);
    }
  }

  Future findHistoryClients(int provider) async {
    stateHistoryClients.value = StateApp.loading;
    try {
      historyClientsList =
          await _historyClientsRepository.findHistoryClients(provider);
      historyClients = historyClientsList;
      _completeEventValues();
      stateHistoryClients.value = StateApp.success;
    } catch (e) {
      stateHistoryClients.value = StateApp.error;
    }
  }

  Future findHistoryProviders() async {
    stateHistoryProviders.value = StateApp.loading;
    try {
      final providerRows =
          await _historyClientsRepository.findHistoryProviders();
      historyProvidersList = _aggregateByEntityAndEvent(providerRows);
      historyProviders = historyProvidersList;
      _completeEventValues();
      stateHistoryProviders.value = StateApp.success;
    } catch (e) {
      stateHistoryProviders.value = StateApp.error;
    }
  }

  Future findHistorySummaryClients(int provider) async {
    stateHistorySummaryClients.value = StateApp.loading;
    try {
      historySummaryClients =
          await _historyClientsRepository.findHistorySummaryClients(provider);
      _completeEventValues();
      stateHistorySummaryClients.value = StateApp.success;
    } catch (e) {
      stateHistorySummaryClients.value = StateApp.error;
    }
  }

  int sortProvidersInt = 0;

  search(String? value) async {
    stateHistoryClients.value = StateApp.loading;
    try {
      final query = (value ?? "").toLowerCase();
      if (query.isEmpty) {
        historyClientsList = historyClients;
      } else {
        historyClientsList = historyClients.where((item) {
          return (item.razao ?? "").toLowerCase().contains(query);
        }).toList();
      }

      stateHistoryClients.value = StateApp.success;
    } catch (e) {
      print("Error search Requests Stores: $e");
    }
  }

  searchProviders(String? value) async {
    stateHistoryProviders.value = StateApp.loading;
    try {
      final query = (value ?? "").toLowerCase();
      if (query.isEmpty) {
        historyProvidersList = historyProviders;
      } else {
        historyProvidersList = historyProviders.where((item) {
          return (item.razao ?? "").toLowerCase().contains(query);
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
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);

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
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);

      stateHistoryProviders.value = StateApp.success;
    } catch (e) {
      stateHistoryProviders.value = StateApp.error;
    }
  }
}
