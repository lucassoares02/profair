class LoginModel {
  String? codAccess;
  int? accessTargeting;
  String? nameCompany;
  int? codCompany;
  String? document;
  int? userCode;
  String? nameUser;
  String? documentUser;
  String? valueOrder;

  LoginModel({this.codAccess, this.accessTargeting, this.nameCompany, this.codCompany, this.document, this.userCode, this.nameUser, this.documentUser, this.valueOrder});

  LoginModel.fromJson(Map<String, dynamic> json) {
    codAccess = json["codAcesso"];
    accessTargeting = json["direcAcesso"];
    nameCompany = json["nomeForn"];
    document = json["cnpjForn"];
    userCode = json["codUsuario"];
    codCompany = json["codForn"];
    nameUser = json["nomeConsult"];
    documentUser = json["cpfConsult"];
    valueOrder = json["valorPedido"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data["codAcesso"] = codAccess;
    data["direcAcesso"] = accessTargeting;
    data["nomeForn"] = nameCompany;
    data["cnpjForn"] = document;
    data["codUsuario"] = userCode;
    data["codForn"] = codCompany;
    data["nomeConsult"] = nameUser;
    data["cpfConsult"] = documentUser;
    data["valorPedido"] = valueOrder;
    return data;
  }
}
