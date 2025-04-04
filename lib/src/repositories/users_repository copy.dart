import 'package:flutter/material.dart';
import 'package:profair/src/models/users_model.dart';
import 'package:profair/src/shared/http_service.dart';

class UsersRepository {
  final httpService = HttpService();

  getUsers() async {
    try {
      final response = await httpService.get("getallusersorg");

      List list = response.data as List;
      return list.map((json) => UsersModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint("Error return Negotiation Model Mapper: $e");
    }
  }

  getUsersProvider() async {
    try {
      final response = await httpService.get("getallusersprovider");

      List list = response.data as List;
      return list.map((json) => UsersModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint("Error return Negotiation Model Mapper: $e");
    }
  }

  getUsersAssociate() async {
    try {
      final response = await httpService.get("getallusersassociate");

      List list = response.data as List;
      return list.map((json) => UsersModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint("Error return Negotiation Model Mapper: $e");
    }
  }
}
