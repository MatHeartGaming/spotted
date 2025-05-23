// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class Post {
  final String id;
  final String title;
  final String content;
  final String createdById;
  final String createdByUsername;
  final String? postedIn;
  final DateTime dateCreated;
  final List<String> comments;
  final List<String> pictureUrls;
  final Map<String, String> reactions;

  Post({
    id,
    required this.createdById,
    required this.createdByUsername,
    required this.title,
    required this.content,
    dateCreated,
    this.postedIn,
    this.comments = const [],
    this.pictureUrls = const [],
    this.reactions = const {},
  }) : id = const Uuid().v6(),
       dateCreated = DateTime.now();

  Post.empty({
    id,
    this.createdById = '',
    this.createdByUsername = '',
    this.title = '',
    this.content = '',
    dateCreated,
    this.postedIn,
    this.comments = const [],
    this.pictureUrls = const [],
    this.reactions = const {},
  }) : id = const Uuid().v6(),
       dateCreated = DateTime.now();

  factory Post.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final map = snapshot.data()!;
    final reactionsMap =
        (map['reactions'] as Map?)?.map(
          (key, value) => MapEntry(key.toString(), value.toString()),
        ) ??
        {};

    return Post(
      id: map['id'] as String,
      createdById: map['created_by_id'] as String,
      createdByUsername: map['created_by_username'] as String,
      title: map['title'] as String,
      content: map['content'] as String,
      postedIn: map['posted_in'] as String?,
      dateCreated:
          (map['date_created'] as Timestamp?)?.toDate() ?? DateTime.now(),
      comments: List<String>.from(map['comments'] ?? const []),
      pictureUrls: List<String>.from(map['picture_urls'] ?? const []),
      reactions: reactionsMap,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'created_by_id': createdById,
      'created_by_username': createdByUsername,
      'title': title,
      'content': content,
      'posted_in': postedIn,
      'date_created': dateCreated,
      'comments': comments,
      'picture_urls': pictureUrls,
      'reactions': reactions,
    };
  }

  Post copyWith({
    String? id,
    String? title,
    String? content,
    String? createdById,
    String? createdByUsername,
    String? postedIn,
    DateTime? dateCreated,
    List<String>? comments,
    List<String>? pictureUrls,
    Map<String, String>? reactions,
  }) {
    return Post(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdById: createdById ?? this.createdById,
      createdByUsername: createdByUsername ?? this.createdByUsername,
      postedIn: postedIn ?? this.postedIn,
      dateCreated: dateCreated ?? this.dateCreated,
      comments: comments ?? this.comments,
      pictureUrls: pictureUrls ?? this.pictureUrls,
      reactions: reactions ?? this.reactions,
    );
  }

  @override
  bool operator ==(covariant Post other) {
    if (identical(this, other)) return true;

    return other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }
}
