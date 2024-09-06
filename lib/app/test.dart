// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import 'package:bento/app/controller/home_controller.dart';
// import 'package:bento/app/modules/home/component/hover_widget.dart';

// class GridSectionWidget extends StatefulWidget {
//   final bool isMobile;
//   const GridSectionWidget({super.key, required this.isMobile});

//   @override
//   State<GridSectionWidget> createState() => _GridSectionWidgetState();
// }

// class _GridSectionWidgetState extends State<GridSectionWidget>
//     with TickerProviderStateMixin {
//   final HomeController _hc = Get.put(HomeController());
//   final _scrollController = ScrollController();
//   int? _draggedIndex; // Track the index of the dragged item

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       return SingleChildScrollView(
//         controller: _scrollController,
//         child: Padding(
//           padding: EdgeInsets.all(widget.isMobile ? 0 : 60),
//           child: SizedBox(
//             width: widget.isMobile ? 550 : null,
//             child: Wrap(
//               spacing: 12, // Adjust spacing for smoothness
//               runSpacing: 12, // Adjust run spacing for better layout
//               children: List.generate(
//                 _hc.items.length,
//                 (index) {
//                   return DragTarget<GridItemModel>(
//                     onWillAcceptWithDetails: (details) {
//                       // Check if the dragged item is not the same as the target
//                       if (_draggedIndex != index) {
//                         _draggedIndex = index;
//                         return true;
//                       }
//                       return false;
//                     },
//                     onAcceptWithDetails: (details) {
//                       final draggedItemIndex = _hc.items.indexOf(details.data);
//                       _hc.swapItems(draggedItemIndex, index);
//                       setState(() {
//                         _draggedIndex =
//                             null; // Reset the dragged index after drop
//                       });
//                     },
//                     builder: (context, candidateData, rejectedData) {
//                       // Highlight target area during dragging
//                       bool isDraggedOver = candidateData.isNotEmpty;
//                       return AnimatedContainer(
//                         duration: const Duration(milliseconds: 300),
//                         curve: Curves.easeInOut,
//                         decoration: BoxDecoration(
//                           border: isDraggedOver
//                               ? Border.all(color: Colors.red, width: 2)
//                               : null,
//                         ),
//                         child: Draggable<GridItemModel>(
//                           onDragStarted: () {
//                             setState(() {
//                               _draggedIndex = index;
//                             });
//                           },
//                           onDragEnd: (details) {
//                             setState(() {
//                               _draggedIndex =
//                                   null; // Reset index after dragging ends
//                             });
//                           },
//                           data: _hc.items[index],
//                           feedback: _buildCard(index, isFeedback: true),
//                           childWhenDragging: const SizedBox(
//                             height: 200,
//                             width: 200,
//                           ),
//                           child: _buildCard(index),
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//           ),
//         ),
//       );
//     });
//   }

//   Widget _buildCard(int index, {bool isFeedback = false}) {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 300),
//       curve: Curves.easeInOut,
//       // Adjust elevation for smooth feedback effect
//       decoration: BoxDecoration(
//         boxShadow: [
//           if (isFeedback)
//             const BoxShadow(
//               color: Colors.black26,
//               blurRadius: 8.0,
//               spreadRadius: 2.0,
//             ),
//         ],
//       ),
//       child: Material(
//         elevation: isFeedback ? 6.0 : 0.0,
//         child: Container(
//           key: ValueKey('${_hc.items[index]}_$index'),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 12.0),
//             child: OnHoverButton(
//               key: ValueKey(_hc.items[index]),
//               itemId: _hc.items[index].itemId,
//               cardData: _hc.items[index].cardData,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class GridItemModel {
//   final int position;
//   final String itemId;
//   CardDataModel? cardData;
//   GridItemModel({
//     required this.position,
//     required this.itemId,
//     this.cardData,
//   });
// }


// import 'dart:math';

// import 'package:bento/app/modules/home/component/hover_widget.dart';
// import 'package:get/get.dart';

// class HomeController extends GetxController {
//   var items = List.generate(
//       84, (index) => GridItemModel(position: index, itemId: 'Item $index')).obs;
//   var itemShapes =
//       <String, ShapeType>{}.obs; 

//   @override
//   void onInit() {
//     randomizeData();
//     super.onInit();
//   }

//   // Method to reorder items
//   void reorderItems(List<GridItemModel> newItems) {
//     items.assignAll(newItems);
//   }

//   // Method to update the shape of an item
//   void updateItemShape(String itemId, ShapeType shape) {
//     itemShapes[itemId] = shape;
//   }

//   // Method to get the shape of an item
//   ShapeType getItemShape(String itemId) {
//     return itemShapes[itemId] ??
//         ShapeType.square; // Default to square if not set
//   }

//   randomizeData() {
//     for (var element in items) {
//       if (getRandomBool()) {
//         element.cardData = CardDataModel(
//             id: 'asd',
//             title: "Title ${element.itemId}",
//             description: "Description ${element.itemId}",
//             link: "",
//             shape: ShapeType.square);
//       }
//     }
//   }

//   void swapItems(int i, int index) {
//     final temp = items[i];
//     items[i] = items[index];
//     items[index] = temp;
//   }
// }

// enum ShapeType {
//   mediumRectangle,
//   square,
//   smallRectangle,
//   horizontalRectangle,
//   largeSquare
// }

// bool getRandomBool() {
//   return Random().nextBool();
// }

// class GridItemModel {
//   final int position;
//   final String itemId;
//   CardDataModel? cardData;
//   GridItemModel({
//     required this.position,
//     required this.itemId,
//     this.cardData,
//   });
// }
