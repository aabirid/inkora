import 'package:flutter/material.dart';
import 'package:inkora/screens/forum/group_overview.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../models/group.dart';
import '../../models/message.dart';
import '../../providers/forum_data_provider.dart';

class ChatRoomPage extends StatefulWidget {
  final int groupId;

  const ChatRoomPage({
    Key? key,
    required this.groupId,
  }) : super(key: key);

  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();

  // Initialize with default values instead of using 'late'
  Group? _currentGroup;
  List<Message> _messages = [];
  bool _isLoading = true;
  String? _selectedGroupPhoto;
  File? _imageFile;
  bool _isSendingMessage = false; // Flag to prevent duplicate sends

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadGroupData();
    });
  }

  void _loadGroupData() {
    final provider = Provider.of<ForumDataProvider>(context, listen: false);

    // Find the current group
    final group = provider.groups.firstWhere(
      (group) => group.id == widget.groupId,
      orElse: () => provider.groups.first,
    );

    // Load messages for this group
    final messages = provider.getGroupMessages(widget.groupId);

    setState(() {
      _currentGroup = group;
      _messages = messages;
      _isLoading = false;
    });

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
    // Prevent duplicate sends
    if (_isSendingMessage || _messageController.text.trim().isEmpty) {
      return;
    }

    setState(() {
      _isSendingMessage = true;
    });

    final provider = Provider.of<ForumDataProvider>(context, listen: false);

    final newMessage = provider.addMessage(
      provider.currentUser.id,
      widget.groupId,
      _messageController.text.trim(),
    );

    // Don't update state here, let the provider notify us
    _messageController.clear();

    // Scroll to bottom after adding the message
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }

      // Reset the sending flag
      setState(() {
        _isSendingMessage = false;
      });
    });
  }

  Future<String?> _pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    return image?.path;
  }

  Future<String?> _pickImageFromCamera() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    return photo?.path;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ForumDataProvider>(context);

    // Get the latest messages from the provider
    _messages = provider.getGroupMessages(widget.groupId);

    // If data is not loaded yet, get the current group from provider
    _currentGroup ??= provider.groups.firstWhere(
      (group) => group.id == widget.groupId,
      orElse: () => provider.groups.first,
    );

    // Check if user is the creator of the group
    final bool isCreator = _currentGroup?.creatorId == provider.currentUser.id;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(_currentGroup?.photo ??
                  provider.getFallbackGroupImage(widget.groupId)),
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
                  _currentGroup?.name ?? 'Loading...',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${_currentGroup?.members?.length ?? 0} Members',
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
              if (_currentGroup != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GroupOverview(group: _currentGroup!),
                  ),
                );
              }
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit' && isCreator) {
                _showEditGroupDialog();
              } else if (value == 'delete' && isCreator) {
                _showDeleteConfirmationDialog();
              } else if (value == 'leave' && !isCreator) {
                _showLeaveGroupConfirmationDialog();
              }
            },
            itemBuilder: (BuildContext context) {
              final List<PopupMenuEntry<String>> menuItems = [];

              if (isCreator) {
                // Options for group creator
                menuItems.addAll([
                  const PopupMenuItem<String>(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 20),
                        SizedBox(width: 8),
                        Text('Edit Group'),
                      ],
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.red, size: 20),
                        SizedBox(width: 8),
                        Text('Delete Group',
                            style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ]);
              } else {
                // Options for group member
                menuItems.add(
                  const PopupMenuItem<String>(
                    value: 'leave',
                    child: Row(
                      children: [
                        Icon(Icons.exit_to_app, color: Colors.orange, size: 20),
                        SizedBox(width: 8),
                        Text('Leave Group'),
                      ],
                    ),
                  ),
                );
              }

              return menuItems;
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: _buildChatMessages(),
                ),
                _buildMessageInput(),
              ],
            ),
    );
  }

  void _showPhotoSelectionDialog(StateSetter setState) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Photo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.camera_alt),
              label: const Text('Take Photo'),
              onPressed: () async {
                Navigator.pop(context);
                final imagePath = await _pickImageFromCamera();
                if (imagePath != null) {
                  setState(() {
                    _selectedGroupPhoto = imagePath;
                    _imageFile = File(imagePath);
                  });
                }
              },
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              icon: const Icon(Icons.photo_library),
              label: const Text('Choose from Gallery'),
              onPressed: () async {
                Navigator.pop(context);
                final imagePath = await _pickImageFromGallery();
                if (imagePath != null) {
                  setState(() {
                    _selectedGroupPhoto = imagePath;
                    _imageFile = File(imagePath);
                  });
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showEditGroupDialog() {
    if (_currentGroup == null) return;

    final nameController = TextEditingController(text: _currentGroup!.name);
    final descriptionController =
        TextEditingController(text: _currentGroup!.description ?? '');
    _selectedGroupPhoto = _currentGroup!.photo;
    _imageFile = null;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Edit Group'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () => _showPhotoSelectionDialog(setState),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: _imageFile != null
                        ? FileImage(_imageFile!) as ImageProvider
                        : _selectedGroupPhoto != null
                            ? AssetImage(_selectedGroupPhoto!)
                            : AssetImage(_currentGroup!.photo ??
                                'assets/images/add_photo.png'),
                    child: _imageFile == null &&
                            _selectedGroupPhoto == null &&
                            _currentGroup!.photo == null
                        ? const Icon(Icons.add_a_photo,
                            size: 30, color: Colors.white70)
                        : null,
                  ),
                ),
                const SizedBox(height: 8),
                const Text('Tap to change photo',
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Group Name',
                    hintText: 'Enter a name for your group',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Enter a description (optional)',
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.trim().isNotEmpty) {
                  final provider =
                      Provider.of<ForumDataProvider>(context, listen: false);

                  final updatedGroup = _currentGroup!.copyWith(
                    name: nameController.text.trim(),
                    description: descriptionController.text.trim().isNotEmpty
                        ? descriptionController.text.trim()
                        : null,
                    photo: _selectedGroupPhoto,
                  );

                  provider.updateGroup(updatedGroup);
                  setState(() {
                    _currentGroup = updatedGroup;
                  });
                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            'Group "${nameController.text.trim()}" updated successfully!')),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog() {
    if (_currentGroup == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Group'),
        content: Text(
            'Are you sure you want to delete "${_currentGroup!.name}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () {
              final provider =
                  Provider.of<ForumDataProvider>(context, listen: false);
              provider.deleteGroup(_currentGroup!.id);
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to forum page

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Group deleted successfully')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showLeaveGroupConfirmationDialog() {
    if (_currentGroup == null) return;

    final provider = Provider.of<ForumDataProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Leave Group'),
        content:
            Text('Are you sure you want to leave "${_currentGroup!.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.orange),
            onPressed: () {
              // Remove user from group members
              if (_currentGroup!.members != null) {
                final updatedMembers = List<int>.from(_currentGroup!.members!)
                  ..remove(provider.currentUser.id);

                final updatedGroup = _currentGroup!.copyWith(
                  members: updatedMembers,
                );

                provider.updateGroup(updatedGroup);
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back to forum page

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('You have left "${_currentGroup!.name}"')),
                );
              }
            },
            child: const Text('Leave'),
          ),
        ],
      ),
    );
  }

  Widget _buildChatMessages() {
    final provider = Provider.of<ForumDataProvider>(context, listen: false);

    if (_messages.isEmpty) {
      return const Center(
        child: Text('No messages yet. Start the conversation!'),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _messages.length + 1, // +1 for the timestamp
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildTimestamp(_formatDate(_messages.isNotEmpty
              ? _messages.first.timestamp
              : DateTime.now()));
        }

        final message = _messages[index - 1];
        final sender = provider.getUserById(message.senderId);
        final isCurrentUser = message.senderId == provider.currentUser.id;

        if (message.imageUrl != null && message.imageUrl!.isNotEmpty) {
          return _buildImageMessage(
            message.imageUrl!,
            isCurrentUser: isCurrentUser,
            avatar: sender.photo ?? provider.getFallbackUserImage(sender.id),
            username: sender.username,
          );
        } else {
          return _buildMessage(
            message.content,
            isCurrentUser: isCurrentUser,
            avatar: sender.photo ?? provider.getFallbackUserImage(sender.id),
            username: sender.username,
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
              backgroundImage:
                  AssetImage(avatar ?? 'assets/images/default_profile.jpeg'),
              onBackgroundImageError: (exception, stackTrace) {
                // Fallback for image loading errors
              },
            ),
            const SizedBox(width: 8),
          ],
          Column(
            crossAxisAlignment: isCurrentUser
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
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
              backgroundImage:
                  AssetImage(avatar ?? 'assets/images/default_profile.jpeg'),
              onBackgroundImageError: (exception, stackTrace) {
                // Fallback for image loading errors
              },
            ),
            const SizedBox(width: 8),
          ],
          Column(
            crossAxisAlignment: isCurrentUser
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
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
                child: imagePath.startsWith('assets/')
                    ? Image.asset(
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
                      )
                    : Image.file(
                        File(imagePath),
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
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.image),
                      onPressed: _showImagePickerDialog,
                    ),
                  ],
                ),
              ),
              onSubmitted: (_) {
                _sendMessage(); // Trigger the message send on Enter key press
              },
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _sendMessage, // Trigger the message send on button click
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
                final imagePath = await _pickImageFromGallery();
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
                final imagePath = await _pickImageFromCamera();
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
    // Prevent duplicate sends
    if (_isSendingMessage) {
      return;
    }

    setState(() {
      _isSendingMessage = true;
    });

    final provider = Provider.of<ForumDataProvider>(context, listen: false);

    provider.addMessage(
      provider.currentUser.id,
      widget.groupId,
      '',
      imageUrl: imagePath,
    );

    // Don't update state here, let the provider notify us

    // Scroll to bottom after adding image
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }

      // Reset the sending flag
      setState(() {
        _isSendingMessage = false;
      });
    });
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
}
