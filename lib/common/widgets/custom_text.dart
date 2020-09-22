import 'package:flutter/material.dart';

class CustomText extends StatelessWidget
{
  final String text;
  final double fontSize;

  CustomText(this.text, this.fontSize);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: "TAHOMA",
        decoration: TextDecoration.none,
        fontSize: fontSize,
        color: Colors.black54,
        fontWeight: FontWeight.w700,),
    );
  }
}
