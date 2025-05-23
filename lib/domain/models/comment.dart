import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class Comment {
  final String id;
  final String createdBy;
  final String? postedIn;
  final DateTime dateCreated;
  final List<String> replies;
  final Map<String, String> reactions;

  Comment({
    String? id,
    required this.createdBy,
    DateTime? dateCreated,
    this.postedIn,
    this.replies = const [],
    this.reactions = const {},
  }) : id = id ?? const Uuid().v6(),
       dateCreated = dateCreated ?? DateTime.now();

  Comment.empty()
    : id = const Uuid().v6(),
      createdBy = '',
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
      createdBy: map['createdBy'] as String,
      postedIn: map['postedIn'] as String?,
      dateCreated:
          (map['dateCreated'] as Timestamp?)?.toDate() ?? DateTime.now(),
      replies: List<String>.from(map['replies'] ?? const []),
      reactions: reactionsMap,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdBy': createdBy,
      'postedIn': postedIn,
      'dateCreated': dateCreated,
      'replies': replies,
      'reactions': reactions,
    };
  }

  Comment copyWith({
    String? id,
    String? createdBy,
    String? postedIn,
    DateTime? dateCreated,
    List<String>? replies,
    Map<String, String>? reactions,
  }) {
    return Comment(
      id: id ?? this.id,
      createdBy: createdBy ?? this.createdBy,
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
}
