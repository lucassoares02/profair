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

  HistoryClientsModel({this.id, this.razao, this.total, this.totalEvent1, this.totalEvent2, this.event, this.descriptionEvent});

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }

  HistoryClientsModel.fromJson(Map<String, dynamic> json) {
    id = json['codAssociadoEvent'] ?? json['codFornEvent'];
    razao = json['razaoAssociado'] ?? json['nomeForn'];
    total = json['valorTotal']?.toDouble();
    volume = json['volumeTotal'];
    event = json['idEvento'];
    descriptionEvent = json['descricaoEvento'];

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

    totalEvent1 = eventValues[1];
    totalEvent2 = eventValues[2];
  }

  /// Valor referente a um evento específico. Sem evento selecionado, retorna o total geral.
  double valueForEvent(int? eventNumber) {
    if (eventNumber == null) return total ?? 0;
    return eventValues[eventNumber] ?? 0;
  }
}
