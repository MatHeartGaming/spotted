// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class Feature {
  final String? id;
  final String name;

  Feature({String? id, required this.name}) : id = id ?? const Uuid().v6();

  @override
  bool operator ==(covariant Feature other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name;
  }

  @override
  int get hashCode => id.hashCode;

  Feature copyWith({
    String? id,
    String? name,
  }) {
    return Feature(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  String toString() => 'Feature(id: $id, name: $name)';

  factory Feature.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final map = snapshot.data()!;
    return Feature(
      id: map['id'] as String,
      name: map['name'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory Feature.fromMap(Map<String, dynamic> map) {
    return Feature(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Feature.fromJson(String source) => Feature.fromMap(json.decode(source) as Map<String, dynamic>);
}
