import 'dart:developer';

import 'package:profair/src/models/providers_model.dart';
import 'package:profair/src/repositories/recipe_model.dart';
import 'package:dio/dio.dart';
import 'package:profair/src/repositories/window_negotiation.dart';
import 'package:profair/src/shared/http_service.dart';
import 'package:provider/provider.dart';

class TicketRepository {
  final Dio clientDio = Dio();
  final httpService = HttpService();
  ProvidersModel? provider;

  getLikesProfile() async {
    final response = await clientDio.get('https://profair-backend.onrender.com/recipeshighlights');
    List list = response.data as List;
    return list.map((json) => RecipeModel.fromJson(json)).toList();
  }

  getSharedProfile() async {
    final response = await clientDio.get('https://profair-backend.onrender.com/cookbook');
    List list = response.data as List;
    return list.map((json) => RecipeModel.fromJson(json)).toList();
  }

  Future? getWindowNegotiations(int client) async {
    try {
      final response = await httpService.get("getwindownegotiations/$client");
      return WindowNegotiationModel.fromJson(response.data);
    } catch (e) {
      print("Error in getWindowNegotiations: $e");
      rethrow;
    }
  }

  Future getDetailsProvider(int user) async {
    try {
      final response = await httpService.get("providerdetails/$user");
      return ProvidersModel.fromJson(response.data);
    } catch (e) {
      print("Error in getWindowNegotiations: $e");
      rethrow;
    }
  }
}
