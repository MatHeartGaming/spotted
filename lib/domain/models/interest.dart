// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class Interest {
  final String? id;
  final String name;

  Interest({String? id, required this.name}) : id = id ?? const Uuid().v6();

  @override
  bool operator ==(covariant Interest other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name;
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
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory Interest.fromMap(Map<String, dynamic> map) {
    return Interest(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] as String,
    );
  }

  Interest copyWith({
    String? id,
    String? name,
  }) {
    return Interest(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  String toString() => 'Interest(id: $id, name: $name)';
}
