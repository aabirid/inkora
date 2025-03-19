class GroupInvitation {
  final int id;
  final int groupId;
  final int userId;
  final String status; // 'pending', 'accepted', 'rejected'
  final DateTime invitationDate;

  GroupInvitation({
    required this.id,
    required this.groupId,
    required this.userId,
    required this.status,
    required this.invitationDate,
  });

  // Factory constructor to convert JSON to GroupInvitation object
  factory GroupInvitation.fromJson(Map<String, dynamic> json) {
    return GroupInvitation(
      id: json['id'] ?? 0,
      groupId: json['groupId'] ?? 0,
      userId: json['userId'] ?? 0,
      status: json['status'] ?? 'pending',
      invitationDate: json['invitationDate'] != null 
          ? DateTime.parse(json['invitationDate']) 
          : DateTime.now(),
    );
  }

  // Convert GroupInvitation to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'groupId': groupId,
      'userId': userId,
      'status': status,
      'invitationDate': invitationDate.toIso8601String(),
    };
  }

  // Database mapping (for future use)
  static Map<String, String> get dbMapping => {
    'id': 'id_invitation',
    'groupId': 'id_groupe',
    'userId': 'id_utilisateur',
    'status': 'statut',
    'invitationDate': 'date_invitation',
  };
}

