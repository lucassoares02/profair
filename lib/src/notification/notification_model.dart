class CustomNotification {
  int? id;
  String? title;
  String? body;
  String? payload;
  String? createdAt;
  int? hour;
  int? minutes;
  int? method;
  int? viewed;

  CustomNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
    required this.createdAt,
    this.hour,
    this.method,
    this.minutes,
    this.viewed,
  });

  CustomNotification.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    body = json['content'];
    payload = json['payload'];
    createdAt = json['created_at'] ?? "";
    hour = json['hour'] ?? 0;
    minutes = json['minute'] ?? 0;
    method = json['method'] ?? 0;
    viewed = json['viewed'] ?? 0;
  }
}
