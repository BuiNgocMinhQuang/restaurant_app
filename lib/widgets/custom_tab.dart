import 'package:app_restaurant/widgets/text_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTab extends StatelessWidget {
  final String text;
  IconData icon;
  double sizeIcon;
  double fontSize;
  Color colorText;
  CustomTab(
      {Key? key,
      required this.text,
      required this.icon,
      this.colorText = Colors.black,
      this.sizeIcon = 0,
      this.fontSize = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(left: 10.w, right: 10.w, top: 10.w, bottom: 10.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: sizeIcon == 0 ? 20.w : sizeIcon,
          ),
          SizedBox(
            width: 3.w,
          ),
          TextApp(
            text: text,
            fontsize: fontSize == 0 ? 16.sp : fontSize,
            color: colorText,
          )
        ],
      ),
    );
  }
}
