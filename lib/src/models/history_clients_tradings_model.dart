class HistoryClientsTradingsModel {
  int? id;
  int? negotiation;
  String? descNegotiation;
  double? total;
  String? volume;
  int? event;
  String? descriptionEvent;
  String? comprador;
  String? vendedor;
  String? date;

  HistoryClientsTradingsModel({this.id, this.negotiation, this.descNegotiation, this.total, this.event, this.descriptionEvent, this.comprador, this.vendedor, this.date});

  HistoryClientsTradingsModel.fromJson(Map<String, dynamic> json) {
    id = json['codAssociadoEvent'] ?? json['codFornEvent'];
    negotiation = json['codNegociacao'];
    descNegotiation = json['descNegociacao'];
    total = json['valorTotal'].toDouble();
    volume = json['volumeTotal'];
    event = json['idEvento'];
    descriptionEvent = json['descricaoEvento'];
    comprador = json['nomeComprador'];
    vendedor = json['nomeVendedor'];
    date = json['dataPedido'];
  }
}
