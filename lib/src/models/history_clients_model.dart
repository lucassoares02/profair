class HistoryClientsModel {
  int? id;
  String? razao;
  double? total;
  double? totalEvent1;
  double? totalEvent2;
  String? volume;
  int? event;
  String? descriptionEvent;

  HistoryClientsModel({this.id, this.razao, this.total, this.totalEvent1, this.totalEvent2, this.event, this.descriptionEvent});

  HistoryClientsModel.fromJson(Map<String, dynamic> json) {
    id = json['codAssociadoEvent'] ?? json['codFornEvent'];
    razao = json['razaoAssociado'] ?? json['nomeForn'];
    total = json['valorTotal']?.toDouble();
    totalEvent1 = json['valorEvento1']?.toDouble();
    totalEvent2 = json['valorEvento2']?.toDouble();
    volume = json['volumeTotal'];
    event = json['idEvento'];
    descriptionEvent = json['descricaoEvento'];
  }
}
