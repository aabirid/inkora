class Group {
  final int id;
  final String name;
  final String? description;
  final int creatorId;
  final DateTime creationDate;
  final List<int>? members; // List of user IDs
  final String? photo;

  Group({
    required this.id,
    required this.name,
    this.description,
    required this.creatorId,
    required this.creationDate,
    this.members,
    this.photo,
  });

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
}

