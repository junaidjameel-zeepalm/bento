import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/enums/shape_enum.dart';

class CustomShapeButton extends StatelessWidget {
  final ValueChanged<ShapeType> onShapeSelected;

  const CustomShapeButton({
    super.key,
    required this.onShapeSelected,
  });

  @override
  Widget build(BuildContext context) {
    bool isMobile = Get.width < 1300;

    final List<Map<String, dynamic>> shapes = [
      {
        'width': 14.0,
        'height': 15.0,
        'borderRadius': 2.0,
        'shape': ShapeType.square,
      },
      {
        'width': 26.0,
        'height': 15.0,
        'borderRadius': 5.0,
        'shape': ShapeType.smallRectangle,
      },
      {
        'width': 14.0,
        'height': 30.0,
        'borderRadius': 5.0,
        'shape': ShapeType.mediumRectangle,
      },
      {
        'width': 25.0,
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
          return isMobile
              ? IconButton(
                  onPressed: () => onShapeSelected(shape['shape']),
                  icon: Container(
                    width: shape['width'],
                    height: shape['height'],
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(shape['borderRadius']),
                    ),
                  ),
                )
              : InkWell(
                  onTap: () => onShapeSelected(shape['shape']),
                  child: Container(
                    width: shape['width'],
                    height: shape['height'],
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(shape['borderRadius']),
                    ),
                  ),
                );
        }).toList(),
      ),
    );
  }
}
