class ConsultantsModel {
  String? start;
  String? end;
  String? duration;
  int? codClient;
  String? nomeClient;
  int? codConsult;
  String? nomeConsult;
  int? codForn;
  String? nomeForn;

  ConsultantsModel({
    this.start,
    this.end,
    this.duration,
    this.codClient,
    this.nomeClient,
    this.codConsult,
    this.nomeConsult,
    this.codForn,
    this.nomeForn,
  });

  ConsultantsModel.fromJson(Map<String, dynamic> json) {
    start = json['start_time'];
    end = json['end_time'];
    duration = json['duration'];
    codClient = json['codPedido'];
    nomeClient = json['nomeClient'];
    codConsult = json['codConsult'];
    nomeConsult = json['nomeConsult'];
    codForn = json['codForn'];
    nomeForn = json['nomeForn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['start_time'] = start;
    data['end_time'] = end;
    data['duration'] = duration;
    data['codPedido'] = codClient;
    data['nomeClient'] = nomeClient;
    data['codConsult'] = codConsult;
    data['nomeConsult'] = nomeConsult;
    data['codForn'] = codForn;
    data['nomeForn'] = nomeForn;

    return data;
  }
}
