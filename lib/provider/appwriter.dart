import 'package:appwrite/appwrite.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppWrite {
  Client clientapp = Client();

  initAppWrite() {
    clientapp.setEndpoint('https://cloud.appwrite.io/v1').setProject('64dd30b79119b5dc74d7').setSelfSigned(status: true);
  }

  initSession(email, password) async {
    Account account = Account(clientapp);
    Future promise = account.createEmailSession(email: email, password: password);
    return resolvePromise(promise: promise);
  }

  getUserDetails() async {
    Account account = Account(clientapp);
    Future promise = account.get();
    return resolvePromise(promise: promise);
  }

  listDocumentsApp() async {
    Databases database = Databases(clientapp);
    Future promise = database.listDocuments(databaseId: '64e4ebc2cce8741e7e5b', collectionId: '64e4fd339e70e9e3f1ca');
    return resolvePromise(promise: promise);
  }

  listDocumentsRealTime() async {
    final realtime = Realtime(clientapp);
    return realtime.subscribe(['documents']);
  }

  createUser(String name, String password, String email) async {
    Account account = Account(clientapp);

    Future promise = account.create(userId: ID.unique(), email: email, password: password);
    return resolvePromise(promise: promise, viewToast: true);
  }

  resolvePromise({required Future promise, bool viewToast = false}) async {
    return await promise.then((value) {
      if (viewToast) toastAlert(message: "Successfully!");
      return value;
    }).catchError((error) {
      print("Error Promise: $error");
      if (viewToast) toastAlert(message: error.response["message"], isError: true);
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
}
