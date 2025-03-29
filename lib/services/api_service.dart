import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:inkora/models/book.dart';
import 'package:inkora/models/booklist.dart';
import 'package:inkora/models/group.dart';
import 'package:inkora/models/user.dart';
import 'package:inkora/models/category.dart';

class ApiService {
  // Base URL of your PHP API
  static const String baseUrl = 'http://192.168.1.105/inkora_api';
  
  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  
  factory ApiService() {
    return _instance;
  }
  
  ApiService._internal();
  
  // Search books
  Future<List<Book>> searchBooks(String query) async {
    final response = await http.get(
      Uri.parse('$baseUrl/search.php?type=books&query=$query'),
    );
    
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      
      if (data['status'] == 'success') {
        final List<dynamic> booksJson = data['data'];
        return booksJson.map((json) => Book.fromJson(json)).toList();
      } else {
        throw Exception(data['message'] ?? 'Failed to search books');
      }
    } else {
      throw Exception('Failed to connect to the server');
    }
  }
  
  // Search booklists
  Future<List<Booklist>> searchBooklists(String query) async {
    final response = await http.get(
      Uri.parse('$baseUrl/search.php?type=booklists&query=$query'),
    );
    
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      
      if (data['status'] == 'success') {
        final List<dynamic> booklistsJson = data['data'];
        return booklistsJson.map((json) => Booklist.fromJson(json)).toList();
      } else {
        throw Exception(data['message'] ?? 'Failed to search booklists');
      }
    } else {
      throw Exception('Failed to connect to the server');
    }
  }
  
  // Search groups
  Future<List<Group>> searchGroups(String query) async {
    final response = await http.get(
      Uri.parse('$baseUrl/search.php?type=groups&query=$query'),
    );
    
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      
      if (data['status'] == 'success') {
        final List<dynamic> groupsJson = data['data'];
        return groupsJson.map((json) => _parseGroup(json)).toList();
      } else {
        throw Exception(data['message'] ?? 'Failed to search groups');
      }
    } else {
      throw Exception('Failed to connect to the server');
    }
  }
  
  // Helper method to parse Group from JSON
  Group _parseGroup(Map<String, dynamic> json) {
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
      photo: json['photo'],
    );
  }
  
  // Search profiles
  Future<List<User>> searchProfiles(String query) async {
    final response = await http.get(
      Uri.parse('$baseUrl/search.php?type=profiles&query=$query'),
    );
    
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      
      if (data['status'] == 'success') {
        final List<dynamic> profilesJson = data['data'];
        return profilesJson.map((json) => User.fromJson(json)).toList();
      } else {
        throw Exception(data['message'] ?? 'Failed to search profiles');
      }
    } else {
      throw Exception('Failed to connect to the server');
    }
  }
  
  // Fetch all categories
  Future<List<Category>> getCategories() async {
    final response = await http.get(
      Uri.parse('$baseUrl/categories.php'),
    );
    
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      
      if (data['status'] == 'success') {
        final List<dynamic> categoriesJson = data['data'];
        return categoriesJson.map((json) => Category.fromJson(json)).toList();
      } else {
        throw Exception(data['message'] ?? 'Failed to fetch categories');
      }
    } else {
      throw Exception('Failed to connect to the server');
    }
  }
}

