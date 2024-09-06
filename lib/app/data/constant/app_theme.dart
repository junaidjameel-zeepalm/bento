import 'package:bento/app/data/constant/app_colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.kPrimary,
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0))),
          padding: WidgetStateProperty.all(EdgeInsets.zero)),
    ),
  );
}
