import 'comment_reply.dart';

class Comment {
  final int id;
  final int userId;
  final String userName; // For display purposes
  final int bookId;
  final String content;
  final DateTime commentDate;
  final List<CommentReply>? replies;

  Comment({
    required this.id,
    required this.userId,
    required this.userName,
    required this.bookId,
    required this.content,
    required this.commentDate,
    this.replies,
  });

  // Factory constructor to convert JSON to Comment object
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      userName: json['userName'] ?? 'Unknown User',
      bookId: json['bookId'] ?? 0,
      content: json['content'] ?? '',
      commentDate: json['commentDate'] != null 
          ? DateTime.parse(json['commentDate']) 
          : DateTime.now(),
      replies: json['replies'] != null 
          ? (json['replies'] as List).map((rep) => CommentReply.fromJson(rep)).toList() 
          : null,
    );
  }

  // Convert Comment to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'bookId': bookId,
      'content': content,
      'commentDate': commentDate.toIso8601String(),
      'replies': replies?.map((rep) => rep.toJson()).toList(),
    };
  }

  // Database mapping (for future use)
  static Map<String, String> get dbMapping => {
    'id': 'id_commentaire',
    'userId': 'id_utilisateur',
    'bookId': 'id_livre',
    'content': 'contenu',
    'commentDate': 'date_commentaire',
  };
}

