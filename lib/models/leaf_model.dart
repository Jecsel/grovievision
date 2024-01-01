import 'dart:typed_data';

class LeafModel {
  final int? id;
  final int mangroveId; // Reference ID
  final Uint8List? imageBlob;
  String? imagePath;
  String? name;
  String? arrangement;
  String? bladeShape;
  String? margin;
  String? apex;
  String? base;
  String? upperSurface;
  String? underSurface;
  String? size;
  String? description;

  LeafModel({
    this.id,
    required this.mangroveId,
    this.imageBlob,
    this.imagePath,
    this.name,
    this.arrangement,
    this.bladeShape,
    this.margin,
    this.apex,
    this.base,
    this.upperSurface,
    this.underSurface,
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
      'arrangement' : arrangement,
      'bladeShape' : bladeShape,
      'margin' : margin,
      'apex' : apex,
      'base' : base,
      'upperSurface' : upperSurface,
      'underSurface' : underSurface,
      'size' : size,
      'description': description
    };
  }

  factory LeafModel.fromMap(Map<String, dynamic> map) {
    return LeafModel(
      id: map['id'],
      mangroveId: map['mangroveId'],
      imageBlob: map['imageBlob'],
      imagePath: map['imagePath'],
      name: map['name'],
      arrangement: map['arrangement'],
      bladeShape: map['bladeShape'],
      margin: map['margin'],
      apex: map['apex'],
      base: map['base'],
      upperSurface: map['upperSurface'],
      underSurface: map['underSurface'],
      size: map['size'],
      description: map['description'],
    );
  }

}
