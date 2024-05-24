import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class TextApp extends StatelessWidget {
  final String text;
  final String fontFamily;
  double fontsize;
  Color color;
  Color colorDecoration;
  TextDecoration textDecoration;
  FontWeight fontWeight;
  TextAlign textAlign;
  bool softWrap;
  bool isOverFlow;
  bool isUnderLine;
  TextApp(
      {Key? key,
      required this.text,
      this.colorDecoration = Colors.black,
      this.textDecoration = TextDecoration.underline,
      this.textAlign = TextAlign.left,
      this.fontsize = 0,
      this.color = Colors.black,
      this.fontFamily = "OpenSans",
      this.softWrap = false,
      this.isOverFlow = true,
      this.isUnderLine = false,
      this.fontWeight = FontWeight.normal})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      softWrap: softWrap,
      text,
      overflow: isOverFlow ? TextOverflow.ellipsis : null,
      textAlign: textAlign,
      style: isUnderLine
          ? TextStyle(
              fontSize: fontsize == 0 ? 12.sp : fontsize,
              color: color,
              fontFamily: fontFamily,
              fontWeight: fontWeight,
              decoration: textDecoration,
              decorationColor: colorDecoration)
          : TextStyle(
              fontSize: fontsize == 0 ? 12.sp : fontsize,
              color: color,
              fontFamily: fontFamily,
              fontWeight: fontWeight,
            ),
    );
  }
}
