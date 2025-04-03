import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:inkora/models/book.dart';
import 'package:inkora/models/booklist.dart';
import 'package:inkora/models/chapter.dart';
import 'package:inkora/models/category.dart';
import 'package:inkora/models/group.dart';
import 'package:inkora/models/user.dart';
import 'package:inkora/models/comment.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Base URL of your PHP API
  static const String baseUrl = 'http://192.168.1.100/inkora_api';

  // Headers for API requests
  final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Singleton pattern
  static final ApiService _instance = ApiService._internal();

  factory ApiService() {
    return _instance;
  }

  ApiService._internal();

// Get current user ID from SharedPreferences
  Future<int?> getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('auth_token');
    if (userData != null) {
      // Get user ID from SharedPreferences
      return prefs.getInt('user_id');
    }
    return null;
  }

  // ==================== SEARCH FUNCTIONALITY ====================

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
      members: json['members'] != null ? List<int>.from(json['members']) : null,
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

  // ==================== CATEGORIES ====================

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

  // ==================== BOOKS CRUD OPERATIONS ====================

  // Get all books
  Future<List<Book>> getBooks() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/book.php?action=read'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> booksData = json.decode(response.body);
        return booksData.map((data) => Book.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load books: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load books: $e');
    }
  }

  // Create a new book
  Future<Book> createBook(Book book) async {
    try {
      final Map<String, dynamic> bookData = book.toJson();

      final response = await http.post(
        Uri.parse('$baseUrl/book.php?action=create'),
        headers: headers,
        body: json.encode(bookData),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Ensure that the response contains the full book object with 'id'
        if (responseData['message'] == 'Book created successfully') {
          // Assuming the response includes a 'book' object with the id
          final createdBookData = responseData['book'];
          return Book.fromJson(
              createdBookData); // Return the full Book object with id
        } else {
          throw Exception('Failed to create book');
        }
      } else {
        throw Exception('Failed to create book: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to create book: $e');
    }
  }

  // Update an existing book
  Future<bool> updateBook(Book book) async {
    try {
      final Map<String, dynamic> bookData = book.toJson();

      final response = await http.post(
        Uri.parse('$baseUrl/book.php?action=update'),
        headers: headers,
        body: json.encode(bookData),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return responseData['message'] == 'Book updated successfully';
      } else {
        throw Exception('Failed to update book: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to update book: $e');
    }
  }

  // Delete a book
  Future<bool> deleteBook(int bookId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/book.php?action=delete&id=$bookId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return responseData['message'] == 'Book deleted successfully';
      } else {
        throw Exception('Failed to delete book: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to delete book: $e');
    }
  }

  // ==================== CHAPTERS CRUD OPERATIONS ====================

  // Get chapters by book ID
  Future<List<Chapter>> getChaptersByBookId(int bookId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/chapter.php?action=read_by_book&book_id=$bookId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> chaptersData = json.decode(response.body);
        return chaptersData.map((data) => Chapter.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load chapters: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load chapters: $e');
    }
  }

  // Create a new chapter
  Future<Map<String, dynamic>?> createChapter(Chapter chapter) async {
    try {
      final Map<String, dynamic> chapterData = {
        'book_id': chapter.bookId,
        'title': chapter.title,
        'content': chapter.content,
      };

      final response = await http.post(
        Uri.parse('$baseUrl/chapter.php?action=create'),
        headers: headers,
        body: json.encode(chapterData),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData.containsKey('message') &&
            responseData['message'] == 'Chapter created successfully') {
          return {
            'id': int.parse(responseData['id'].toString()),
            'order': int.parse(responseData['order'].toString()),
          };
        }
        return null;
      } else {
        throw Exception('Failed to create chapter: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to create chapter: $e');
    }
  }

  // Update an existing chapter
  Future<bool> updateChapter(Chapter chapter) async {
    try {
      final Map<String, dynamic> chapterData = {
        'id': chapter.id,
        'title': chapter.title,
        'content': chapter.content,
      };

      final response = await http.post(
        Uri.parse('$baseUrl/chapter.php?action=update'),
        headers: headers,
        body: json.encode(chapterData),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return responseData['message'] == 'Chapter updated successfully';
      } else {
        throw Exception('Failed to update chapter: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to update chapter: $e');
    }
  }

  // Delete a chapter
  Future<bool> deleteChapter(int chapterId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/chapter.php?action=delete&id=$chapterId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return responseData['message'] == 'Chapter deleted successfully';
      } else {
        throw Exception('Failed to delete chapter: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to delete chapter: $e');
    }
  }

  // Reorder chapters
  Future<bool> reorderChapters(int bookId, List<Chapter> newOrder) async {
    try {
      final List<Map<String, dynamic>> chaptersData =
          newOrder.asMap().entries.map((entry) {
        final index = entry.key;
        final chapter = entry.value;
        return {
          'id': chapter.id,
          'order': index + 1,
        };
      }).toList();

      final Map<String, dynamic> data = {
        'book_id': bookId,
        'chapters': chaptersData,
      };

      final response = await http.post(
        Uri.parse('$baseUrl/chapter.php?action=reorder'),
        headers: headers,
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return responseData['message'] == 'Chapters reordered successfully';
      } else {
        throw Exception('Failed to reorder chapters: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to reorder chapters: $e');
    }
  }

  // Get a single book by ID
  Future<Book> getBookById(int bookId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/book.php?action=read_single&id=$bookId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> bookData = json.decode(response.body);
        return Book.fromJson(bookData);
      } else {
        throw Exception('Failed to load book: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load book: $e');
    }
  }

  // Get comments for a book
  Future<List<Comment>> getBookComments(int bookId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/comment.php?action=read_by_book&book_id=$bookId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> commentsData = json.decode(response.body);
        return commentsData.map((data) => Comment.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load comments: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load comments: $e');
    }
  }

  // Add a comment to a book
  Future<bool> addComment(Comment comment) async {
    try {
      final Map<String, dynamic> commentData = {
        'user_id': comment.userId,
        'book_id': comment.bookId,
        'content': comment.content,
      };

      final response = await http.post(
        Uri.parse('$baseUrl/comment.php?action=create'),
        headers: headers,
        body: json.encode(commentData),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return responseData['message'] == 'Comment added successfully';
      } else {
        throw Exception('Failed to add comment: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to add comment: $e');
    }
  }

  // Toggle bookmark status for a book
  Future<bool> toggleBookmark(int userId, int bookId) async {
    try {
      final Map<String, dynamic> data = {
        'user_id': userId,
        'book_id': bookId,
      };

      final response = await http.post(
        Uri.parse('$baseUrl/favorite.php?action=toggle'),
        headers: headers,
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return responseData['status'] == 'success';
      } else {
        throw Exception('Failed to toggle bookmark: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to toggle bookmark: $e');
    }
  }

  // Check if a book is bookmarked by user
  Future<bool> isBookmarked(int userId, int bookId) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$baseUrl/favorite.php?action=check&user_id=$userId&book_id=$bookId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return responseData['is_favorite'] == true;
      } else {
        throw Exception(
            'Failed to check bookmark status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to check bookmark status: $e');
    }
  }

// Get a single booklist by ID
  Future<Booklist> getBooklistById(int booklistId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/booklist.php?action=read_single&id=$booklistId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> booklistData = json.decode(response.body);
        return Booklist.fromJson(booklistData);
      } else {
        throw Exception('Failed to load booklist: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load booklist: $e');
    }
  }

// Toggle favorite status for a booklist
  Future<bool> toggleBooklistFavorite(int userId, int booklistId) async {
    try {
      final Map<String, dynamic> data = {
        'user_id': userId,
        'booklist_id': booklistId,
      };

      final response = await http.post(
        Uri.parse('$baseUrl/booklist_favorite.php?action=toggle'),
        headers: headers,
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return responseData['status'] == 'success';
      } else {
        throw Exception('Failed to toggle favorite: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to toggle favorite: $e');
    }
  }

// Check if a booklist is favorited by user
  Future<bool> isBooklistFavorited(int userId, int booklistId) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$baseUrl/booklist_favorite.php?action=check&user_id=$userId&booklist_id=$booklistId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return responseData['is_favorite'] == true;
      } else {
        throw Exception(
            'Failed to check favorite status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to check favorite status: $e');
    }
  }

// Get chapter content
  Future<String> getChapterContent(int chapterId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/chapter.php?action=read_content&id=$chapterId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data['content'] ?? '';
      } else {
        throw Exception(
            'Failed to load chapter content: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load chapter content: $e');
    }
  }

// Update reading progress
  Future<bool> updateReadingProgress(
      int userId, int bookId, int chapterId) async {
    try {
      final Map<String, dynamic> data = {
        'user_id': userId,
        'book_id': bookId,
        'chapter_id': chapterId,
      };

      final response = await http.post(
        Uri.parse('$baseUrl/progress.php?action=update'),
        headers: headers,
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return responseData['status'] == 'success';
      } else {
        throw Exception('Failed to update progress: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to update progress: $e');
    }
  }

// Get user's reading progress for a book
  Future<int> getReadingProgress(int userId, int bookId) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$baseUrl/progress.php?action=get&user_id=$userId&book_id=$bookId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data['chapter_id'] ?? 0;
      } else {
        throw Exception(
            'Failed to get reading progress: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get reading progress: $e');
    }
  }

  // Update the getFavoriteBooks method to handle the direct array response
  Future<List<Book>> getFavoriteBooks(int userId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/get_favorites.php?user_id=$userId'));

    print("Response Status: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      
      // Check if the response is an error message
      if (data is Map && data.containsKey('status') && data['status'] == 'error') {
        throw Exception(data['message'] ?? 'Failed to load favorite books');
      }
      
      // Process the array of books
      if (data is List) {
        return data.map((json) {
          // Map the database field names to the Book model field names
          final mappedJson = {
            'id': json['id_livre'],
            'title': json['titre'],
            'author': json['auteur'],
            'coverImage': json['couverture'],
            'description': json['description'] ?? '',
            'rating': 0.0,  // Default values for required fields
            'chapters': 0,
            'status': 'Ongoing'
          };
          return Book.fromJson(mappedJson);
        }).toList();
      }
      
      return [];
    } else {
      throw Exception('Failed to load favorite books');
    }
  }

  // Update the getFavoriteBooklists method to handle the direct array response
  Future<List<Booklist>> getFavoriteBooklists(int userId) async {
 final response = await http
     .get(Uri.parse('$baseUrl/get_favorite_booklists.php?user_id=$userId'));

 print("Response Status: ${response.statusCode}");
 print("Response Body: ${response.body}");

 if (response.statusCode == 200) {
   final data = json.decode(response.body);
   
   // Check if the response is an error message
   if (data is Map && data.containsKey('status') && data['status'] == 'error') {
     throw Exception(data['message'] ?? 'Failed to load favorite booklists');
   }
   
   // Process the array of booklists
   if (data is List) {
     return data.map((json) {
       // Map the database field names to the Booklist model field names
       final mappedJson = {
         'id': json['id'],
         'userId': userId,
         'title': json['title'],
         'visibility': json['visibility'],
         'creationDate': DateTime.now().toIso8601String(),
       };
       return Booklist.fromJson(mappedJson);
     }).toList();
   } else {
     // If the response isn't a list, log the data for debugging
     print("Unexpected response format: $data");
   }
   
   return [];
 } else {
   throw Exception('Failed to load favorite booklists');
 }
}

}

