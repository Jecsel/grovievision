import 'dart:typed_data';

class FlowerModel {
  final int? id;
  final int mangroveId; // Reference ID
  final Uint8List? imageBlob;
  String? imagePath;
  String? name;
  String? inflorescence;
  String? petals;
  String? sepals;
  String? stamen;
  String? size;
  String? description;

  FlowerModel({
    this.id,
    required this.mangroveId,
    this.imageBlob,
    this.imagePath,
    this.name,
    this.inflorescence,
    this.petals,
    this.sepals,
    this.stamen,
    this.size,
    this.description
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'mangroveId': mangroveId,
      'imageBlob': imageBlob,
      'imagePath': imagePath,
      'name': name,
      'inflorescence': inflorescence,
      'petals': petals,
      'sepals': sepals,
      'stamen': stamen,
      'size' : size,
      'description': description
    };
  }

  factory FlowerModel.fromMap(Map<String, dynamic> map) {
    return FlowerModel(
      id: map['id'],
      mangroveId: map['mangroveId'],
      imageBlob: map['imageBlob'],
      imagePath: map['imagePath'],
      name: map['name'],
      inflorescence: map['inflorescence'],
      petals: map['petals'],
      sepals: map['sepals'],
      stamen: map['stamen'],
      size: map['size'],
      description: map['description']
    );
  }
}
