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
  final List<String>? categories;

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
      publishedDate: json['publishedDate'] != null 
          ? DateTime.parse(json['publishedDate']) 
          : null,
      categories: json['categories'] != null 
          ? List<String>.from(json['categories']) 
          : null,
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
      'categories': categories,
    };
  }
}

