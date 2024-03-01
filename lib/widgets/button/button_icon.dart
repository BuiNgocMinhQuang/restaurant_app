import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ButtonIcon extends StatelessWidget {
  void Function() event;
  Color color1;
  Color color2;
  Color iconColor;
  double height;
  double sizeButton;
  double sizeIcon;
  double radius;
  bool isHaveIcon;
  bool isIconCircle;
  IconData icon;

  ButtonIcon(
      {Key? key,
      required this.color1,
      required this.color2,
      required this.event,
      required this.icon,
      this.isIconCircle = true,
      this.iconColor = Colors.white,
      this.sizeButton = 0,
      this.radius = 0,
      this.height = 0,
      this.isHaveIcon = false,
      this.sizeIcon = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        event();
      },
      child: isIconCircle
          ? Container(
              width: sizeButton == 0 ? 50.w : sizeButton,
              height: sizeButton == 0 ? 50.w : sizeButton,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                      Radius.circular(radius == 0 ? 25.w : radius)),
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [color1, color2])),
              child: Center(
                child: SizedBox(
                  width: sizeIcon == 0 ? 25.w : sizeIcon,
                  height: sizeIcon == 0 ? 25.w : sizeIcon,
                  child: Icon(
                    icon,
                    color: iconColor,
                  ),
                ),
              ),
            )
          : Container(
              width: sizeButton == 0 ? 50.w : sizeButton,
              height: sizeButton == 0 ? 50.w : sizeButton,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                      Radius.circular(radius == 0 ? 5.w : radius)),
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [color1, color2])),
              child: Center(
                child: SizedBox(
                  width: sizeIcon == 0 ? 25.w : sizeIcon,
                  height: sizeIcon == 0 ? 25.w : sizeIcon,
                  child: Icon(
                    icon,
                    color: iconColor,
                  ),
                ),
              ),
            ),
    );
  }
}
