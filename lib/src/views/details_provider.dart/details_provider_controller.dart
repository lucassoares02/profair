import 'package:fluttertoast/fluttertoast.dart';
import 'package:profair/src/models/nogotiation_model.dart';
import 'package:profair/src/repositories/products_provider_model.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:flutter/material.dart';
import 'package:profair/src/views/details_provider.dart/details_provider_repository.dart';

class DetailsProviderController extends ValueNotifier<StateApp> {
  DetailsProviderController(super.value, this._detailsProviderRepository);

  List<NegotiationModel> negotiations = [];
  List<ProductsProviderModel> merchandises = [];
  List<ProductsProviderModel> merchandisesBackup = [];
  final stateNegotiations = ValueNotifier<StateApp>(StateApp.start);
  final stateMerchandises = ValueNotifier<StateApp>(StateApp.start);
  final DetailsProviderRepository _detailsProviderRepository;
  int sortInt = 0;

  Future findNegotiations(int codeBranch, int codeProvider) async {
    stateNegotiations.value = StateApp.loading;
    try {
      negotiations = await _detailsProviderRepository.getNegotiations(codeBranch, codeProvider);
      stateNegotiations.value = StateApp.success;
    } catch (e) {
      print("Error Find Negotiations: $e");
      stateNegotiations.value = StateApp.error;
    }
  }

  Future findMerchandises(int codeClient, int codeProvider) async {
    stateMerchandises.value = StateApp.loading;
    try {
      merchandises = await _detailsProviderRepository.getMerchandises(codeClient, codeProvider);
      merchandisesBackup = merchandises;
      stateMerchandises.value = StateApp.success;
    } catch (e) {
      print("Error Find Merchandises: $e");
      stateMerchandises.value = StateApp.error;
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
