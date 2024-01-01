class FruitImagesModel {
  final int? id;
  final int fruitId;
  final String imagePath;

  FruitImagesModel({
    this.id,
    required this.fruitId,
    required this.imagePath
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fruitId': fruitId,
      'imagePath': imagePath
    };
  }

  factory FruitImagesModel.fromMap(Map<String, dynamic> map) {
    return FruitImagesModel(
      id: map['id'],
      fruitId: map['fruitId'],
      imagePath: map['imagePath']
    );
  }
}
