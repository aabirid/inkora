import 'package:flutter/material.dart';
import '../models/group.dart';
import '../models/user.dart';
import '../models/message.dart';

class ForumDataProvider extends ChangeNotifier {
  // Current user
  final User currentUser = User(
    id: 1,
    lastName: 'Smith',
    firstName: 'John',
    email: 'john.smith@example.com',
    password: 'password123',
    gender: 'male',
    registrationDate: DateTime(2023, 5, 15),
    status: 'active',
    photo: 'assets/images/nonfiction.jpeg',
    username: 'johnsmith',
    bio: 'A passionate software developer',
  );

  // Sample users
  final List<User> _users = [];
  
  // Sample groups
  final List<Group> _groups = [];
  
  // Messages for each group
  final Map<int, List<Message>> _allMessages = {};

  ForumDataProvider() {
    _initializeData();
  }

  void _initializeData() {
    // Initialize users
    _users.addAll([
      currentUser,
      User(
        id: 2,
        lastName: 'Johnson',
        firstName: 'Emily',
        email: 'emily.j@example.com',
        password: 'password123',
        gender: 'female',
        registrationDate: DateTime(2023, 6, 10),
        status: 'active',
        photo: 'assets/images/poetry.jpeg',
        username: 'emilyjohnson',
        bio: 'Loves to code and explore new tech',
      ),
      User(
        id: 3,
        lastName: 'Williams',
        firstName: 'Michael',
        email: 'michael.w@example.com',
        password: 'password123',
        gender: 'male',
        registrationDate: DateTime(2023, 7, 5),
        status: 'active',
        photo: 'assets/images/adventure.jpeg',
        username: 'michaelwilliams',
        bio: 'Tech enthusiast and gamer',
      ),
      User(
        id: 4,
        lastName: 'Brown',
        firstName: 'Sophia',
        email: 'sophia.b@example.com',
        password: 'password123',
        gender: 'female',
        registrationDate: DateTime(2023, 8, 20),
        status: 'active',
        photo: 'assets/images/thriller.jpeg',
        username: 'sophiabrown',
        bio: 'Creative designer and artist',
      ),
      User(
        id: 5,
        lastName: 'Davis',
        firstName: 'James',
        email: 'james.d@example.com',
        password: 'password123',
        gender: 'male',
        registrationDate: DateTime(2023, 9, 12),
        status: 'active',
        photo: 'assets/images/historical.jpeg',
        username: 'jamesdavis',
        bio: 'Business professional with a passion for tech',
      ),
    ]);

    // Initialize groups
    _groups.addAll([
      Group(
        id: 1,
        name: 'Fantasy Besties',
        description: 'A group for fantasy book lovers',
        creatorId: 1, // Current user is creator
        creationDate: DateTime(2023, 9, 15),
        members: [1, 2, 3, 4, 5],
        photo: 'assets/images/fantasy.jpeg',
      ),
      Group(
        id: 2,
        name: 'Harry Potter',
        description: 'Discussing all things Harry Potter',
        creatorId: 1, // Current user is creator
        creationDate: DateTime(2023, 10, 5),
        members: [1, 2, 3, 6],
        photo: 'assets/images/romance.jpeg',
      ),
      Group(
        id: 3,
        name: 'Science Fiction',
        description: 'For sci-fi enthusiasts',
        creatorId: 2,
        creationDate: DateTime(2023, 11, 10),
        members: [1, 2, 4, 7], // Current user is member
        photo: 'assets/images/horror.jpeg',
      ),
      Group(
        id: 4,
        name: 'Mystery Novels',
        description: 'Discussing mystery and thriller books',
        creatorId: 3,
        creationDate: DateTime(2023, 12, 20),
        members: [1, 3, 4, 8], // Current user is member
        photo: 'assets/images/mystery.jpeg',
      ),
    ]);

    // Initialize messages for Fantasy Besties group
    _allMessages[1] = [
      Message(
        id: 1,
        senderId: 1, // Current user
        groupId: 1,
        content: 'Guys did you read the latest chapters of Kingdom of fire ... period 🔥',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      Message(
        id: 2,
        senderId: 2,
        groupId: 1,
        content: 'I diiid i think i\'m in love with the new caracter ❤️💕',
        timestamp: DateTime.now().subtract(const Duration(minutes: 55)),
      ),
      Message(
        id: 3,
        senderId: 3,
        groupId: 1,
        content: 'nooo don\'t spoil ☺️❤️ i didn\'t read it yet',
        timestamp: DateTime.now().subtract(const Duration(minutes: 50)),
      ),
    ];

    // Initialize messages for Harry Potter group
    _allMessages[2] = [
      Message(
        id: 1,
        senderId: 1,
        groupId: 2,
        content: 'Which book in the series is your favorite?',
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      Message(
        id: 2,
        senderId: 3,
        groupId: 2,
        content: 'Prisoner of Azkaban for sure! Time travel and Sirius Black 🙌',
        timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 50)),
      ),
    ];
  }

  // Get all users
  List<User> get users => _users;

  // Get all groups
  List<Group> get groups => _groups;

  // Get user by ID
  User getUserById(int userId) {
    return _users.firstWhere(
      (user) => user.id == userId,
      orElse: () => User(
        id: 0,
        lastName: 'Unknown',
        firstName: 'User',
        email: 'unknown@example.com',
        password: '',
        gender: 'unknown',
        registrationDate: DateTime.now(),
        status: 'unknown',
        photo: 'assets/images/default_profile.jpeg',
        username: 'unknown_user',
        bio: 'No bio available',
      ),
    );
  }

  // Get groups where user is creator
  List<Group> getCreatedGroups(int userId) {
    return _groups.where((group) => group.creatorId == userId).toList();
  }

  // Get groups where user is a member but not creator
  List<Group> getMemberGroups(int userId) {
    return _groups.where((group) => 
      group.members?.contains(userId) == true && 
      group.creatorId != userId
    ).toList();
  }

  // Get messages for a specific group
  List<Message> getGroupMessages(int groupId) {
    return List<Message>.from(_allMessages[groupId] ?? []);
  }

  // Add a new message
  Message addMessage(int senderId, int groupId, String content, {String? imageUrl}) {
    // Get the messages list for this group, or create a new one if it doesn't exist
    final messages = _allMessages[groupId] ?? [];
    if (_allMessages[groupId] == null) {
      _allMessages[groupId] = messages;
    }
    
    // Create a new message
    final newMessage = Message(
      id: messages.isEmpty ? 1 : messages.last.id + 1,
      senderId: senderId,
      groupId: groupId,
      content: content,
      imageUrl: imageUrl,
      timestamp: DateTime.now(),
    );
    
    // Add the message to the list
    _allMessages[groupId]!.add(newMessage);
    notifyListeners();
    
    return newMessage;
  }

  // Create a new group
  Group createGroup(String name, String description, String? photoPath) {
    final newGroupId = _groups.isEmpty ? 1 : _groups.map((g) => g.id).reduce((a, b) => a > b ? a : b) + 1;
    
    final newGroup = Group(
      id: newGroupId,
      name: name,
      description: description.isNotEmpty ? description : null,
      creatorId: currentUser.id,
      creationDate: DateTime.now(),
      members: [currentUser.id],
      photo: photoPath ?? 'assets/images/book_cover${(newGroupId % 3) + 1}.jpeg',
    );
    
    _groups.add(newGroup);
    notifyListeners();
    
    return newGroup;
  }

  // Update a group
  void updateGroup(Group updatedGroup) {
    final index = _groups.indexWhere((group) => group.id == updatedGroup.id);
    if (index != -1) {
      _groups[index] = updatedGroup;
      notifyListeners();
    }
  }

  // Delete a group
  void deleteGroup(int groupId) {
    _groups.removeWhere((group) => group.id == groupId);
    _allMessages.remove(groupId);
    notifyListeners();
  }

  // Join a group
  void joinGroup(int groupId) {
    final index = _groups.indexWhere((g) => g.id == groupId);
    if (index != -1) {
      final group = _groups[index];
      final updatedMembers = List<int>.from(group.members ?? []);
      
      if (!updatedMembers.contains(currentUser.id)) {
        updatedMembers.add(currentUser.id);
        
        _groups[index] = group.copyWith(members: updatedMembers);
        notifyListeners();
      }
    }
  }

  // Get a fallback image for groups
  String getFallbackGroupImage(int groupId) {
    final images = [
      'assets/images/book_cover.jpeg',
      'assets/images/book_cover2.jpeg',
      'assets/images/book_cover3.jpeg',
    ];
    return images[groupId % images.length];
  }

  // Get a fallback image for users
  String getFallbackUserImage(int userId) {
    return 'assets/images/default_profile.jpeg';
  }
}

