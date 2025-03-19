class Category {
  final int id;
  final String name;

  Category({
    required this.id,
    required this.name,
  });

  // Factory constructor to convert JSON to Category object
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
    );
  }

  // Convert Category to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  // Database mapping (for future use)
  static Map<String, String> get dbMapping => {
    'id': 'id_categorie',
    'name': 'nom_categorie',
  };
}

