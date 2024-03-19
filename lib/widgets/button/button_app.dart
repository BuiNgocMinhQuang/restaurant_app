import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ButtonApp extends StatelessWidget {
  Function event;
  final String text;
  final String fontFamily;
  FontWeight fontWeight;
  double fontsize;
  double radius;
  Color colorText;
  Color backgroundColor;
  Color outlineColor;
  double line;
  ButtonApp({
    Key? key,
    required this.event,
    required this.text,
    required this.colorText,
    required this.backgroundColor,
    required this.outlineColor,
    this.radius = 0,
    this.fontsize = 0,
    this.fontFamily = "OpenSans",
    this.fontWeight = FontWeight.normal,
    this.line = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius == 0 ? 10.r : radius),
        ),
        backgroundColor: backgroundColor,
        side: BorderSide(color: outlineColor, width: line), //<-- SEE HERE
      ),
      onPressed: () {
        event();
      },
      child: Text(
        overflow: TextOverflow.ellipsis,
        text.toUpperCase(),
        style: TextStyle(
            fontSize: fontsize == 0 ? 14.sp : fontsize, color: colorText),
      ),
    );
  }
}
