class ClientsSelectStoreModel {
  int? relationshipCode;
  String? nameUser;
  int? codeBranch;
  String? nameCompany;
  String? documentCompany;
  double? totalValue;
  String? totalVolume;
  bool? checked;

  ClientsSelectStoreModel({
    this.relationshipCode,
    this.nameUser,
    this.nameCompany,
    this.codeBranch,
    this.documentCompany,
    this.totalValue,
    this.totalVolume,
    this.checked,
  });

  ClientsSelectStoreModel.fromJson(Map<String, dynamic> json) {
    try {
      checked = false;
      codeBranch = json['codAssociado'];
      nameUser = json['nomeConsult'];
      relationshipCode = json['codConsultRelaciona'];
      nameCompany = json['razaoAssociado'];
      documentCompany = json['cnpjAssociado'];
      totalValue = json['valor'].toDouble();
      totalVolume = json['volume'];
    } catch (e) {
      print("Error Map Clients Select Store Model");
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // data['codAssocRelaciona'] = codeBranch;
    data['codAssociado'] = codeBranch;
    data['nomeConsult'] = nameUser;
    data['codConsultRelaciona'] = relationshipCode;
    data['razao'] = nameCompany;
    data['cnpjAssociado'] = documentCompany;
    data['valorTotal'] = totalValue;
    data['volumeTotal'] = totalVolume;
    return data;
  }
}
