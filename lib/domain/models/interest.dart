// ignore_for_file: public_member_api_docs, sort_constructors_first
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
