import 'dart:developer';

import 'package:profair/src/models/login_model.dart';
import 'package:profair/src/models/providers_model.dart';
import 'package:profair/src/models/response_model.dart';
import 'package:profair/src/notification/notification_details_model.dart';
import 'package:profair/src/notification/notification_model.dart';
import 'package:profair/src/notification/notification_user_model.dart';
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
  List<CustomNotification> notifications = [];
  NotificationDetailsModel? notification;
  NoticeModel? notice;
  ProvidersModel? provider;
  List<NotificationUserModel> notificationsPeding = [];
  List<BuyersModel> buyers = [];
  CampaignModel? campaign;
  List<CampaignModel> campaigns = [];
  LoginModel? data;
  List<LoginModel>? moreData;

  int indexSelected = 0;

  final stateCategories = ValueNotifier<StateApp>(StateApp.start);
  final stateBuyers = ValueNotifier<StateApp>(StateApp.start);
  final stateStore = ValueNotifier<StateApp>(StateApp.start);
  final stateNotifications = ValueNotifier<StateApp>(StateApp.start);
  final stateNotice = ValueNotifier<StateApp>(StateApp.start);
  final stateProvider = ValueNotifier<StateApp>(StateApp.start);
  final stateNotification = ValueNotifier<StateApp>(StateApp.start);
  final stateNotificationsPending = ValueNotifier<StateApp>(StateApp.start);

  final stateCheckNotificationsPending = ValueNotifier<StateApp>(StateApp.start);
  final stateData = ValueNotifier<StateApp>(StateApp.start);
  final stateCampaign = ValueNotifier<StateApp>(StateApp.start);
  final stateTopProvider = ValueNotifier<StateApp>(StateApp.start);
  final stateAlert = ValueNotifier<StateApp>(StateApp.start);
  final stateShared = ValueNotifier<StateApp>(StateApp.start);
  final stateRequestsStore = ValueNotifier<StateApp>(StateApp.start);
  final stateSaveToken = ValueNotifier<StateApp>(StateApp.start);
  final stateSaveAction = ValueNotifier<StateApp>(StateApp.start);

  final HomeRepository _homeRepository;

  Future<LoginModel?> findData() async {
    stateData.value = StateApp.loading;
    try {
      final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      final code = sharedPreferences.getString("codacesso");

      moreData = await _homeRepository.getData({"codacesso": code});

      inspect(moreData);

      if (moreData != null && moreData!.isNotEmpty) {
        final info = moreData![indexSelected];
        if (info.history != null) {
          sharedPreferences.setInt("history", info.history!);
        }
      }

      data = moreData![indexSelected];

      try {
        sharedPreferences.setInt("codeUser", data!.userCode!);
      } catch (e) {
        print("Error saving codeUser to shared preferences: $e");
      }

      int codeRequest = 0;
      if (data!.accessTargeting == 1 || data!.accessTargeting == 2) {
        codeRequest = data!.codCompany!;
      }
      // await findLastTradings(codeRequest, data!.accessTargeting);
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

  Future<void> findNotifications() async {
    stateNotifications.value = StateApp.loading;
    try {
      final response = await _homeRepository.getNotifications();
      notifications = response;
      stateNotifications.value = StateApp.success;
    } catch (e) {
      stateNotifications.value = StateApp.error;
    }
  }

  Future<void> findNotification(int id) async {
    stateNotification.value = StateApp.loading;
    try {
      final response = await _homeRepository.getNotification(id);
      notification = response[0];
      stateNotification.value = StateApp.success;
    } catch (e) {
      stateNotification.value = StateApp.error;
    }
  }

  Future<void> getNotice(int id) async {
    stateNotice.value = StateApp.loading;
    try {
      final response = await _homeRepository.getNotice(id);
      notice = response;
      stateNotice.value = StateApp.success;
    } catch (e) {
      debugPrint("Get Notice (Home Controller) Error: $e");
      stateNotice.value = StateApp.error;
    }
  }

  Future<void> getProvider(int id) async {
    stateProvider.value = StateApp.loading;
    try {
      final response = await _homeRepository.getProvider(id);
      provider = response;
      stateProvider.value = StateApp.success;
    } catch (e) {
      debugPrint("Get Provider (Home Controller) Error: $e");
      stateProvider.value = StateApp.error;
    }
  }

  Future<void> checkNotificationsUser() async {
    stateNotificationsPending.value = StateApp.loading;
    try {
      final response = await _homeRepository.checkNotificationsUser();
      notificationsPeding = response;
      stateNotificationsPending.value = StateApp.success;
    } catch (e) {
      stateNotificationsPending.value = StateApp.error;
    }
  }

  Future<void> updateNotification(Object data) async {
    await _homeRepository.updateNotification(data);
  }

  Future<void> sendCheckNotificationsUser() async {
    stateCheckNotificationsPending.value = StateApp.loading;
    try {
      await _homeRepository.confirmCheckNotificationsUser();
      stateCheckNotificationsPending.value = StateApp.success;
      checkNotificationsUser();
    } catch (e) {
      stateCheckNotificationsPending.value = StateApp.error;
    }
  }

  Future findCampaign() async {
    stateCampaign.value = StateApp.loading;
    try {
      List<CampaignModel?> response = await _homeRepository.getNotices();
      campaigns = response.whereType<CampaignModel>().toList();
      campaign = campaigns.isNotEmpty ? campaigns.first : CampaignModel();
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
      final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      final history = sharedPreferences.getInt("history");

      categories = await _homeRepository.getCategoriesss(data!.accessTargeting!, history: history);

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

  Future postAction(String user, String notice, String action) async {
    stateSaveAction.value = StateApp.loading;
    try {
      requestStores = await _homeRepository.postAction(user, notice, action);
    } catch (e) {
      stateSaveAction.value = StateApp.error;
    }
    stateSaveAction.value = StateApp.success;
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
