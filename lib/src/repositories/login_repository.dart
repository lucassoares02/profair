import 'package:profair/src/models/login_model.dart';
import 'package:dio/dio.dart';

class LoginRepository {
  final Dio clientDio = Dio();
  final String url = "https://seller-backend.onrender.com/";

  Future getLogin(Object data) async {
    clientDio.options.contentType = Headers.formUrlEncodedContentType;

    try {
      final response = await clientDio.post("https://seller-backend.onrender.com/getuser", data: data);
      final list = response.data[0];
      return LoginModel.fromJson(list);
    } catch (e) {
      print("Error post login $e");
      return e;
    }
  }
}
