import 'package:profair/src/models/login_model.dart';
import 'package:dio/dio.dart';

class LoginRepository {
  final Dio clientDio = Dio();
  final String url = "https://profair.click/";

  Future getLogin(Object data) async {
    clientDio.options.contentType = Headers.formUrlEncodedContentType;

    try {
      final response = await clientDio.post("https://profair.click/getuser", data: data);
      print(response);
      final list = response.data[0];
      return LoginModel.fromJson(list);
    } catch (e) {
      print("Error post login $e");
      return e;
    }
  }
}
