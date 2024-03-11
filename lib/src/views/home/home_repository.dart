import 'dart:developer';

import 'package:profair/src/models/login_model.dart';
import 'package:profair/src/models/providers_model.dart';
import 'package:profair/src/repositories/buyers_model.dart';
import 'package:profair/src/repositories/campaign_model.dart';
import 'package:profair/src/repositories/categories_icon.dart';
import 'package:profair/src/repositories/categories_model.dart';
import 'package:profair/src/repositories/recipe_model.dart';
import 'package:profair/src/repositories/requests_stores_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class HomeRepository {
  final Dio clientDio = Dio();
  final String url = "https://seller-backend.onrender.com/";

  Future<List<LoginModel>?> getData(Object data) async {
    clientDio.options.contentType = Headers.formUrlEncodedContentType;

    try {
      // final response = await clientDio.post("https://seller-backend.onrender.com/getuser", data: data);
      final response = await clientDio.post("https://seller-backend.onrender.com/getusermore", data: data);
      inspect(response);

      List list = response.data as List;

      return list.map((json) => LoginModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint("Get Data (Home Repository) Error: $e");
      return null;
    }
  }

  Future<LoginModel> getClient(String id) async {
    clientDio.options.contentType = Headers.formUrlEncodedContentType;

    final response = await clientDio.get("${url}client/$id");

    final item = response.data[0];
    return LoginModel.fromJson(item);
  }

  getCategoriesHome() async {
    final response = await clientDio.post('https://profair-backend.onrender.com/categories');
    List list = response.data as List;
    return list.map((json) => CategoriesModel.fromJson(json)).toList();
  }

  getNotices() async {
    try {
      final response = await clientDio.get('${url}notices');
      List list = response.data as List;
      return list.map((json) => CampaignModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint("Get Notices (Home Repository) Error: $e");
    }
  }

  getTopFourProviders(int codBranch) async {
    try {
      final response = await clientDio.get('${url}requesttopproviderclient/$codBranch');
      List list = response.data as List;
      return list.map((json) => ProvidersModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint("Get Top Four Providers (Home Repository) Error: $e");
      rethrow;
    }
  }

  getSharedHome() async {
    final response = await clientDio.get('https://profair-backend.onrender.com/cookbook');
    List list = response.data as List;
    return list.map((json) => RecipeModel.fromJson(json)).toList();
  }

  getLastTradings(int? codeProvider, int accessTargeting) async {
    Response? response;
    if (accessTargeting == 1) {
      response = await clientDio.get('${url}requestsprovider/$codeProvider');
    } else if (accessTargeting == 2) {
      response = await clientDio.get('${url}requestsnegotiationbyclient/$codeProvider');
    } else {
      response = await clientDio.get('${url}requestsclients/$codeProvider');
    }
    List list = response.data as List;
    return list.map((json) => RequestsStoresModel.fromJson(json)).toList();
  }

  getBuyers() async {
    final response = await clientDio.get('${url}buyers');
    List list = response.data as List;
    return list.map((json) => BuyersModel.fromJson(json)).toList();
  }

  getCategoriesss(int code) async {
    List list = [
      if (code == 1)
        {
          "id": 14,
          "title": 'Novo',
          "icon": Icons.add_outlined,
          "route": "selectstore",
        },
      if (code == 1)
        {
          "id": 34,
          "title": 'Produtos',
          "icon": Icons.shopping_basket_rounded,
          "route": "productsprovider",
        },
      if (code == 3)
        {
          "id": 54,
          "title": code == 1 ? 'Clientes' : 'Assoc...',
          "icon": Icons.groups_2_sharp,
          "route": "clients",
        },
      if (code == 3)
        {
          "id": 64,
          "title": 'Forne...',
          "icon": Icons.business_rounded,
          "route": "selectprovider",
        },
      if (code == 1)
        {
          "id": 84,
          "title": 'Negociações',
          "icon": Icons.swap_horiz_rounded,
          "route": "tradings",
        },
      // {
      //   "id": 84,
      //   "title": 'Relatórios',
      //   "icon": Icons.show_chart_rounded,
      //   "route": "reports",
      // },
      // if (code == 2)
      //   {
      //     "id": 94,
      //     "title": 'Ticket',
      //     "icon": Icons.qr_code_rounded,
      //     "route": "ticket",
      //   },
      // {
      //   "id": 74,
      //   "title": 'Dúvidas',
      //   "icon": Icons.messenger_outline_outlined,
      //   "route": "faq",
      // },
      // {
      //   "id": 24,
      //   "title": 'Contatos',
      //   "icon": Icons.phone,
      //   "route": "contacts",
      // },
    ];
    return list.map((json) => CategoriesIcon.fromJson(json)).toList();
  }
}
