import 'package:flutter/material.dart';
import 'package:inkora/screens/search/books_result.dart';
import 'package:inkora/screens/search/booklists_result.dart';
import 'package:inkora/screens/search/authors_result.dart';

class SearchResultsPage extends StatelessWidget {
  final String query;

  const SearchResultsPage({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Results for '$query'"),
          bottom: TabBar(
            tabs: [
              Tab(text: "Books"),
              Tab(text: "Authors"),
              Tab(text: "Booklists"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            BooksResult(query: query),
            AuthorsResult(query: query),
            BooklistsResult(query: query),
          ],
        ),
      ),
    );
  }
}
