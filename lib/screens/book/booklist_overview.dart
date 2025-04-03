import 'package:flutter/material.dart';
import 'package:inkora/models/booklist.dart';
import 'package:inkora/screens/search/search_page.dart';
import 'package:inkora/widgets/book_card.dart';
import 'package:inkora/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:inkora/providers/auth_provider.dart';

class BooklistOverview extends StatefulWidget {
  final int booklistId;

  const BooklistOverview({super.key, required this.booklistId});

  @override
  _BooklistOverviewState createState() => _BooklistOverviewState();
}

class _BooklistOverviewState extends State<BooklistOverview> {
  late Future<Booklist> _booklistFuture;
  late Future<bool> _isFavoritedFuture;
  final ApiService _apiService = ApiService();
  int _userId =
      1; // Default user ID, should be replaced with actual logged-in user ID

  @override
  void initState() {
    super.initState();
    _loadUserId();
    _refreshData();
  }

  // Load the user ID from SharedPreferences
  Future<void> _loadUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _userId = prefs.getInt('user_id') ?? 1;
      });

      // Try to get username from AuthProvider if available
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.isAuthenticated && authProvider.user != null) {
        setState(() {
          _userId = authProvider.user!.id;
        });
      }
    } catch (e) {
      print('Error loading user id: $e');
      // Continue with default values
    }
  }

  // Refresh the data (booklist and favorite status)
  void _refreshData() {
    _booklistFuture = _apiService.getBooklistById(widget.booklistId);
    _isFavoritedFuture =
        _apiService.isBooklistFavorited(_userId, widget.booklistId);
  }

  // Toggle the favorite status of the booklist
  Future<void> _toggleFavorite() async {
    final success =
        await _apiService.toggleBooklistFavorite(_userId, widget.booklistId);
    if (success) {
      setState(() {
        _isFavoritedFuture =
            _apiService.isBooklistFavorited(_userId, widget.booklistId);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update favorite status')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<Booklist>(
          future: _booklistFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(snapshot.data!.title,
                  style: theme.textTheme.titleLarge);
            } else {
              return const Text('Booklist');
            }
          },
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
              // Implement sharing functionality
            },
          ),
        ],
      ),
      body: FutureBuilder<Booklist>(
        future: _booklistFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Booklist not found'));
          }

          final booklist = snapshot.data!;

          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  height: 100,
                  decoration: BoxDecoration(
                    color: theme.scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              booklist.title,
                              style: theme.textTheme.titleLarge,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          FutureBuilder<bool>(
                            future: _isFavoritedFuture,
                            builder: (context, snapshot) {
                              final isFavorited = snapshot.data ?? false;
                              return IconButton(
                                icon: Icon(
                                  isFavorited
                                      ? Icons.bookmark
                                      : Icons.bookmark_border,
                                  color: isFavorited
                                      ? theme.primaryColor
                                      : Colors.grey,
                                ),
                                onPressed: _toggleFavorite,
                              );
                            },
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.favorite,
                              size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            "${booklist.likesCount}",
                            style: theme.textTheme.bodyMedium,
                          ),
                          const SizedBox(width: 12),
                          const Icon(Icons.menu_book,
                              size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            "${booklist.booksCount}",
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: booklist.books != null && booklist.books!.isNotEmpty
                      ? RefreshIndicator(
                          onRefresh: () async {
                            setState(() {
                              _refreshData();
                            });
                          },
                          child: ListView.builder(
                            itemCount: booklist.books!.length,
                            itemBuilder: (context, index) {
                              return BookCard(book: booklist.books![index]);
                            },
                          ),
                        )
                      : Center(
                          child: Text(
                            "No books available in this booklist.",
                            style: theme.textTheme.bodyLarge,
                          ),
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
