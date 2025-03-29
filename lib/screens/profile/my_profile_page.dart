import 'package:flutter/material.dart';
import 'package:inkora/models/book.dart';
import 'package:inkora/models/booklist.dart';
import 'package:inkora/models/user.dart';
import 'package:inkora/screens/edit/profile_edit_page.dart';
import 'package:inkora/widgets/my_book_card.dart';
import 'package:inkora/widgets/my_booklist_card.dart';
import 'dart:io';

class MyProfilePage extends StatefulWidget {
  final User currentUser;

  const MyProfilePage({super.key, required this.currentUser});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  late User _user;
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
    _user = widget.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildProfileSection(),
          _buildTabBar(),
          Expanded(
            child: _buildContentList(
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
                ? (_user.photo!.startsWith('http')
                    ? NetworkImage(_user.photo!) // Network image
                    : FileImage(File(_user.photo!))) // Local file image
                : const AssetImage("assets/images/profile_default.jpeg")
                    as ImageProvider, // Default image
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatColumn('4', 'Work'),
              _buildStatColumn('258', 'Followers'),
              _buildStatColumn('62', 'Following'),
            ],
          ),
          const SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(_user.username),
              Text(_user.bio ?? ""),
            ],
          ),
          const SizedBox(height: 10),
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
                  _user = updatedUser; // Update the user with the new profile
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
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildTabIcon(Icons.article_outlined, 0),
          _buildTabIcon(Icons.bookmark_border, 1),
        ],
      ),
    );
  }

  Widget _buildTabIcon(IconData icon, int index) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3.0),
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

  Widget _buildContentList(BuildContext context, List<dynamic> items) {
    if (items.isEmpty) {
      return const Center(child: Text("No items available"));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemCount: items.length,
      itemBuilder: (context, index) {
        if (items[index] is Book) {
          return MyBookCard(book: items[index]);
        } else {
          return MyBooklistCard(
            booklist: items[index],
          );
        }
      },
    );
  }
}
