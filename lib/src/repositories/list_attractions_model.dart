class ListAttractionsModel {
  int? code;
  String? title;
  String? content;
  String? hour;

  ListAttractionsModel({
    this.code,
    this.title,
    this.content,
    this.hour,
  });

  ListAttractionsModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    title = json['title'];
    content = json['content'];
    hour = json['hour'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['title'] = title;
    data['content'] = content;
    data['hour'] = hour;
    return data;
  }
}
