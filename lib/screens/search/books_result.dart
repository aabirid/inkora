import 'package:flutter/material.dart';
import 'package:inkora/models/book.dart';
import 'package:inkora/services/api_service.dart';
import 'package:inkora/widgets/book_card.dart';

class BooksResult extends StatefulWidget {
  final String query;

  const BooksResult({super.key, required this.query});

  @override
  _BooksResultState createState() => _BooksResultState();
}

class _BooksResultState extends State<BooksResult> {
  late Future<List<Book>> _booksFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _booksFuture = _apiService.searchBooks(widget.query);
  }

  @override
  void didUpdateWidget(BooksResult oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.query != widget.query) {
      setState(() {
        _booksFuture = _apiService.searchBooks(widget.query);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Book>>(
      future: _booksFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("No books found for '${widget.query}'"));
        } else {
          final books = snapshot.data!;
          return ListView.builder(
            itemCount: books.length,
            itemBuilder: (context, index) {
              return BookCard(book: books[index]);
            },
          );
        }
      },
    );
  }
}

