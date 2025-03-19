class Report {
  final int id;
  final int userId;
  final int targetId;
  final String reportType; // 'book', 'user'
  final String reason;
  final DateTime reportDate;

  Report({
    required this.id,
    required this.userId,
    required this.targetId,
    required this.reportType,
    required this.reason,
    required this.reportDate,
  });

  // Factory constructor to convert JSON to Report object
  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      targetId: json['targetId'] ?? 0,
      reportType: json['reportType'] ?? '',
      reason: json['reason'] ?? '',
      reportDate: json['reportDate'] != null 
          ? DateTime.parse(json['reportDate']) 
          : DateTime.now(),
    );
  }

  // Convert Report to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'targetId': targetId,
      'reportType': reportType,
      'reason': reason,
      'reportDate': reportDate.toIso8601String(),
    };
  }

  // Database mapping (for future use)
  static Map<String, String> get dbMapping => {
    'id': 'id_signalement',
    'userId': 'id_utilisateur',
    'targetId': 'id_cible',
    'reportType': 'type_signalement',
    'reason': 'motif',
    'reportDate': 'date_signalement',
  };
}

