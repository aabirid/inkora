import 'package:flutter/material.dart';
import 'package:inkora/providers/data_provider.dart';
import 'package:inkora/models/group.dart';
import 'package:inkora/models/message.dart';
import 'package:inkora/utils/image_picker.dart';

class ChatRoomPage extends StatefulWidget {
  final int groupId;
  
  const ChatRoomPage({
    super.key, 
    required this.groupId,
  });

  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final TextEditingController _messageController = TextEditingController();
  late Group _currentGroup;
  late List<Message> _messages;
  final ScrollController _scrollController = ScrollController();
  
  @override
  void initState() {
    super.initState();
    _loadGroupData();
  }
  
  void _loadGroupData() {
    // Find the current group
    _currentGroup = DataProvider.groups.firstWhere(
      (group) => group.id == widget.groupId,
      orElse: () => DataProvider.groups.first,
    );
    
    // Load messages for this group
    _messages = DataProvider.getGroupMessages(widget.groupId);
    
    // Scroll to bottom after frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      final newMessage = DataProvider.addMessage(
        DataProvider.currentUser.id,
        widget.groupId,
        _messageController.text.trim(),
      );
      
      setState(() {
        _messages.add(newMessage);
      });
      _messageController.clear();
      
      // Scroll to bottom after adding message
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(_currentGroup.photo ?? DataProvider.getFallbackGroupImage(_currentGroup.id)),
              radius: 16,
              onBackgroundImageError: (exception, stackTrace) {
                // Fallback for image loading errors
              },
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _currentGroup.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${_currentGroup.members?.length ?? 0} Members',
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
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              _showGroupInfoDialog();
            },
          ),
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

  void _showGroupInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_currentGroup.name),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(_currentGroup.photo ?? DataProvider.getFallbackGroupImage(_currentGroup.id)),
                  onBackgroundImageError: (exception, stackTrace) {
                    // Fallback for image loading errors
                  },
                ),
              ),
              const SizedBox(height: 16),
              Text('Description: ${_currentGroup.description ?? 'No description'}'),
              const SizedBox(height: 8),
              Text('Created: ${_formatDate(_currentGroup.creationDate)}'),
              const SizedBox(height: 8),
              Text('Members: ${_currentGroup.members?.length ?? 0}'),
              const SizedBox(height: 16),
              const Text('Members List:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ..._currentGroup.members?.map((userId) {
                final user = DataProvider.getUserById(userId);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundImage: AssetImage(user.photo ?? DataProvider.getFallbackUserImage(user.id)),
                        onBackgroundImageError: (exception, stackTrace) {
                          // Fallback for image loading errors
                        },
                      ),
                      const SizedBox(width: 8),
                      Text('${user.firstName} ${user.lastName}'),
                      if (userId == _currentGroup.creatorId)
                        const Padding(
                          padding: EdgeInsets.only(left: 4),
                          child: Text('(Creator)', style: TextStyle(fontStyle: FontStyle.italic)),
                        ),
                    ],
                  ),
                );
              }).toList() ?? [],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildChatMessages() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _messages.length + 1, // +1 for the timestamp
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildTimestamp(_formatDate(_messages.isNotEmpty ? _messages.first.timestamp : DateTime.now()));
        }
        
        final message = _messages[index - 1];
        final sender = DataProvider.getUserById(message.senderId);
        final isCurrentUser = message.senderId == DataProvider.currentUser.id;
        
        if (message.imageUrl != null && message.imageUrl!.isNotEmpty) {
          return _buildImageMessage(
            message.imageUrl!,
            isCurrentUser: isCurrentUser,
            avatar: sender.photo ?? DataProvider.getFallbackUserImage(sender.id),
            username: '${sender.firstName} ${sender.lastName}',
          );
        } else {
          return _buildMessage(
            message.content,
            isCurrentUser: isCurrentUser,
            avatar: sender.photo ?? DataProvider.getFallbackUserImage(sender.id),
            username: '${sender.firstName} ${sender.lastName}',
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
              backgroundImage: AssetImage(avatar ?? 'assets/images/default_profile.jpg'),
              onBackgroundImageError: (exception, stackTrace) {
                // Fallback for image loading errors
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
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
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
              backgroundImage: AssetImage(avatar ?? 'assets/images/default_profile.jpg'),
              onBackgroundImageError: (exception, stackTrace) {
                // Fallback for image loading errors
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

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(date.year, date.month, date.day);
    
    if (messageDate == today) {
      return 'Today, ${_formatTime(date)}';
    } else if (messageDate == yesterday) {
      return 'Yesterday, ${_formatTime(date)}';
    } else {
      return '${date.day}/${date.month}/${date.year}, ${_formatTime(date)}';
    }
  }
  
  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
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
                      icon: const Icon(Icons.image),
                      onPressed: () {
                        // This would typically open an image picker
                        // For now, we'll just simulate adding an image
                        _showImagePickerDialog();
                      },
                    ),
                  ],
                ),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          FloatingActionButton(
            onPressed: _sendMessage,
            mini: true,
            child: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }

  void _showImagePickerDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Image Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () async {
                Navigator.pop(context);
                final imagePath = await context.pickImageFromGallery();
                if (imagePath != null) {
                  _addImageMessage(imagePath);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () async {
                Navigator.pop(context);
                final imagePath = await context.pickImageFromCamera();
                if (imagePath != null) {
                  _addImageMessage(imagePath);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
  
  void _addImageMessage(String imagePath) {
    final newMessage = DataProvider.addMessage(
      DataProvider.currentUser.id,
      widget.groupId,
      '',
      imageUrl: imagePath,
    );
    
    setState(() {
      _messages.add(newMessage);
    });
    
    // Scroll to bottom after adding image
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}

