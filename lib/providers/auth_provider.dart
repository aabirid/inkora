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

  // Base URL for your PHP API - update this to your actual server URL
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
          'identifier': identifier, // Peut être un email ou un username
          'password': password,
        }),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['token'] != null) {
        // Créer l'utilisateur
        _user = User(
          id: data['id_utilisateur'],
          email: data['email'],
          password: '',
          gender: data['genre'] ?? '',
          registrationDate: DateTime.parse(data['date_inscription']),
          status: data['statut'],
          username: data['username'],
        );

        // Sauvegarder le token et le username
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
          'genre':
              gender, // Note: your backend uses 'genre' instead of 'gender'
          'date_naissance': birthDate?.toIso8601String(),
          'adresse': country, // Using 'adresse' field for country
        }),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['message'] != null) {
        // Registration successful, now login
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

  // Check if user is already logged in
  Future<bool> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final username = prefs.getString('username');

    if (token == null || username == null) {
      return false;
    }

    // Create a basic user object from stored data
    // In a real app, you would make an API call to get full user details
    _user = User(
      id: 0, // We don't have the ID stored
      email: '', // We don't have the email stored
      password: '', // Don't store password
      gender: '', // We don't have this stored
      registrationDate: DateTime.now(),
      status: 'actif',
      username: username,
    );

    notifyListeners();
    return true;
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
