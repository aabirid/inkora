class FavouriteBook {
  final int userId;
  final int bookId;
  final DateTime addDate;

  FavouriteBook({
    required this.userId,
    required this.bookId,
    required this.addDate,
  });

  // Factory constructor to convert JSON to FavouriteBook object
  factory FavouriteBook.fromJson(Map<String, dynamic> json) {
    return FavouriteBook(
      userId: json['userId'] ?? 0,
      bookId: json['bookId'] ?? 0,
      addDate: json['addDate'] != null 
          ? DateTime.parse(json['addDate']) 
          : DateTime.now(),
    );
  }

  // Convert FavouriteBook to JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'bookId': bookId,
      'addDate': addDate.toIso8601String(),
    };
  }

  // Database mapping (for future use)
  static Map<String, String> get dbMapping => {
    'userId': 'id_utilisateur',
    'bookId': 'id_livre',
    'addDate': 'date_ajout',
  };
}

