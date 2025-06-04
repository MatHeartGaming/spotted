// ignore_for_file: public_member_api_docs, sort_constructors_first
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
}
