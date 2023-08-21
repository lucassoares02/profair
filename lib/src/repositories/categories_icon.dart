import 'package:flutter/material.dart';

class CategoriesIcon {
  int? id;
  String? title;
  IconData? icon;
  String? route;

  CategoriesIcon({this.id, this.title, this.icon, this.route});

  CategoriesIcon.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    icon = json['icon'];
    route = json['route'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['icon'] = icon;
    data['route'] = route;
    return data;
  }
}
