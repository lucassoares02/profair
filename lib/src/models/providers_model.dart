class ProvidersModel {
  String? document;
  String? nameProvider;
  String? socialName;
  int? codeProvider;
  double? totalValue;
  String? totalVolume;

  ProvidersModel({this.document, this.nameProvider, this.socialName, this.codeProvider, this.totalValue, this.totalVolume});

  ProvidersModel.fromJson(Map<String, dynamic> json) {
    document = json['cnpjForn'];
    nameProvider = json['nomeForn'];
    socialName = json['razao'];
    codeProvider = json['codForn'];
    totalValue = json['valorTotal'].toDouble();
    totalVolume = json['volumeTotal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // data['codAssocRelaciona'] = codeBranch;
    data['cnpjForn'] = document;
    data['nomeForn'] = nameProvider;
    data['razao'] = socialName;
    data['codForn'] = codeProvider;
    data['valorTotal'] = totalValue;
    data['volumeTotal'] = totalVolume;
    return data;
  }
}
