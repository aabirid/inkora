class Group {
  final int id;
  final String name;
  final String? description;
  final int creatorId;
  final DateTime creationDate;
  final List<int> members; // List of user IDs
  final String? photo;

  Group({
    required this.id,
    required this.name,
    this.description,
    required this.creatorId,
    required this.creationDate,
    List<int>? members, // Use an empty list if no members are provided
    this.photo,
  }) : members = members ?? [];

  // Create a copy of this group with updated fields
  Group copyWith({
    int? id,
    String? name,
    String? description,
    int? creatorId,
    DateTime? creationDate,
    List<int>? members,
    String? photo,
  }) {
    return Group(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      creatorId: creatorId ?? this.creatorId,
      creationDate: creationDate ?? this.creationDate,
      members: members ?? this.members,
      photo: photo ?? this.photo,
    );
  }

  // Convert JSON to Group
  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      creatorId: json['creatorId'],
      creationDate: DateTime.parse(json['creationDate']),
      members: List<int>.from(json['members'] ?? []),
      photo: json['photo'],
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
      'photo': photo,
    };
  }
}
