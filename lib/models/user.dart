class User {
  final int id;
  final String lastName;
  final String firstName;
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
    required this.lastName,
    required this.firstName,
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
      id: json['id'] ?? 0,
      lastName: json['lastName'] ?? '',
      firstName: json['firstName'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      birthDate: json['birthDate'] != null ? DateTime.parse(json['birthDate']) : null,
      gender: json['gender'] ?? 'prefer not to say',
      address: json['address'],
      registrationDate: DateTime.parse(json['registrationDate'] ?? DateTime.now().toString()),
      status: json['status'] ?? 'active',
      photo: json['photo'],
      username: json['username'] ?? '',
      bio: json['bio'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lastName': lastName,
      'firstName': firstName,
      'email': email,
      'password': password,
      'birthDate': birthDate?.toIso8601String(),
      'gender': gender,
      'address': address,
      'registrationDate': registrationDate.toIso8601String(),
      'status': status,
      'photo': photo,
      'username': username,
      'bio': bio,
    };
  }

  User copyWith({
    int? id,
    String? lastName,
    String? firstName,
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
      lastName: lastName ?? this.lastName,
      firstName: firstName ?? this.firstName,
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
