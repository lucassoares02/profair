class ListAttractionsModel {
  int? code;
  String? title;
  String? content;
  String? hour;
  String? image;

  ListAttractionsModel({
    this.code,
    this.title,
    this.content,
    this.hour,
    this.image,
  });

  ListAttractionsModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    title = json['title'];
    content = json['content'];
    hour = json['hour'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['title'] = title;
    data['content'] = content;
    data['hour'] = hour;
    data['image'] = image;
    return data;
  }
}
