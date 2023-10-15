import 'dart:typed_data';

class MangrooveModel {
  final int? id;
  final Uint8List imageBlob;
  final String local_name;
  final String scientific_name;
  final String description;

  MangrooveModel({
    this.id,
    required this.imageBlob,
    required this.local_name,
    required this.scientific_name,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imageBlob': imageBlob,
      'local_name': local_name,
      'scientific_name': scientific_name,
      'description': description,
    };
  }

  factory MangrooveModel.fromMap(Map<String, dynamic> map) {
    return MangrooveModel(
      id: map['id'],
      imageBlob: map['imageBlob'],
      local_name: map['local_name'],
      scientific_name: map['scientific_name'],
      description: map['description'],
    );
  }

  MangrooveModel copy({
    int? id,
    Uint8List? imageBlob,
    String? local_name,
    String? scientific_name,
    String? description,
  }) {
    return MangrooveModel(
      id: id ?? this.id,
      imageBlob: imageBlob ?? this.imageBlob,
      local_name: local_name ?? this.local_name,
      scientific_name: scientific_name ?? this.scientific_name,
      description: description ?? this.description,
    );
  }
}