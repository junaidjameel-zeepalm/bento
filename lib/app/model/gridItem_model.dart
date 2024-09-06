import 'package:bento/app/data/enums/shape_enum.dart';

class GridItem {
  final String id;
  final ShapeType shape;
  final ItemType type;
  final String? link;
  final String? imagePath;
  final String? text;
  final String? sectionTile;
  final int position; // New field to store the order

  GridItem({
    required this.id,
    required this.shape,
    required this.type,
    this.link,
    this.imagePath,
    this.text,
    this.sectionTile,
    required this.position, // Initialize in constructor
  });

  // Include 'position' in toMap and fromMap methods
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'shape': shape.name,
      'type': type.name,
      'link': link,
      'imagePath': imagePath,
      'text': text,
      'sectionTile': sectionTile,
      'position': position, // Add this
    };
  }

  factory GridItem.fromMap(Map<String, dynamic> map) {
    return GridItem(
      id: map['id'] ?? '',
      shape: ShapeType.values.byName(map['shape']),
      type: ItemType.values.byName(map['type']),
      link: map['link'],
      imagePath: map['imagePath'],
      text: map['text'],
      sectionTile: map['sectionTile'],
      position: map['position'], // Add this
    );
  }

  // Add copyWith method for 'position'
  GridItem copyWith({
    String? id,
    ShapeType? shape,
    ItemType? type,
    String? link,
    String? imagePath,
    String? text,
    String? sectionTile,
    int? position, // Add position here
  }) {
    return GridItem(
      id: id ?? this.id,
      shape: shape ?? this.shape,
      type: type ?? this.type,
      link: link ?? this.link,
      imagePath: imagePath ?? this.imagePath,
      text: text ?? this.text,
      sectionTile: sectionTile ?? this.sectionTile,
      position: position ?? this.position, // Add position here
    );
  }
}
