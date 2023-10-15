import 'dart:typed_data';

class LeafModel {
  final int? id;
  final int mangroveId; // Reference ID
  final Uint8List imageBlob;
  final String name;
  final String description;

  LeafModel({
    this.id,
    required this.mangroveId,
    required this.imageBlob,
    required this.name,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'mangroveId': mangroveId,
      'imageBlob': imageBlob,
      'name': name,
      'description': description,
    };
  }

  factory LeafModel.fromMap(Map<String, dynamic> map) {
    return LeafModel(
      id: map['id'],
      mangroveId: map['mangroveId'],
      imageBlob: map['imageBlob'],
      name: map['name'],
      description: map['description'],
    );
  }

}
