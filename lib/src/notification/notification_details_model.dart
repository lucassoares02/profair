class NotificationDetailsModel {
  int? id;
  String? title;
  String? content;
  int? redirect;
  int? target;
  int? method;
  int? send;
  int? provider;
  String? nameProvider;
  String? imageProvider;
  String? color;

  NotificationDetailsModel({
    required this.id,
    required this.title,
    required this.content,
    required this.redirect,
    required this.target,
    required this.method,
    required this.send,
    required this.provider,
    required this.nameProvider,
    required this.imageProvider,
    required this.color,
  });

  NotificationDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    content = json['content'];
    redirect = json['redirect'];
    target = json['target'];
    method = json['method'];
    send = json['send'];
    provider = json['provider'];
    nameProvider = json['nomeForn'];
    imageProvider = json['image'];
    color = json['color'];
  }
}
