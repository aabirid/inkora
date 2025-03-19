class Notification {
  final int id;
  final int userId;
  final String type;
  final String message;
  final DateTime notificationDate;
  final bool isRead;

  Notification({
    required this.id,
    required this.userId,
    required this.type,
    required this.message,
    required this.notificationDate,
    this.isRead = false,
  });

  // Factory constructor to convert JSON to Notification object
  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      type: json['type'] ?? '',
      message: json['message'] ?? '',
      notificationDate: json['notificationDate'] != null 
          ? DateTime.parse(json['notificationDate']) 
          : DateTime.now(),
      isRead: json['isRead'] ?? false,
    );
  }

  // Convert Notification to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'type': type,
      'message': message,
      'notificationDate': notificationDate.toIso8601String(),
      'isRead': isRead,
    };
  }

  // Database mapping (for future use)
  static Map<String, String> get dbMapping => {
    'id': 'id_notification',
    'userId': 'id_utilisateur',
    'type': 'type_notification',
    'message': 'message',
    'notificationDate': 'date_notification',
  };
}

