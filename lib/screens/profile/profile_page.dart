import 'package:flutter/material.dart';
import 'package:inkora/models/booklist.dart';
import 'package:inkora/models/user.dart';
import 'package:inkora/models/book.dart';
import 'package:inkora/screens/book/book_overview.dart';
import 'package:inkora/screens/book/booklist_overview.dart';
import 'package:inkora/widgets/simple_book_card.dart';
import 'package:inkora/widgets/simple_booklist_card.dart';
import 'package:inkora/theme/theme.dart';

class ProfilePage extends StatefulWidget {
  final User user; // Accept User parameter

  const ProfilePage({super.key, required this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int selectedTab = 0;
  late final User currentUser; // Declare variable for user

  bool isFollowing = false; // Track if the current user is following

  @override
  void initState() {
    super.initState();
    currentUser = widget.user; // Get user passed from the constructor

    // Optionally, you can check if the current user is already following this profile.
    // For now, I'm just initializing it as false. Update this with logic if needed.
  }

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

  // Function to toggle follow/unfollow
  void toggleFollow() {
    setState(() {
      isFollowing = !isFollowing; // Toggle the follow state
    });

    // Optionally, send a request to the backend to update the follow status in the database.
    // Example: sendFollowRequest(currentUser.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${currentUser.firstName} ${currentUser.lastName}'),
      ),
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
            backgroundImage: AssetImage(
              currentUser.photo ?? 'assets/images/profile_default.jpeg',
            ),
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
              Text('@${currentUser.username}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              if (currentUser.bio != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    currentUser.bio!,
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          // Follow Button (with conditional styling)
          isFollowing
              ? OutlinedButton(
                  onPressed: toggleFollow,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Theme.of(context).primaryColor,
                    side: BorderSide(color: Theme.of(context).primaryColor),
                    minimumSize: const Size(double.infinity, 40),
                  ),
                  child: Text('Unfollow', style: TextStyle(color: Theme.of(context).primaryColor)),
                )
              : ElevatedButton(
                  onPressed: toggleFollow,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 40),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  child: const Text('Follow'),
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
      child: IconButton(
        icon: Icon(
          icon,
          color: selectedTab == index ? Colors.green : Colors.grey,
        ),
        onPressed: () => setState(() => selectedTab = index),
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
