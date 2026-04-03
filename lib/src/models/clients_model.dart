class ClientsModel {
  int? relationshipCode;
  String? nameUser;
  int? codeBranch;
  int? codeGroup;
  String? nameCompany;
  String? documentCompany;
  double? totalValue;
  String? totalVolume;

  ClientsModel({this.relationshipCode, this.codeGroup, this.nameUser, this.nameCompany, this.codeBranch, this.documentCompany, this.totalValue, this.totalVolume});

  ClientsModel.fromJson(Map<String, dynamic> json) {
    print(json);
    // codeBranch = json['codAssocRelaciona'];
    codeBranch = json['codAssociado'];
    codeGroup = json['codGrupo'];
    nameUser = json['nomeConsult'];
    relationshipCode = json['codConsultRelaciona'];
    nameCompany = json['razao'];
    documentCompany = json['cnpjAssociado'];
    totalValue = json['valorTotal']?.toDouble();
    totalVolume = json['volumeTotal']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // data['codAssocRelaciona'] = codeBranch;
    data['codAssociado'] = codeBranch;
    data['codGrupo'] = codeGroup;
    data['nomeConsult'] = nameUser;
    data['codConsultRelaciona'] = relationshipCode;
    data['razao'] = nameCompany;
    data['cnpjAssociado'] = documentCompany;
    data['valorTotal'] = totalValue;
    data['volumeTotal'] = totalVolume;
    return data;
  }
}
