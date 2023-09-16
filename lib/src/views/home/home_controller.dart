import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:profair/provider/appwriter.dart';
import 'package:profair/src/models/login_model.dart';
import 'package:profair/src/repositories/buyers_model.dart';
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
  List<BuyersModel> buyers = [];
  LoginModel? data;
  List<LoginModel>? moreData;
  DocumentList? alerts;
  int indexSelected = 0;

  final stateCategories = ValueNotifier<StateApp>(StateApp.start);
  final stateBuyers = ValueNotifier<StateApp>(StateApp.start);
  final stateStore = ValueNotifier<StateApp>(StateApp.start);
  final stateData = ValueNotifier<StateApp>(StateApp.start);
  final stateAlert = ValueNotifier<StateApp>(StateApp.start);
  final stateNoticesAppWrite = ValueNotifier<StateApp>(StateApp.start);
  final stateShared = ValueNotifier<StateApp>(StateApp.start);
  final stateRequestsStore = ValueNotifier<StateApp>(StateApp.start);

  final HomeRepository _homeRepository;
  DocumentList? documents;

  Future<LoginModel?> findData(AppWrite appWriteSend) async {
    stateData.value = StateApp.loading;
    try {
      final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      final code = sharedPreferences.getString("codacesso");

      moreData = await _homeRepository.getData({"codacesso": code});
      print("moreData");
      print(moreData);
      data = moreData![indexSelected];

      int codeRequest = 0;
      if (data!.accessTargeting == 1) {
        codeRequest = data!.codCompany!;
      } else if (data!.accessTargeting == 2) {
        codeRequest = data!.userCode!;
      }
      await findLastTradings(codeRequest, data!.accessTargeting);
      getCategories();
      if (data!.accessTargeting == 3) {
        findBuyers();
      }

      if (data!.accessTargeting != null) {
        findAlert(appWriteSend, data!.accessTargeting!);
      }
      stateData.value = StateApp.success;
    } catch (e) {
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

  Future<LoginModel?> findBuyers() async {
    stateBuyers.value = StateApp.loading;
    try {
      buyers = await _homeRepository.getBuyers();
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

  // Future findNotices() async {
  //   stateNotices.value = StateApp.loading;
  //   try {
  //     notices = await _homeRepository.getNotices();
  //     stateNotices.value = StateApp.success;
  //   } catch (e) {
  //     stateNotices.value = StateApp.error;
  //   }
  // }

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

  findDoc(AppWrite appWriteSend) async {
    stateNoticesAppWrite.value = StateApp.loading;
    try {
      // documents = await appWriteSend.getDocuments("64e4fd339e70e9e3f1ca", []);
      final teste = await appWriteSend.getDocuments("64e4fd339e70e9e3f1ca", []);
      documents = teste;

      stateNoticesAppWrite.value = StateApp.success;
    } catch (e) {
      print("Error FIND DOC$e");
      stateNoticesAppWrite.value = StateApp.error;
    }
  }

  Future findAlert(AppWrite appWriteSend, int accessTargeting) async {
    stateAlert.value = StateApp.loading;
    try {
      alerts = await appWriteSend.getDocuments("64ea1ced75f87c91474e", [
        Query.orderDesc("priority"),
        Query.equal("direction", [0, accessTargeting])
      ]);

      stateAlert.value = StateApp.success;
    } catch (e) {
      stateAlert.value = StateApp.error;
    }
  }

  Future findAlertCurrentTime(AppWrite appWriteSend) async {
    try {
      alerts = await appWriteSend.getDocuments("64ea1ced75f87c91474e", [Query.orderDesc("priority")]);

      stateAlert.value = StateApp.loading;
      stateAlert.value = StateApp.success;
    } catch (e) {
      stateAlert.value = StateApp.error;
    }
  }

  Future getNoticeAppWrite(AppWrite appWriteSend) async {
    stateNoticesAppWrite.value = StateApp.loading;
    try {
      final subscription = await appWriteSend.listDocumentsRealTime();
      subscription.stream.listen((response) {
        if (response.channels[1].toString().contains("64ea1ced75f87c91474e")) {
          final indexAlerts = alerts!.documents.indexWhere((item) => (item.$id).toString() == response.payload["\$id"].toString());
          if (indexAlerts != -1) {
            findAlertCurrentTime(appWriteSend);
            // stateAlert.value = StateApp.loading;
            // alerts!.documents[indexAlerts].data["title"] = response.payload["title"];
            // alerts!.documents[indexAlerts].data["time"] = response.payload["time"];
            // alerts!.documents[indexAlerts].data["description"] = response.payload["description"];
            // alerts!.documents[indexAlerts].data["priority"] = response.payload["priority"];
            // stateAlert.value = StateApp.success;
          }
        }

        final index = documents!.documents.indexWhere((item) => (item.$id).toString() == response.payload["\$id"].toString());
        if (index != -1) {
          stateNoticesAppWrite.value = StateApp.loading;
          documents!.documents[index].data["title"] = response.payload["title"];
          documents!.documents[index].data["content"] = response.payload["content"];
          documents!.documents[index].data["color"] = response.payload["color"];
          documents!.documents[index].data["stamp"] = response.payload["stamp"];
          documents!.documents[index].data["colorStamp"] = response.payload["colorStamp"];
          stateNoticesAppWrite.value = StateApp.success;
        }
      });
    } catch (e) {
      print("Error Init Real Time:f $e");
      stateNoticesAppWrite.value = StateApp.error;
    }
  }

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
