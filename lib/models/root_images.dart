class RootImagesModel {
  final int? id;
  final int rootId;
  final String imagePath;

  RootImagesModel({
    this.id,
    required this.rootId,
    required this.imagePath
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'rootId': rootId,
      'imagePath': imagePath
    };
  }

  factory RootImagesModel.fromMap(Map<String, dynamic> map) {
    return RootImagesModel(
      id: map['id'],
      rootId: map['rootId'],
      imagePath: map['imagePath']
    );
  }
}
