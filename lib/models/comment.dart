class Comment {
  final int id;
  final int userId;
  final String userName; // For display purposes
  final int bookId;
  final String content;
  final DateTime commentDate;
  final int likesCount;
  final bool isLikedByCurrentUser;
  final String? userPhoto; // Add userPhoto field

  Comment({
    required this.id,
    required this.userId,
    required this.userName,
    required this.bookId,
    required this.content,
    required this.commentDate,
    this.likesCount = 0,
    this.isLikedByCurrentUser = false, // Default to false to avoid null
    this.userPhoto, // Make it optional
  });

  // Create a copy of this comment with updated properties
  Comment copyWith({
    int? id,
    int? userId,
    String? userName,
    int? bookId,
    String? content,
    DateTime? commentDate,
    int? likesCount,
    bool? isLikedByCurrentUser,
  }) {
    return Comment(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      bookId: bookId ?? this.bookId,
      content: content ?? this.content,
      commentDate: commentDate ?? this.commentDate,
      likesCount: likesCount ?? this.likesCount,
      isLikedByCurrentUser: isLikedByCurrentUser ?? this.isLikedByCurrentUser,
    );
  }

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
      likesCount: json['likesCount'] ?? 0,
      isLikedByCurrentUser:
          json['isLikedByCurrentUser'] ?? false, // Default to false
      userPhoto: json['userPhoto'], // Parse userPhoto from JSON
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
      'likesCount': likesCount,
      'isLikedByCurrentUser': isLikedByCurrentUser,
      'userPhoto': userPhoto, // Include userPhoto in JSON
    };
  }
}
