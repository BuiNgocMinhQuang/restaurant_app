import 'package:flutter/material.dart';

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
      this.radius = 25,
      this.fontSize = 12,
      this.isUpperCase = true,
      this.height = 45})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        event();
      },
      child: Container(
        height: height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
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
                fontSize: fontSize),
          ),
        ),
      ),
    );
  }
}
