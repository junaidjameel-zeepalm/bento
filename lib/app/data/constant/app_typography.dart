import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  static TextStyle kRegular10 =
      GoogleFonts.montserrat(fontSize: 10, fontWeight: FontWeight.w400);
  static TextStyle kRegular12 =
      GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w400);
  static TextStyle kRegular14 =
      GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.w400);
  static TextStyle kRegular16 =
      GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.w400);
  static TextStyle kSemiBold16 =
      GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.w600);
  static TextStyle kSemiBold18 =
      GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.w600);
  static TextStyle kBold20 =
      GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.w700);
  static TextStyle kBold28 =
      GoogleFonts.montserrat(fontSize: 28, fontWeight: FontWeight.w700);
  static TextStyle kBold36 =
      GoogleFonts.montserrat(fontSize: 36, fontWeight: FontWeight.w700);
  static TextStyle kBold48 =
      GoogleFonts.montserrat(fontSize: 48, fontWeight: FontWeight.w700);
}

getFontSize(BuildContext context, double size) {
  return MediaQuery.of(context).size.width / 1440 * size;
}
