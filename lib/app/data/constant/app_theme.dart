import 'package:bento/app/data/constant/app_colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    splashColor: Colors.transparent,
    hoverColor: Colors.transparent,
    highlightColor: Colors.transparent,
    scaffoldBackgroundColor: AppColors.kBlack,
    primaryColor: AppColors.kPrimary,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.slateGray,
      elevation: 10,
      surfaceTintColor: Colors.transparent,
    ),
  );
}
