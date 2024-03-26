import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextApp extends StatelessWidget {
  final String text;
  final String fontFamily;
  double fontsize;
  Color color;
  FontWeight fontWeight;
  TextAlign textAlign;
  bool softWrap;
  bool isOverFlow;
  TextApp(
      {Key? key,
      required this.text,
      this.textAlign = TextAlign.left,
      this.fontsize = 0,
      this.color = Colors.black,
      this.fontFamily = "OpenSans",
      this.softWrap = false,
      this.isOverFlow = true,
      this.fontWeight = FontWeight.normal})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      softWrap: softWrap,
      text,
      overflow: isOverFlow ? TextOverflow.ellipsis : null,
      textAlign: textAlign,
      style: TextStyle(
          fontSize: fontsize == 0 ? 12.sp : fontsize,
          color: color,
          fontFamily: fontFamily,
          fontWeight: fontWeight),
    );
  }
}
