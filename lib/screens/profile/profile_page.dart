import 'package:flutter/material.dart';
import 'package:inkora/models/book.dart';
import 'package:inkora/screens/book/book_overview.dart';
import 'package:inkora/screens/profile/profile_edit_page.dart';
import 'package:inkora/widgets/simple_book_card.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int selectedTab = 0;

  final List<Book> myBooks = [
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
    Book(
      id: "12",
      title: "Sci-Fi Odyssey",
      author: "Jane Doe",
      coverImage: "assets/images/book_cover4.jpeg",
      description: "Explore the galaxies in this sci-fi epic...",
      rating: 4.2,
      chapters: 30,
      status: "Completed",
    ),
     Book(
      id: "18",
      title: "Sci-Fi Odyssey",
      author: "Jane Doe",
      coverImage: "assets/images/book_cover.jpeg",
      description: "Explore the galaxies in this sci-fi epic...",
      rating: 4.2,
      chapters: 30,
      status: "Completed",
    ),
  ];

  final List<Book> myBooklists = [
    Book(
      id: "3",
      title: "Romantic Vibes",
      author: "Emily Heart",
      coverImage: "assets/images/book_cover4.jpeg",
      description: "A heartwarming love story...",
      rating: 4.8,
      chapters: 20,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildProfileSection(),
          const Divider(height: 1),
          _buildTabBar(),
          const Divider(height: 1),
          const SizedBox(height: 10),
          Expanded(
            child: _buildBookGrid(
              context,
              selectedTab == 0 ? myBooks : myBooklists,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage('assets/images/profile_default.jpeg'),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatColumn('4', 'Work'),
              _buildStatColumn('258', 'Followers'),
              _buildStatColumn('62', 'Following'),
            ],
          ),
          const SizedBox(height: 16),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Sara Jane',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text('Breathing books that\'s how I live'),
              Text('Coming Soon... 🔔'),
            ],
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext) {
                    return ProfileEditPage();
                  },
                ),
              );
            },
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 40),
            ),
            child: const Text('Edit Profile'),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Row(
      children: [
        Expanded(
          child: IconButton(
            icon: Icon(
              Icons.article_outlined,
              color: selectedTab == 0 ? Colors.green : Colors.grey,
            ),
            onPressed: () {
              setState(() {
                selectedTab = 0; // My Books
              });
            },
          ),
        ),
        Expanded(
          child: IconButton(
            icon: Icon(
              Icons.bookmark_border,
              color: selectedTab == 1 ? Colors.green : Colors.grey,
            ),
            onPressed: () {
              setState(() {
                selectedTab = 1; // Bookmarked Books
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStatColumn(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildBookGrid(BuildContext context, List<Book> books) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 3,
        childAspectRatio: 0.6,
        crossAxisSpacing: 10,
        mainAxisSpacing: 15,
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
