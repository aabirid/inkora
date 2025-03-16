import 'package:flutter/material.dart';
import 'package:inkora/models/book.dart';
import 'package:inkora/screens/search/search_page.dart';
import 'package:inkora/widgets/booklist_card.dart';
import 'package:inkora/widgets/book_card.dart';

class BooklistOverview extends StatelessWidget {
  final Map<String, dynamic> booklist;

  const BooklistOverview({super.key, required this.booklist});

  @override
  Widget build(BuildContext context) {
    final List<Book> books = [
      Book(
        id: "1",
        title: "Alice in Neverland",
        author: "Richard Jones",
        rating: 4.5,
        status: "Completed",
        chapters: 27,
        description: "Alice, growing older and obsessed with her memories of Wonderland, embarks on a journey to recapture her youth.",
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

    return Scaffold(
      appBar: AppBar(
        title: const Text("Booklist Overview"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => SearchPage()),
              );
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            icon: const Icon(Icons.share_rounded),
            onPressed: () {
              // TODO: Implement sharing functionality
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BooklistCard(booklist: booklist),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: books.length,
                itemBuilder: (context, index) {
                  return BookCard(book: books[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}