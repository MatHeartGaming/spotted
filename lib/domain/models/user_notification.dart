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

  UserNotification({
    String? id,
    DateTime? dateCreated,
    required this.senderId,
    required this.receiverId,
    required this.postId,
    required this.content,
    this.clicked = false,
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
  }) {
    return UserNotification(
      id: id ?? this.id,
      receiverId: receiverId ?? this.receiverId,
      senderId: senderId ?? this.senderId,
      content: content ?? this.content,
      postId: postId ?? this.postId,
      dateCreated: dateCreated ?? this.dateCreated,
      clicked: clicked ?? this.clicked,
    );
  }
}
