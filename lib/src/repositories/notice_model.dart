class NoticeModel {
  int? code;
  String? title;
  String? description;
  String? image;
  String? action;
  int? priority;

  NoticeModel({
    this.code,
    this.title,
    this.description,
    this.image,
    this.action,
    this.priority,
  });

  NoticeModel.fromJson(Map<String, dynamic> json) {
    code = json['codNotice'];
    title = json['title'];
    description = json['description'];
    image = json['image'];
    action = json['action'];
    priority = json['priority'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['codNotice'] = code;
    data['title'] = title;
    data['description'] = description;
    data['image'] = image;
    data['action'] = action;
    data['priority'] = priority;
    return data;
  }
}
