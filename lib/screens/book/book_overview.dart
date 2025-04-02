import 'dart:io';

import 'package:flutter/material.dart';
import 'package:inkora/models/book.dart';
import 'package:inkora/models/comment.dart';
import 'package:inkora/screens/book/read_book_page.dart';
import 'package:inkora/screens/search/search_page.dart';
import 'package:inkora/services/api_service.dart';
import 'package:provider/provider.dart';
import 'package:inkora/providers/auth_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookOverview extends StatefulWidget {
  final int bookId;

  const BookOverview({super.key, required this.bookId});

  @override
  _BookOverviewState createState() => _BookOverviewState();
}

class _BookOverviewState extends State<BookOverview> {
  final ApiService _apiService = ApiService();
  final TextEditingController _commentController = TextEditingController();

  int _userId =
      1; // Default user ID, should be replaced with actual logged-in user ID
  String _username = ''; // Will store the actual username
  String _userPhoto = ''; // Will store the user's profile photo URL
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  Book? _book;
  List<Comment> _comments = [];
  bool _isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _loadUserData().then((_) => _loadData());
  }

  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _userId = prefs.getInt('user_id') ?? 1;
        _username = prefs.getString('username') ?? 'User$_userId';
        _userPhoto = prefs.getString('user_photo') ?? '';
      });

      // Try to get username from AuthProvider if available
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.isAuthenticated && authProvider.user != null) {
        setState(() {
          _userId = authProvider.user!.id;
          _username = authProvider.user!.username;
          _userPhoto = authProvider.user!.photo ?? '';

          // Save the photo URL to SharedPreferences for future use
          if (authProvider.user!.photo != null && authProvider.user!.photo!.isNotEmpty) {
            prefs.setString('user_photo', authProvider.user!.photo!);
          }
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
      // Continue with default values
    }
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      // Load book details
      final book = await _apiService.getBookById(widget.bookId);

      // Load comments
      List<Comment> comments = [];
      try {
        comments = await _apiService.getBookComments(widget.bookId);
      } catch (e) {
        print('Error loading comments: $e');
        // Continue with empty comments list
      }

      // Check bookmark status
      bool isBookmarked = false;
      try {
        isBookmarked = await _apiService.isBookmarked(_userId, widget.bookId);
      } catch (e) {
        print('Error checking bookmark status: $e');
        // Continue with default bookmark status
      }

      // Only update state if the widget is still mounted
      if (mounted) {
        setState(() {
          _book = book;
          _comments = comments;
          _isBookmarked = isBookmarked;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading book data: $e');
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = 'Failed to load book details: ${e.toString()}';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _addComment() async {
    if (_commentController.text.trim().isEmpty || _book == null) return;

    setState(() {
      // Show loading indicator or disable button if needed
    });

    try {
      // Get the latest username and photo in case they were updated
      final prefs = await SharedPreferences.getInstance();
      final username = prefs.getString('username') ?? _username;
      final userPhoto = prefs.getString('user_photo') ?? _userPhoto;

      final newComment = Comment(
        id: 0, // Will be assigned by the server
        userId: _userId,
        userName: username, // Use the actual username
        bookId: widget.bookId,
        content: _commentController.text.trim(),
        commentDate: DateTime.now(),
        userPhoto: userPhoto, // Include the user's photo URL
      );

      final success = await _apiService.addComment(newComment);
      if (success) {
        _commentController.clear();
        // Reload comments
        try {
          final comments = await _apiService.getBookComments(widget.bookId);
          if (mounted) {
            setState(() {
              _comments = comments;
            });
          }
        } catch (e) {
          print('Error reloading comments: $e');
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to add comment')),
          );
        }
      }
    } catch (e) {
      print('Error adding comment: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _toggleBookmark() async {
    if (_book == null) return;

    try {
      final success = await _apiService.toggleBookmark(_userId, _book!.id);
      if (success && mounted) {
        setState(() {
          _isBookmarked = !_isBookmarked;
        });
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update bookmark')),
        );
      }
    } catch (e) {
      print('Error toggling bookmark: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Try to get the latest user data from AuthProvider on each build
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.isAuthenticated && authProvider.user != null) {
      _userId = authProvider.user!.id;
      _username = authProvider.user!.username;
      _userPhoto = authProvider.user!.photo ?? '';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_book?.title ?? 'Book Details'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => SearchPage()),
              );
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            icon: const Icon(Icons.share_rounded),
            onPressed: () {
              // Implement share functionality
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hasError
              ? _buildErrorView()
              : _book == null
                  ? const Center(child: Text('Book not found'))
                  : _buildBookContent(),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadData,
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookContent() {
    return RefreshIndicator(
      onRefresh: _loadData,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBookDetails(),
                  const SizedBox(height: 20),
                  Text(
                    _book!.description,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  _buildCommentsSection(),
                ],
              ),
            ),
          ),
          _buildCommentInput(),
        ],
      ),
    );
  }

  Widget _buildBookDetails() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: _book!.coverImage.startsWith('http')
              ? Image.network(
                  _book!.coverImage,
                  width: 120,
                  height: 180,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 120,
                      height: 180,
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image, size: 40),
                    );
                  },
                )
              : Image.asset(
                  _book!.coverImage,
                  width: 120,
                  height: 180,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 120,
                      height: 180,
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image, size: 40),
                    );
                  },
                ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_book!.title,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text("by ${_book!.author}",
                  style: const TextStyle(
                      fontSize: 16, fontStyle: FontStyle.italic)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.orange, size: 20),
                  const SizedBox(width: 4),
                  Text("${_book!.rating}"),
                  const SizedBox(width: 10),
                  Icon(Icons.menu_book_rounded, color: Colors.grey, size: 20),
                  const SizedBox(width: 5),
                  Text("${_book!.chapters} chapters"),
                ],
              ),
              const SizedBox(height: 10),
              _buildStatusTag(_book!.status),
              const SizedBox(height: 10),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ReadBookPage(bookId: _book!.id),
                        ),
                      );
                    },
                    child: Text("Read"),
                  ),
                  IconButton(
                    onPressed: _toggleBookmark,
                    icon: Icon(
                      _isBookmarked
                          ? Icons.bookmark
                          : Icons.bookmark_border_outlined,
                      color: _isBookmarked ? Colors.blue : null,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusTag(String status) {
    Color tagColor = status == "Completed" ? Colors.green : Colors.blue;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: tagColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        status,
        style: const TextStyle(
            color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildCommentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Comments",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        _comments.isEmpty
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: Text('No comments yet. Be the first to comment!'),
                ),
              )
            : SizedBox(
                height: 400, // Fix height to prevent infinite expansion
                child: ListView.builder(
                  itemCount: _comments.length,
                  itemBuilder: (context, index) {
                    final comment = _comments[index];
                    return ListTile(
                      leading: _buildUserAvatar(comment.userPhoto),
                      title: Text(comment.userName),
                      subtitle: Text(comment.content),
                      trailing: Text(
                        "${comment.commentDate.hour}:${comment.commentDate.minute}",
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    );
                  },
                ),
              ),
    ],
  );
}

Widget _buildUserAvatar(String? photoUrl) {
  ImageProvider imageProvider;

  if (photoUrl != null && photoUrl.isNotEmpty) {
    if (photoUrl.startsWith('http')) {
      imageProvider = NetworkImage(photoUrl);
    } else {
      imageProvider = FileImage(File(photoUrl));
    }
  } else {
    imageProvider = const AssetImage("assets/images/profile_default.jpeg");
  }

  return CircleAvatar(
    backgroundImage: imageProvider,
    onBackgroundImageError: (exception, stackTrace) {
      debugPrint("Failed to load image: $exception"); // Log the error
    },
  );
}



  Widget _buildCommentInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          _buildUserAvatar(_userPhoto), // Show the current user's avatar
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _commentController,
              decoration: const InputDecoration(
                hintText: "Add a comment...",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.blue),
            onPressed: _addComment,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}

