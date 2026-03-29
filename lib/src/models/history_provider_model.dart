class HistoryProviderModel {
  int? event;
  String? description;
  double? total;
  String? volume;

  HistoryProviderModel({this.event, this.description, this.total, this.volume});

  HistoryProviderModel.fromJson(Map<String, dynamic> json) {
    event = json['id'] ?? json['idEvento'] ?? json['event'];
    description = json['descricao'] ?? json['description'] ?? json['descricaoEvento'];
    if (json['total'] != null) {
      total = (json['total'] as num).toDouble();
    }
    if (json['volume'] != null) {
      volume = json['volume'].toString();
    }
  }
}
