class NotificationModel {
  String id;
  String userId; // the user who receives the notification
  String title;
  String message;
  bool isRead;
  DateTime timestamp;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.isRead,
    required this.timestamp,
  });

  // Convert NotificationModel to Map
  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'title': title,
        'message': message,
        'isRead': isRead,
        'timestamp': timestamp.toIso8601String(),
      };

  // Create NotificationModel from Map
  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
        id: json['id'],
        userId: json['userId'],
        title: json['title'],
        message: json['message'],
        isRead: json['isRead'],
        timestamp: DateTime.parse(json['timestamp']),
      );
}
