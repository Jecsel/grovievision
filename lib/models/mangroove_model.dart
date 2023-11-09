import 'dart:typed_data';

class MangrooveModel {
  final int? id;
  final Uint8List? imageBlob;
  String? imagePath;
  final String local_name;  
  final String scientific_name;
  final String description;
  String? summary;

  MangrooveModel({
    this.id,
    this.imageBlob,
    this.imagePath,
    required this.local_name,
    required this.scientific_name,
    required this.description,
    this.summary
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imageBlob': imageBlob,
      'imagePath': imagePath,
      'local_name': local_name,
      'scientific_name': scientific_name,
      'description': description,
      'summary': summary
    };
  }

  factory MangrooveModel.fromMap(Map<String, dynamic> map) {
    return MangrooveModel(
      id: map['id'],
      imageBlob: map['imageBlob'],
      imagePath: map['imagePath'],
      local_name: map['local_name'],
      scientific_name: map['scientific_name'],
      description: map['description'],
      summary: map['summary']
    );
  }

  MangrooveModel copy({
    int? id,
    Uint8List? imageBlob,
    String? imagePath,
    String? local_name,
    String? scientific_name,
    String? description,
    String? summary
  }) {
    return MangrooveModel(
      id: id ?? this.id,
      imageBlob: imageBlob ?? this.imageBlob,
      imagePath: imagePath ?? this.imagePath,
      local_name: local_name ?? this.local_name,
      scientific_name: scientific_name ?? this.scientific_name,
      description: description ?? this.description,
      summary: summary ?? this.summary
    );
  }
}
