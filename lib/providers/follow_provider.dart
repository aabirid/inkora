import 'package:flutter/material.dart';

class FollowProvider with ChangeNotifier {
  final Set<int> _followingUsers = {}; // Store IDs of followed users

  bool isFollowing(int userId) {
    return _followingUsers.contains(userId);
  }

  void toggleFollow(int userId) {
    if (_followingUsers.contains(userId)) {
      _followingUsers.remove(userId);
    } else {
      _followingUsers.add(userId);
    }
    notifyListeners(); // Notify UI updates
  }
}
