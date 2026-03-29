import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:profair/src/models/history_clients_model.dart';
import 'package:profair/src/models/history_clients_summary_model.dart';
import 'package:profair/src/models/history_clients_tradings_model.dart';
import 'package:profair/src/repositories/history_clients_tradings_repository.dart';
import 'package:profair/src/state/state_app.dart';

class HistoryClientsTradingsController extends ValueNotifier<StateApp> {
  HistoryClientsTradingsController(super.value, this._historyClientsTradingsRepository);

  final HistoryClientsTradingsRepository _historyClientsTradingsRepository;

  List<HistoryClientsSummaryModel> historyClientsSummaryTradings = [];
  List<HistoryClientsTradingsModel> historyClientsTradings = [];
  List<HistoryClientsTradingsModel> historyClientsTradingsList = [];

  List<HistoryClientsModel> historyProvidersByClients = [];
  List<HistoryClientsModel> historyProvidersByClientsList = [];

  final stateHistoryTradingsClients = ValueNotifier<StateApp>(StateApp.start);
  final stateHistoryTradingsProvidersByClient = ValueNotifier<StateApp>(StateApp.start);
  final stateHistoryTradingsSummaryClients = ValueNotifier<StateApp>(StateApp.start);
  int sortInt = 0;

  Future findHistoryClientsTradings(int provider, int client) async {
    stateHistoryTradingsClients.value = StateApp.loading;
    try {
      historyClientsTradingsList = await _historyClientsTradingsRepository.findHistoryClientsTradings(provider, client);
      historyClientsTradings = historyClientsTradingsList;
      stateHistoryTradingsClients.value = StateApp.success;
    } catch (e) {
      stateHistoryTradingsClients.value = StateApp.error;
    }
  }

  Future findHistoryProvidersByClient(int client) async {
    stateHistoryTradingsProvidersByClient.value = StateApp.loading;
    try {
      historyProvidersByClientsList = await _historyClientsTradingsRepository.findHistoryProvidersByClient(client);
      historyProvidersByClients = historyProvidersByClientsList;
      inspect(historyProvidersByClientsList);
      stateHistoryTradingsProvidersByClient.value = StateApp.success;
    } catch (e) {
      stateHistoryTradingsProvidersByClient.value = StateApp.error;
    }
  }

  Future findHistoryProvidersByProvider(int provider) async {
    stateHistoryTradingsProvidersByClient.value = StateApp.loading;
    try {
      historyProvidersByClientsList = await _historyClientsTradingsRepository.findHistoryProvidersByProvider(provider);
      historyProvidersByClients = historyProvidersByClientsList;
      inspect(historyProvidersByClientsList);
      stateHistoryTradingsProvidersByClient.value = StateApp.success;
    } catch (e) {
      stateHistoryTradingsProvidersByClient.value = StateApp.error;
    }
  }

  Future findHistoryClientsSummaryTradings(int provider, int client) async {
    stateHistoryTradingsSummaryClients.value = StateApp.loading;
    try {
      historyClientsSummaryTradings = await _historyClientsTradingsRepository.findHistoryClientsSummaryTradings(provider, client);
      stateHistoryTradingsSummaryClients.value = StateApp.success;
    } catch (e) {
      stateHistoryTradingsSummaryClients.value = StateApp.error;
    }
  }

  Future findHistoryClientsSummaryProviders(int client) async {
    stateHistoryTradingsSummaryClients.value = StateApp.loading;
    try {
      historyClientsSummaryTradings = await _historyClientsTradingsRepository.findHistoryClientsSummaryProviders(client);
      stateHistoryTradingsSummaryClients.value = StateApp.success;
    } catch (e) {
      stateHistoryTradingsSummaryClients.value = StateApp.error;
    }
  }

  Future findHistoryClientsSummaryClients(int provider) async {
    stateHistoryTradingsSummaryClients.value = StateApp.loading;
    try {
      historyClientsSummaryTradings = await _historyClientsTradingsRepository.findHistoryClientsSummaryClients(provider);
      stateHistoryTradingsSummaryClients.value = StateApp.success;
    } catch (e) {
      stateHistoryTradingsSummaryClients.value = StateApp.error;
    }
  }

  search(String? value) async {
    stateHistoryTradingsClients.value = StateApp.loading;
    try {
      if (value! == "") {
        historyClientsTradingsList = historyClientsTradings;
      }
      historyClientsTradingsList = historyClientsTradings.where((item) {
        return item.descNegotiation!.toLowerCase().contains(value.toLowerCase());
      }).toList();

      stateHistoryTradingsClients.value = StateApp.success;
    } catch (e) {
      print("Error search Requests Stores: $e");
    }
  }

  sort() async {
    stateHistoryTradingsClients.value = StateApp.loading;
    String? message = "";
    try {
      if (sortInt == 0) {
        historyClientsTradingsList.sort(((a, b) => b.total!.compareTo(a.total!)));
        message = "Ordenado por valor total de vendas!";
      } else if (sortInt == 1) {
        historyClientsTradingsList.sort(((a, b) => a.descNegotiation!.compareTo(b.descNegotiation!)));
        message = "Ordenado por ordem alfabética!";
      }
      if (sortInt == 1) {
        sortInt = 0;
      } else {
        sortInt += 1;
      }
      Fluttertoast.showToast(msg: message, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, textColor: Colors.white, fontSize: 16.0);

      stateHistoryTradingsClients.value = StateApp.success;
    } catch (e) {
      stateHistoryTradingsClients.value = StateApp.error;
    }
  }
}
