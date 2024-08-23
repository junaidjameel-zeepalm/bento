import 'package:flutter/material.dart';

class Test extends StatelessWidget {
  const Test({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: OnHoverButton(),
      ),
    );
  }
}

enum ShapeType {
  mediumRectangle,
  square,
  smallRectangle,
  horizontalRectangle,
  largeSquare
}

class OnHoverButton extends StatefulWidget {
  const OnHoverButton({super.key});

  @override
  State<OnHoverButton> createState() => _OnHoverButtonState();
}

class _OnHoverButtonState extends State<OnHoverButton> {
  bool isHovered = false;
  ShapeType selectedShape = ShapeType.mediumRectangle;

  // Map each shape to its corresponding width and height
  final shapeSizes = {
    ShapeType.mediumRectangle: const Size(200, 400),
    ShapeType.square: const Size(200, 200),
    ShapeType.smallRectangle: const Size(500, 200),
    ShapeType.horizontalRectangle: const Size(1200, 200),
    ShapeType.largeSquare: const Size(400, 400),
  };

  @override
  Widget build(BuildContext context) {
    // Determine the size of the container based on the selected shape
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
              color: Colors.amber,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(
              child: Text(
                'Selected Shape: ${selectedShape.name}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: 200,
          child: CustomShapeButton(
            onShapeSelected: (ShapeType shape) {
              setState(() {
                selectedShape = shape;
              });
            },
          ),
        ),
      ],
    );
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
