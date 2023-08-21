import 'package:profair/src/repositories/recipe_model.dart';
import 'package:dio/dio.dart';

class CategoryRepository {
  final Dio clientDio = Dio();
  getListCategoryItems(int category) async {
    final response = await clientDio.get('https://profair-backend.onrender.com/recipecategory/$category');
    List list = response.data;
    return list.map((json) => RecipeModel.fromJson(json)).toList();
  }
}
