class CommentReport {
  final int id;
  final int userId;
  final int commentId;
  final String reason;
  final DateTime reportDate;

  CommentReport({
    required this.id,
    required this.userId,
    required this.commentId,
    required this.reason,
    required this.reportDate,
  });

  // Factory constructor to convert JSON to CommentReport object
  factory CommentReport.fromJson(Map<String, dynamic> json) {
    return CommentReport(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      commentId: json['commentId'] ?? 0,
      reason: json['reason'] ?? '',
      reportDate: json['reportDate'] != null 
          ? DateTime.parse(json['reportDate']) 
          : DateTime.now(),
    );
  }

  // Convert CommentReport to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'commentId': commentId,
      'reason': reason,
      'reportDate': reportDate.toIso8601String(),
    };
  }

  // Database mapping (for future use)
  static Map<String, String> get dbMapping => {
    'id': 'id_signalement',
    'userId': 'id_utilisateur',
    'commentId': 'id_commentaire',
    'reason': 'motif',
    'reportDate': 'date_signalement',
  };
}

