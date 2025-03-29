import 'package:flutter/material.dart';
import 'package:inkora/models/booklist.dart';
import 'package:inkora/services/api_service.dart';
import 'package:inkora/widgets/booklist_card.dart';

class BooklistsResult extends StatefulWidget {
  final String query;

  const BooklistsResult({super.key, required this.query});

  @override
  _BooklistsResultState createState() => _BooklistsResultState();
}

class _BooklistsResultState extends State<BooklistsResult> {
  late Future<List<Booklist>> _booklistsFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _booklistsFuture = _apiService.searchBooklists(widget.query);
  }

  @override
  void didUpdateWidget(BooklistsResult oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.query != widget.query) {
      setState(() {
        _booklistsFuture = _apiService.searchBooklists(widget.query);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Booklist>>(
      future: _booklistsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("No booklists found for '${widget.query}'"));
        } else {
          final booklists = snapshot.data!;
          return ListView.builder(
            itemCount: booklists.length,
            itemBuilder: (context, index) {
              return BooklistCard(booklist: booklists[index]);
            },
          );
        }
      },
    );
  }
}

