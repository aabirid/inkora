import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:inkora/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  String _errorMessage = '';
  bool _isLoading = false;

  User? get user => _user;
  String get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  final String _baseUrl = 'http://192.168.1.105/inkora_api';

  // Login method
  Future<bool> login(String identifier, String password) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/login.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'identifier': identifier,
          'password': password,
        }),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['token'] != null) {
        _user = User(
          id: data['id_utilisateur'],
          email: data['email'] ?? '',
          password: '',
          gender: data['genre'] ?? '',
          registrationDate: DateTime.tryParse(data['date_inscription'] ?? '') ??
              DateTime.now(),
          status: data['statut'] ?? '',
          username: data['username'] ?? '',
          bio: data['bio'] ?? '',
          photo: data['photo'] ?? '',
        );

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', data['token']);
        await prefs.setString('username', data['username']);

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = data['error'] ?? 'Login failed. Please try again.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Network error. Please check your connection.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Register method
  Future<bool> register({
    required String username,
    required String email,
    required String password,
    required String gender,
    DateTime? birthDate,
    String? country,
  }) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/register.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username,
          'email': email,
          'password': password,
          'genre': gender,
          'date_naissance': birthDate?.toIso8601String(),
          'adresse': country,
        }),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['message'] != null) {
        return await login(email, password);
      } else {
        _errorMessage =
            data['error'] ?? 'Registration failed. Please try again.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Network error. Please check your connection.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Auto login using saved token and username
  Future<bool> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final username = prefs.getString('username');

    if (token == null || username == null) {
      return false;
    }

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/user_details.php?username=$username'),
        headers: {'Authorization': 'Bearer $token'},
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['user'] != null) {
        _user = User(
          id: data['user']['id_utilisateur'],
          email: data['user']['email'] ?? '',
          password: '',
          gender: data['user']['genre'] ?? '',
          registrationDate:
              DateTime.tryParse(data['user']['date_inscription'] ?? '') ??
                  DateTime.now(),
          status: data['user']['statut'] ?? '',
          username: data['user']['username'] ?? '',
        );

        notifyListeners();
        return true;
      }
    } catch (e) {
      _errorMessage = 'Failed to fetch user details. Please try again.';
    }

    return false;
  }

  // Update profile method
  Future<bool> updateProfile({
    required String username,
    String? bio,
    String? photoPath,
  }) async {
    if (_user == null) return false;

    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/update_profile.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'id_utilisateur': _user!.id,
          'username': username,
          'bio': bio,
          'photo':
              photoPath, // You should handle image upload separately if needed
        }),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        _user = _user!.copyWith(
          username: username,
          bio: bio,
          photo: photoPath,
        );

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', username);

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = data['error'] ?? 'Failed to update profile';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Network error. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Logout method
  Future<void> logout() async {
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('username');
    notifyListeners();
  }
}
