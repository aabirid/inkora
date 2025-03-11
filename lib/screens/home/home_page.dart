import 'package:flutter/material.dart';
import 'package:inkora/models/book.dart';
import 'package:inkora/screens/book/book_overview.dart';
import 'package:inkora/widgets/simple_book_card.dart';

class HomePage extends StatelessWidget {
  final List<Book> recommendedBooks = [
    Book(
      id: "1",
      title: "Fantasy Besties",
      author: "John Doe",
      coverImage: "assets/images/book_cover3.jpeg",
      description: "A thrilling fantasy adventure...",
      rating: 4.5,
      chapters: 25,
      status: "Ongoing",
    ),
    Book(
      id: "2",
      title: "Sci-Fi Odyssey",
      author: "Jane Doe",
      coverImage: "assets/images/book_cover2.jpeg",
      description: "Explore the galaxies in this sci-fi epic...",
      rating: 4.2,
      chapters: 30,
      status: "Completed",
    ),
  ];

  final List<Book> continueReadingBooks = [
    Book(
      id: "4",
      title: "Fantasy Besties",
      author: "John Doe",
      coverImage: "assets/images/book_cover.jpeg",
      description: "A thrilling fantasy adventure...",
      rating: 4.5,
      chapters: 25,
      status: "Ongoing",
    ),
    Book(
      id: "5",
      title: "Sci-Fi Odyssey",
      author: "Jane Doe",
      coverImage: "assets/images/book_cover2.jpeg",
      description: "Explore the galaxies in this sci-fi epic...",
      rating: 4.2,
      chapters: 30,
      status: "Completed",
    ),
  ];

  final List<Book> followingBooks = [
    Book(
      id: "3",
      title: "Fantasy Besties",
      author: "John Doe",
      coverImage: "assets/images/book_cover.jpeg",
      description: "A thrilling fantasy adventure...",
      rating: 4.5,
      chapters: 25,
      status: "Ongoing",
    ),
    Book(
      id: "6",
      title: "Sci-Fi Odyssey",
      author: "Jane Doe",
      coverImage: "assets/images/book_cover2.jpeg",
      description: "Explore the galaxies in this sci-fi epic...",
      rating: 4.2,
      chapters: 30,
      status: "Completed",
    ),
    Book(
      id: "8",
      title: "Fantasy Besties",
      author: "John Doe",
      coverImage: "assets/images/book_cover3.jpeg",
      description: "A thrilling fantasy adventure...",
      rating: 4.5,
      chapters: 25,
      status: "Ongoing",
    ),
  ];

  final List<Book> popularBooks = [
    Book(
      id: "12",
      title: "Sci-Fi Odyssey",
      author: "Jane Doe",
      coverImage: "assets/images/book_cover2.jpeg",
      description: "Explore the galaxies in this sci-fi epic...",
      rating: 4.2,
      chapters: 30,
      status: "Completed",
    ),
    Book(
      id: "9",
      title: "Fantasy Besties",
      author: "John Doe",
      coverImage: "assets/images/book_cover.jpeg",
      description: "A thrilling fantasy adventure...",
      rating: 4.5,
      chapters: 25,
      status: "Ongoing",
    ),
    Book(
      id: "22",
      title: "Sci-Fi Odyssey",
      author: "Jane Doe",
      coverImage: "assets/images/book_cover2.jpeg",
      description: "Explore the galaxies in this sci-fi epic...",
      rating: 4.2,
      chapters: 30,
      status: "Completed",
    ),
  ];

   HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("Recommended Books"),
          _buildBookGrid(context, recommendedBooks),
          _buildSectionTitle("Continue Reading"),
          _buildBookGrid(context, continueReadingBooks),
          _buildSectionTitle("Following"),
          _buildBookGrid(context, followingBooks),
          _buildSectionTitle("Popular Books"),
          _buildBookGrid(context, popularBooks),
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

  Widget _buildBookGrid(BuildContext context, List<Book> books) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 3, // Dynamic columns
        childAspectRatio: 0.7,
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
}
