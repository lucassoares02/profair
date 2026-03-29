import 'package:dio/dio.dart';
import 'package:profair/src/models/response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HttpServiceHistory {
  SharedPreferences? sharedPreferences;

  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://history.profair.click/',
    // baseUrl: 'http://localhost:3001/',
  ));

  // Método GET
  Future<ResponseModel> get(String endpoint, {Map<String, dynamic>? params}) async {
    _dio.options.contentType = Headers.formUrlEncodedContentType;
    try {
      sharedPreferences = await SharedPreferences.getInstance();
      _dio.options.headers.addAll({'user-id': sharedPreferences!.getString('codacesso')});
      Response response = await _dio.get(endpoint, queryParameters: params);
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return ResponseModel(success: true, message: response.statusMessage.toString(), data: response.data);
      } else {
        return ResponseModel(success: false, message: response.statusMessage.toString(), data: response.data);
      }
    } catch (e) {
      return Future.error('Erro na requisição GET: $e');
    }
  }

  // Método POST
  Future<ResponseModel> post(String endpoint, Object data) async {
    _dio.options.contentType = Headers.formUrlEncodedContentType;
    try {
      sharedPreferences = await SharedPreferences.getInstance();
      _dio.options.headers.addAll({'user-id': sharedPreferences!.getString('codacesso')});
      Response response = await _dio.post(endpoint, data: data);
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return ResponseModel(success: true, message: response.statusMessage.toString(), data: response.data);
      } else {
        return ResponseModel(success: false, message: response.statusMessage.toString(), data: response.data);
      }
    } catch (e) {
      return Future.error('Erro na requisição POST: $e');
    }
  }

  // Método DELETE
  Future<ResponseModel> delete(String endpoint) async {
    _dio.options.contentType = Headers.formUrlEncodedContentType;
    try {
      sharedPreferences = await SharedPreferences.getInstance();
      _dio.options.headers.addAll({'user-id': sharedPreferences!.getString('codacesso')});
      Response response = await _dio.delete(endpoint);
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return ResponseModel(success: true, message: response.statusMessage.toString(), data: response.data);
      } else {
        return ResponseModel(success: false, message: response.statusMessage.toString(), data: response.data);
      }
    } catch (e) {
      return Future.error('Erro na requisição DELETE: $e');
    }
  }

  // Método PATCH
  Future<ResponseModel> patch(String endpoint, Object data) async {
    _dio.options.contentType = Headers.formUrlEncodedContentType;
    try {
      sharedPreferences = await SharedPreferences.getInstance();
      _dio.options.headers.addAll({'user-id': sharedPreferences!.getString('codacesso')});
      Response response = await _dio.patch(endpoint, data: data);
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return ResponseModel(success: true, message: response.statusMessage.toString(), data: response.data);
      } else {
        return ResponseModel(success: false, message: response.statusMessage.toString(), data: response.data);
      }
    } catch (e) {
      return Future.error('Erro na requisição PATCH: $e');
    }
  }
}
