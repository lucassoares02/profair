class RequestsStoresModel {
  int? codeRequest;
  String? documentCompany;
  int? codeClient;
  String? nameClient;
  String? razaoClient;
  double? value;
  String? hour;

  RequestsStoresModel({
    this.codeRequest,
    this.documentCompany,
    this.codeClient,
    this.nameClient,
    this.razaoClient,
    this.value,
    this.hour,
  });

  RequestsStoresModel.fromJson(Map<String, dynamic> json) {
    codeRequest = json['codPedido'];
    documentCompany = json['cnpjAssociado'];
    codeClient = json['codAssociado'];
    nameClient = json['nomeConsult'];
    razaoClient = json['razaoAssociado'];
    value = json['valor'].toDouble();
    hour = json['horas'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['codPedido'] = codeRequest;
    data['cnpjAssociado'] = documentCompany;
    data['codAssociado'] = codeClient;
    data['nomeConsult'] = nameClient;
    data['razaoAssociado'] = razaoClient;
    data['valor'] = value;
    data['horas'] = hour;
    return data;
  }
}
