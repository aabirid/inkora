import 'package:inkora/models/category.dart';

class Book {
  final int id;
  final String title;
  final String author;
  final String coverImage;
  final String description;
  final double rating;
  final int chapters;
  final String status;
  final DateTime? publishedDate;
  final List<Category>? categories;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.coverImage,
    required this.description,
    required this.rating,
    required this.chapters,
    required this.status,
    this.publishedDate,
    this.categories,
  });

  // Convert JSON to Book
  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Unknown',
      author: json['author'] ?? 'Unknown',
      coverImage: json['coverImage'] ?? json['cover_image'] ?? 'assets/default_cover.png',
      description: json['description'] ?? '',
      rating: double.tryParse(json['rating'].toString()) ?? 0.0,
      chapters: json['chapters'] ?? 0,
      status: json['status'] ?? 'Ongoing',
      publishedDate: json['publishedDate'] != null
          ? DateTime.tryParse(json['publishedDate'])
          : null,
      categories: json['categories'] is List
          ? (json['categories'] as List).map((cat) => Category.fromJson(cat)).toList()
          : [],
    );
  }

  // Convert Book to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'coverImage': coverImage,
      'description': description,
      'rating': rating,
      'chapters': chapters,
      'status': status,
      'publishedDate': publishedDate?.toIso8601String(),
      'categories': categories?.map((c) => c.toJson()).toList(),
    };
  }
}
