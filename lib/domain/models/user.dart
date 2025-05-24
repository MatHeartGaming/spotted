// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spotted/config/constants/app_constants.dart';
import 'package:uuid/uuid.dart';

class User {
  final String id;
  final String email;
  final String name;
  final String surname;
  final String username;
  final String profileImageUrl;
  final DateTime dateCreated;
  final List<String> features;
  final List<String> communitiesSubs;
  final List<String> friends;
  final List<String> posted;
  final List<String> comments;
  final Map<String, String> reactions;

  User({
    String? id,
    required this.email,
    required this.name,
    required this.surname,
    required this.username,
    DateTime? dateCreated,
    this.profileImageUrl = '',
    this.features = const [],
    this.communitiesSubs = const [],
    this.friends = const [],
    this.posted = const [],
    this.comments = const [],
    this.reactions = const {},
  }) : id = id ?? const Uuid().v6(),
       dateCreated = dateCreated ?? DateTime.now();

  User.empty({
    String? id,
    this.email = '',
    this.name = '',
    this.surname = '',
    this.username = '',
    DateTime? dateCreated,
    this.profileImageUrl = '',
    this.features = const [],
    this.communitiesSubs = const [],
    this.friends = const [],
    this.posted = const [],
    this.comments = const [],
    this.reactions = const {},
  }) : id = id ?? const Uuid().v6(),
       dateCreated = dateCreated ?? DateTime.now();

  String get completeName => '$name $surname';

  bool get isProfileUrlValid => profileImageUrl.startsWith('https');

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }

  factory User.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final map = snapshot.data()!;
    final reactionsMap = (map['reactions'] as Map).map(
      (key, value) =>
          MapEntry(key.toString(), value.toString()),
    );
    logger.i('Reactions: $map');
    return User(
      id: map['id'],
      email: map['email'] as String,
      name: map['name'] as String,
      surname: map['surname'] as String,
      username: map['username'] as String,
      profileImageUrl: map['profile_image_url'] as String,
      dateCreated: (map['date_created'] as Timestamp?)?.toDate(),
      features:
          map.containsKey('communities_subs')
              ? List<String>.from(map['features'] as List<String>)
              : [],
      communitiesSubs:
          map.containsKey('communities_subs')
              ? List<String>.from(map['communitiesSubs'] as List<String>)
              : [],
      friends:
          map.containsKey('friends')
              ? List<String>.from(map['friends'] as List<String>)
              : [],
      posted:
          map.containsKey('posted')
              ? List<String>.from(map['posted'] as List<String>)
              : [],
      comments:
          map.containsKey('comments')
              ? List<String>.from(map['comments'] as List<String>)
              : [],
      reactions: reactionsMap,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'name': name,
      'surname': surname,
      'username': username,
      'profileImageUrl': profileImageUrl,
      'dateCreated': dateCreated,
      'features': features,
      'communitiesSubs': communitiesSubs,
      'friends': friends,
      'posted': posted,
      'reactions': reactions,
      'comments': comments,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      email: map['email'] as String,
      name: map['name'] as String,
      surname: map['surname'] as String,
      username: map['username'] as String,
      profileImageUrl: map['profile_image_url'] as String,
      dateCreated: (map['date_created'] as Timestamp?)?.toDate(),
      features:
          map.containsKey('communities_subs')
              ? List<String>.from(map['features'] as List<String>)
              : [],
      communitiesSubs:
          map.containsKey('communities_subs')
              ? List<String>.from(map['communitiesSubs'] as List<String>)
              : [],
      friends:
          map.containsKey('friends')
              ? List<String>.from(map['friends'] as List<String>)
              : [],
      posted:
          map.containsKey('posted')
              ? List<String>.from(map['posted'] as List<String>)
              : [],
      comments:
          map.containsKey('comments')
              ? List<String>.from(map['comments'] as List<String>)
              : [],
      reactions:
          map.containsKey('reactions')
              ? Map<String, String>.from(
                map['reactions'] as Map<String, String>,
              )
              : {},
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? surname,
    String? username,
    String? profileImageUrl,
    DateTime? dateCreated,
    List<String>? features,
    List<String>? communitiesSubs,
    List<String>? friends,
    List<String>? posted,
    List<String>? comments,
    Map<String, String>? reactions,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      username: username ?? this.username,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      dateCreated: dateCreated ?? this.dateCreated,
      features: features ?? this.features,
      communitiesSubs: communitiesSubs ?? this.communitiesSubs,
      friends: friends ?? this.friends,
      posted: posted ?? this.posted,
      comments: comments ?? this.comments,
      reactions: reactions ?? this.reactions,
    );
  }
}
