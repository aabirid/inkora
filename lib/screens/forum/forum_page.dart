import 'package:flutter/material.dart';
import 'package:inkora/screens/forum/chat_room_page.dart';
import 'package:inkora/providers/data_provider.dart';
import 'package:inkora/models/group.dart';
import 'package:inkora/utils/image_picker.dart';
import 'dart:io';

class ForumPage extends StatefulWidget {
  const ForumPage({super.key});

  @override
  _ForumPageState createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Group> ownedGroups = [];
  List<Group> memberGroups = [];
  List<Group> filteredOwnedGroups = [];
  List<Group> filteredMemberGroups = [];
  String? _selectedGroupPhoto;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _loadGroups();
  }

  void _loadGroups() {
    // Get groups created by current user
    ownedGroups = DataProvider.getCreatedGroups(DataProvider.currentUser.id);
    
    // Get groups where user is a member but not creator
    memberGroups = DataProvider.getMemberGroups(DataProvider.currentUser.id);
    
    // Initialize filtered lists
    filteredOwnedGroups = List.from(ownedGroups);
    filteredMemberGroups = List.from(memberGroups);
  }

  void _filterGroups(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredOwnedGroups = List.from(ownedGroups);
        filteredMemberGroups = List.from(memberGroups);
      } else {
        filteredOwnedGroups = ownedGroups
            .where((group) => group.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
        filteredMemberGroups = memberGroups
            .where((group) => group.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
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
                        ? const Icon(Icons.add_a_photo, size: 30, color: Colors.white70)
                        : null,
                  ),
                ),
                const SizedBox(height: 8),
                const Text('Tap to select a photo', style: TextStyle(fontSize: 12, color: Colors.grey)),
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
                  _createNewRoom(
                    nameController.text.trim(),
                    descriptionController.text.trim(),
                    _selectedGroupPhoto,
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Create'),
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
              final imagePath = await context.pickImageFromCamera();
              if (imagePath != null) {
                setState(() {
                  _selectedGroupPhoto = imagePath;
                  _imageFile = null;
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
              final imagePath = await context.pickImageFromGallery();
              if (imagePath != null) {
                setState(() {
                  _selectedGroupPhoto = imagePath;
                  _imageFile = null;
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

  void _createNewRoom(String name, String description, String? photoPath) {
    // Create a new group
    final newGroupId = DataProvider.groups.length + 1;
    final newGroup = Group(
      id: newGroupId,
      name: name,
      description: description.isNotEmpty ? description : null,
      creatorId: DataProvider.currentUser.id,
      creationDate: DateTime.now(),
      members: [DataProvider.currentUser.id],
      photo: photoPath ?? 'assets/images/book_cover${(newGroupId % 3) + 1}.jpeg',
    );

    // Add to data provider
    DataProvider.groups.add(newGroup);

    // Refresh the lists
    setState(() {
      _loadGroups();
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Room "$name" created successfully!')),
    );
  }

  void _showEditGroupDialog(Group group) {
    final nameController = TextEditingController(text: group.name);
    final descriptionController = TextEditingController(text: group.description ?? '');
    _selectedGroupPhoto = group.photo;
    _imageFile = null;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Edit Room'),
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
                            : AssetImage(group.photo ?? 'assets/images/add_photo.png'),
                    child: _imageFile == null && _selectedGroupPhoto == null
                        ? const Icon(Icons.add_a_photo, size: 30, color: Colors.white70)
                        : null,
                  ),
                ),
                const SizedBox(height: 8),
                const Text('Tap to change photo', style: TextStyle(fontSize: 12, color: Colors.grey)),
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
                  _updateGroup(
                    group.id,
                    nameController.text.trim(),
                    descriptionController.text.trim(),
                    _selectedGroupPhoto ?? group.photo,
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _updateGroup(int groupId, String name, String description, String? photoPath) {
    // Find the group in the list
    final index = DataProvider.groups.indexWhere((g) => g.id == groupId);
    if (index != -1) {
      // Get the existing group
      final existingGroup = DataProvider.groups[index];
      
      // Create an updated group
      final updatedGroup = Group(
        id: existingGroup.id,
        name: name,
        description: description.isNotEmpty ? description : null,
        creatorId: existingGroup.creatorId,
        creationDate: existingGroup.creationDate,
        members: existingGroup.members,
        photo: photoPath,
      );
      
      // Update the group in the data provider
      DataProvider.updateGroup(updatedGroup);
      
      // Refresh the lists
      setState(() {
        _loadGroups();
      });
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Room "$name" updated successfully!')),
      );
    }
  }

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
                  filteredOwnedGroups.map((group) => _buildRoomItem(
                    context,
                    group.name,
                    group.photo ?? DataProvider.getFallbackGroupImage(group.id),
                    group.id,
                    isOwner: true,
                  )).toList(),
                ),
                if (filteredOwnedGroups.isEmpty && ownedGroups.isNotEmpty)
                  _buildEmptyMessage('No matching rooms found'),
                if (ownedGroups.isEmpty)
                  _buildEmptyMessage('You don\'t own any rooms yet'),
                
                _buildSection(
                  context,
                  'Member Of',
                  filteredMemberGroups.map((group) => _buildRoomItem(
                    context,
                    group.name,
                    group.photo ?? DataProvider.getFallbackGroupImage(group.id),
                    group.id,
                    isOwner: false,
                  )).toList(),
                ),
                if (filteredMemberGroups.isEmpty && memberGroups.isNotEmpty)
                  _buildEmptyMessage('No matching rooms found'),
                if (memberGroups.isEmpty)
                  _buildEmptyMessage('You are not a member of any rooms yet'),
                
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
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _filterGroups('');
                  },
                )
              : null,
        ),
        onChanged: _filterGroups,
      ),
    );
  }

  Widget _buildCreateRoomButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton.icon(
        onPressed: _showCreateRoomDialog,
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

  Widget _buildRoomItem(BuildContext context, String title, String imagePath, int groupId, {required bool isOwner}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatRoomPage(groupId: groupId),
          ),
        ).then((_) {
          // Refresh the groups when returning from chat room
          setState(() {
            _loadGroups();
          });
        });
      },
      onLongPress: isOwner ? () {
        // Show edit options if user is the owner
        _showRoomOptionsDialog(DataProvider.groups.firstWhere((g) => g.id == groupId));
      } : null,
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
                if (isOwner)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      child: Icon(
                        Icons.edit,
                        size: 14,
                        color: Colors.green[700],
                      ),
                    ),
                  ),
              ],
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

  void _showRoomOptionsDialog(Group group) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(group.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Room'),
              onTap: () {
                Navigator.pop(context);
                _showEditGroupDialog(group);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete Room', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmationDialog(group);
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

  void _showDeleteConfirmationDialog(Group group) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Room'),
        content: Text('Are you sure you want to delete "${group.name}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () {
              _deleteGroup(group.id);
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _deleteGroup(int groupId) {
    // Remove the group from the list
    DataProvider.groups.removeWhere((group) => group.id == groupId);
    
    // Refresh the lists
    setState(() {
      _loadGroups();
    });
    
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Room deleted successfully')),
    );
  }

  Widget _buildJoinNewRoomsButton() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton.icon(
        onPressed: () {
          // Show a dialog with available rooms to join
          _showJoinRoomsDialog();
        },
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

  void _showJoinRoomsDialog() {
    // Get groups the user is not a member of
    final availableGroups = DataProvider.groups.where((group) => 
      !group.members!.contains(DataProvider.currentUser.id)
    ).toList();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Available Rooms'),
        content: SizedBox(
          width: double.maxFinite,
          child: availableGroups.isEmpty
              ? const Text('No available rooms to join')
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: availableGroups.length,
                  itemBuilder: (context, index) {
                    final group = availableGroups[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(
                          group.photo ?? DataProvider.getFallbackGroupImage(group.id)
                        ),
                      ),
                      title: Text(group.name),
                      subtitle: Text(group.description ?? 'No description'),
                      trailing: ElevatedButton(
                        onPressed: () {
                          _joinRoom(group);
                          Navigator.pop(context);
                        },
                        child: const Text('Join'),
                      ),
                    );
                  },
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

  void _joinRoom(Group group) {
    // Find the group in the original list
    final index = DataProvider.groups.indexWhere((g) => g.id == group.id);
    if (index != -1) {
      // Add the user to the members list
      final updatedMembers = List<int>.from(DataProvider.groups[index].members ?? []);
      updatedMembers.add(DataProvider.currentUser.id);
      
      // Create an updated group
      final updatedGroup = Group(
        id: group.id,
        name: group.name,
        description: group.description,
        creatorId: group.creatorId,
        creationDate: group.creationDate,
        members: updatedMembers,
        photo: group.photo,
      );
      
      // Update the group in the list
      DataProvider.updateGroup(updatedGroup);
      
      // Refresh the lists
      setState(() {
        _loadGroups();
      });
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Joined "${group.name}" successfully!')),
      );
    }
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

