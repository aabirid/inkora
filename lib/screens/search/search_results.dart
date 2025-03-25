import 'package:flutter/material.dart';
import 'package:inkora/screens/search/books_result.dart';
import 'package:inkora/screens/search/booklists_result.dart';
import 'package:inkora/screens/search/groups_result.dart';
import 'package:inkora/screens/search/profiles_result.dart';

class SearchResultsPage extends StatelessWidget {
  final String query;

  const SearchResultsPage({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Results for '$query'"),
          bottom: TabBar(
            tabs: [
              Tab(text: "Books"),
              Tab(text: "Authors"),
              Tab(text: "Booklists"),
               Tab(text: "Groups"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            BooksResult(query: query),
            ProfilesResult(query: query),
            BooklistsResult(query: query),
            GroupsResult(query: query),
          ],
        ),
      ),
    );
  }
}
