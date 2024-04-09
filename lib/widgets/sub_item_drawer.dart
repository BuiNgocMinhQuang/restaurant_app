import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SubItemDrawer extends StatelessWidget {
  void Function() event;
  Color textColor;
  Color iconColor;
  double fontSize;
  double iconSize;
  FontWeight fontWeight;
  final String text;
  SubItemDrawer({
    Key? key,
    required this.text,
    required this.event,
    this.fontWeight = FontWeight.normal,
    this.iconSize = 0,
    this.iconColor = Colors.black,
    this.fontSize = 0,
    this.textColor = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        event();
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 25.w,
            height: 25.h,
          ),
          Icon(
            Icons.circle,
            size: iconSize == 0 ? 10.w : iconSize,
            color: iconColor,
          ),
          SizedBox(
            width: 10.w,
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: fontSize == 0 ? 14.w : fontSize,
              color: textColor,
              fontWeight: fontWeight,
            ),
          ),
        ],
      ),
    );
  }
}
