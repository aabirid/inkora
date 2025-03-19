import 'book.dart';

class Booklist {
  final int id;
  final int userId;
  final String title;
  final String visibility;
  final DateTime creationDate;
  final List<Book>? books;
  final int? likesCount; // Calculated from Favorites_Booklist
  final int? booksCount; // Calculated from Booklist_Items

  Booklist({
    required this.id,
    required this.userId,
    required this.title,
    required this.visibility,
    required this.creationDate,
    this.books,
    this.likesCount,
    this.booksCount,
  });

  // Getter for the cover image
  String get coverImage {
    if (books != null && books!.isNotEmpty) {
      return books!.first.coverImage;
    }
    return 'assets/images/default_book.jpeg'; // Default cover image when empty
  }

  // Factory constructor to convert JSON to Booklist object
  factory Booklist.fromJson(Map<String, dynamic> json) {
    return Booklist(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      title: json['title'] ?? 'Unknown',
      visibility: json['visibility'] ?? 'private',
      creationDate: json['creationDate'] != null 
          ? DateTime.parse(json['creationDate']) 
          : DateTime.now(),
      books: json['books'] != null 
          ? (json['books'] as List).map((book) => Book.fromJson(book)).toList() 
          : null,
      likesCount: json['likesCount'] ?? 0,
      booksCount: json['booksCount'] ?? 0,
    );
  }

  // Convert Booklist to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'visibility': visibility,
      'creationDate': creationDate.toIso8601String(),
      'books': books?.map((book) => book.toJson()).toList(),
      'likesCount': likesCount,
      'booksCount': booksCount,
    };
  }

  // Database mapping (for future use)
  static Map<String, String> get dbMapping => {
    'id': 'id_booklist',
    'userId': 'id_utilisateur',
    'title': 'nom',
    'visibility': 'visibilite',
    'creationDate': 'date_creation',
  };
}
