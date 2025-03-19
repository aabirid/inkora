class Rating {
  final int id;
  final int userId;
  final int bookId;
  final String score; // '1', '2', '3', '4', '5'
  final DateTime ratingDate;

  Rating({
    required this.id,
    required this.userId,
    required this.bookId,
    required this.score,
    required this.ratingDate,
  });

  // Factory constructor to convert JSON to Rating object
  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      bookId: json['bookId'] ?? 0,
      score: json['score'] ?? '0',
      ratingDate: json['ratingDate'] != null 
          ? DateTime.parse(json['ratingDate']) 
          : DateTime.now(),
    );
  }

  // Convert Rating to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'bookId': bookId,
      'score': score,
      'ratingDate': ratingDate.toIso8601String(),
    };
  }

  // Database mapping (for future use)
  static Map<String, String> get dbMapping => {
    'id': 'id_evaluation',
    'userId': 'id_utilisateur',
    'bookId': 'id_livre',
    'score': 'score',
    'ratingDate': 'date_evaluation',
  };
}

