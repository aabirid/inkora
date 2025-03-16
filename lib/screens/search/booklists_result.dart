import 'package:flutter/material.dart';
import 'package:inkora/widgets/booklist_card.dart';
import 'package:inkora/models/booklist.dart'; 

class BooklistsResult extends StatelessWidget {
  final String query;

  BooklistsResult({super.key, required this.query});

  final List<Booklist> booklists = [
    Booklist(
      id: "1",
      title: "Best Books of the 2000s",
      coverImage: "assets/images/book_cover.jpeg",
      likes: 507,
      booksCount: 30,
    ),
    Booklist(
      id: "2",
      title: "Top Fantasy Reads",
      coverImage: "assets/images/book_cover3.jpeg",
      likes: 6049,
      booksCount: 25,
    ),
    Booklist(
      id: "3",
      title: "Sci-Fi Must Reads",
      coverImage: "assets/images/book_cover2.jpeg",
      likes: 323,
      booksCount: 18,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    List<Booklist> filteredBooklists = booklists.where((booklist) {
      return booklist.title.toLowerCase().contains(query.toLowerCase());
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
