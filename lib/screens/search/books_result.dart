import 'package:flutter/material.dart';
import 'package:inkora/models/book.dart';
import 'package:inkora/widgets/book_card.dart';

class BooksResult extends StatelessWidget {
  final String query;

  BooksResult({super.key, required this.query});

  final List<Book> books = [
    Book(
      id: "1",
      title: "Alice in Neverland",
      author: "Richard Jones",
      rating: 4.5,
      status: "Finished",
      chapters: 27,
      description: "Alice, growing older and obsessed with her memories of Wonderland, embarks on a daring journey to recapture her youth.",
      coverImage: 'assets/images/book_cover.jpeg',
    ),
    Book(
      id: "2",
      title: "Mysterious Island",
      author: "Jules Verne",
      rating: 4.0,
      status: "On-Going",
      chapters: 35,
      description: "A group of castaways struggle for survival on a mysterious island full of secrets.",
      coverImage: 'assets/images/book_cover2.jpeg',
    ),
    Book(
      id: "3",
      title: "Flutter for Beginners",
      author: "John Doe",
      rating: 5.0,
      status: "Completed",
      chapters: 55,
      description: "A complete guide to learning Flutter from scratch.",
      coverImage: 'assets/images/book_cover3.jpeg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    List<Book> filteredBooks = books.where((book) {
      return book.title.toLowerCase().contains(query.toLowerCase()) ||
          book.author.toLowerCase().contains(query.toLowerCase());
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
