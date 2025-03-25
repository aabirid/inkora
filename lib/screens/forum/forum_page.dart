import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../models/group.dart';
import '../../providers/forum_data_provider.dart';
import 'chat_room_page.dart';

class ForumPage extends StatefulWidget {
  const ForumPage({super.key});

  @override
  _ForumPageState createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  List<Group> _filteredOwnedGroups = [];
  List<Group> _filteredMemberGroups = [];
  String? _selectedGroupPhoto;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadGroups();
    });
  }

  void _loadGroups() {
    final provider = Provider.of<ForumDataProvider>(context, listen: false);
    final ownedGroups = provider.getCreatedGroups(provider.currentUser.id);
    final memberGroups = provider.getMemberGroups(provider.currentUser.id);

    setState(() {
      _filteredOwnedGroups = List.from(ownedGroups);
      _filteredMemberGroups = List.from(memberGroups);
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
    final ownedGroups = provider.getCreatedGroups(provider.currentUser.id);
    final memberGroups = provider.getMemberGroups(provider.currentUser.id);

    // If we haven't filtered yet, initialize with all groups
    if (_filteredOwnedGroups.isEmpty &&
        _filteredMemberGroups.isEmpty &&
        (ownedGroups.isNotEmpty || memberGroups.isNotEmpty)) {
      // Use Future.microtask to avoid setState during build
      Future.microtask(() {
        if (mounted) {
          setState(() {
            _filteredOwnedGroups = List.from(ownedGroups);
            _filteredMemberGroups = List.from(memberGroups);
          });
        }
      });
    }

    return Column(
      children: [       
        _buildCreateRoomButton(),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              _loadGroups();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection(
                    'Owner Of',
                    _filteredOwnedGroups
                        .map((group) => _buildRoomItem(
                              group,
                              isOwner: true,
                            ))
                        .toList(),
                  ),
                  if (_filteredOwnedGroups.isEmpty && ownedGroups.isNotEmpty)
                    _buildEmptyMessage('No matching rooms found'),
                  if (ownedGroups.isEmpty)
                    _buildEmptyMessage('You don\'t own any rooms yet'),
                  _buildSection(
                    'Member Of',
                    _filteredMemberGroups
                        .map((group) => _buildRoomItem(
                              group,
                              isOwner: false,
                            ))
                        .toList(),
                  ),
                  if (_filteredMemberGroups.isEmpty && memberGroups.isNotEmpty)
                    _buildEmptyMessage('No matching rooms found'),
                  if (memberGroups.isEmpty)
                    _buildEmptyMessage('You are not a member of any rooms yet'),                  
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

 
  Widget _buildCreateRoomButton() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton.icon(
        onPressed: _showCreateRoomDialog,
        icon: const Icon(Icons.add),
        label: const Text('Create New Room'),
        style: ElevatedButton.styleFrom(          
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> items) {
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
        if (items.isNotEmpty)
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

  Widget _buildRoomItem(Group group, {required bool isOwner}) {
    final provider = Provider.of<ForumDataProvider>(context, listen: false);
    final imagePath = group.photo ?? provider.getFallbackGroupImage(group.id);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatRoomPage(groupId: group.id),
          ),
        ).then((_) {
          // Refresh the groups when returning from chat room
          _loadGroups();
        });
      },
      // Removed the onLongPress functionality since we moved it to the chat room
      child: Padding(
        padding: const EdgeInsets.only(right: 16),
        child: Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage(imagePath),
                  onBackgroundImageError: (exception, stackTrace) {
                    // Fallback for image loading errors
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              group.name,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ),
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

  void _showCreateRoomDialog() {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    _selectedGroupPhoto = null;
    _imageFile = null;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Create New Room'),
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
                            : const AssetImage('assets/images/add_photo.png'),
                    child: _imageFile == null && _selectedGroupPhoto == null
                        ? const Icon(Icons.add_a_photo,
                            size: 30, color: Colors.white70)
                        : null,
                  ),
                ),
                const SizedBox(height: 8),
                const Text('Tap to select a photo',
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Room Name',
                    hintText: 'Enter a name for your room',
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
                  provider.createGroup(
                    nameController.text.trim(),
                    descriptionController.text.trim(),
                    _selectedGroupPhoto,
                  );

                  _loadGroups();
                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            'Room "${nameController.text.trim()}" created successfully!')),
                  );
                }
              },
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }

 
  Widget _buildEmptyMessage(String message) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        message,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 14,
        ),
      ),
    );
  }
}
