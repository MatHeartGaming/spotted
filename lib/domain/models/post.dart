// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class Post {
  final String id;
  final String title;
  final String content;
  final String createdBy;
  final String? postedIn;
  final DateTime dateCreated;
  final List<String> comments;
  final List<String> pictureUrls;
  final Map<String, String> reactions;

  Post({
    id,
    required this.createdBy,
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
    this.createdBy = '',
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
      createdBy: map['createdBy'] as String,
      title: map['title'] as String,
      content: map['content'] as String,
      postedIn: map['postedIn'] as String?,
      dateCreated:
          (map['dateCreated'] as Timestamp?)?.toDate() ?? DateTime.now(),
      comments: List<String>.from(map['comments'] ?? const []),
      pictureUrls: List<String>.from(map['picture_urls'] ?? const []),
      reactions: reactionsMap,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'createdBy': createdBy,
      'title': title,
      'content': content,
      'postedIn': postedIn,
      'dateCreated': dateCreated,
      'comments': comments,
      'picture_urls': pictureUrls,
      'reactions': reactions,
    };
  }

  Post copyWith({
    String? id,
    String? title,
    String? content,
    String? createdBy,
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
      createdBy: createdBy ?? this.createdBy,
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
