import 'package:appwrite/appwrite.dart';
import 'package:profair/provider/resolver.dart';

class AppWrite {
  Client clientapp = Client();

//=============================================================
// AppWrite ===================================================
//=============================================================

  initAppWrite() {
    clientapp.setEndpoint('https://cloud.appwrite.io/v1').setProject('64dd30b79119b5dc74d7').setSelfSigned(status: true);
  }

//=============================================================
// Users ======================================================
//=============================================================

  initSessionUser(email, password) async {
    Account account = Account(clientapp);
    Future promise = account.createEmailSession(email: email, password: password);
    return resolvePromise(promise: promise);
  }

  createUser(String name, String password, String email) async {
    Account account = Account(clientapp);

    Future promise = account.create(userId: ID.unique(), email: email, password: password);
    return resolvePromise(promise: promise, viewToast: true);
  }

  getUser() async {
    Account account = Account(clientapp);
    Future promise = account.get();
    return resolvePromise(promise: promise);
  }

//=============================================================
// Documents ==================================================
//=============================================================

  createDocuments({required Map<dynamic, dynamic> data, required String collectionId}) {
    Databases database = Databases(clientapp);
    Future promise = database.createDocument(
      databaseId: '64e4ebc2cce8741e7e5b',
      collectionId: collectionId,
      documentId: ID.unique(),
      data: data,
    );
    return resolvePromise(promise: promise, viewToast: true);
  }

  getDocuments(String collectionId, List<String>? query) {
    Databases database = Databases(clientapp);
    Future promise = database.listDocuments(
      databaseId: '64e4ebc2cce8741e7e5b',
      collectionId: collectionId,
      queries: query,
    );
    return resolvePromise(promise: promise);
  }

  deleteDocuments(String collectionId, String documentId) {
    Databases database = Databases(clientapp);
    Future promise = database.deleteDocument(
      databaseId: '64e4ebc2cce8741e7e5b',
      collectionId: collectionId,
      documentId: documentId,
    );
    return resolvePromise(promise: promise);
  }

  updateDocuments({required String collectionId, required String documentId, required Map<dynamic, dynamic> data}) {
    Databases database = Databases(clientapp);
    Future promise = database.updateDocument(
      databaseId: '64e4ebc2cce8741e7e5b',
      collectionId: collectionId,
      documentId: documentId,
      data: data,
    );
    return resolvePromise(promise: promise);
  }

//=============================================================
// RealTime Documents==========================================
//=============================================================

  listDocumentsRealTime() async {
    final realtime = Realtime(clientapp);
    return realtime.subscribe(['documents']);
  }
}
