import 'package:inkora/models/user.dart';
import 'package:inkora/models/book.dart';
import 'package:inkora/models/booklist.dart';
import 'package:inkora/models/group.dart';
import 'package:inkora/models/comment.dart';

class Notification {
  final int id;
  final int userId; // The user who receives the notification
  final String type; // 'follow', 'comment', 'like_book', 'like_booklist', 'group_request'
  final String message;
  final DateTime notificationDate;
  final bool isRead;
  
  // Related data
  final int? actorId; // The user who performed the action
  final String? actorUsername; // Username of the actor
  final String? actorPhoto; // Photo of the actor
  
  // Content references
  final int? contentId; // ID of the related content (book, booklist, comment, group)
  final String? contentType; // 'book', 'booklist', 'comment', 'group'
  final String? contentTitle; // Title of the book, booklist, or group

  Notification({
    required this.id,
    required this.userId,
    required this.type,
    required this.message,
    required this.notificationDate,
    this.isRead = false,
    this.actorId,
    this.actorUsername,
    this.actorPhoto,
    this.contentId,
    this.contentType,
    this.contentTitle,
  });

  // Factory constructor to convert JSON to Notification object
  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      type: json['type'] ?? '',
      message: json['message'] ?? '',
      notificationDate: json['notificationDate'] != null 
          ? DateTime.parse(json['notificationDate']) 
          : DateTime.now(),
      isRead: json['isRead'] ?? false,
      actorId: json['actorId'],
      actorUsername: json['actorUsername'],
      actorPhoto: json['actorPhoto'],
      contentId: json['contentId'],
      contentType: json['contentType'],
      contentTitle: json['contentTitle'],
    );
  }

  // Convert Notification to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'type': type,
      'message': message,
      'notificationDate': notificationDate.toIso8601String(),
      'isRead': isRead,
      'actorId': actorId,
      'actorUsername': actorUsername,
      'actorPhoto': actorPhoto,
      'contentId': contentId,
      'contentType': contentType,
      'contentTitle': contentTitle,
    };
  }

  // Database mapping (for future use)
  static Map<String, String> get dbMapping => {
    'id': 'id_notification',
    'userId': 'id_utilisateur',
    'type': 'type_notification',
    'message': 'message',
    'notificationDate': 'date_notification',
    'isRead': 'est_lu',
    'actorId': 'id_acteur',
    'actorUsername': 'nom_utilisateur_acteur',
    'actorPhoto': 'photo_acteur',
    'contentId': 'id_contenu',
    'contentType': 'type_contenu',
    'contentTitle': 'titre_contenu',
  };
  
  // Factory methods for creating specific notification types
  
  // Follow notification
  static Notification createFollowNotification({
    required int id,
    required int userId,
    required User follower,
  }) {
    return Notification(
      id: id,
      userId: userId,
      type: 'follow',
      message: '${follower.username} a commencé à vous suivre.',
      notificationDate: DateTime.now(),
      actorId: follower.id,
      actorUsername: follower.username,
      actorPhoto: follower.photo,
    );
  }
  
  // Comment notification
  static Notification createCommentNotification({
    required int id,
    required int userId,
    required User commenter,
    required Book book,
    required Comment comment,
  }) {
    return Notification(
      id: id,
      userId: userId,
      type: 'comment',
      message: '${commenter.username} a commenté votre livre "${book.title}".',
      notificationDate: DateTime.now(),
      actorId: commenter.id,
      actorUsername: commenter.username,
      actorPhoto: commenter.photo,
      contentId: book.id,
      contentType: 'book',
      contentTitle: book.title,
    );
  }
  
  // Book like notification
  static Notification createBookLikeNotification({
    required int id,
    required int userId,
    required User liker,
    required Book book,
  }) {
    return Notification(
      id: id,
      userId: userId,
      type: 'like_book',
      message: '${liker.username} a aimé votre livre "${book.title}".',
      notificationDate: DateTime.now(),
      actorId: liker.id,
      actorUsername: liker.username,
      actorPhoto: liker.photo,
      contentId: book.id,
      contentType: 'book',
      contentTitle: book.title,
    );
  }
  
  // Booklist like notification
  static Notification createBooklistLikeNotification({
    required int id,
    required int userId,
    required User liker,
    required Booklist booklist,
  }) {
    return Notification(
      id: id,
      userId: userId,
      type: 'like_booklist',
      message: '${liker.username} a aimé votre liste "${booklist.title}".',
      notificationDate: DateTime.now(),
      actorId: liker.id,
      actorUsername: liker.username,
      actorPhoto: liker.photo,
      contentId: booklist.id,
      contentType: 'booklist',
      contentTitle: booklist.title,
    );
  }
  
  // Group join request notification
  static Notification createGroupRequestNotification({
    required int id,
    required int userId,
    required User requester,
    required Group group,
  }) {
    return Notification(
      id: id,
      userId: userId,
      type: 'group_request',
      message: '${requester.username} a demandé à rejoindre votre groupe "${group.name}".',
      notificationDate: DateTime.now(),
      actorId: requester.id,
      actorUsername: requester.username,
      actorPhoto: requester.photo,
      contentId: group.id,
      contentType: 'group',
      contentTitle: group.name,
    );
  }
}
