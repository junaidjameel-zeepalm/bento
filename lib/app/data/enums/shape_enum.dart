enum ShapeType {
  mediumRectangle,
  square,
  smallRectangle,
  largeSquare,
  sectionTileShape,
}

extension ShapeTypeExtension on ShapeType {
  String get name {
    switch (this) {
      case ShapeType.square:
        return 'square';
      case ShapeType.smallRectangle:
        return 'smallRectangle';
      case ShapeType.largeSquare:
        return 'largeSquare'; // Adjusted to match enum
      case ShapeType.mediumRectangle:
        return 'mediumRectangle'; // Added case for mediumRectangle
      case ShapeType.sectionTileShape:
        return 'sectionTileShape'; // Added case for sectionTileShape
      default:
        return '';
    }
  }
}

ShapeType shapeTypeFromString(String value) {
  switch (value) {
    case 'square':
      return ShapeType.square;
    case 'smallRectangle':
      return ShapeType.smallRectangle;
    case 'largeSquare':
      return ShapeType.largeSquare;
    case 'mediumRectangle':
      return ShapeType.mediumRectangle;
    case 'sectionTileShape':
      return ShapeType.sectionTileShape;
    default:
      throw ArgumentError('Invalid shape type: $value');
  }
}

enum ItemType { link, image, video, text, sectionTile }

extension ItemTypeExtension on ItemType {
  String get name {
    switch (this) {
      case ItemType.link:
        return 'link';
      case ItemType.image:
        return 'image';
      case ItemType.video:
        return 'video';
      case ItemType.text:
        return 'text';
      case ItemType.sectionTile:
        return 'sectionTile';
      default:
        return '';
    }
  }
}

ItemType itemTypeFromString(String value) {
  switch (value) {
    case 'link':
      return ItemType.link;
    case 'image':
      return ItemType.image;
    case 'video':
      return ItemType.video;
    case 'text':
      return ItemType.text;
    case 'sectionTile':
      return ItemType.sectionTile;
    default:
      throw ArgumentError('Invalid item type: $value');
  }
}
