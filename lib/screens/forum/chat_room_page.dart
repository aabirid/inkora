import 'package:flutter/material.dart';

class ChatRoomPage extends StatefulWidget {
  const ChatRoomPage({super.key});

  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      'text': 'Guys did you read the latest chapters of Kingdom of fire ... period 🔥',
      'isCurrentUser': true,
      'timestamp': DateTime.now().subtract(const Duration(hours: 1)),
    },
    {
      'text': 'I diiid i think i\'m in love with the new caracter ❤️💕',
      'isCurrentUser': false,
      'user': 'Name1',
      'avatar': 'assets/images/user1.jpg',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 55)),
    },
    {
      'text': 'nooo don\'t spoil ☺️❤️ i didn\'t read it yet',
      'isCurrentUser': false,
      'user': 'Name2',
      'avatar': 'assets/images/user2.jpg',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 50)),
    },
    {
      'text': 'yeaaah i did came out last week ... happy (: ',
      'isCurrentUser': false,
      'user': 'Name3',
      'avatar': 'assets/images/user3.jpg',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 45)),
    },
    {
      'text': 'no waaay you should read it right now 😮🔥🔥',
      'isCurrentUser': true,
      'timestamp': DateTime.now().subtract(const Duration(minutes: 40)),
    },
    {
      'image': 'assets/images/map.jpg',
      'isCurrentUser': false,
      'user': 'Name1',
      'avatar': 'assets/images/user1.jpg',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 35)),
    },
  ];

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        _messages.add({
          'text': _messageController.text.trim(),
          'isCurrentUser': true,
          'timestamp': DateTime.now(),
        });
      });
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage('assets/images/book_cover3.jpeg'),
              radius: 16,
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Fantasy Besties',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '52 Members',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [          
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildChatMessages(),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildChatMessages() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _messages.length + 1, // +1 for the timestamp
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildTimestamp('Oct 05, 2024, 9:41 AM');
        }
        
        final message = _messages[index - 1];
        if (message.containsKey('image')) {
          return _buildImageMessage(
            message['image'],
            isCurrentUser: message['isCurrentUser'],
            avatar: message['avatar'],
            username: message['user'],
          );
        } else {
          return _buildMessage(
            message['text'],
            isCurrentUser: message['isCurrentUser'],
            avatar: message['avatar'],
            username: message['user'],
          );
        }
      },
    );
  }

  Widget _buildTimestamp(String timestamp) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 16),
        child: Text(
          timestamp,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildMessage(
    String message, {
    required bool isCurrentUser,
    String? avatar,
    String? username,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isCurrentUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundImage: AssetImage(avatar ?? 'assets/images/horror.jpeg'),
              onBackgroundImageError: (exception, stackTrace) {
                return;
              },
            ),
            const SizedBox(width: 8),
          ],
          Column(
            crossAxisAlignment:
                isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              if (!isCurrentUser)
                Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 4),
                  child: Text(
                    username ?? 'Unknown',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isCurrentUser ? Colors.green : Colors.grey[200],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  message,
                  style: TextStyle(
                    color: isCurrentUser ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImageMessage(
    String imagePath, {
    required bool isCurrentUser,
    String? avatar,
    String? username,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isCurrentUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundImage: AssetImage(avatar ?? 'assets/images/book_cover2.jpeg'),
              onBackgroundImageError: (exception, stackTrace) {
                return;
              },
            ),
            const SizedBox(width: 8),
          ],
          Column(
            crossAxisAlignment:
                isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              if (!isCurrentUser)
                Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 4),
                  child: Text(
                    username ?? 'Unknown',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  imagePath,
                  width: 200,
                  height: 150,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 200,
                      height: 150,
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.mic),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.image),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
        ],
      ),
    );
  }
}

