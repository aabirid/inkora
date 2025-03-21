import 'package:flutter/material.dart';
import 'package:inkora/screens/notifications/notification_settings_page.dart';
import 'package:inkora/models/notification.dart' as custom_notification;

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<custom_notification.Notification> notifications = [];

  @override
  void initState() {
    super.initState();
    _loadFakeNotifications();
  }

  void _loadFakeNotifications() {
    setState(() {
      notifications = [
        custom_notification.Notification(
          id: 1,
          userId: 1,
          type: 'Update',
          message: 'Your app has been updated to the latest version.',
          notificationDate: DateTime.now().subtract(Duration(minutes: 10)),
          isRead: false,
        ),
        custom_notification.Notification(
          id: 2,
          userId: 2,
          type: 'Success',
          message: 'Your account has been successfully verified!',
          notificationDate: DateTime.now().subtract(Duration(minutes: 20)),
          isRead: true,
        ),
        custom_notification.Notification(
          id: 3,
          userId: 1,
          type: 'Invite',
          message:
              'You have been invited to join the group "Tech Enthusiasts".',
          notificationDate: DateTime.now().subtract(Duration(hours: 1)),
          isRead: false,
        ),
        custom_notification.Notification(
          id: 4,
          userId: 3,
          type: 'Follow',
          message: 'John Doe started following you.',
          notificationDate: DateTime.now().subtract(Duration(hours: 2)),
          isRead: true,
        ),
        custom_notification.Notification(
          id: 5,
          userId: 2,
          type: 'Comment',
          message: 'Jane commented on your post: "Great work on this project!"',
          notificationDate: DateTime.now().subtract(Duration(hours: 3)),
          isRead: false,
        ),
        custom_notification.Notification(
          id: 6,
          userId: 4,
          type: 'Like',
          message: 'Your photo has been liked by Alice.',
          notificationDate: DateTime.now().subtract(Duration(hours: 4)),
          isRead: false,
        ),
        custom_notification.Notification(
          id: 7,
          userId: 5,
          type: 'Reject',
          message: 'Your application for the event has been rejected.',
          notificationDate: DateTime.now().subtract(Duration(days: 1)),
          isRead: true,
        ),
        custom_notification.Notification(
          id: 8,
          userId: 1,
          type: 'Update',
          message: 'New features have been added to your dashboard.',
          notificationDate: DateTime.now().subtract(Duration(days: 2)),
          isRead: false,
        ),
        custom_notification.Notification(
          id: 9,
          userId: 3,
          type: 'Success',
          message: 'Your password has been successfully changed.',
          notificationDate: DateTime.now().subtract(Duration(days: 2)),
          isRead: true,
        ),
        custom_notification.Notification(
          id: 10,
          userId: 1,
          type: 'Follow',
          message: 'Mark Smith started following you.',
          notificationDate: DateTime.now().subtract(Duration(days: 3)),
          isRead: false,
        ),
      ];
    });
  }

  // Helper method to get the icon and color based on notification type
  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'Update':
        return Icons.update;
      case 'Success':
        return Icons.check_circle;
      case 'Invite':
        return Icons.group_add_rounded;
      case 'Follow':
        return Icons.person_add_alt_1_rounded;
      case 'Comment':
        return Icons.comment_rounded;
      case 'Like':
        return Icons.favorite_outlined;
      case 'Reject':
        return Icons.cancel_outlined;
      default:
        return Icons.notifications_sharp;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
            ),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: notifications.isEmpty
          ? const Center(
              child: Text(
                "Aucune notification pour le moment.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notif = notifications[index];
                final timeAgo = _getTimeAgo(notif.notificationDate);
                return Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                  margin: const EdgeInsets.symmetric(vertical: 2),
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withOpacity(0.1),
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
                    leading: CircleAvatar(
                      backgroundColor: theme.primaryColor,
                      child: Icon(
                        _getNotificationIcon(notif.type),
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      notif.type,
                      style: theme.textTheme.titleLarge,
                    ),
                    subtitle: Text(
                      notif.message,
                      style: theme.textTheme.bodyMedium,
                    ),
                    trailing: Text(
                      timeAgo,
                      style:
                          TextStyle(color: theme.textTheme.bodyMedium?.color),
                    ),
                    onTap: () {
                      // Handle notification tap
                    },
                  ),
                );
              },
            ),
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} h';
    } else {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    }
  }

  // Get icon background color based on notification type
}
