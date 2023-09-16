class TicketModel {
  int? id;

  TicketModel({
    this.id,
  });

  TicketModel.fromJson(Map<String, dynamic> json) {
    id = json['idRecipe'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idRecipe'] = id;

    return data;
  }
}
