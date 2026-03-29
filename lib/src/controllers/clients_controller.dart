import 'package:fluttertoast/fluttertoast.dart';
import 'package:profair/src/repositories/clients_repository.dart';
import 'package:profair/src/models/clients_model.dart';
import 'package:profair/src/repositories/percentage_clients_model.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:flutter/material.dart';

class ClientsController extends ValueNotifier<StateApp> {
  ClientsController(super.value, this._clientsRepository);

  final ClientsRepository _clientsRepository;

  List<ClientsModel> clientsList = [];
  List<ClientsModel> clients = [];

  final stateSearchClients = ValueNotifier<StateApp>(StateApp.start);

  final stateClients = ValueNotifier<StateApp>(StateApp.start);
  final statePercentageClients = ValueNotifier<StateApp>(StateApp.start);

  PercentageClientsModel? percentageClients;
  int sortInt = 0;

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

  Future findPercentageClients(int provider) async {
    statePercentageClients.value = StateApp.loading;
    try {
      List<PercentageClientsModel> clientsPercentage = await _clientsRepository.getPercentageProviders(provider);
      percentageClients = clientsPercentage.first;
      print("Percentage Clients: ${percentageClients!.percentage}");
      statePercentageClients.value = StateApp.success;
    } catch (e) {
      statePercentageClients.value = StateApp.error;
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
      }).toList();

      stateSearchClients.value = StateApp.success;
    } catch (e) {
      print("Error search Requests Stores: $e");
      stateSearchClients.value = StateApp.error;
    }
  }

  sort() async {
    stateClients.value = StateApp.loading;
    String? message = "";
    try {
      if (sortInt == 0) {
        clients.sort(((a, b) => b.totalValue!.compareTo(a.totalValue!)));
        message = "Ordenado por valor total de vendas!";
      } else if (sortInt == 1) {
        clients.sort(((a, b) => int.parse(b.totalVolume!) - int.parse(a.totalVolume!)));
        message = "Ordenado volume vendido!";
      } else if (sortInt == 2) {
        clients.sort(((a, b) => a.nameCompany!.compareTo(b.nameCompany!)));
        message = "Ordenado por ordem alfabética!";
      }
      if (sortInt == 2) {
        sortInt = 0;
      } else {
        sortInt += 1;
      }
      Fluttertoast.showToast(msg: message, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, textColor: Colors.white, fontSize: 16.0);

      stateClients.value = StateApp.success;
    } catch (e) {
      print("Error Sort Stores: $e");
      stateClients.value = StateApp.error;
    }
  }
}
