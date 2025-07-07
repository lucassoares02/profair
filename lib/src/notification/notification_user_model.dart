class NotificationUserModel {
  int? id;
  int? user;
  int? notification;
  int? viewed;
  String? createdAt;
  String? updatedAt;
  int? success;

  NotificationUserModel({
    required this.id,
    required this.user,
    required this.notification,
    required this.viewed,
    required this.createdAt,
    required this.updatedAt,
    required this.success,
  });

  NotificationUserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'];
    notification = json['notification'];
    viewed = json['viewed'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    success = json['success'];
  }
}
