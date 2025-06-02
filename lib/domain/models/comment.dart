// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class Comment {
  final String id;
  final String text;
  final String postId;
  final String createdById;
  final String createdByUsername;
  final String? postedIn;
  final DateTime dateCreated;
  final List<String> replies;
  final Map<String, String> reactions;

  Comment({
    String? id,
    String? postId,
    required this.text,
    required this.createdById,
    required this.createdByUsername,
    DateTime? dateCreated,
    this.postedIn,
    this.replies = const [],
    this.reactions = const {},
  }) : id = id ?? const Uuid().v6(),
       postId = postId ?? const Uuid().v6(),
       dateCreated = dateCreated ?? DateTime.now();

  Comment.empty()
    : id = const Uuid().v6(),
      postId = const Uuid().v6(),
      text = '',
      createdById = '',
      createdByUsername = '',
      postedIn = null,
      dateCreated = DateTime.now(),
      replies = const [],
      reactions = const {};

  factory Comment.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final map = snapshot.data()!;
    final reactionsMap =
        (map['reactions'] as Map?)?.map(
          (key, value) => MapEntry(key.toString(), value.toString()),
        ) ??
        {};

    return Comment(
      id: map['id'] as String,
      text: map['text'] as String,
      postId: map['post_id'] as String,
      createdById: map['created_by_id'] as String,
      createdByUsername: map['created_by_username'] as String,
      postedIn: map['posted_in'] as String?,
      dateCreated:
          (map['date_created'] as Timestamp?)?.toDate() ?? DateTime.now(),
      replies: List<String>.from(map['replies'] ?? const []),
      reactions: reactionsMap,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'post_id': postId,
      'created_by_id': createdById,
      'created_by_username': createdByUsername,
      'posted_in': postedIn,
      'date_created': dateCreated,
      'replies': replies,
      'reactions': reactions,
    };
  }

  Comment copyWith({
    String? id,
    String? text,
    String? postId,
    String? createdById,
    String? createdByUsername,
    String? postedIn,
    DateTime? dateCreated,
    List<String>? replies,
    Map<String, String>? reactions,
  }) {
    return Comment(
      id: id ?? this.id,
      text: text ?? this.id,
      postId: postId ?? this.postId,
      createdById: createdById ?? this.createdById,
      createdByUsername: createdByUsername ?? this.createdByUsername,
      postedIn: postedIn ?? this.postedIn,
      dateCreated: dateCreated ?? this.dateCreated,
      replies: replies ?? this.replies,
      reactions: reactions ?? this.reactions,
    );
  }

  @override
  bool operator ==(covariant Comment other) {
    if (identical(this, other)) return true;
    return other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Comment(text: $text, createdById: $createdById, createdByUsername: $createdByUsername, postedIn: $postedIn)';
  }
}
