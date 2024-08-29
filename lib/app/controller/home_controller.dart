import 'package:bento/app/data/enums/shape_enum.dart';
import 'package:bento/app/model/gridItem_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final linkController = TextEditingController();

  var items = <GridItem>[
    for (int i = 0; i < 6; i++)
      GridItem(id: 'Item $i', shape: ShapeType.square, type: ItemType.link)
  ].obs;

  var itemShapes =
      <String, ShapeType>{}.obs; // Map to store shape for each item identifier

  // Method to reorder items
  void reorderItems(List<GridItem> newItems) {
    items.assignAll(newItems);
  }

  // Method to add a new item
  void addItem({ItemType type = ItemType.link, String content = ''}) {
    String newItemId = 'Item ${items.length}';
    GridItem newItem = GridItem(
      id: newItemId,
      shape: ShapeType.square,
      type: type,
      link: type == ItemType.link ? content : null,
      imagePath: type == ItemType.image ? content : null,
      text: type == ItemType.text ? content : null,
    );
    items.add(newItem);
  }

  // Method to delete an item by ID
  void deleteItem(String itemId) {
    items.removeWhere((item) => item.id == itemId);
  }

  // Method to update the shape of an item
  void updateItemShape(String itemId, ShapeType shape) {
    int index = items.indexWhere((item) => item.id == itemId);

    if (index != -1) {
      items[index] = items[index].copyWith(shape: shape);
    }
  }

  // Method to update the link of an item
  void updateItemLink(String itemId, String link) {
    int index = items.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      items[index] = items[index].copyWith(link: link);
    }
  }

  // Method to update the type of an item
  void updateItemType(String itemId, ItemType type) {
    int index = items.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      items[index] = items[index].copyWith(type: type);
    }
  }

  // Method to get the shape of an item
  // ShapeType getItemShape(String itemId) {
  //   int index = items.indexWhere((item) => item.id == itemId);
  //   return index != -1 ? items[index].shape : ShapeType.square;
  // }

  // Method to get the link of an item
  String? getItemLink(String itemId) {
    int index = items.indexWhere((item) => item.id == itemId);
    return index != -1 ? items[index].link : null;
  }

  ShapeType getItemShape(String id) {
    return getItem(id).shape;
  }

  GridItem getItem(String id) {
    return items.firstWhere((item) => item.id == id);
  }

  // Method to get the size of an item based on its shape
  Size getItemSize(String itemId) {
    ShapeType shape = getItemShape(itemId);

    switch (shape) {
      case ShapeType.mediumRectangle:
        return const Size(200, 490); // Specific size for medium rectangle
      case ShapeType.square:
        return const Size(200, 260); // Specific size for square
      case ShapeType.smallRectangle:
        return const Size(430, 150); // Specific size for small rectangle
      case ShapeType.largeSquare:
        return const Size(430, 490); // Specific size for large square
      default:
        return const Size(200, 260); // Default size
    }
  }
}
