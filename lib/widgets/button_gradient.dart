import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ButtonGradient extends StatelessWidget {
  void Function() event;
  Color color1;
  Color color2;
  Color textColor;
  double fontSize;
  double height;
  bool isUpperCase;
  double radius;
  final String text;
  ButtonGradient(
      {Key? key,
      required this.color1,
      required this.color2,
      required this.event,
      required this.text,
      this.textColor = Colors.black,
      this.radius = 0,
      this.fontSize = 0,
      this.isUpperCase = true,
      this.height = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        event();
      },
      child: Container(
        height: height == 0 ? 45.h : height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius == 0 ? 20.r : radius),
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [color1, color2],
            )),
        child: Center(
          child: Text(
            isUpperCase ? text.toUpperCase() : text,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: textColor,
                fontFamily: "Icomoon",
                fontWeight: FontWeight.bold,
                fontSize: fontSize == 0 ? 12.sp : fontSize),
          ),
        ),
      ),
    );
  }
}
