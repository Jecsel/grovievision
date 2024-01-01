class LeafImagesModel {
  final int? id;
  final int leafId;
  final String imagePath;

  LeafImagesModel({
    this.id,
    required this.leafId,
    required this.imagePath
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'leafId': leafId,
      'imagePath': imagePath
    };
  }

  factory LeafImagesModel.fromMap(Map<String, dynamic> map) {
    return LeafImagesModel(
      id: map['id'],
      leafId: map['leafId'],
      imagePath: map['imagePath']
    );
  }
}
