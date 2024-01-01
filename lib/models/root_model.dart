import 'dart:typed_data';

class RootModel {
  final int? id;
  final int mangroveId; // Reference ID
  final Uint8List? imageBlob;
  String? imagePath;
  String? name;
  final String description;

  RootModel({
    this.id,
    required this.mangroveId,
    this.imageBlob,
    this.imagePath,
    this.name,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'mangroveId': mangroveId,
      'imageBlob': imageBlob,
      'imagePath': imagePath,
      'name': name,
      'description': description,
    };
  }

  static RootModel fromMap(Map<String, dynamic> map) {
    return RootModel(
      id: map['id'],
      mangroveId: map['mangroveId'],
      imageBlob: map['imageBlob'],
      imagePath: map['imagePath'],
      name: map['name'],
      description: map['description'],
    );
  }
}