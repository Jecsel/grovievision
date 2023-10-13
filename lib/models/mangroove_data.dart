import 'dart:typed_data';

class MangrooveData {
  final int id;
  final Uint8List imageBlob;
  final String name;
  final String description;

  MangrooveData({
    required this.id,
    required this.imageBlob,
    required this.name,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imageBlob': imageBlob,
      'name': name,
      'description': description,
    };
  }

  factory MangrooveData.fromMap(Map<String, dynamic> map) {
    return MangrooveData(
      id: map['id'],
      imageBlob: map['imageBlob'],
      name: map['name'],
      description: map['description'],
    );
  }

  MangrooveData copy({
    int? id,
    Uint8List? imageBlob,
    String? name,
    String? description,
  }) {
    return MangrooveData(
      id: id ?? this.id,
      imageBlob: imageBlob ?? this.imageBlob,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }
}
