import 'package:flutter/material.dart';
import 'package:inkora/widgets/booklist_card.dart';

class BooklistsResult extends StatelessWidget {
  final String query;

  BooklistsResult({super.key, required this.query});

  final List<Map<String, dynamic>> booklists = [
    {
      "title": "Best Books of the 2000s",
      "likes": 507,
      "books": 30,
      "coverImage": "assets/images/book_cover.jpeg"
    },
    {
      "title": "Top Fantasy Reads",
      "likes": 6049,
      "books": 25,
      "coverImage": "assets/images/book_cover3.jpeg"
    },
    {
      "title": "Sci-Fi Must Reads",
      "likes": 323,
      "books": 18,
      "coverImage": "assets/images/book_cover2.jpeg"
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Filter booklists based on the search query
    List<Map<String, dynamic>> filteredBooklists = booklists.where((booklist) {
      return booklist["title"].toLowerCase().contains(query.toLowerCase());
    }).toList();

    return filteredBooklists.isEmpty
        ? Center(child: Text("No booklists found for '$query'"))
        : ListView.builder(
            itemCount: filteredBooklists.length,
            itemBuilder: (context, index) {
              return BooklistCard(booklist: filteredBooklists[index]);
            },
          );
  }
}
