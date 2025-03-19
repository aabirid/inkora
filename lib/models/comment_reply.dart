class CommentReply {
  final int id;
  final int commentId;
  final int userId;
  final String userName; // For display purposes
  final String content;
  final DateTime replyDate;

  CommentReply({
    required this.id,
    required this.commentId,
    required this.userId,
    required this.userName,
    required this.content,
    required this.replyDate,
  });

  // Factory constructor to convert JSON to CommentReply object
  factory CommentReply.fromJson(Map<String, dynamic> json) {
    return CommentReply(
      id: json['id'] ?? 0,
      commentId: json['commentId'] ?? 0,
      userId: json['userId'] ?? 0,
      userName: json['userName'] ?? 'Unknown User',
      content: json['content'] ?? '',
      replyDate: json['replyDate'] != null 
          ? DateTime.parse(json['replyDate']) 
          : DateTime.now(),
    );
  }

  // Convert CommentReply to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'commentId': commentId,
      'userId': userId,
      'userName': userName,
      'content': content,
      'replyDate': replyDate.toIso8601String(),
    };
  }

  // Database mapping (for future use)
  static Map<String, String> get dbMapping => {
    'id': 'id_reponse',
    'commentId': 'id_commentaire',
    'userId': 'id_utilisateur',
    'content': 'contenu',
    'replyDate': 'date_reponse',
  };
}

