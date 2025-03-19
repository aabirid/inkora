class ReaderBook {
  final int userId;
  final int bookId;
  final int progress;
  final DateTime readDate;

  ReaderBook({
    required this.userId,
    required this.bookId,
    required this.progress,
    required this.readDate,
  });

  // Factory constructor to convert JSON to ReaderBook object
  factory ReaderBook.fromJson(Map<String, dynamic> json) {
    return ReaderBook(
      userId: json['userId'] ?? 0,
      bookId: json['bookId'] ?? 0,
      progress: json['progress'] ?? 0,
      readDate: json['readDate'] != null 
          ? DateTime.parse(json['readDate']) 
          : DateTime.now(),
    );
  }

  // Convert ReaderBook to JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'bookId': bookId,
      'progress': progress,
      'readDate': readDate.toIso8601String(),
    };
  }

  // Database mapping (for future use)
  static Map<String, String> get dbMapping => {
    'userId': 'id_utilisateur',
    'bookId': 'id_livre',
    'progress': 'progression',
    'readDate': 'date_lecture',
  };
}

