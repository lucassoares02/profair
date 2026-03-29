import 'package:profair/src/models/history_clients_model.dart';
import 'package:profair/src/models/history_clients_summary_model.dart';
import 'package:profair/src/shared/http_service_history.dart';

class HistoryClientsRepository {
  final clientDioHistory = HttpServiceHistory();

  findHistoryClients(int codeProvider) async {
    print("codeProvider: $codeProvider");
    try {
      final response = await clientDioHistory.get("/history/list/client/$codeProvider");
      List list = response.data as List;
      return list.map((json) => HistoryClientsModel.fromJson(json)).toList();
    } catch (e) {
      print("Error return History Clients Model Mapper: $e");
    }
  }

  findHistoryProviders() async {
    try {
      final response = await clientDioHistory.get("/history/list/provider");
      List list = response.data as List;
      return list.map((json) => HistoryClientsModel.fromJson(json)).toList();
    } catch (e) {
      print("Error return History Clients Model Mapper: $e");
    }
  }

  findHistorySummaryClients(int codeProvider) async {
    try {
      final response = await clientDioHistory.get("/history/provider/$codeProvider");
      List list = response.data as List;
      return list.map((json) => HistoryClientsSummaryModel.fromJson(json)).toList();
    } catch (e) {
      print("Error return History Clients Model Mapper: $e");
    }
  }
}
