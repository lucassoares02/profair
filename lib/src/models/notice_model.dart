class NoticeModel {
  int? code;
  String? title;
  String? description;
  String? image;
  String? action;
  int? priority;
  String? primaryColor;
  String? secondaryColor;
  String? stamp;
  int? type;
  int? provider;

  NoticeModel({this.code, this.title, this.description, this.image, this.action, this.priority, this.primaryColor, this.secondaryColor, this.stamp, this.type, this.provider});

  NoticeModel.fromJson(Map<String, dynamic> json) {
    code = json['codNotice'];
    title = json['title'];
    description = json['description'];
    image = json['image'];
    action = json['action'];
    priority = json['priority'];
    primaryColor = json['primaryColor'];
    secondaryColor = json['secondaryColor'];
    stamp = json['stamp'];
    type = json['type'];
    provider = json['provider'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['codNotice'] = code;
    data['title'] = title;
    data['description'] = description;
    data['image'] = image;
    data['action'] = action;
    data['priority'] = priority;
    data['primaryColor'] = primaryColor;
    data['secondaryColor'] = secondaryColor;
    data['stamp'] = stamp;
    data['type'] = type;
    data['provider'] = provider;
    return data;
  }
}
