import 'package:profair/src/models/history_clients_model.dart';
import 'package:profair/src/models/history_clients_summary_model.dart';
import 'package:profair/src/models/history_clients_tradings_model.dart';
import 'package:profair/src/shared/http_service_history.dart';

class HistoryClientsTradingsRepository {
  final clientDioHistory = HttpServiceHistory();

  findHistoryClientsTradings(int provider, int client) async {
    print("Finding history clients tradings for Provider ID: $provider, Client ID: $client");
    try {
      final response = await clientDioHistory.get("history/details/client/$provider/$client");
      List list = response.data as List;
      return list.map((json) => HistoryClientsTradingsModel.fromJson(json)).toList();
    } catch (e) {
      print("Error return History Clients Model Mapper: $e");
    }
  }

  findHistoryProvidersByClient(int client) async {
    print("Client ID: $client");
    try {
      final response = await clientDioHistory.get("historyprovider/$client");
      List list = response.data as List;
      return list.map((json) => HistoryClientsModel.fromJson(json)).toList();
    } catch (e) {
      print("Error return History Clients Model Mapper: $e");
    }
  }

  findHistoryProvidersByProvider(int provider) async {
    try {
      final response = await clientDioHistory.get("history/list/client/$provider");
      List list = response.data as List;
      return list.map((json) => HistoryClientsModel.fromJson(json)).toList();
    } catch (e) {
      print("Error return History Clients Model Mapper: $e");
    }
  }

  findHistoryClientsSummaryTradings(int provider, int client) async {
    try {
      final response = await clientDioHistory.get("history/events/$provider/$client");
      List list = response.data as List;
      return list.map((json) => HistoryClientsSummaryModel.fromJson(json)).toList();
    } catch (e) {
      print("Error return History Clients Model Mapper: $e");
    }
  }

  findHistoryClientsSummaryProviders(int client) async {
    try {
      final response = await clientDioHistory.get("history/client/events/$client");
      List list = response.data as List;
      return list.map((json) => HistoryClientsSummaryModel.fromJson(json)).toList();
    } catch (e) {
      print("Error return History Clients Model Mapper: $e");
    }
  }

  findHistoryClientsSummaryClients(int provider) async {
    try {
      final response = await clientDioHistory.get("history/provider/$provider");
      List list = response.data as List;
      return list.map((json) => HistoryClientsSummaryModel.fromJson(json)).toList();
    } catch (e) {
      print("Error return History Clients Model Mapper: $e");
    }
  }
}
