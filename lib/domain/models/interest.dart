// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class Interest {
  final String? id;
  final String name;
  final String nameLowercased;

  Interest({this.id, required this.name, String? nameLowercased})
    : nameLowercased = nameLowercased ?? name.trim().toLowerCase();

  @override
  bool operator ==(covariant Interest other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode;

  factory Interest.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final map = snapshot.data()!;
    return Interest(
      id: map['id'] as String,
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

  factory Interest.fromMap(Map<String, dynamic> map) {
    return Interest(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] as String,
    );
  }

  Interest copyWith({String? id, String? name}) {
    return Interest(
      id: id ?? this.id,
      name: name ?? this.name,
      nameLowercased: (name ?? this.name).trim().toLowerCase(),
    );
  }

  @override
  String toString() => 'Interest(id: $id, name: $name)';
}
