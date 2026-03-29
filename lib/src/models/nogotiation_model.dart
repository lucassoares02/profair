import 'package:profair/src/models/product_model.dart';

class NegotiationModel {
  int? negotiation;
  int? codAssoc;
  String? razaoAssociado;
  String? title;
  int? confirm;
  bool? checked;
  String? term;
  String? observation;
  List<ProductModel>? merchandises;

  NegotiationModel({
    this.negotiation,
    this.codAssoc,
    this.razaoAssociado,
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
    codAssoc = json["codAssociado"];
    razaoAssociado = json["razaoAssociado"];
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
      codAssoc: codAssoc,
      razaoAssociado: razaoAssociado,
      title: title,
      confirm: confirm,
      checked: checked,
      term: term,
      observation: observation,
      merchandises: merchandises,
    );
  }

  NegotiationModel copyWith() {
    return NegotiationModel(
      negotiation: negotiation,
      codAssoc: codAssoc,
      razaoAssociado: razaoAssociado,
      title: title,
      confirm: confirm,
      checked: checked,
      term: term,
      observation: observation,
      merchandises: merchandises != null ? List<ProductModel>.from(merchandises!.map((x) => ProductModel.clone(x))) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data["codNegociacao"] = negotiation;
    data["codAssociado"] = codAssoc;
    data["razaoAssociado"] = razaoAssociado;
    data["descNegociacao"] = title;
    data["confirma"] = confirm;
    data["prazo"] = term;
    data["observacao"] = observation;
    data["checked"] = false;
    return data;
  }
}
