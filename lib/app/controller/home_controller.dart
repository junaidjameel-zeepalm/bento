import 'package:bento/app/modules/home/component/hover_widget.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  var items = List.generate(20, (index) => 'Item $index').obs;
  var itemShapes =
      <String, ShapeType>{}.obs; // Map to store shape for each item identifier

  // Method to reorder items
  void reorderItems(List<String> newItems) {
    items.assignAll(newItems);
  }

  // Method to update the shape of an item
  void updateItemShape(String itemId, ShapeType shape) {
    itemShapes[itemId] = shape;
  }

  // Method to get the shape of an item
  ShapeType getItemShape(String itemId) {
    return itemShapes[itemId] ??
        ShapeType.square; // Default to square if not set
  }
}
