import 'package:flutter/material.dart';
import 'package:inkora/models/book.dart';
import 'package:inkora/models/booklist.dart';
import 'package:inkora/services/api_service.dart';
import 'package:inkora/widgets/simple_book_card.dart';
import 'package:inkora/widgets/simple_booklist_card.dart';
import 'package:inkora/screens/book/book_overview.dart';
import 'package:inkora/screens/book/booklist_overview.dart';

class LibraryPage extends StatefulWidget {
  // Add an optional user parameter
  final dynamic currentUser;
  
  const LibraryPage({super.key, this.currentUser});

  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  int? userId;
  List<Book> myBooks = [];
  List<Booklist> myBooklists = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _fetchFavorites(int userId) async {
  try {
    print("Fetching favorites for user ID: $userId");
    // Fetch books
    final books = await ApiService().getFavoriteBooks(userId);
    print("Fetched ${books.length} favorite books");

    // Fetch booklists
    final booklists = await ApiService().getFavoriteBooklists(userId);
    print("Fetched ${booklists.length} favorite booklists");

    // Check if the widget is still mounted before calling setState
    if (mounted) {
      setState(() {
        myBooks = books;
        myBooklists = booklists;
        isLoading = false; // Set loading to false once the data is fetched
      });
    }
  } catch (e) {
    print("Error fetching favorites: $e");
    if (mounted) {
      setState(() {
        isLoading = false; // Set loading to false on error
      });
    }
  }
}

Future<void> _loadUserData() async {
  if (widget.currentUser != null && widget.currentUser.id != null) {
    setState(() {
      userId = widget.currentUser.id;
    });
    print("Using user ID from props: $userId");
    _fetchFavorites(userId!);
  } else {
    // Fallback to API service if no user ID is provided
    int? fetchedUserId = await ApiService().getCurrentUserId();
    if (fetchedUserId != null) {
      if (mounted) {
        setState(() {
          userId = fetchedUserId;
        });
      }
      print("Using user ID from API service: $userId");
      _fetchFavorites(fetchedUserId);
    } else {
      print("No user ID found!");
      if (mounted) {
        setState(() {
          isLoading = false; // End loading state
        });
      }
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle("Saved Books"),
                myBooks.isEmpty
                    ? _buildEmptyMessage("No saved books yet.")
                    : _buildBookGrid(myBooks),
                const SizedBox(height: 20),
                _buildSectionTitle("Saved Booklists"),
                myBooklists.isEmpty
                    ? _buildEmptyMessage("No saved booklists yet.")
                    : _buildBooklistGrid(myBooklists),
              ],
            ),
          );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildEmptyMessage(String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: Text(
          message,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildBookGrid(List<Book> books) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.55,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: books.length,
      itemBuilder: (context, index) {
        return SimpleBookCard(
          book: books[index],
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookOverview(bookId: books[index].id),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBooklistGrid(List<Booklist> booklists) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.55,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: booklists.length,
      itemBuilder: (context, index) {
        return SimpleBooklistCard(
          booklist: booklists[index],
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    BooklistOverview(booklistId: booklists[index].id),
              ),
            );
          },
        );
      },
    );
  }
}
