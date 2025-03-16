import 'book.dart';

class Booklist {
  final String id;
  final String title;
  final String coverImage;
  final int likes;
  final int booksCount;
  final List<Book>? books;

  Booklist({
    required this.id,
    required this.title,
    required this.coverImage,
    required this.likes,
    required this.booksCount,
    this.books,
  });

  // Factory constructor to convert JSON to Booklist object
  factory Booklist.fromJson(Map<String, dynamic> json) {
    return Booklist(
      id: json['id'] ?? '',
      title: json['title'] ?? 'Unknown',
      coverImage: json['coverImage'] ?? 'assets/images/default_cover.jpeg',
      likes: json['likes'] ?? 0,
      booksCount: json['booksCount'] ?? 0,
      books: json['books'] != null
          ? (json['books'] as List).map((book) => Book.fromJson(book)).toList()
          : null,
    );
  }

  // Convert Booklist to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'coverImage': coverImage,
      'likes': likes,
      'booksCount': booksCount,
      'books': books?.map((book) => book.toJson()).toList(),
    };
  }
}