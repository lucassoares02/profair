import 'package:fluttertoast/fluttertoast.dart';

resolvePromise({required Future promise, bool viewToast = false}) async {
  return await promise.then((value) {
    if (viewToast) toastAlert(message: "Salvo com sucesso!");
    return value;
  }).catchError((error) {
    print("Error Promise: $error");
    if (viewToast) toastAlert(message: "Parece que algo deu errado, tente novamente!", isError: true);
    return error;
  });
}

toastAlert({required String message, bool isError = false}) {
  if (isError) {
    Fluttertoast.showToast(msg: message, webBgColor: "linear-gradient(to right, #ff0000, #ff0000)");
  } else {
    Fluttertoast.showToast(msg: message);
  }
}
