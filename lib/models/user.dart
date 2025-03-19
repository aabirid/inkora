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
    };
  }
}