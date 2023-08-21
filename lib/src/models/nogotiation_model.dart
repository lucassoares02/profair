class NegotiationModel {
  int? negotiation;
  String? title;
  int? confirm;
  bool? checked;

  NegotiationModel({this.negotiation, this.title, this.confirm, this.checked});

  NegotiationModel.fromJson(Map<String, dynamic> json) {
    negotiation = json["codNegociacao"];
    title = json["descNegociacao"];
    confirm = json["confirma"];
    checked = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data["codNegociacao"] = negotiation;
    data["descNegociacao"] = title;
    data["confirma"] = confirm;
    data["checked"] = false;
    return data;
  }
}
