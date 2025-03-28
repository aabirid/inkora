import 'package:flutter/foundation.dart';
import 'package:inkora/models/notification.dart';
import 'package:inkora/services/notification_service.dart';

class NotificationProvider with ChangeNotifier {
  List<Notification> _notifications = [];
  bool _isLoading = false;
  int _unreadCount = 0;
  
  List<Notification> get notifications => _notifications;
  bool get isLoading => _isLoading;
  int get unreadCount => _unreadCount;
  
  Future<void> loadNotifications(int userId) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final notifs = await NotificationService.getMockNotifications(userId);
      _notifications = notifs;
      _updateUnreadCount();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error loading notifications: $e');
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> markAsRead(int notificationId) async {
    await NotificationService.markAsRead(notificationId);
    
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      final notification = _notifications[index];
      _notifications[index] = Notification(
        id: notification.id,
        userId: notification.userId,
        type: notification.type,
        message: notification.message,
        notificationDate: notification.notificationDate,
        isRead: true,
        actorId: notification.actorId,
        actorUsername: notification.actorUsername,
        actorPhoto: notification.actorPhoto,
        contentId: notification.contentId,
        contentType: notification.contentType,
        contentTitle: notification.contentTitle,
      );
      
      _updateUnreadCount();
      notifyListeners();
    }
  }
  
  void _updateUnreadCount() {
    _unreadCount = _notifications.where((n) => !n.isRead).length;
  }
}

