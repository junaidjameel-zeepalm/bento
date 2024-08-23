import 'package:bento/app/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum ShapeType {
  mediumRectangle,
  square,
  smallRectangle,
  horizontalRectangle,
  largeSquare
}

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
    ShapeType.square: const Size(260, 260),
    ShapeType.mediumRectangle: const Size(200, 400),
    ShapeType.smallRectangle: const Size(500, 200),
    ShapeType.horizontalRectangle: const Size(1200, 200),
    ShapeType.largeSquare: const Size(400, 400),
  };

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedShape = _hc.getItemShape(widget.itemId);
      final containerSize = shapeSizes[selectedShape]!;

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.grab,
            onEnter: (_) => setState(() => isHovered = true),
            onExit: (_) => setState(() => isHovered = false),
            child: AnimatedContainer(
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
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 50),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  if (isHovered)
                    SizedBox(
                      width: 200,
                      child: CustomShapeButton(
                        onShapeSelected: (ShapeType shape) {
                          _hc.updateItemShape(widget.itemId, shape);
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}

class CustomShapeButton extends StatelessWidget {
  final ValueChanged<ShapeType> onShapeSelected;

  const CustomShapeButton({
    super.key,
    required this.onShapeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> shapes = [
      {
        'width': 15.0,
        'height': 15.0,
        'borderRadius': 2.0,
        'shape': ShapeType.square,
      },
      {
        'width': 30.0,
        'height': 15.0,
        'borderRadius': 5.0,
        'shape': ShapeType.smallRectangle,
      },
      {
        'width': 15.0,
        'height': 30.0,
        'borderRadius': 5.0,
        'shape': ShapeType.mediumRectangle,
      },
      {
        'width': 30.0,
        'height': 30.0,
        'borderRadius': 4.0,
        'shape': ShapeType.largeSquare,
      },
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      height: 45,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: shapes.map((shape) {
          return IconButton(
            onPressed: () => onShapeSelected(shape['shape']),
            icon: Container(
              width: shape['width'],
              height: shape['height'],
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(shape['borderRadius']),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
