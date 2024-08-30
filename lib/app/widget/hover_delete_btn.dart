import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HoverButton extends StatelessWidget {
  final bool isHovered;
  final VoidCallback onPressed;
  final IconData icon;

  const HoverButton({
    super.key,
    required this.isHovered,
    required this.onPressed,
    this.icon = CupertinoIcons.delete,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
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
              overlayColor: WidgetStateProperty.all(Colors.grey[300]),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            onPressed: onPressed,
            icon: Icon(
              icon,
              color: Colors.black,
              size: 17,
            ),
          ),
        ),
      ),
    );
  }
}
