import 'dart:typed_data';

class FruitModel {
  final int? id;
  final int mangroveId; // Reference ID
  final Uint8List? imageBlob;
  String? imagePath;
  String? name;
  String? shape;
  String? color;
  String? texture;
  String? size;
  String? description;


  FruitModel({
    this.id,
    required this.mangroveId,
    this.imageBlob,
    this.imagePath,
    this.name,
    this.shape,
    this.color,
    this.texture,
    this.size,
    this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'mangroveId': mangroveId,
      'imageBlob': imageBlob,
      'imagePath': imagePath,
      'name': name,
      'shape': shape,
      'color': color,
      'texture': texture,
      'size': size,
      'description': description,
    };
  }

  factory FruitModel.fromMap(Map<String, dynamic> map) {
    return FruitModel(
      id: map['id'],
      mangroveId: map['mangroveId'],
      imageBlob: map['imageBlob'],
      imagePath: map['imagePath'],
      name: map['name'],
      shape: map['shape'],
      color: map['color'],
      texture: map['texture'],
      size: map['size'],
      description: map['description'],
    );
  }
}
