import 'dart:async';
import 'dart:developer';
import 'package:bento/app/controller/auth_controller.dart';
import 'package:bento/app/data/enums/shape_enum.dart';
import 'package:bento/app/model/gridItem_model.dart';
import 'package:bento/app/repo/widget_repo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final linkController = TextEditingController();
  final String currentUid = Get.find<AuthController>().user!.uid;

  var items = <GridItem>[].obs;
  var selectedItemId = ''.obs;

  Timer? _debounce;

  final WidgetRepo _widgetRepo = WidgetRepo();

  final Map<String, TextEditingController> textControllers = {};
  final Map<String, TextEditingController> sectionTextControllers = {};

  @override
  void onInit() {
    super.onInit();
    fetchWidgets();
  }

  // Fetches widgets and initializes controllers
  void fetchWidgets() async {
    try {
      var fetchedItems = await _widgetRepo.fetchUserWidgets(currentUid);
      items.assignAll(fetchedItems);

      // Initialize text and section text controllers for fetched items
      for (var item in items) {
        if (!textControllers.containsKey(item.id)) {
          textControllers[item.id] = TextEditingController(text: item.text);
          textControllers[item.id]!.addListener(() {
            _onTextChanged(item.id);
          });
        }

        if (!sectionTextControllers.containsKey(item.id)) {
          sectionTextControllers[item.id] =
              TextEditingController(text: item.sectionTile);
          sectionTextControllers[item.id]!.addListener(() {
            _onSectionTextChanged(item.id);
            log('Section text controller initialized for item ${item.id} with text: ${item.sectionTile}');
          });
        }
      }

      log('Widgets fetched successfully!');
    } catch (e) {
      log('Failed to fetch widgets: $e');
    }
  }

  void addItem({required ItemType type, required String content}) async {
    String newItemId = 'Item ${items.length}';
    String? imagePath;

    // Handle image upload if necessary
    if (type == ItemType.image && content.isNotEmpty) {
      try {
        if (kIsWeb) {
          Uint8List? fileBytes = await _widgetRepo.fetchBytesFromUrl(content);
          if (fileBytes != null) {
            imagePath = await _widgetRepo.uploadToStorageFromBytes(
              fileBytes: fileBytes,
              folderName: 'user_images/$currentUid/$newItemId',
            );
          }
        }
      } catch (e) {
        log('Failed to upload image: $e');
      }
    }

    // Initialize the new text controller or section text controller
    if (type == ItemType.text) {
      textControllers[newItemId] = TextEditingController(text: content);
      textControllers[newItemId]!.addListener(() {
        _onTextChanged(newItemId);
      });
    }

    if (type == ItemType.sectionTile) {
      sectionTextControllers[newItemId] = TextEditingController(text: content);
      sectionTextControllers[newItemId]!.addListener(() {
        _onSectionTextChanged(newItemId);
      });
    }

    // Create the new grid item
    GridItem newItem = GridItem(
      id: newItemId,
      shape: type == ItemType.sectionTile
          ? ShapeType.sectionTileShape
          : ShapeType.square,
      type: type,
      link: type == ItemType.link ? content : null,
      imagePath: type == ItemType.image ? imagePath : null,
      text: type == ItemType.text ? content : null,
      sectionTile: type == ItemType.sectionTile ? content : null,
      position: items.length,
    );

    // Insert the new item into the grid
    items.insert(items.length, newItem);

    // Update the UI
    update();

    try {
      await _widgetRepo.addWidget(currentUid, newItem);
      log('Item added to Firestore successfully!');
    } catch (e) {
      log('Failed to add item to Firestore: $e');
    }
  }

  // Handles changes in the text field and saves to Firestore (debounced)
  void _onTextChanged(String itemId) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _updateTextInFirestore(itemId, textControllers[itemId]!.text);
    });
  }

  // Handles changes in the section text field and saves to Firestore (debounced)
  void _onSectionTextChanged(String itemId) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _updateSectionTextInFirestore(
          itemId, sectionTextControllers[itemId]!.text);
    });
  }

  // Updates the regular text in Firestore
  void _updateTextInFirestore(String itemId, String newText) async {
    if (newText.isNotEmpty) {
      try {
        updateItemText(itemId, newText);
        await _widgetRepo.updateWidgetText(currentUid, itemId, newText);
        log('Text updated in Firestore successfully!');
      } catch (e) {
        log('Failed to update text in Firestore: $e');
      }
    }
  }

  // Updates the section text in Firestore
  void _updateSectionTextInFirestore(String itemId, String newText) async {
    if (newText.isNotEmpty) {
      log('Updating section text in Firestore for item $itemId with text: $newText');
      try {
        updateItemSectionText(itemId, newText);
        await _widgetRepo.updateSectionText(currentUid, itemId, newText);
        log('Section text updated in Firestore successfully!');
      } catch (e) {
        log('Failed to update section text in Firestore: $e');
      }
    }
  }

  // Returns the text controller for a given itemId (or initializes it)
  TextEditingController getTextController(String itemId) {
    return textControllers[itemId] ??= TextEditingController();
  }

  // Returns the section text controller for a given itemId (or initializes it)
  TextEditingController getSectionTextController(String itemId) {
    return sectionTextControllers[itemId] ??= TextEditingController();
  }

  @override
  void onClose() {
    textControllers.forEach((_, controller) => controller.dispose());
    sectionTextControllers.forEach((_, controller) => controller.dispose());
    super.onClose();
  }

  // Sets the selected item by ID
  void setSelectedItem(String itemId) {
    selectedItemId.value = itemId;
    log('Selected item ID set to: $itemId');
  }

  // Reorders items and updates Firestore
  void reorderItems(List<GridItem> newItems) async {
    try {
      items.assignAll(newItems);
      await _widgetRepo.reorderWidgets(currentUid, newItems);
      log('Items reordered and updated in Firestore successfully!');
    } catch (e) {
      log('Failed to reorder items in Firestore: $e');
    }
  }

  // Adds a new item to the grid and Firestore

  // Deletes an item from the grid and Firestore
  Future<void> deleteItem(String itemId) async {
    items.removeWhere((item) => item.id == itemId);
    textControllers.remove(itemId)?.dispose();
    sectionTextControllers.remove(itemId)?.dispose();
    try {
      await _widgetRepo.deleteWidget(currentUid, itemId);
      log('Item deleted from Firestore successfully!');
    } catch (e) {
      log('Failed to delete item from Firestore: $e');
    }
  }

  // Updates an item's shape in Firestore
  Future<void> updateItemShape(String itemId, ShapeType shape) async {
    int index = items.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      items[index] = items[index].copyWith(shape: shape);
      try {
        await _widgetRepo.updateWidgetShape(currentUid, itemId, shape.name);
        log('Shape updated in Firestore successfully!');
      } catch (e) {
        log('Failed to update shape in Firestore: $e');
      }
    }
  }

  // Updates the item text locally
  void updateItemText(String itemId, String text) {
    int index = items.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      items[index] = items[index].copyWith(text: text);
    }
  }

  void updateImage(String itemId, String imagePath) {
    int index = items.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      items[index] = items[index].copyWith(imagePath: imagePath);
    }
  }

  // Updates the section text locally
  void updateItemSectionText(String itemId, String text) {
    int index = items.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      items[index] = items[index].copyWith(sectionTile: text);
    }
  }

  ShapeType getItemShape(String id) {
    return getItem(id).shape;
  }

  // Retrieves a specific item by ID
  GridItem getItem(String id) {
    return items.firstWhere((item) => item.id == id);
  }

  // Retrieves a link associated with an item by ID
  String? getItemLink(String itemId) {
    int index = items.indexWhere((item) => item.id == itemId);
    return index != -1 ? items[index].link : null;
  }
}
