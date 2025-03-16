import 'package:flutter/material.dart';
import 'package:inkora/screens/forum/chat_room_page.dart';

class ForumPage extends StatelessWidget {
  const ForumPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSearchBar(),
        _buildCreateRoomButton(),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSection(
                  context,
                  'Owner Of',
                  [
                    _buildRoomItem(
                      context,
                      'Fantasy Besties',
                      'assets/images/book_cover3.jpeg',
                    ),
                    _buildRoomItem(
                      context,
                      'Harry Potter',
                      'assets/images/book_cover2.jpeg',
                    ),
                  ],
                ),
                _buildSection(
                  context,
                  'Admin of',
                  [
                    _buildRoomItem(
                      context,
                      'Title',
                      'assets/images/book_cover3.jpeg',
                    ),
                    _buildRoomItem(
                      context,
                      'Title',
                      'assets/images/book_cover2.jpeg',
                    ),
                    _buildRoomItem(
                      context,
                      'Title',
                      'assets/images/book_cover.jpeg',
                    ),
                  ],
                ),
                _buildAdminMessage(),
                _buildSection(
                  context,
                  'Member Of',
                  [
                    _buildRoomItem(
                      context,
                      'Title',
                      'assets/images/book_cover.jpeg',
                    ),
                    _buildRoomItem(
                      context,
                      'Title',
                      'assets/images/book_cover3.jpeg',
                    ),
                    _buildRoomItem(
                      context,
                      'Title',
                      'assets/images/book_cover2.jpeg',
                    ),
                  ],
                ),
                _buildJoinNewRoomsButton(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildCreateRoomButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text('Create New Room'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green[200],
          foregroundColor: Colors.black,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: items,
          ),
        ),
      ],
    );
  }

  Widget _buildRoomItem(BuildContext context, String title, String imagePath) {
    return GestureDetector(
      onTap: () {
        if (title == 'Fantasy Besties') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ChatRoomPage(),
            ),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(imagePath),
              onBackgroundImageError: (exception, stackTrace) {
                // Fallback for image loading errors
              },
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminMessage() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        'You are not an admin in any room for the moment',
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildJoinNewRoomsButton() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text('Join New Rooms'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[200],
          foregroundColor: Colors.black,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      ),
    );
  }
}

