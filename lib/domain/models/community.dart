// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class Community {
  final String id;
  final String title;
  final String description;
  final String? createdById;
  final String? createdByUsername;
  final DateTime dateCreated;
  final String? pictureUrl;
  final List<String> admins;
  final List<String> posts;

  Community({
    String? id,
    required this.title,
    required this.description,
    this.createdById,
    this.createdByUsername,
    DateTime? dateCreated,
    this.pictureUrl,
    this.admins = const [],
    this.posts = const [],
  }) : id = id ?? const Uuid().v6(),
       dateCreated = dateCreated ?? DateTime.now();

  Community.empty({
    id,
    this.title = '',
    this.description = '',
    this.createdById,
    this.createdByUsername,
    dateCreated,
    this.pictureUrl,
    this.admins = const [],
    this.posts = const [],
  }) : id = id ?? const Uuid().v6(),
       dateCreated = dateCreated ?? DateTime.now();

  bool get isEmpty => id.isEmpty || title.isEmpty || description.isEmpty;

  /// Creates a Community from Firestore
  factory Community.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final map = snapshot.data()!;
    return Community(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      createdById: map['created_by_id'] as String?,
      createdByUsername: map['created_by_username'] as String?,
      dateCreated:
          (map['date_created'] as Timestamp?)?.toDate() ?? DateTime.now(),
      pictureUrl: map['picture_url'] as String?,
      admins: List<String>.from(map['admins'] ?? const []),
      posts: List<String>.from(map['posts'] ?? const []),
    );
  }

  /// Converts a Community to a Firestore-friendly map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'created_by_id': createdById,
      'created_by_username': createdByUsername,
      'date_created': dateCreated,
      'picture_url': pictureUrl,
      'admins': admins,
      'posts': posts,
    };
  }

  Community copyWith({
    String? id,
    String? title,
    String? description,
    String? createdById,
    String? createdByUsername,
    DateTime? dateCreated,
    String? pictureUrl,
    List<String>? admins,
    List<String>? posts,
  }) {
    return Community(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdById: createdById ?? this.createdById,
      createdByUsername: createdByUsername ?? this.createdByUsername,
      dateCreated: dateCreated ?? this.dateCreated,
      pictureUrl: pictureUrl ?? this.pictureUrl,
      admins: admins ?? this.admins,
      posts: posts ?? this.posts,
    );
  }

  @override
  bool operator ==(covariant Community other) {
    if (identical(this, other)) return true;

    return other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }
}
