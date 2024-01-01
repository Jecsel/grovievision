class MangroveImagesModel {
  final int? id;
  final int mangroveId;
  final String imagePath;

  MangroveImagesModel({
    this.id,
    required this.mangroveId,
    required this.imagePath
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'mangroveId': mangroveId,
      'imagePath': imagePath
    };
  }

  factory MangroveImagesModel.fromMap(Map<String, dynamic> map) {
    return MangroveImagesModel(
      id: map['id'],
      mangroveId: map['mangroveId'],
      imagePath: map['imagePath']
    );
  }
}
