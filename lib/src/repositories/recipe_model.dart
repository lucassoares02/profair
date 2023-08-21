import 'package:flutter/material.dart';

class RecipeModel {
  int? id;
  String? title;
  List? ingredients;
  String? preparationMode;
  String? additionalInfo;
  String? portion;
  String? time;
  String? image;
  String? category;
  String? awayCategory;
  dynamic likes;
  dynamic idLike;
  List? preparation;
  bool? emphasis;
  bool? like;
  String? chef;

  RecipeModel({
    this.id,
    this.title,
    this.ingredients,
    this.preparationMode,
    this.additionalInfo,
    this.portion,
    this.time,
    this.image,
    this.category,
    this.awayCategory,
    this.likes,
    this.idLike,
    this.preparation,
    this.emphasis,
    this.like,
    this.chef,
  });

  RecipeModel.fromJson(Map<String, dynamic> json) {
    try {
      id = json['idRecipe'];
      title = json['title'];
      ingredients = json['ingredients'];
      preparationMode = json['preparationMode'];
      additionalInfo = json['additionInfo'];
      portion = json['portion'];
      time = json['time'];
      image = json['image'];
      category = json['category'];
      awayCategory = json['awayCategory'];
      likes = json['likes'];
      idLike = json['idLike'];
      preparation = json['preparation'];
      emphasis = json['emphasis'];
      like = json['like'];
      chef = json['chef'];
    } catch (e) {
      debugPrint('$e');
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idRecipe'] = id;
    data['title'] = title;
    data['ingredients'] = ingredients;
    data['preparationMode'] = preparationMode;
    data['additionInfo'] = additionalInfo;
    data['portion'] = portion;
    data['time'] = time;
    data['image'] = image;
    data['category'] = category;
    data['awayCategory'] = awayCategory;
    data['likes'] = likes;
    data['idLike'] = idLike;
    data['preparation'] = preparation;
    data['emphasis'] = emphasis;
    data['like'] = like;
    data['chef'] = chef;

    return data;
  }
}
