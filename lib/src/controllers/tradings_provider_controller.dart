import 'dart:developer';

import 'package:profair/src/models/clients_select_stores_model.dart';
import 'package:profair/src/models/nogotiation_model.dart';
import 'package:profair/src/models/product_model.dart';
import 'package:profair/src/repositories/tradings_provider_repository.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:flutter/material.dart';

class NegotiationResume {
  final int negotiation;
  final String title;
  final String description;
  final double value;
  final int volume;

  NegotiationResume({required this.negotiation, required this.title, required this.description, required this.value, required this.volume});
}

class TradingsProviderController extends ValueNotifier<StateApp> {
  final stateRequest = ValueNotifier<StateApp>(StateApp.start);

  final TradingsProviderRepository tradingsProviderRepository;
  List<NegotiationModel> negotiations = [];
  List<NegotiationResume> negotiationResume = [];
  List<NegotiationModel> firstNegotiations = [];
  List<NegotiationModel> negotiationsProductsTrading = [];
  ValueNotifier<bool> visibleText = ValueNotifier(false);
  ValueNotifier<bool> stateTradings = ValueNotifier(false);
  ValueNotifier<StateApp> stateCheckList = ValueNotifier(StateApp.start);
  ValueNotifier<StateApp> stateSearchProductsTrading = ValueNotifier(StateApp.start);
  final itemTotal = ValueNotifier<StateApp>(StateApp.start);
  ValueNotifier<int> itemSelected = ValueNotifier(-1);
  late TabController tabController;
  double totalValue = 0.0;
  int totalVolume = 0;
  final stateFinishTrading = ValueNotifier<StateApp>(StateApp.start);
  int totalCheckedBranch = 1;
  List<dynamic> actualList = [];
  int tabSelected = 0;

  TradingsProviderController(super.value, this.tradingsProviderRepository);

  Future findTradingsProvider(int codeBranch, int codeProvider) async {
    stateRequest.value = StateApp.loading;
    try {
      negotiations = await tradingsProviderRepository.getTradingProvider(codeBranch, codeProvider);
      firstNegotiations = negotiations;
      negotiationsProductsTrading = await tradingsProviderRepository.getTradingProvider(codeBranch, codeProvider);
      negotiations.add(NegotiationModel(title: "Resumo do pedido", merchandises: []));
      makeSum();
      stateRequest.value = StateApp.success;
    } catch (e) {
      debugPrint("Find Tradings Provider (Tradings Provider Controller) Error: $e");
      stateRequest.value = StateApp.error;
    }
  }

  updateTrading() {
    stateTradings.value = !stateTradings.value;
    makeSum();
  }

  updateProductsTrading(String? value, int indexNegotiation, int index) {
    itemTotal.value = StateApp.loading;
    try {
      value = value != "" ? value : "0";
      negotiations[indexNegotiation].merchandises!.elementAt(index).amount = value;
      makeSum();
      itemTotal.value = StateApp.success;
    } catch (e) {
      debugPrint("$e");
    }
  }

  makeSum() async {
    negotiationResume.clear();
    totalValue = 0.0;
    totalVolume = 0;
    for (var negotiation in negotiations) {
      if (negotiation.negotiation != null) {
        double totalNegotiation = 0.0;
        int volumeNegotiation = 0;
        if (negotiation.merchandises != null) {
          for (var merchandise in negotiation.merchandises!) {
            double? total;
            if (merchandise.amount != "0") {
              totalVolume += int.parse(merchandise.amount!);
              volumeNegotiation += int.parse(merchandise.amount!);
              total = int.parse(merchandise.amount!) * merchandise.price!;
              totalNegotiation += total;
              totalValue += total;
            }
          }
        }
        if (volumeNegotiation != 0) {
          negotiationResume.add(
              NegotiationResume(negotiation: negotiation.negotiation!, description: "${negotiation.observation}", title: "${negotiation.title}", value: totalNegotiation, volume: volumeNegotiation));
        }
      }
    }
    totalValue = totalValue * totalCheckedBranch;
    totalVolume = totalVolume * totalCheckedBranch;
    itemTotal.value = StateApp.loading;
    itemTotal.value = StateApp.success;
  }

  insertInList(int codeBranch, int codeProvider, int codeClient, List<ClientsSelectStoreModel> listBranchs, int codeConsult) async {
    stateFinishTrading.value = StateApp.loading;
    inspect(negotiations);
    inspect(negotiationsProductsTrading);
    for (int i = 0; i < negotiations.length; i++) {
      List<dynamic> teste = [];
      for (int j = 0; j < negotiations[i].merchandises!.length; j++) {
        if (int.parse(negotiations[i].merchandises![j].amount!) > 0 || int.parse(negotiationsProductsTrading[i].merchandises![j].amount!) > 0) {
          teste.add(ProductModel(
                  codeProduct: negotiations[i].merchandises![j].codeProduct,
                  amount: negotiations[i].merchandises![j].amount,
                  brand: negotiations[i].merchandises![j].brand,
                  coefficient: negotiations[i].merchandises![j].coefficient,
                  complement: negotiations[i].merchandises![j].complement,
                  packing: negotiations[i].merchandises![j].packing,
                  price: negotiations[i].merchandises![j].price,
                  title: negotiations[i].merchandises![j].title,
                  total: negotiations[i].merchandises![j].total,
                  unitPrice: negotiations[i].merchandises![j].unitPrice)
              .toJson());
        }
      }
      if (teste.isNotEmpty) {
        await sendOrder(teste, negotiations[i].negotiation!, codeBranch, codeProvider, codeClient, listBranchs, codeConsult);
      }
    }
    stateFinishTrading.value = StateApp.success;
  }

  Future sendOrder(List<dynamic> products, int trading, int? codeBranch, int? codeProvider, int? codeClient, List<ClientsSelectStoreModel> listBranchs, int? codeConsult) async {
    try {
      return await tradingsProviderRepository.postTradingNew(
        products: products,
        tradings: trading,
        codeBranch: codeBranch,
        codeProvider: codeProvider,
        codeClient: codeClient,
        listBranchs: listBranchs,
        codeConsult: codeConsult,
      );
    } catch (e) {
      print("Error save order: $e");
      stateFinishTrading.value = StateApp.error;
      return;
    }
  }

  search(String? value) async {
    stateSearchProductsTrading.value = StateApp.loading;
    try {
      if (value == null || value.isEmpty) {
        negotiations[tabSelected].merchandises = negotiationsProductsTrading[tabSelected].merchandises!.toList();
      } else {
        negotiations[tabSelected].merchandises = negotiationsProductsTrading[tabSelected].merchandises!.where((item) {
          return item.title!.toLowerCase().contains(value.toLowerCase());
        }).toList();
      }

      stateSearchProductsTrading.value = StateApp.success;
    } catch (e) {
      print("Error search Requests Stores: $e");
      stateSearchProductsTrading.value = StateApp.error;
    }
  }
}
