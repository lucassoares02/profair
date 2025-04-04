import 'package:profair/src/models/login_model.dart';
import 'package:profair/src/shared/http_service.dart';

class LoginRepository {
  final httpService = HttpService();

  Future getLogin(Object data) async {
    try {
      final response = await httpService.post("getuser", data);
      print(response);
      final list = response.data[0];
      return LoginModel.fromJson(list);
    } catch (e) {
      print("Error post login $e");
      return e;
    }
  }
}
