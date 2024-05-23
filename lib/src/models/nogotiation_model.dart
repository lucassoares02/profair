import 'package:profair/src/models/product_model.dart';

class NegotiationModel {
  int? negotiation;
  String? title;
  int? confirm;
  bool? checked;
  String? term;
  String? observation;
  List<ProductModel>? merchandises;

  NegotiationModel({
    this.negotiation,
    this.title,
    this.confirm,
    this.checked,
    this.term,
    this.observation,
    this.merchandises,
  });

  NegotiationModel.fromJson(Map<String, dynamic> json) {
    print(json);
    negotiation = json["codNegociacao"];
    title = json["descNegociacao"];
    confirm = json["confirma"];
    term = json["prazo"];
    observation = json["observacao"];
    checked = false;
    if (json["merchandises"] != null) {
      merchandises = List<ProductModel>.from(json["merchandises"].map((x) => ProductModel.fromJson(x)));
    }
  }

  NegotiationModel clone() {
    return NegotiationModel(
      negotiation: negotiation,
      title: title,
      confirm: confirm,
      checked: checked,
      term: term,
      observation: observation,
      merchandises: merchandises,
    );
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
