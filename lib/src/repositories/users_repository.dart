import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:profair/src/models/users_model.dart';

class UsersRepository {
  final Dio clientDio = Dio();
  final String url = "https://profair.click/";

  getUsers() async {
    try {
      final response = await clientDio.get("${url}getallusersorg");

      List list = response.data as List;
      return list.map((json) => UsersModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint("Error return Negotiation Model Mapper: $e");
    }
  }

  getUsersProvider() async {
    try {
      final response = await clientDio.get("${url}getallusersprovider");

      List list = response.data as List;
      return list.map((json) => UsersModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint("Error return Negotiation Model Mapper: $e");
    }
  }

  getUsersAssociate() async {
    try {
      final response = await clientDio.get("${url}getallusersassociate");

      List list = response.data as List;
      return list.map((json) => UsersModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint("Error return Negotiation Model Mapper: $e");
    }
  }
}
