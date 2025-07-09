import 'dart:developer';
import 'package:fluttertoast/fluttertoast.dart';
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
  int sortInt = 0;
  final TradingsProviderRepository tradingsProviderRepository;
  List<NegotiationResume> negotiationResume = [];
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

  List<NegotiationModel> negotiations = [];
  List<NegotiationModel> negotiationsProductsTrading = [];

  Future findTradingsProvider(int codeBranch, int codeProvider) async {
    stateRequest.value = StateApp.loading;
    try {
      negotiations = await tradingsProviderRepository.getTradingProvider(codeBranch, codeProvider);
      // negotiationsProductsTrading = await tradingsProviderRepository.getTradingProvider(codeBranch, codeProvider);
      negotiations.add(NegotiationModel(title: "Resumo do pedido", merchandises: []));
      negotiationsProductsTrading = negotiations.map((e) => e.clone()).toList();
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

  Future<void> makeSum() async {
    negotiationResume.clear();
    totalValue = 0.0;
    totalVolume = 0;

    // Verifica se há negociações a processar
    if (negotiationsProductsTrading.isEmpty) return;

    for (var negotiation in negotiationsProductsTrading) {
      if (negotiation.negotiation == null || negotiation.merchandises == null) continue;

      double totalNegotiation = 0.0;
      int volumeNegotiation = 0;

      for (var merchandise in negotiation.merchandises!) {
        int amount = int.tryParse(merchandise.amount ?? "0") ?? 0;
        if (amount > 0) {
          totalVolume += amount;
          volumeNegotiation += amount;

          double total = amount * (merchandise.price ?? 0);
          totalNegotiation += total;
          totalValue += total;
        }
      }

      if (volumeNegotiation > 0) {
        negotiationResume.add(
          NegotiationResume(
            negotiation: negotiation.negotiation!,
            description: negotiation.observation ?? '',
            title: negotiation.title ?? '',
            value: totalNegotiation,
            volume: volumeNegotiation,
          ),
        );
      }
    }

    totalValue *= totalCheckedBranch;
    totalVolume *= totalCheckedBranch;

    itemTotal.value = StateApp.loading;
    itemTotal.value = StateApp.success;
  }

  insertInList(int codeBranch, int codeProvider, int codeClient, List<ClientsSelectStoreModel> listBranchs, int codeConsult) async {
    stateFinishTrading.value = StateApp.loading;
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
        try {
          await sendOrder(teste, negotiations[i].negotiation!, codeBranch, codeProvider, codeClient, listBranchs, codeConsult);
          // stateFinishTrading.value = StateApp.success;
        } catch (e) {
          stateFinishTrading.value = StateApp.error;
          rethrow;
        }
      }
    }
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
      debugPrint("Tradings Provider Controller Error: $e");
      stateFinishTrading.value = StateApp.error;
      rethrow;
    }
  }

  search(String? value) async {
    itemSelected.value = -1;
    stateSearchProductsTrading.value = StateApp.loading;
    try {
      if (value == null || value.isEmpty) {
        negotiations[tabSelected].merchandises = negotiationsProductsTrading[tabSelected].merchandises!.toList();
      } else {
        negotiations[tabSelected].merchandises = negotiationsProductsTrading[tabSelected].merchandises!.where((item) {
          return item.title!.toLowerCase().contains(value.toLowerCase());
        }).toList();
        if (negotiations[tabSelected].merchandises!.isEmpty) {
          negotiations[tabSelected].merchandises = negotiationsProductsTrading[tabSelected].merchandises!.where((item) {
            return item.brand!.toLowerCase().contains(value.toLowerCase());
          }).toList();
        }
        if (negotiations[tabSelected].merchandises!.isEmpty) {
          negotiations[tabSelected].merchandises = negotiationsProductsTrading[tabSelected].merchandises!.where((item) {
            return item.complement!.toLowerCase().contains(value.toLowerCase());
          }).toList();
        }
        if (negotiations[tabSelected].merchandises!.isEmpty) {
          negotiations[tabSelected].merchandises = negotiationsProductsTrading[tabSelected].merchandises!.where((item) {
            return item.codeProduct.toString().contains(value);
          }).toList();
        }
      }

      stateSearchProductsTrading.value = StateApp.success;
    } catch (e) {
      print("Error search Requests Stores: $e");
      stateSearchProductsTrading.value = StateApp.error;
    }
  }

  void search1(String? value) {
    stateSearchProductsTrading.value = StateApp.loading;

    if (value == null || value.isEmpty) {
      negotiations = List.from(negotiationsProductsTrading);
    } else {
      final lowerCaseValue = value.toLowerCase();
      negotiations = negotiationsProductsTrading.where((negotiation) {
        return negotiation.merchandises!.any((item) {
          return item.title!.toLowerCase().contains(lowerCaseValue) ||
              item.brand!.toLowerCase().contains(lowerCaseValue) ||
              item.complement!.toLowerCase().contains(lowerCaseValue) ||
              item.codeProduct.toString().contains(value);
        });
      }).toList();
    }

    stateSearchProductsTrading.value = StateApp.success;
  }

  sort() async {
    stateSearchProductsTrading.value = StateApp.loading;
    String? message = "";
    print("sort");
    print(sortInt);
    try {
      if (sortInt == 0) {
        negotiations[tabSelected].merchandises!.sort(((a, b) => (double.parse(b.amount!) * b.price!).compareTo(double.parse(a.amount!) * a.price!)));
        message = "Ordenado por valor total de vendas!";
      } else if (sortInt == 1) {
        negotiations[tabSelected].merchandises!.sort(((a, b) => int.parse(b.amount!) - int.parse(a.amount!)));
        message = "Ordenado volume vendido!";
      } else if (sortInt == 2) {
        negotiations[tabSelected].merchandises!.sort(((a, b) => a.title!.compareTo(b.title!)));
        message = "Ordenado por ordem alfabética!";
      }
      if (sortInt == 2) {
        sortInt = 0;
      } else {
        sortInt += 1;
      }
      Fluttertoast.showToast(msg: message, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, textColor: Colors.white, fontSize: 16.0);

      stateSearchProductsTrading.value = StateApp.success;
    } catch (e) {
      print("Error Sort Tradings Provider: $e");
      stateSearchProductsTrading.value = StateApp.error;
    }
  }
}
