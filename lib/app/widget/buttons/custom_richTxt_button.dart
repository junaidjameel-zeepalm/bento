import 'package:bento/app/data/constant/data.dart';
import 'package:flutter/material.dart';

class CustomRichText extends StatelessWidget {
  final String info;
  final String title;
  TextStyle? firstTextStyle;
  TextStyle? secondTextStyle;

  CustomRichText(
      {super.key,
      required this.info,
      required this.title,
      this.firstTextStyle,
      this.secondTextStyle});

  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(
            text: '$info ',
            style: firstTextStyle ?? AppTypography.kRegular14,
            children: [
          TextSpan(
            text: ' $title',
            style: secondTextStyle ?? AppTypography.kSemiBold16,
          )
        ]));
  }
}
