import 'dart:developer';

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
  String? email;
  int? active;
  int? history;
  String? color;
  String? image;

  LoginModel({
    this.codAccess,
    this.accessTargeting,
    this.nameCompany,
    this.codCompany,
    this.document,
    this.userCode,
    this.nameUser,
    this.documentUser,
    this.valueOrder,
    this.email,
    this.active,
    this.history,
    this.color,
    this.image,
  });

  LoginModel.fromJson(Map<String, dynamic> json) {
    print(json);
    codAccess = json["codAcesso"];
    accessTargeting = json["direcAcesso"];
    nameCompany = json["nomeForn"];
    document = json["cnpjForn"];
    userCode = json["codUsuario"];
    codCompany = json["codForn"];
    active = json["ativo"];
    nameUser = json["nomeConsult"];
    documentUser = json["cpfConsult"];
    valueOrder = json["valorPedido"];
    email = json["emailConsult"];
    history = json["history"];
    color = json["color"];
    image = json["image"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data["codAcesso"] = codAccess;
    data["direcAcesso"] = accessTargeting;
    data["nomeForn"] = nameCompany;
    data["cnpjForn"] = document;
    data["codUsuario"] = userCode;
    data["codForn"] = codCompany;
    data["ativo"] = active;
    data["nomeConsult"] = nameUser;
    data["cpfConsult"] = documentUser;
    data["valorPedido"] = valueOrder;
    data["emailConsult"] = email;
    return data;
  }
}
