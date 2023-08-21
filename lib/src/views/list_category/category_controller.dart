import 'package:profair/src/state/state_app.dart';
import 'package:profair/src/views/list_category/category_repository.dart';
import 'package:profair/src/repositories/recipe_model.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class CategoryController extends ValueNotifier<StateApp> {
  List<RecipeModel> listCategoryItems = [];
  final stateCategoryItems = ValueNotifier<StateApp>(StateApp.start);
  final CategoryRepository _categoryRepository;

  CategoryController(super.value, this._categoryRepository);

  Future categoryItems(category) async {
    stateCategoryItems.value = StateApp.loading;
    try {
      listCategoryItems = await _categoryRepository.getListCategoryItems(category);
      stateCategoryItems.value = StateApp.success;
    } catch (e) {
      stateCategoryItems.value = StateApp.error;
    }
  }
}
