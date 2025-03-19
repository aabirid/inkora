class FavoriteBooklist {
  final int userId;
  final int booklistId;
  final DateTime addDate;

  FavoriteBooklist({
    required this.userId,
    required this.booklistId,
    required this.addDate,
  });

  // Factory constructor to convert JSON to FavoriteBooklist object
  factory FavoriteBooklist.fromJson(Map<String, dynamic> json) {
    return FavoriteBooklist(
      userId: json['userId'] ?? 0,
      booklistId: json['booklistId'] ?? 0,
      addDate: json['addDate'] != null 
          ? DateTime.parse(json['addDate']) 
          : DateTime.now(),
    );
  }

  // Convert FavoriteBooklist to JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'booklistId': booklistId,
      'addDate': addDate.toIso8601String(),
    };
  }

  // Database mapping (for future use)
  static Map<String, String> get dbMapping => {
    'userId': 'id_utilisateur',
    'booklistId': 'id_booklist',
    'addDate': 'date_ajout',
  };
}

