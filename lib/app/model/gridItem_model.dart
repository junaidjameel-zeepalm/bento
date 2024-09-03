import '../data/enums/shape_enum.dart';

class GridItem {
  final String id;
  final ShapeType shape;
  final ItemType type;
  final String? link; // For link type
  final String? imagePath; // For image type
  final String? text; // For text type
  final String? sectionTile;

  GridItem({
    required this.id,
    required this.shape,
    required this.type,
    this.link,
    this.imagePath,
    this.text,
    this.sectionTile,
  });

  GridItem copyWith({
    String? id,
    ShapeType? shape,
    ItemType? type,
    String? link,
    String? imagePath,
    String? text,
    String? sectionTile,
  }) {
    return GridItem(
      id: id ?? this.id,
      shape: shape ?? this.shape,
      type: type ?? this.type,
      link: link ?? this.link,
      imagePath: imagePath ?? this.imagePath,
      text: text ?? this.text,
      sectionTile: sectionTile ?? this.sectionTile,
    );
  }
}

enum ItemType { link, image, text, sectionTile }
