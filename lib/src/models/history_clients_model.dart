class HistoryClientsModel {
  int? id;
  String? razao;
  double? total;
  double? totalEvent1;
  double? totalEvent2;

  /// Valor de cada evento indexado pelo número do evento (1, 2, 3, ...).
  final Map<int, double> eventValues = {};

  String? volume;
  int? event;
  String? descriptionEvent;

  HistoryClientsModel(
      {this.id,
      this.razao,
      this.total,
      this.totalEvent1,
      this.totalEvent2,
      this.event,
      this.descriptionEvent});

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }

  HistoryClientsModel.fromJson(Map<String, dynamic> json) {
    id = _toInt(json['codAssociadoEvent'] ?? json['codFornEvent']);
    razao = json['razaoAssociado'] ?? json['nomeForn'];
    total = _toDouble(json['valorTotal']);
    volume = json['volumeTotal']?.toString();
    event = _toInt(json['idEvento'] ?? json['event'] ?? json['id']);
    descriptionEvent =
        json['descricaoEvento'] ?? json['descricao'] ?? json['description'];

    // Mapeia dinamicamente todos os campos valorEvento1, valorEvento2, valorEvento3, ...
    // (antes só existiam 1 e 2, então o evento 3 caía no total geral).
    json.forEach((key, value) {
      final match = RegExp(r'^valorEvento(\d+)$').firstMatch(key);
      if (match != null) {
        final eventNumber = int.tryParse(match.group(1)!);
        if (eventNumber != null) {
          eventValues[eventNumber] = _toDouble(value);
        }
      }
    });

    if (event != null && eventValues.isEmpty) {
      eventValues[event!] = total ?? 0;
    }

    totalEvent1 = eventValues[1];
    totalEvent2 = eventValues[2];
  }

  void completeMissingEventValues(Iterable<int> events) {
    if (event != null && eventValues.isEmpty) {
      eventValues[event!] = total ?? 0;
    }

    final eventIds = events.where((event) => event > 0).toSet();
    final missingEvents =
        eventIds.where((event) => !eventValues.containsKey(event)).toList();
    if (missingEvents.length != 1) return;

    final knownTotal =
        eventValues.values.fold<double>(0, (sum, value) => sum + value);
    final remainingTotal = (total ?? 0) - knownTotal;
    if (remainingTotal <= 0) return;

    eventValues[missingEvents.first] = remainingTotal;
    totalEvent1 = eventValues[1];
    totalEvent2 = eventValues[2];
  }

  /// Valor referente a um evento específico. Sem evento selecionado, retorna o total geral.
  double valueForEvent(int? eventNumber) {
    if (eventNumber == null) return total ?? 0;
    return eventValues[eventNumber] ?? 0;
  }
}
