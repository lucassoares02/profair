import 'package:profair/src/models/login_model.dart';
import 'package:profair/src/models/providers_model.dart';
import 'package:profair/src/models/response_model.dart';
import 'package:profair/src/notification/notification_details_model.dart';
import 'package:profair/src/notification/notification_model.dart';
import 'package:profair/src/notification/notification_user_model.dart';
import 'package:profair/src/repositories/buyers_model.dart';
import 'package:profair/src/repositories/campaign_model.dart';
import 'package:profair/src/repositories/categories_icon.dart';
import 'package:profair/src/repositories/categories_model.dart';
import 'package:profair/src/repositories/recipe_model.dart';
import 'package:profair/src/repositories/requests_stores_model.dart';
import 'package:flutter/material.dart';
import 'package:profair/src/shared/http_service.dart';

class HomeRepository {
  final httpService = HttpService();

  Future<List<LoginModel>?> getData(Object data) async {
    try {
      final response = await httpService.post("getusermore", data);
      List list = response.data as List;
      return list.map((json) => LoginModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint("Get Data (Home Repository) Error: $e");
      return null;
    }
  }

  Future<LoginModel> getClient(String id) async {
    final response = await httpService.get("client/$id");
    final item = response.data[0];
    return LoginModel.fromJson(item);
  }

  getCategoriesHome() async {
    final response = await httpService.post('categories', {});
    List list = response.data as List;
    return list.map((json) => CategoriesModel.fromJson(json)).toList();
  }

  getNotices() async {
    try {
      final response = await httpService.get('notices');
      List list = response.data as List;
      return list.map((json) => CampaignModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint("Get Notices (Home Repository) Error: $e");
    }
  }

  getTopFourProviders(int codBranch) async {
    try {
      final response = await httpService.get('requesttopproviderclient/$codBranch');
      List list = response.data as List;
      return list.map((json) => ProvidersModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint("Get Top Four Providers (Home Repository) Error: $e");
      rethrow;
    }
  }

  getSharedHome() async {
    final response = await httpService.get('https://profair-backend.onrender.com/cookbook');
    List list = response.data as List;
    return list.map((json) => RecipeModel.fromJson(json)).toList();
  }

  getLastTradings(int? codeProvider, int accessTargeting) async {
    ResponseModel? response;
    if (accessTargeting == 1) {
      response = await httpService.get('requestsprovider/$codeProvider');
    } else if (accessTargeting == 2) {
      response = await httpService.get('requestsnegotiationbyclient/$codeProvider');
    } else {
      response = await httpService.get('requestsclients/$codeProvider');
    }
    List list = response.data as List;
    return list.map((json) => RequestsStoresModel.fromJson(json)).toList();
  }

  getBuyers({int? codeProvider}) async {
    ResponseModel? response;
    if (codeProvider != null) {
      response = await httpService.get('buyersprovider/$codeProvider');
    } else {
      response = await httpService.get('buyers');
    }
    List list = response.data as List;
    return list.map((json) => BuyersModel.fromJson(json)).toList();
  }

  getNotifications() async {
    ResponseModel? response;
    try {
      response = await httpService.get('notifications');
      List list = response.data as List;
      return list.map((json) => CustomNotification.fromJson(json)).toList();
    } catch (e) {
      debugPrint("Get Notifications (Home Repository) Error: $e");
      rethrow;
    }
  }

  updateNotification(Object data) async {
    try {
      await httpService.post('/notification/opened', data);
      return true;
    } catch (e) {
      debugPrint("Get Notifications (Home Repository) Error: $e");
      rethrow;
    }
  }

  getNotification(int notification) async {
    ResponseModel? response;
    try {
      response = await httpService.get('notification/$notification');
      List list = response.data as List;
      return list.map((json) => NotificationDetailsModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint("Get Notifications (Home Repository) Error: $e");
      rethrow;
    }
  }

  checkNotificationsUser() async {
    ResponseModel? response;
    try {
      response = await httpService.get('notification/pending');
      List list = response.data as List;
      print("Notifications User: ${response.data}");
      return list.map((json) => NotificationUserModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint("Get Pending Notifications (Home Repository) Error: $e");
      rethrow;
    }
  }

  confirmCheckNotificationsUser() async {
    ResponseModel? response;
    try {
      response = await httpService.get('notification/check');
      return response;
    } catch (e) {
      debugPrint("Get Check Notifications (Home Repository) Error: $e");
      rethrow;
    }
  }

  postToken(String user, String token) async {
    try {
      ResponseModel response = await httpService.post('notification/save/token', {
        "userId": user,
        "tokenFcm": token,
      });
      print(response.data);
    } catch (e) {
      debugPrint("Post Token (Home Repository) Error: $e");
    }
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
      if (code == 3 || code == 1)
        {
          "id": 54,
          "title": code == 1 ? 'Clientes' : 'Lojas',
          "icon": Icons.store,
          "route": "clients",
        },
      // if (code == 3)
      //   {
      //     "id": 64,6
      //     "title": 'Fornecedores',
      //     "icon": Icons.business_rounded,
      //     "route": "selectprovider",
      //   },
      if (code == 3)
        {
          "id": 94,
          "title": 'Usuários',
          "icon": Icons.group_outlined,
          "route": "users",
        },
      if (code == 1)
        {
          "id": 84,
          "title": 'Prazos',
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
