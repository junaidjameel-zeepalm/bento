// import 'package:bento/app/controller/home_controller.dart';
// import 'package:bento/app/modules/home/component/hover_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class BentoGridPage extends StatefulWidget {
//   const BentoGridPage({super.key});

//   @override
//   BentoGridPageState createState() => BentoGridPageState();
// }

// class BentoGridPageState extends State<BentoGridPage> {
//   final HomeController _hc = Get.put(HomeController());
//   final Map<String, Offset> itemPositions = {}; // Stores positions of items
//   final int itemsPerRow = 4; // Number of items per row
//   final double itemSize = 100.0; // Width and height of each item
//   final double spacing = 10.0; // Spacing between items

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Obx(() {
//         final items = _hc.items;

//         // Initialize positions if not already done
//         for (int i = 0; i < items.length; i++) {
//           if (!itemPositions.containsKey(items[i])) {
//             // Calculate row and column for each item
//             int row = i ~/ itemsPerRow;
//             int col = i % itemsPerRow;

//             // Calculate the position based on row, column, item size, and spacing
//             double dx = col * (itemSize + spacing);
//             double dy = row * (itemSize + spacing);

//             itemPositions[items[i]] = Offset(dx, dy);
//           }
//         }

//         return Stack(
//           clipBehavior: Clip.antiAliasWithSaveLayer,
//           children: items.map((item) {
//             final itemPosition = itemPositions[item];

//             return Positioned(
//               left: itemPosition!.dx,
//               top: itemPosition.dy,
//               child: Draggable(
//                 data: item,
//                 feedback: Material(
//                   color: Colors.transparent,
//                   child: Opacity(
//                     opacity: 0.7,
//                     child: OnHoverButton(
//                       key: ValueKey(item),
//                       itemId: item,
//                     ),
//                   ),
//                 ),
//                 childWhenDragging: Container(),
//                 onDragEnd: (details) {
//                   setState(() {
//                     // Update position of the item based on drag end details
//                     itemPositions[item] = details.offset;
//                   });
//                 },
//                 child: DragTarget<String>(
//                   onWillAcceptWithDetails: (receivedItem) =>
//                       receivedItem != item,
//                   onAcceptWithDetails: (details) {
//                     setState(() {
//                       // final draggedItemIndex = items.indexOf(details.data);

//                       // Swap positions of dragged item and target item
//                       final targetPosition = itemPositions[item];
//                       itemPositions[item] = itemPositions[details.data]!;
//                       itemPositions[details.data] = targetPosition!;
//                     });
//                   },
//                   builder: (context, candidateData, rejectedData) {
//                     return OnHoverButton(
//                       key: ValueKey(item),
//                       itemId: item,
//                     );
//                   },
//                 ),
//               ),
//             );
//           }).toList(),
//         );
//       }),
//     );
//   }
// }
