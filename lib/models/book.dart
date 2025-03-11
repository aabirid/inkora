class Book {
  final String id;
  final String title;
  final String author;
  final String coverImage;
  final String description;
  final double rating;
  final int chapters;
  final String status;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.coverImage,
    required this.description,
    required this.rating,
    required this.chapters,
    required this.status,
  });

  // Factory constructor to convert JSON to Book object
  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] ?? '',
      title: json['title'] ?? 'Unknown',
      author: json['author'] ?? 'Unknown',
      coverImage: json['coverImage'] ?? 'assets/default_cover.png',
      description: json['description'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      chapters: json['chapters'] ?? 0,
      status: json['status'] ?? 'Ongoing',
    );
  }
}
