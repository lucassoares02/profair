class NegotiationModel {
  int? negotiation;
  String? title;
  int? confirm;
  bool? checked;
  String? term;
  String? observation;

  NegotiationModel({
    this.negotiation,
    this.title,
    this.confirm,
    this.checked,
    this.term,
    this.observation,
  });

  NegotiationModel.fromJson(Map<String, dynamic> json) {
    negotiation = json["codNegociacao"];
    title = json["descNegociacao"];
    confirm = json["confirma"];
    term = json["prazo"];
    observation = json["observacao"];
    checked = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data["codNegociacao"] = negotiation;
    data["descNegociacao"] = title;
    data["confirma"] = confirm;
    data["prazo"] = term;
    data["observacao"] = observation;
    data["checked"] = false;
    return data;
  }
}
