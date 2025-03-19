class BooklistItem {
  final int booklistId;
  final int bookId;
  final DateTime addDate;

  BooklistItem({
    required this.booklistId,
    required this.bookId,
    required this.addDate,
  });

  // Factory constructor to convert JSON to BooklistItem object
  factory BooklistItem.fromJson(Map<String, dynamic> json) {
    return BooklistItem(
      booklistId: json['booklistId'] ?? 0,
      bookId: json['bookId'] ?? 0,
      addDate: json['addDate'] != null 
          ? DateTime.parse(json['addDate']) 
          : DateTime.now(),
    );
  }

  // Convert BooklistItem to JSON
  Map<String, dynamic> toJson() {
    return {
      'booklistId': booklistId,
      'bookId': bookId,
      'addDate': addDate.toIso8601String(),
    };
  }

  // Database mapping (for future use)
  static Map<String, String> get dbMapping => {
    'booklistId': 'id_booklist',
    'bookId': 'id_livre',
    'addDate': 'date_ajout',
  };
}

