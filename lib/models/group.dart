class Group {
  final int id;
  final String name;
  final String? description;
  final int creatorId;
  final DateTime creationDate;
  final List<int>? members; // List of user IDs
  final String? photo; // Added photo property

  Group({
    required this.id,
    required this.name,
    this.description,
    required this.creatorId,
    required this.creationDate,
    this.members,
    this.photo, // Added photo parameter
  });

  // Factory constructor to convert JSON to Group object
  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'],
      creatorId: json['creatorId'] ?? 0,
      creationDate: json['creationDate'] != null 
          ? DateTime.parse(json['creationDate']) 
          : DateTime.now(),
      members: json['members'] != null 
          ? List<int>.from(json['members']) 
          : null,
      photo: json['photo'], // Added photo from JSON
    );
  }

  // Convert Group to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'creatorId': creatorId,
      'creationDate': creationDate.toIso8601String(),
      'members': members,
      'photo': photo, // Added photo to JSON
    };
  }

  // Database mapping (for future use)
  static Map<String, String> get dbMapping => {
    'id': 'id_groupe',
    'name': 'nom_groupe',
    'description': 'description',
    'creatorId': 'id_createur',
    'creationDate': 'date_creation',
    'photo': 'photo', // Added photo mapping
  };
}

