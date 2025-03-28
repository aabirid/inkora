import 'package:flutter/material.dart';
import 'package:inkora/screens/notifications/notification_settings_page.dart';
import 'package:inkora/models/notification.dart' as custom_notification;
import 'package:inkora/services/notification_service.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> with SingleTickerProviderStateMixin {
  List<custom_notification.Notification> notifications = [];
  bool _isLoading = true;
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadNotifications();
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadNotifications() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      // In a real app, you would get the current user ID
      final userId = 1; // Mock user ID
      final notifs = await NotificationService.getMockNotifications(userId);
      
      setState(() {
        notifications = notifs;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading notifications: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Helper method to get the icon based on notification type
  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'follow':
        return Icons.person_add_alt_1_rounded;
      case 'comment':
        return Icons.comment_rounded;
      case 'like_book':
      case 'like_booklist':
        return Icons.favorite_outlined;
      case 'group_request':
        return Icons.group_add_rounded;
      case 'update':
        return Icons.update;
      case 'success':
        return Icons.check_circle;
      default:
        return Icons.notifications_sharp;
    }
  }
  
  // Helper method to get color based on notification type
  Color _getNotificationColor(String type) {
    switch (type) {
      case 'follow':
        return Colors.blue;
      case 'comment':
        return Colors.green;
      case 'like_book':
      case 'like_booklist':
        return Colors.red;
      case 'group_request':
        return Colors.purple;
      case 'update':
        return Colors.orange;
      case 'success':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }
  
  // Helper method to handle notification tap
  void _handleNotificationTap(custom_notification.Notification notification) async {
    // Mark as read
    await NotificationService.markAsRead(notification.id);
    
    // Update UI
    setState(() {
      final index = notifications.indexWhere((n) => n.id == notification.id);
      if (index != -1) {
        notifications[index] = custom_notification.Notification(
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
      }
    });
    
    // Navigate based on notification type
    switch (notification.type) {
      case 'follow':
        if (notification.actorId != null) {
          print('Navigate to user profile: ${notification.actorId}');
          // Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfilePage(userId: notification.actorId!)));
        }
        break;
      case 'comment':
        if (notification.contentId != null) {
          print('Navigate to book with comment: ${notification.contentId}');
          // Navigator.push(context, MaterialPageRoute(builder: (context) => BookDetailPage(bookId: notification.contentId!)));
        }
        break;
      case 'like_book':
        if (notification.contentId != null) {
          print('Navigate to book: ${notification.contentId}');
          // Navigator.push(context, MaterialPageRoute(builder: (context) => BookDetailPage(bookId: notification.contentId!)));
        }
        break;
      case 'like_booklist':
        if (notification.contentId != null) {
          print('Navigate to booklist: ${notification.contentId}');
          // Navigator.push(context, MaterialPageRoute(builder: (context) => BooklistDetailPage(booklistId: notification.contentId!)));
        }
        break;
      case 'group_request':
        if (notification.contentId != null) {
          print('Navigate to group: ${notification.contentId}');
          // Navigator.push(context, MaterialPageRoute(builder: (context) => GroupDetailPage(groupId: notification.contentId!)));
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Filter notifications
    final activityNotifications = notifications.where((n) => 
      ['follow', 'comment', 'like_book', 'like_booklist', 'group_request'].contains(n.type)).toList();
    final systemNotifications = notifications.where((n) => 
      !['follow', 'comment', 'like_book', 'like_booklist', 'group_request'].contains(n.type)).toList();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NotificationSettingsPage(),
              ),
            ).then((_) => _loadNotifications()), // Reload after settings change
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Activité"),
            Tab(text: "Système"),
          ],
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                // Activity Tab
                _buildNotificationList(activityNotifications, theme),
                
                // System Tab
                _buildNotificationList(systemNotifications, theme),
              ],
            ),
    );
  }
  
  Widget _buildNotificationList(List<custom_notification.Notification> notifs, ThemeData theme) {
    if (notifs.isEmpty) {
      return const Center(
        child: Text(
          "Aucune notification pour le moment.",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }
    
    return RefreshIndicator(
      onRefresh: _loadNotifications,
      child: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: notifs.length,
        itemBuilder: (context, index) {
          final notif = notifs[index];
          final timeAgo = _getTimeAgo(notif.notificationDate);
          final notifColor = _getNotificationColor(notif.type);
          
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
            margin: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: notif.isRead ? Colors.white : notifColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  spreadRadius: 2,
                  blurRadius: 5,
                ),
              ],
            ),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: notif.actorPhoto != null 
                ? CircleAvatar(
                    backgroundImage: NetworkImage(notif.actorPhoto!),
                    backgroundColor: notifColor,
                  )
                : CircleAvatar(
                    backgroundColor: notifColor,
                    child: Icon(
                      _getNotificationIcon(notif.type),
                      color: Colors.white,
                    ),
                  ),
              title: Text(
                notif.actorUsername ?? _getNotificationTypeTitle(notif.type),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: notif.isRead ? FontWeight.normal : FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notif.message,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: notif.isRead ? Colors.grey[600] : Colors.black,
                    ),
                  ),
                  Text(
                    timeAgo,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              trailing: notif.isRead 
                ? null 
                : Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: notifColor,
                      shape: BoxShape.circle,
                    ),
                  ),
              onTap: () => _handleNotificationTap(notif),
            ),
          );
        },
      ),
    );
  }
  
  String _getNotificationTypeTitle(String type) {
    switch (type) {
      case 'follow':
        return 'Nouvel abonné';
      case 'comment':
        return 'Nouveau commentaire';
      case 'like_book':
      case 'like_booklist':
        return 'Nouveau j\'aime';
      case 'group_request':
        return 'Demande de groupe';
      case 'update':
        return 'Mise à jour';
      default:
        return 'Notification';
    }
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} h';
    } else {
      return '${difference.inDays} jour${difference.inDays > 1 ? 's' : ''}';
    }
  }
}

