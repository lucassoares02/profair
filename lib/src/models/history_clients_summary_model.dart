class HistoryClientsSummaryModel {
  int? event;
  String? description;
  double? total;

  HistoryClientsSummaryModel({this.event, this.description, this.total});

  HistoryClientsSummaryModel.fromJson(Map<String, dynamic> json) {
    event = json['id'];
    description = json['descricao'];
    total = json['total'].toDouble();
  }
}
