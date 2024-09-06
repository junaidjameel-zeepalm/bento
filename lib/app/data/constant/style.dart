import 'package:flutter/material.dart';

class AppStyles {
  static final ButtonStyle circleIconButtonStyle = ButtonStyle(
    overlayColor: WidgetStateProperty.all(Colors.grey[300]),
    shape: WidgetStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    ),
  );
}
