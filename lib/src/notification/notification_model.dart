class CustomNotification {
  int? id;
  String? title;
  String? body;
  String? payload;

  CustomNotification({required this.id, required this.title, required this.body, required this.payload});

  CustomNotification.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    body = json['body'];
    payload = json['payload'];
  }
}
