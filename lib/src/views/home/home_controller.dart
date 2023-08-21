import 'dart:developer';

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
  List<CategoriesIcon> categories = [];
  List<NoticeModel> notices = [];
  List<RequestsStoresModel> requestStores = [];
  List<RecipeModel> shared = [];
  List<RecipeModel> stores = [];
  List<BuyersModel> buyers = [];
  LoginModel? data;
  final stateCategories = ValueNotifier<StateApp>(StateApp.start);
  final stateBuyers = ValueNotifier<StateApp>(StateApp.start);
  final stateStore = ValueNotifier<StateApp>(StateApp.start);
  final stateData = ValueNotifier<StateApp>(StateApp.start);
  final stateNotices = ValueNotifier<StateApp>(StateApp.start);
  final stateShared = ValueNotifier<StateApp>(StateApp.start);
  final stateRequestsStore = ValueNotifier<StateApp>(StateApp.start);
  final HomeRepository _homeRepository;

  HomeController(super.value, this._homeRepository);

  Future<LoginModel?> findData() async {
    stateData.value = StateApp.loading;
    try {
      final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      final code = sharedPreferences.getString("codacesso");
      data = await _homeRepository.getData({"codacesso": code});
      await findLastTradings(data!.codCompany);
      getCategories();
      if (data!.accessTargeting == 3) {
        findBuyers();
      }
      stateData.value = StateApp.success;
    } catch (e) {
      stateData.value = StateApp.error;
    }
    return null;
  }

  Future<LoginModel?> findClient(String id) async {
    stateStore.value = StateApp.loading;
    try {
      return await _homeRepository.getClient(id);
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

  Future findNotices() async {
    stateNotices.value = StateApp.loading;
    try {
      notices = await _homeRepository.getNotices();
      stateNotices.value = StateApp.success;
    } catch (e) {
      stateNotices.value = StateApp.error;
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

  Future findLastTradings(int? codeProvider) async {
    stateRequestsStore.value = StateApp.loading;
    try {
      requestStores = await _homeRepository.getLastTradings(codeProvider);
    } catch (e) {
      stateRequestsStore.value = StateApp.error;
    }
    stateRequestsStore.value = StateApp.success;
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
