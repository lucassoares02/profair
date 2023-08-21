import 'package:profair/src/repositories/recipe_model.dart';
import 'package:dio/dio.dart';

class ProfileRepository {
  final Dio clientDio = Dio();

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
}
