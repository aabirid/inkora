import 'package:flutter/material.dart';
import 'package:inkora/widgets/book_card.dart';

class BooksResult extends StatelessWidget {
  final String query;

  BooksResult({required this.query});

  final List<Map<String, dynamic>> books = [
    {
      "title": "Alice in Neverland",
      "author": "Richard Jones",
      "rating": 4.5,
      "status": "Finished",
      "chapters": 27,
      "description": "The musical follows Alice, growing older and obsessed with her memories of Wonderland, as she embarks on a daring journey to recapture her youth and discovers the sacrifices that might be required to never grow up.",
      "coverImage": 'assets/images/book_cover.jpeg'
    },
    {
      "title": "Mysterious Island",
      "author": "Jules Verne",
      "rating": 4.0,
      "status": "On-Going",
      "chapters": 35,
      "description": "The musical follows Alice, growing older and obsessed with her memories of Wonderland, as she embarks on a daring journey to recapture her youth and discovers the sacrifices that might be required to never grow up.",
      "coverImage": 'assets/images/book_cover2.jpeg'
    },
    {
      "title": "Flutter for Beginners",
      "author": "John Doe",
      "rating": 5.0,
      "status": "Completed",
      "chapters": 55,
      "description": "The musical follows Alice, growing older and obsessed with her memories of Wonderland, as she embarks on a daring journey to recapture her youth and discovers the sacrifices that might be required to never grow up.",
      "coverImage": 'assets/images/book_cover3.jpeg'
    }
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredBooks = books.where((book) {
      return book["title"].toLowerCase().contains(query.toLowerCase()) ||
          book["author"].toLowerCase().contains(query.toLowerCase());
    }).toList();

    return filteredBooks.isEmpty
        ? Center(child: Text("No books found for '$query'"))
        : ListView.builder(
            itemCount: filteredBooks.length,
            itemBuilder: (context, index) {
              return BookCard(book: filteredBooks[index]);
            },
          );
  }
}
