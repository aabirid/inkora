import 'package:shared_preferences/shared_preferences.dart';
import 'package:inkora/models/notification.dart';
import 'package:inkora/models/user.dart';
import 'package:inkora/models/book.dart';
import 'package:inkora/models/booklist.dart';
import 'package:inkora/models/group.dart';
import 'package:inkora/models/comment.dart';

class NotificationService {
  static const String _prefKeyFollows = 'notifications_follows';
  static const String _prefKeyComments = 'notifications_comments';
  static const String _prefKeyLikes = 'notifications_likes';
  static const String _prefKeyGroupRequests = 'notifications_group_requests';
  static const String _prefKeyUpdates = 'notifications_updates';
  static const String _prefKeyPromotions = 'notifications_promotions';
  
  // Get notification settings
  static Future<Map<String, bool>> getNotificationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    
    return {
      'follows': prefs.getBool(_prefKeyFollows) ?? true,
      'comments': prefs.getBool(_prefKeyComments) ?? true,
      'likes': prefs.getBool(_prefKeyLikes) ?? true,
      'groupRequests': prefs.getBool(_prefKeyGroupRequests) ?? true,
      'updates': prefs.getBool(_prefKeyUpdates) ?? true,
      'promotions': prefs.getBool(_prefKeyPromotions) ?? false,
    };
  }
  
  // Save notification settings
  static Future<void> saveNotificationSettings({
    required bool follows,
    required bool comments,
    required bool likes,
    required bool groupRequests,
    required bool updates,
    required bool promotions,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    
    await prefs.setBool(_prefKeyFollows, follows);
    await prefs.setBool(_prefKeyComments, comments);
    await prefs.setBool(_prefKeyLikes, likes);
    await prefs.setBool(_prefKeyGroupRequests, groupRequests);
    await prefs.setBool(_prefKeyUpdates, updates);
    await prefs.setBool(_prefKeyPromotions, promotions);
  }
  
  // Check if a notification type is enabled
  static Future<bool> isNotificationTypeEnabled(String type) async {
    final settings = await getNotificationSettings();
    
    switch (type) {
      case 'follow':
        return settings['follows'] ?? true;
      case 'comment':
        return settings['comments'] ?? true;
      case 'like_book':
      case 'like_booklist':
        return settings['likes'] ?? true;
      case 'group_request':
        return settings['groupRequests'] ?? true;
      case 'update':
        return settings['updates'] ?? true;
      case 'promotion':
        return settings['promotions'] ?? false;
      default:
        return true;
    }
  }
  
  // Generate a follow notification if enabled
  static Future<Notification?> createFollowNotificationIfEnabled({
    required int id,
    required int userId,
    required User follower,
  }) async {
    if (await isNotificationTypeEnabled('follow')) {
      return Notification.createFollowNotification(
        id: id,
        userId: userId,
        follower: follower,
      );
    }
    return null;
  }
  
  // Generate a comment notification if enabled
  static Future<Notification?> createCommentNotificationIfEnabled({
    required int id,
    required int userId,
    required User commenter,
    required Book book,
    required Comment comment,
  }) async {
    if (await isNotificationTypeEnabled('comment')) {
      return Notification.createCommentNotification(
        id: id,
        userId: userId,
        commenter: commenter,
        book: book,
        comment: comment,
      );
    }
    return null;
  }
  
  // Generate a book like notification if enabled
  static Future<Notification?> createBookLikeNotificationIfEnabled({
    required int id,
    required int userId,
    required User liker,
    required Book book,
  }) async {
    if (await isNotificationTypeEnabled('like_book')) {
      return Notification.createBookLikeNotification(
        id: id,
        userId: userId,
        liker: liker,
        book: book,
      );
    }
    return null;
  }
  
  // Generate a booklist like notification if enabled
  static Future<Notification?> createBooklistLikeNotificationIfEnabled({
    required int id,
    required int userId,
    required User liker,
    required Booklist booklist,
  }) async {
    if (await isNotificationTypeEnabled('like_booklist')) {
      return Notification.createBooklistLikeNotification(
        id: id,
        userId: userId,
        liker: liker,
        booklist: booklist,
      );
    }
    return null;
  }
  
  // Generate a group request notification if enabled
  static Future<Notification?> createGroupRequestNotificationIfEnabled({
    required int id,
    required int userId,
    required User requester,
    required Group group,
  }) async {
    if (await isNotificationTypeEnabled('group_request')) {
      return Notification.createGroupRequestNotification(
        id: id,
        userId: userId,
        requester: requester,
        group: group,
      );
    }
    return null;
  }
  
  // Mock method to get notifications for testing
  static Future<List<Notification>> getMockNotifications(int userId) async {
    // This would be replaced with actual API calls in production
    await Future.delayed(Duration(milliseconds: 500)); // Simulate network delay
    
    return [
      Notification(
        id: 1,
        userId: userId,
        type: 'follow',
        message: 'John Doe a commencé à vous suivre.',
        notificationDate: DateTime.now().subtract(Duration(minutes: 30)),
        actorId: 101,
        actorUsername: 'johndoe',
        actorPhoto: 'https://randomuser.me/api/portraits/men/1.jpg',
      ),
      Notification(
        id: 2,
        userId: userId,
        type: 'comment',
        message: 'Alice a commenté votre livre "Les Misérables".',
        notificationDate: DateTime.now().subtract(Duration(hours: 2)),
        actorId: 102,
        actorUsername: 'alice',
        actorPhoto: 'https://randomuser.me/api/portraits/women/2.jpg',
        contentId: 201,
        contentType: 'book',
        contentTitle: 'Les Misérables',
      ),
      Notification(
        id: 3,
        userId: userId,
        type: 'like_book',
        message: 'Bob a aimé votre livre "Don Quixote".',
        notificationDate: DateTime.now().subtract(Duration(hours: 5)),
        actorId: 103,
        actorUsername: 'bob',
        actorPhoto: 'https://randomuser.me/api/portraits/men/3.jpg',
        contentId: 202,
        contentType: 'book',
        contentTitle: 'Don Quixote',
      ),
      Notification(
        id: 4,
        userId: userId,
        type: 'like_booklist',
        message: 'Carol a aimé votre liste "Classiques français".',
        notificationDate: DateTime.now().subtract(Duration(days: 1)),
        actorId: 104,
        actorUsername: 'carol',
        actorPhoto: 'https://randomuser.me/api/portraits/women/4.jpg',
        contentId: 301,
        contentType: 'booklist',
        contentTitle: 'Classiques français',
      ),
      Notification(
        id: 5,
        userId: userId,
        type: 'group_request',
        message: 'Dave a demandé à rejoindre votre groupe "Club de lecture".',
        notificationDate: DateTime.now().subtract(Duration(days: 2)),
        actorId: 105,
        actorUsername: 'dave',
        actorPhoto: 'https://randomuser.me/api/portraits/men/5.jpg',
        contentId: 401,
        contentType: 'group',
        contentTitle: 'Club de lecture',
      ),
    ];
  }
  
  // Mark notification as read
  static Future<void> markAsRead(int notificationId) async {
    // This would update the database in production
    print('Marking notification $notificationId as read');
  }
}

