import 'dart:developer';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:profair/src/models/nogotiation_model.dart';
import 'package:profair/src/repositories/products_provider_model.dart';
import 'package:profair/src/repositories/requests_stores_model.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:flutter/material.dart';
import 'package:profair/src/views/details_provider.dart/details_provider_repository.dart';

class DetailsProviderController extends ValueNotifier<StateApp> {
  DetailsProviderController(super.value, this._detailsProviderRepository);

  List<NegotiationModel> negotiations = [];
  List<ProductsProviderModel> merchandises = [];
  List<ProductsProviderModel> merchandisesBackup = [];
  List<RequestsStoresModel> requestsStores = [];
  RequestsStoresModel? request;
  final stateNegotiations = ValueNotifier<StateApp>(StateApp.start);
  final stateMerchandises = ValueNotifier<StateApp>(StateApp.start);
  final stateRequestStores = ValueNotifier<StateApp>(StateApp.start);
  ValueNotifier<int> indexNegotiationSelected = ValueNotifier(0);
  final DetailsProviderRepository _detailsProviderRepository;
  int sortInt = 0;

  Future findNegotiations(int codeBranch, int codeProvider) async {
    stateNegotiations.value = StateApp.loading;
    try {
      negotiations = await _detailsProviderRepository.getNegotiations(codeBranch, codeProvider);
      stateNegotiations.value = StateApp.success;
      if (negotiations.isNotEmpty && negotiations[indexNegotiationSelected.value].negotiation != null) {
        findMerchandises(codeBranch, codeProvider, negotiations[indexNegotiationSelected.value].negotiation!);
        findRequestStores(codeBranch, codeProvider);
      }
    } catch (e) {
      debugPrint("Find Negotiations (Details Provider Controller) Error: $e");
      stateNegotiations.value = StateApp.error;
    }
  }

  Future findMerchandises(int codeBranch, int codeProvider, int codeNegotiation) async {
    stateMerchandises.value = StateApp.loading;
    try {
      merchandises = await _detailsProviderRepository.getMerchandises(codeBranch, codeProvider, codeNegotiation);
      merchandisesBackup = merchandises;
      stateMerchandises.value = StateApp.success;
    } catch (e) {
      debugPrint("Find Merhcandises (Details Provider Controller) Error: $e");
      stateMerchandises.value = StateApp.error;
    }
  }

  Future findRequestStores(int codeBranch, int codeProvider) async {
    stateRequestStores.value = StateApp.loading;
    try {
      requestsStores = await _detailsProviderRepository.getRequestsStores(codeBranch, codeProvider);
      stateRequestStores.value = StateApp.success;
      if (negotiations.isNotEmpty) {
        searchNegotiation(negotiations[0].negotiation!);
      }
    } catch (e) {
      debugPrint("Find Request Stores (Details Provider Controller) Error: $e");
      stateRequestStores.value = StateApp.error;
    }
  }

  search(String? value) async {
    stateMerchandises.value = StateApp.loading;
    try {
      if (value! == "") {
        merchandises = merchandisesBackup;
      }
      merchandises = merchandisesBackup.where((item) {
        return item.nameProduct!.toLowerCase().contains(value.toLowerCase());
      }).toList();

      stateMerchandises.value = StateApp.success;
    } catch (e) {
      print("Error search Requests Stores: $e");
      stateMerchandises.value = StateApp.error;
    }
  }

  searchNegotiation(int value) async {
    stateRequestStores.value = StateApp.loading;
    try {
      for (var i = 0; i < requestsStores.length; i++) {
        if (requestsStores[i].codeNegotiation == value) {
          request = requestsStores[i];
        }
      }
      stateRequestStores.value = StateApp.success;
    } catch (e) {
      print("Error search Negotiation: $e");
      stateRequestStores.value = StateApp.error;
    }
  }

  sort() async {
    stateMerchandises.value = StateApp.loading;
    String? message = "";
    try {
      if (sortInt == 0) {
        merchandises.sort(((a, b) => b.totalValue!.compareTo(a.totalValue!)));
        message = "Ordenado por valor total de vendas!";
      } else if (sortInt == 1) {
        merchandises.sort(((a, b) => int.parse(b.totalVolume!) - int.parse(a.totalVolume!)));
        message = "Ordenado volume vendido!";
      } else if (sortInt == 2) {
        merchandises.sort(((a, b) => a.nameProduct!.compareTo(b.nameProduct!)));
        message = "Ordenado por ordem alfabética!";
      }
      if (sortInt == 2) {
        sortInt = 0;
      } else {
        sortInt += 1;
      }
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);

      stateMerchandises.value = StateApp.success;
    } catch (e) {
      print("Error Sort Stores: $e");
      stateMerchandises.value = StateApp.error;
    }
  }
}
