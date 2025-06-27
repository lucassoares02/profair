import 'package:profair/src/models/login_model.dart';
import 'package:profair/src/models/providers_model.dart';
import 'package:profair/src/repositories/buyers_model.dart';
import 'package:profair/src/repositories/campaign_model.dart';
import 'package:profair/src/repositories/categories_icon.dart';
import 'package:profair/src/repositories/notice_model.dart';
import 'package:profair/src/repositories/requests_stores_model.dart';
import 'package:profair/src/views/home/home_repository.dart';
import 'package:profair/src/repositories/recipe_model.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends ValueNotifier<StateApp> {
  HomeController(super.value, this._homeRepository);

  List<CategoriesIcon> categories = [];
  List<NoticeModel> notices = [];
  List<RequestsStoresModel> requestStores = [];
  List<RecipeModel> shared = [];
  List<RecipeModel> stores = [];
  List<ProvidersModel> topProviders = [];
  List<BuyersModel> buyers = [];
  CampaignModel? campaign;
  LoginModel? data;
  List<LoginModel>? moreData;

  int indexSelected = 0;

  final stateCategories = ValueNotifier<StateApp>(StateApp.start);
  final stateBuyers = ValueNotifier<StateApp>(StateApp.start);
  final stateStore = ValueNotifier<StateApp>(StateApp.start);
  final stateData = ValueNotifier<StateApp>(StateApp.start);
  final stateCampaign = ValueNotifier<StateApp>(StateApp.start);
  final stateTopProvider = ValueNotifier<StateApp>(StateApp.start);
  final stateAlert = ValueNotifier<StateApp>(StateApp.start);
  final stateShared = ValueNotifier<StateApp>(StateApp.start);
  final stateRequestsStore = ValueNotifier<StateApp>(StateApp.start);
  final stateSaveToken = ValueNotifier<StateApp>(StateApp.start);

  final HomeRepository _homeRepository;

  Future<LoginModel?> findData() async {
    stateData.value = StateApp.loading;
    try {
      final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      final code = sharedPreferences.getString("codacesso");

      moreData = await _homeRepository.getData({"codacesso": code});

      data = moreData![indexSelected];

      int codeRequest = 0;
      if (data!.accessTargeting == 1 || data!.accessTargeting == 2) {
        codeRequest = data!.codCompany!;
      }
      await findLastTradings(codeRequest, data!.accessTargeting);
      getCategories();
      if (data!.accessTargeting == 3 || data!.accessTargeting == 1) {
        if (data!.accessTargeting == 1) {
          findBuyers(codeProvider: data!.codCompany);
        } else {
          findBuyers();
        }
      }

      if (data!.accessTargeting != null) {
        // findAlert(appWriteSend, data!.accessTargeting!);
      }
      stateData.value = StateApp.success;
    } catch (e) {
      debugPrint("Find Data (Home Controller) Error: $e");
      stateData.value = StateApp.error;
    }
    return null;
  }

  Future logout() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
    return;
  }

  Future<LoginModel?> findClient(String id) async {
    stateStore.value = StateApp.loading;
    try {
      LoginModel? response = await _homeRepository.getClient(id);
      stateStore.value = StateApp.success;
      return response;
    } catch (e) {
      stateStore.value = StateApp.error;
    }
    return null;
  }

  Future findCampaign() async {
    stateCampaign.value = StateApp.loading;
    try {
      List<CampaignModel?> response = await _homeRepository.getNotices();
      campaign = response[3] ?? CampaignModel();
      stateCampaign.value = StateApp.success;
    } catch (e) {
      stateCampaign.value = StateApp.error;
    }
    return null;
  }

  Future findTopProviders() async {
    stateTopProvider.value = StateApp.loading;
    try {
      topProviders = await _homeRepository.getTopFourProviders(data!.codCompany!);
      stateTopProvider.value = StateApp.success;
    } catch (error) {
      debugPrint("Find Top Providers (Home Controller) Error: $error");
      stateTopProvider.value = StateApp.error;
    }
  }

  Future<LoginModel?> findBuyers({int? codeProvider}) async {
    stateBuyers.value = StateApp.loading;
    try {
      buyers = await _homeRepository.getBuyers(codeProvider: codeProvider);
      double soma = 0;
      for (var item in buyers) {
        soma += item.total ?? 0;
      }
      buyers.insert(0, BuyersModel(total: soma, nameBuyer: "Todos", codeBuyer: 0));
      stateBuyers.value = StateApp.success;
    } catch (e) {
      stateBuyers.value = StateApp.error;
    }
    return null;
  }

  Future getCategories() async {
    stateCategories.value = StateApp.loading;
    try {
      categories = await _homeRepository.getCategoriesss(data!.accessTargeting!);
      stateCategories.value = StateApp.success;
    } catch (e) {
      stateCategories.value = StateApp.error;
    }
  }

  Future getShared() async {
    stateShared.value = StateApp.loading;
    try {
      shared = await _homeRepository.getSharedHome();
      stateShared.value = StateApp.success;
    } catch (e) {
      stateShared.value = StateApp.error;
    }
  }

  Future findLastTradings(int? codeProvider, int? accessTargeting) async {
    stateRequestsStore.value = StateApp.loading;
    try {
      requestStores = await _homeRepository.getLastTradings(codeProvider, accessTargeting!);
    } catch (e) {
      stateRequestsStore.value = StateApp.error;
    }
    stateRequestsStore.value = StateApp.success;
  }

  Future postTokenFcm(String user, String token) async {
    stateSaveToken.value = StateApp.loading;
    try {
      requestStores = await _homeRepository.postToken(user, token);
    } catch (e) {
      stateSaveToken.value = StateApp.error;
    }
    stateSaveToken.value = StateApp.success;
  }

  Future findAlert(int accessTargeting) async {}

  String formatCurrency(double amount) {
    String formattedAmount = amount.toStringAsFixed(2);
    formattedAmount = formattedAmount.replaceAll('.', ',');
    List<String> parts = formattedAmount.split(',');
    String integerPart = parts[0];
    String decimalPart = parts[1];

    String formattedIntegerPart = '';
    for (int i = integerPart.length - 1, count = 0; i >= 0; i--, count++) {
      if (count != 0 && count % 3 == 0) {
        formattedIntegerPart = ".$formattedIntegerPart";
      }
      formattedIntegerPart = integerPart[i] + formattedIntegerPart;
    }

    return 'R\$$formattedIntegerPart,$decimalPart';
  }
}
