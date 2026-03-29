class UsersModel {
  String? codeAcess;
  int? typeAcess;
  String? nameProvider;
  String? documentProvider;
  int? codeUser;
  int? codeProvider;
  String? nameUser;
  String? documentUser;
  bool? present;

  UsersModel({
    this.codeAcess,
    this.typeAcess,
    this.nameProvider,
    this.documentProvider,
    this.codeUser,
    this.codeProvider,
    this.nameUser,
    this.documentUser,
    this.present,
  });

  UsersModel.fromJson(Map<String, dynamic> json) {
    codeAcess = json['codAcesso'];
    typeAcess = json['direcAcesso'];
    nameProvider = json['nomeForn'];
    documentProvider = json['cnpjForn'];
    codeUser = json['codUsuario'];
    codeProvider = json['codForn'];
    nameUser = json['nomeConsult'];
    documentUser = json['cpfConsult'];
    present = json['present'] == 1 ? true : false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['codAcesso'] = codeAcess;
    data['direcAcesso'] = typeAcess;
    data['nomeForn'] = nameProvider;
    data['cnpjForn'] = documentProvider;
    data['codUsuario'] = codeUser;
    data['codForn'] = codeProvider;
    data['nomeConsult'] = nameUser;
    data['present'] = present;
    data['cpfConsult'] = documentUser;
    return data;
  }
}
