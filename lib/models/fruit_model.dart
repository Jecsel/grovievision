import 'dart:typed_data';

class FruitModel {
  final int? id;
  final Uint8List imageBlob;
  final String name;
  final String description;

  FruitModel({
    this.id,
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

  factory FruitModel.fromMap(Map<String, dynamic> map) {
    return FruitModel(
      id: map['id'],
      imageBlob: map['imageBlob'],
      name: map['name'],
      description: map['description'],
    );
  }

  FruitModel copy({
    int? id,
    Uint8List? imageBlob,
    String? name,
    String? description,
  }) {
    return FruitModel(
      id: id ?? this.id,
      imageBlob: imageBlob ?? this.imageBlob,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }
}
