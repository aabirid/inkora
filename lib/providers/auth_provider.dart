import 'package:flutter/material.dart';
import '../models/user.dart';

enum AuthStatus {
  unauthenticated,
  authenticating,
  authenticated,
  error,
}

class AuthProvider extends ChangeNotifier {
  AuthStatus _status = AuthStatus.unauthenticated;
  User? _currentUser;
  String _errorMessage = '';

  // Sample users for authentication
  final List<User> _users = [
    User(
      id: 1,
      firstName: 'John',
      lastName: 'Smith',
      email: 'john@example.com',
      username: 'johnsmith',
      password: 'password123',
      gender: 'Male',
      birthDate: DateTime(1990, 5, 15),
      registrationDate: DateTime(2023, 1, 10),
      status: 'active',
      photo: 'assets/images/nonfiction.jpeg',
      bio: 'A passionate reader and writer.',
    ),
    User(
      id: 2,
      firstName: 'Emily',
      lastName: 'Johnson',
      email: 'emily@example.com',
      username: 'emilyjohnson',
      password: 'password123',
      gender: 'Female',
      birthDate: DateTime(1992, 8, 20),
      registrationDate: DateTime(2023, 2, 15),
      status: 'active',
      photo: 'assets/images/poetry.jpeg',
      bio: 'Loves to read poetry and fiction.',
    ),
    User(
      id: 3,
      firstName: 'Michael',
      lastName: 'Williams',
      email: 'michael@example.com',
      username: 'michaelwilliams',
      password: 'password123',
      gender: 'Male',
      birthDate: DateTime(1988, 3, 10),
      registrationDate: DateTime(2023, 3, 5),
      status: 'active',
      photo: 'assets/images/adventure.jpeg',
      bio: 'Adventure book enthusiast.',
    ),
  ];

  AuthStatus get status => _status;
  User? get currentUser => _currentUser;
  String get errorMessage => _errorMessage;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  // Login with email/username and password
  Future<bool> login(String emailOrUsername, String password) async {
    _status = AuthStatus.authenticating;
    _errorMessage = '';
    notifyListeners();

    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 800));
      
      // Find user by email or username
      User? user;
      for (var u in _users) {
        if (u.email == emailOrUsername || u.username == emailOrUsername) {
          user = u;
          break;
        }
      }
      
      if (user == null) {
        throw Exception('User not found');
      }
      
      // Check password
      if (user.password != password) {
        throw Exception('Invalid password');
      }

      _currentUser = user;
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e.toString().contains('Exception:') 
          ? e.toString().split('Exception: ')[1] 
          : 'An error occurred';
      notifyListeners();
      return false;
    }
  }

  // Register a new user
  Future<bool> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String gender,
    DateTime? birthDate,
    String? country,
  }) async {
    _status = AuthStatus.authenticating;
    _errorMessage = '';
    notifyListeners();

    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 1000));
      
      // Check if user already exists
      bool existingUser = false;
      for (var u in _users) {
        if (u.email == email || u.username == '${firstName.toLowerCase()}${lastName.toLowerCase()}') {
          existingUser = true;
          break;
        }
      }
      
      if (existingUser) {
        throw Exception('User with this email or username already exists');
      }

      // Create a new user
      final newId = _users.isEmpty ? 1 : _users.map((u) => u.id).reduce((a, b) => a > b ? a : b) + 1;
      final username = (firstName.toLowerCase() + lastName.toLowerCase()).replaceAll(' ', '');
      
      final newUser = User(
        id: newId,
        firstName: firstName,
        lastName: lastName,
        email: email,
        username: username,
        password: password,
        gender: gender,
        birthDate: birthDate,
        address: country,
        registrationDate: DateTime.now(),
        status: 'active',
        photo: 'assets/images/default_profile.jpeg',
        bio: 'New Inkora user',
      );
      
      _users.add(newUser);
      _currentUser = newUser;
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e.toString().contains('Exception:') 
          ? e.toString().split('Exception: ')[1] 
          : 'An error occurred';
      notifyListeners();
      return false;
    }
  }

  // Logout the current user
  void logout() {
    _currentUser = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }
}

