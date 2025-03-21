import 'package:flutter/material.dart';
import 'package:inkora/models/book.dart';
import 'package:inkora/models/booklist.dart';
import 'package:inkora/models/user.dart';
import 'package:inkora/screens/book/book_overview.dart';
import 'package:inkora/screens/book/booklist_overview.dart';
import 'package:inkora/screens/profile/profile_edit_page.dart';
import 'package:inkora/widgets/simple_book_card.dart';
import 'package:inkora/widgets/simple_booklist_card.dart';
import 'dart:io';

class MyProfilePage extends StatefulWidget {
  final User currentUser;

  const MyProfilePage({super.key, required this.currentUser});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  late User _user; // Mutable user instance
  int selectedTab = 0;

  final List<Book> myBooks = [
    Book(
      id: 1,
      title: "Fantasy Besties",
      author: "John Doe",
      coverImage: "assets/images/book_cover3.jpeg",
      description: "A thrilling fantasy adventure...",
      rating: 4.5,
      chapters: 25,
      status: "Ongoing",
    ),
    Book(
      id: 2,
      title: "Sci-Fi Odyssey",
      author: "Jane Doe",
      coverImage: "assets/images/book_cover2.jpeg",
      description: "Explore the galaxies in this sci-fi epic...",
      rating: 4.2,
      chapters: 30,
      status: "Completed",
    ),
  ];

  final List<Booklist> myBooklists = [
    Booklist(
      id: 1,
      userId: 1,
      title: "My Fantasy Collection",
      visibility: "public",
      creationDate: DateTime.now(),
      books: [],
      likesCount: 230,
      booksCount: 15,
    ),
    Booklist(
      id: 2,
      userId: 1,
      title: "Top Mystery Picks",
      visibility: "public",
      creationDate: DateTime.now(),
      books: [],
      likesCount: 340,
      booksCount: 10,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _user = widget.currentUser; // Initialize with the passed user
  }

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
            child: _buildContentGrid(
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
          CircleAvatar(
            radius: 40,
            backgroundImage: _user.photo != null
                ? FileImage(
                    File(_user.photo!)) // Use FileImage for local images
                : const AssetImage("assets/images/profile_default.jpeg"),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '${_user.firstName} ${_user.lastName}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(_user.username),
              Text(_user.email),
              Text(_user.bio ?? ""),
            ],
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () async {
              final updatedUser = await Navigator.push<User>(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileEditPage(user: _user),
                ),
              );

              if (updatedUser != null) {
                setState(() {
                  _user = updatedUser; // Update local state
                });
              }
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
        _buildTabIcon(Icons.article_outlined, 0),
        _buildTabIcon(Icons.bookmark_border, 1),
      ],
    );
  }

  Widget _buildTabIcon(IconData icon, int index) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: IconButton(
          icon: Icon(
            icon,
            color: selectedTab == index ? Colors.green : Colors.grey,
          ),
          onPressed: () => setState(() => selectedTab = index),
        ),
      ),
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

  Widget _buildContentGrid(BuildContext context, List<dynamic> items) {
    if (items.isEmpty) {
      return const Center(child: Text("No items available"));
    }

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 3,
        childAspectRatio: 0.6,
        crossAxisSpacing: 10,
        mainAxisSpacing: 15,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) => items[index] is Book
          ? SimpleBookCard(
              book: items[index],
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookOverview(book: items[index]),
                ),
              ),
            )
          : SimpleBooklistCard(
              booklist: items[index],
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      BooklistOverview(booklist: items[index]),
                ),
              ),
            ),
    );
  }
}
