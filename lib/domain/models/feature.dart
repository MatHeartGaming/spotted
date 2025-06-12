// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Feature {
  final String? id;
  final String name;
  final String nameLowercased;

  Feature({
    this.id,
    required this.name,
    String? nameLowercased,
  })  : nameLowercased = nameLowercased ?? name.trim().toLowerCase();

  @override
  bool operator ==(covariant Feature other) {
    if (identical(this, other)) return true;
    return other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode;

  factory Feature.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final map = snapshot.data()!;
    return Feature(
      id: map['id'] as String,
      name: map['name'] as String,
      nameLowercased: map['name_lower_cased'] as String?,
    );
  }

  factory Feature.fromMap(Map<String, dynamic> map) {
    return Feature(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] as String,
      nameLowercased: map['name_lower_cased'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'name_lower_cased': nameLowercased,
    };
  }

  String toJson() => json.encode(toMap());

  factory Feature.fromJson(String source) =>
      Feature.fromMap(json.decode(source) as Map<String, dynamic>);

  Feature copyWith({
    String? id,
    String? name,
  }) {
    final newName = name ?? this.name;
    return Feature(
      id: id ?? this.id,
      name: newName,
      nameLowercased: newName.trim().toLowerCase(),
    );
  }

  @override
  String toString() => 'Feature(id: $id, name: $name)';
}
