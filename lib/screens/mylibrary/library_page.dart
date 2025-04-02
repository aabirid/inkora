import 'package:flutter/material.dart';
import 'package:inkora/models/book.dart';
import 'package:inkora/models/booklist.dart';
import 'package:inkora/widgets/simple_book_card.dart';
import 'package:inkora/widgets/simple_booklist_card.dart';
import 'package:inkora/screens/book/book_overview.dart';
import 'package:inkora/screens/book/booklist_overview.dart';

class LibraryPage extends StatelessWidget {
  final List<Book> myBooks = [
    Book(
      id: 1,
      title: "The Alchemist",
      author: "Paulo Coelho",
      coverImage: "assets/images/book_cover7.jpeg",
      description: "A journey to find one's destiny.",
      rating: 4.5,
      chapters: 15,
      status: "Completed",
    ),
    Book(
      id: 2,
      title: "1984",
      author: "George Orwell",
      coverImage: "assets/images/book_cover6.jpeg",
      description: "A dystopian future ruled by surveillance.",
      rating: 4.8,
      chapters: 24,
      status: "Completed",
    ),
  ];

  final List<Booklist> myBooklists = [
    Booklist(
      id: 1,
      userId: 101,
      title: "Classics to Read",
      visibility: "public",
      creationDate: DateTime(2023, 5, 20),
      likesCount: 100,
      booksCount: 2,
      books: [
        Book(
          id: 1,
          title: "The Alchemist",
          author: "Paulo Coelho",
          coverImage: "assets/images/book_cover8.jpeg",
          description: "A journey to find one's destiny.",
          rating: 4.5,
          chapters: 15,
          status: "Completed",
        ),
      ],
    ),
  ];

   LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("Saved Books"),
          _buildBookGrid(myBooks),
          const SizedBox(height: 20),
          _buildSectionTitle("Saved Booklists"),
          _buildBooklistGrid(myBooklists),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildBookGrid(List<Book> books) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.55,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: books.length,
      itemBuilder: (context, index) {
        return SimpleBookCard(
          book: books[index],
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookOverview(bookId: books[index].id),
              ),
            );
          },
        );
      },
    );
  }
    
  Widget _buildBooklistGrid(List<Booklist> booklists) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.55,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: booklists.length,
      itemBuilder: (context, index) {
        return SimpleBooklistCard(
          booklist: booklists[index],
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BooklistOverview(booklistId: booklists[index].id),
              ),
            );
          },
        );
      },
    );
  }
}
