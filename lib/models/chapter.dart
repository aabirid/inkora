class Chapter {
  final int id;
  final int bookId;
  final String title;
  final int order;
  final String content;

  Chapter({
    required this.id,
    required this.bookId,
    required this.title,
    required this.order,
    required this.content,
  });

  // Factory constructor to convert JSON to Chapter object
  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      id: json['id'] ?? 0,
      bookId: json['bookId'] ?? 0,
      title: json['title'] ?? 'Unknown',
      order: json['order'] ?? 0,
      content: json['content'] ?? '',
    );
  }

  // Convert Chapter to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookId': bookId,
      'title': title,
      'order': order,
      'content': content,
    };
  }

  // Database mapping (for future use)
  static Map<String, String> get dbMapping => {
    'id': 'id_chapitre',
    'bookId': 'id_livre',
    'title': 'titre',
    'order': 'ordre',
    'content': 'contenu',
  };
}

