import 'package:bento/app/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/enums/shape_enum.dart';
import '../../../model/gridItem_model.dart';
import 'custom_shapes_tile.dart';

class OnHoverButton extends StatefulWidget {
  final String itemId; // Unique identifier for the item
  const OnHoverButton({
    super.key,
    required this.itemId,
  });

  @override
  State<OnHoverButton> createState() => _OnHoverButtonState();
}

class _OnHoverButtonState extends State<OnHoverButton> {
  final HomeController _hc = Get.find<HomeController>();
  bool isHovered = false;

  final shapeSizes = {
    ShapeType.square: const Size(200, 260),
    ShapeType.smallRectangle: const Size(430, 150),
    ShapeType.mediumRectangle: const Size(200, 490),
    ShapeType.largeSquare: const Size(430, 490),
  };

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedShape = _hc.getItemShape(widget.itemId);
      final item = _hc.getItem(widget.itemId);
      final containerSize = shapeSizes[selectedShape]!;

      Widget contentWidget;

      switch (item.type) {
        case ItemType.link:
          contentWidget = Center(
            child: Text(item.link ?? item.link.toString(),
                style: const TextStyle(color: Colors.blue)),
          );
          break;
        case ItemType.image:
          contentWidget = item.imagePath != null
              ? Center(child: Image.network(item.imagePath!, fit: BoxFit.fill))
              : Container();
          break;
        case ItemType.text:
          contentWidget = Center(
            child: Text(item.text ?? 'Text',
                style: const TextStyle(color: Colors.black)),
          );
          break;
        default:
          contentWidget = Container();
      }

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.grab,
            onEnter: (_) => setState(() => isHovered = true),
            onExit: (_) => setState(() => isHovered = false),
            child: Stack(
              children: [
                AnimatedContainer(
                  width: containerSize.width,
                  height: containerSize.height,
                  duration: const Duration(milliseconds: 200),
                  transform: isHovered
                      ? Matrix4.translationValues(0, -10, 0)
                      : Matrix4.identity(),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 50),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(0, 3),
                              ),
                            ],
                            border: Border.all(color: Colors.grey[300]!),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: contentWidget,
                        ),
                      ),
                      AnimatedOpacity(
                        opacity: isHovered ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 250),
                        child: SizedBox(
                          width: 200,
                          child: CustomShapeButton(
                            onShapeSelected: (ShapeType shape) {
                              _hc.updateItemShape(widget.itemId, shape);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedOpacity(
                  opacity: isHovered ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 250),
                  child: Container(
                    transform: Matrix4.translationValues(-10, -15, 0),
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: IconButton(
                        style: ButtonStyle(
                            overlayColor:
                                WidgetStateProperty.all(Colors.grey[300]),
                            shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)))),
                        onPressed: () {
                          _hc.deleteItem(widget.itemId);
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.black,
                          size: 17,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
