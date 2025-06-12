// ignore_for_file: constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class UserNotification {
  final String id;
  final DateTime dateCreated;
  final String senderId;
  final String receiverId;
  final String postId;
  final String content;
  final bool clicked;
  final UserNotificationType type;

  UserNotification({
    String? id,
    DateTime? dateCreated,
    required this.senderId,
    required this.receiverId,
    required this.postId,
    required this.content,
    this.clicked = false,
    this.type = UserNotificationType.Comment,
  }) : id = id ?? const Uuid().v6(),
       dateCreated = dateCreated ?? DateTime.now();

  UserNotification.empty({
    String? id,
    DateTime? dateCreated,
    this.senderId = '',
    this.receiverId = '',
    this.postId = '',
    this.content = '',
    this.clicked = false,
    this.type = UserNotificationType.Comment,
  }) : id = id ?? const Uuid().v6(),
       dateCreated = dateCreated ?? DateTime.now();

  factory UserNotification.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final map = snapshot.data()!;
    return UserNotification(
      id: map['id'] as String,
      receiverId: map['receiver_id'] as String,
      senderId: map['sender_id'] as String,
      content: map['content'],
      dateCreated:
          (map['date_created'] as Timestamp?)?.toDate() ?? DateTime.now(),
      postId: map['post_id'],
      clicked: map['clicked'] as bool,
      type: UserNotificationTypeX.fromString(map['type'] as String?),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'receiver_id': receiverId,
      'sender_id': senderId,
      'content': content,
      'date_created': dateCreated,
      'post_id': postId,
      'clicked': clicked,
      'type': type.name,
    };
  }

  @override
  bool operator ==(covariant UserNotification other) {
    if (identical(this, other)) return true;

    return other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      "Sender Id: $senderId - Receiver: $receiverId - PostID: $postId - content: $content";

  UserNotification copyWith({
    String? id,
    String? receiverId,
    String? senderId,
    String? content,
    String? postId,
    DateTime? dateCreated,
    bool? clicked,
    UserNotificationType? type,
  }) {
    return UserNotification(
      id: id ?? this.id,
      receiverId: receiverId ?? this.receiverId,
      senderId: senderId ?? this.senderId,
      content: content ?? this.content,
      postId: postId ?? this.postId,
      dateCreated: dateCreated ?? this.dateCreated,
      clicked: clicked ?? this.clicked,
      type: type ?? this.type,
    );
  }
}

enum UserNotificationType { Comment, Follow, Unknown }

extension UserNotificationTypeX on UserNotificationType {
  /// Parse a Firestore‐stored string back into the enum,
  /// defaulting to `Unknown` if the value isn’t recognized.
  static UserNotificationType fromString(String? value) {
    if (value == null) return UserNotificationType.Unknown;
    return UserNotificationType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => UserNotificationType.Unknown,
    );
  }
}
