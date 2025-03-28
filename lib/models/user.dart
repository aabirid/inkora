class User {
  final int id;
  final String email;
  final String password;
  final DateTime? birthDate;
  final String gender;
  final String? address;
  final DateTime registrationDate;
  final String status;
  final String? photo;
  final String username;
  final String? bio;

  User({
    required this.id,
    required this.email,
    required this.password,
    this.birthDate,
    required this.gender,
    this.address,
    required this.registrationDate,
    required this.status,
    this.photo,
    required this.username,
    this.bio,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id_utilisateur'] ?? 0,
      email: json['email'] ?? '',
      password: '', // Don't store password
      birthDate: json['date_naissance'] != null ? DateTime.parse(json['date_naissance']) : null,
      gender: json['genre'] ?? 'prefer not to say',
      address: json['adresse'],
      registrationDate: DateTime.parse(json['date_inscription'] ?? DateTime.now().toString()),
      status: json['statut'] ?? 'actif',
      photo: json['photo'],
      username: json['username'] ?? '',
      bio: null, // Your schema doesn't have a bio field
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_utilisateur': id,
      'email': email,
      'mot_de_passe': password,
      'date_naissance': birthDate?.toIso8601String(),
      'genre': gender,
      'adresse': address,
      'date_inscription': registrationDate.toIso8601String(),
      'statut': status,
      'photo': photo,
      'username': username,
    };
  }

  User copyWith({
    int? id,
    String? email,
    String? password,
    DateTime? birthDate,
    String? gender,
    String? address,
    DateTime? registrationDate,
    String? status,
    String? photo,
    String? username,
    String? bio,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      registrationDate: registrationDate ?? this.registrationDate,
      status: status ?? this.status,
      photo: photo ?? this.photo,
      username: username ?? this.username,
      bio: bio ?? this.bio,
    );
  }
}