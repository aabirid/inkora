import 'package:flutter/material.dart';
import 'package:inkora/models/book.dart';
import 'package:inkora/models/booklist.dart';
import 'package:inkora/screens/book/book_overview.dart';
import 'package:inkora/screens/book/booklist_overview.dart';
import 'package:inkora/widgets/simple_book_card.dart';
import 'package:inkora/widgets/simple_booklist_card.dart';

class LibraryPage extends StatelessWidget {
  final List<Book> myBooks = [
    Book(
      id: "1",
      title: "Fantasy Besties",
      author: "John Doe",
      coverImage: "assets/images/book_cover6.jpeg",
      description: "A fantasy adventure",
      rating: 4.5,
      chapters: 12,
      status: "Ongoing",
    ),
    Book(
      id: "2",
      title: "Mystery Nights",
      author: "Jane Doe",
      coverImage: "assets/images/book_cover8.jpeg",
      description: "A thrilling mystery",
      rating: 4.8,
      chapters: 8,
      status: "Completed",
    ),
    Book(
      id: "3",
      title: "Sci-Fi Legends",
      author: "Sam Smith",
      coverImage: "assets/images/book_cover5.jpeg",
      description: "A space exploration story",
      rating: 4.9,
      chapters: 10,
      status: "Ongoing",
    ),
  ];

  final List<Booklist> myBooklists = [];

  LibraryPage({super.key}) {
    myBooklists.addAll([
      Booklist(
        id: "1",
        title: "My Fantasy Collection",
        coverImage: "assets/images/book_cover7.jpeg",
        likes: 230,
        booksCount: 15,
        books: myBooks,
      ),
      Booklist(
        id: "2",
        title: "Top Mystery Picks",
        coverImage: "assets/images/book_cover4.jpeg",
        likes: 340,
        booksCount: 10,
        books: myBooks,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [          
          const SizedBox(height: 12),
          _buildSectionTitle("Saved Books"),
          _buildBookGrid(myBooks),
          const SizedBox(height: 20),
          _buildSectionTitle("Saved Booklists"),
          _buildBooklistGrid(myBooklists), // Fixed this part
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16),
        ],
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
                builder: (context) => BookOverview(book: books[index]),
              ),
            );
          },
        );
      },
    );
  }

   // New function for Booklists
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
                builder: (context) => BooklistOverview(booklist: booklists[index]),
              ),
            );
          },
        );
      },
    );
  }
}
