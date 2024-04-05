class UsersModel {
  String? codeAcess;
  int? typeAcess;
  String? nameProvider;
  String? documentProvider;
  int? codeUser;
  int? codeProvider;
  String? nameUser;
  String? documentUser;

  UsersModel({
    this.codeAcess,
    this.typeAcess,
    this.nameProvider,
    this.documentProvider,
    this.codeUser,
    this.codeProvider,
    this.nameUser,
    this.documentUser,
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
    data['cpfConsult'] = documentUser;
    return data;
  }
}
