import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextApp extends StatelessWidget {
  final String text;
  final String fontFamily;
  double fontsize;
  Color color;
  FontWeight fontWeight;
  TextApp(
      {Key? key,
      required this.text,
      this.fontsize = 0,
      this.color = Colors.black,
      this.fontFamily = "Icomoon",
      this.fontWeight = FontWeight.normal})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontSize: fontsize == 0 ? 12.sp : fontsize,
          color: color,
          fontFamily: fontFamily,
          fontWeight: fontWeight),
    );
  }
}
