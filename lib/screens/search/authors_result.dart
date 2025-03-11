import 'package:flutter/material.dart';
import 'package:inkora/widgets/author_card.dart';

class AuthorsResult extends StatelessWidget {
  final String query;

  AuthorsResult({required this.query});

  final List<Map<String, dynamic>> authors = [
    {"name": "Daydreamer", "profile-picture": 'assets/images/book_cover.jpeg'},
    {"name": "Max Jackson", "profile-picture": 'assets/images/book_cover3.jpeg'},
    {"name": "Mia Potter", "profile-picture": 'assets/images/book_cover2.jpeg'},
    {"name": "John Doe", "profile-picture": 'assets/images/book_cover.jpeg'},
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredAuthors = authors.where((authorData) {
      return authorData["name"].toLowerCase().contains(query.toLowerCase());
    }).toList();

    return filteredAuthors.isEmpty
        ? Center(child: Text("No authors found for '$query'"))
        : ListView.builder(
            itemCount: filteredAuthors.length,
            itemBuilder: (context, index) {
              return AuthorCard(author: filteredAuthors[index]); 
            },
          );
  }
}
