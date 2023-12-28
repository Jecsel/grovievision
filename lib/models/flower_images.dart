class FlowerImagesModel {
  final int? id;
  final int flowerId;
  final String imagePath;

  FlowerImagesModel({
    this.id,
    required this.flowerId,
    required this.imagePath
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'flowerId': flowerId,
      'imagePath': imagePath
    };
  }

  factory FlowerImagesModel.fromMap(Map<String, dynamic> map) {
    return FlowerImagesModel(
      id: map['id'],
      flowerId: map['flowerId'],
      imagePath: map['imagePath']
    );
  }
}
