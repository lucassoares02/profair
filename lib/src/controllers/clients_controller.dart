import 'package:profair/src/repositories/clients_repository.dart';
import 'package:profair/src/models/clients_model.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:flutter/material.dart';

class ClientsController extends ValueNotifier<StateApp> {
  Iterable<ClientsModel> clientsList = [];
  Iterable<ClientsModel> clients = [];

  final stateSearchClients = ValueNotifier<StateApp>(StateApp.start);

  final stateClients = ValueNotifier<StateApp>(StateApp.start);

  final ClientsRepository _clientsRepository;

  ClientsController(super.value, this._clientsRepository);

  Future findClients({String? codeProvider, int? accessTargenting, int? merchandise, int? trading}) async {
    stateClients.value = StateApp.loading;
    try {
      clientsList = await _clientsRepository.getClients(codeProvider, accessTargenting!, merchandise!, trading!);
      clients = clientsList;

      stateClients.value = StateApp.success;
    } catch (e) {
      stateClients.value = StateApp.error;
    }
  }

  search(String? value) async {
    stateSearchClients.value = StateApp.loading;
    try {
      if (value! == "") {
        clientsList = clients;
      }
      clientsList = clients.where((item) {
        return item.nameCompany!.toLowerCase().contains(value.toLowerCase());
      });

      stateSearchClients.value = StateApp.success;
    } catch (e) {
      print("Error search Requests Stores: $e");
      stateSearchClients.value = StateApp.error;
    }
  }
}
