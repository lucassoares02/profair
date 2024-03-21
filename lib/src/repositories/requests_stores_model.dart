class RequestsStoresModel {
  int? codeRequest;
  String? documentCompany;
  int? codeClient;
  int? codeBranch;
  String? nameClient;
  String? razaoClient;
  double? value;
  String? hour;
  String? descriptionNegotiation;
  String? nameForn;
  int? codeNegotiation;
  int? codeForn;

  RequestsStoresModel({
    this.codeRequest,
    this.documentCompany,
    this.codeClient,
    this.codeBranch,
    this.nameClient,
    this.razaoClient,
    this.value,
    this.hour,
    this.descriptionNegotiation,
    this.nameForn,
    this.codeNegotiation,
    this.codeForn,
  });

  RequestsStoresModel.fromJson(Map<String, dynamic> json) {
    codeRequest = json['codPedido'];
    documentCompany = json['cnpjAssociado'];
    codeClient = json['codAssociado'];
    codeBranch = json['codConsultRelaciona'];
    nameClient = json['nomeConsult'];
    razaoClient = json['razaoAssociado'];
    value = json['valor'].toDouble();
    hour = json['horas'];
    nameForn = json["nomeForn"];
    codeForn = json["codForn"];
    codeNegotiation = json["codNegociacao"];
    descriptionNegotiation = json["descNegociacao"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['codPedido'] = codeRequest;
    data['cnpjAssociado'] = documentCompany;
    data['codAssociado'] = codeClient;
    data['codConsultRelaciona'] = codeBranch;
    data['nomeConsult'] = nameClient;
    data['razaoAssociado'] = razaoClient;
    data['valor'] = value;
    data['horas'] = hour;
    data['codForn'] = codeForn;
    data['codNegociacao'] = codeNegotiation;
    data['descriptionNegotiation'] = descriptionNegotiation;
    data['nameForn'] = nameForn;
    return data;
  }
}
