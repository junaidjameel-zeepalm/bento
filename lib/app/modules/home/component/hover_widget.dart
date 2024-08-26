import 'package:bento/app/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  // Base size for consistency
  final double baseSize = 200.0;

  // Shape sizes with equal width or width twice the height
  final shapeSizes = {
    ShapeType.square: const Size(200, 260),
    ShapeType.smallRectangle: const Size(430, 160),
    ShapeType.mediumRectangle: const Size(200, 490),
    ShapeType.largeSquare: const Size(430, 490),
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
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(
                                    0, 3), // Changes position of shadow
                              )
                            ],
                            border: Border.all(color: Colors.grey[300]!),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
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
                        onPressed: () {
                          // Handle delete action
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
