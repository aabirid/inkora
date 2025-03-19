import 'package:flutter/material.dart';
import 'package:inkora/widgets/booklist_card.dart';
import 'package:inkora/models/booklist.dart'; 
import 'package:inkora/models/book.dart'; // For the Book class

class BooklistsResult extends StatelessWidget {
  final String query;

  BooklistsResult({super.key, required this.query});

  final List<Booklist> booklists = [
    Booklist(
      id: 1,
      userId: 101,
      title: "Best Books of the 2000s",
      visibility: "public",
      creationDate: DateTime(2022, 6, 10),
      likesCount: 507,
      booksCount: 3,
      books: [
        Book(
          id: 1,
          title: "The Road",
          author: "Cormac McCarthy",
          coverImage: "assets/images/book_cover.jpeg",
          description: "A post-apocalyptic novel about survival and hope.",
          rating: 4.5,
          chapters: 12,
          status: "Completed",
        ),
        Book(
          id: 2,
          title: "The Kite Runner",
          author: "Khaled Hosseini",
          coverImage: "assets/images/kite_runner.jpeg",
          description: "A story of friendship and redemption in Afghanistan.",
          rating: 4.7,
          chapters: 20,
          status: "Completed",
        ),
      ],
    ),
    Booklist(
      id: 2,
      userId: 102,
      title: "Top Fantasy Reads",
      visibility: "public",
      creationDate: DateTime(2023, 4, 20),
      likesCount: 6049,
      booksCount: 3,
      books: [
        Book(
          id: 3,
          title: "Harry Potter and the Philosopher's Stone",
          author: "J.K. Rowling",
          coverImage: "assets/images/book_cover.jpeg",
          description: "The beginning of the legendary wizarding world.",
          rating: 4.9,
          chapters: 17,
          status: "Completed",
        ),
        Book(
          id: 4,
          title: "The title of the Wind",
          author: "Patrick Rothfuss",
          coverImage: "assets/images/book_cover.jpeg",
          description: "The epic tale of Kvothe's life and magic.",
          rating: 4.8,
          chapters: 22,
          status: "Ongoing",
        ),
      ],
    ),
    Booklist(
      id: 3,
      userId: 103,
      title: "Sci-Fi Must Reads",
      visibility: "private",
      creationDate: DateTime(2021, 9, 15),
      likesCount: 323,
      booksCount: 2,
      books: [
        Book(
          id: 5,
          title: "Dune",
          author: "Frank Herbert",
          coverImage: "assets/images/book_cover7.jpeg",
          description: "A science fiction epic set on the desert planet Arrakis.",
          rating: 4.6,
          chapters: 30,
          status: "Completed",
        ),
        Book(
          id: 6,
          title: "Neuromancer",
          author: "William Gibson",
          coverImage: "assets/images/book_cover.jpeg",
          description: "A cyberpunk classic about hacking and AI.",
          rating: 4.4,
          chapters: 20,
          status: "Completed",
        ),
      ],
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
