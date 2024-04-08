import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ItemDrawer extends StatelessWidget {
  Color textColor;
  Color backgroundIconColor;
  Color iconColor;
  double fontSize;
  double iconSize;
  IconData? icon;
  bool isShowIcon;
  Widget? image;

  final String text;
  bool isExpand;
  List<Widget> subItem;
  ItemDrawer(
      {Key? key,
      required this.text,
      required this.subItem,
      this.image,
      this.icon,
      this.isShowIcon = true,
      this.isExpand = true,
      this.iconSize = 0,
      this.fontSize = 0,
      this.textColor = Colors.black,
      this.backgroundIconColor = const Color.fromRGBO(233, 236, 239, 1),
      this.iconColor = Colors.black})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: isExpand
          ? ExpansionTile(
              leading: Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: backgroundIconColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: isShowIcon
                    ? Icon(
                        icon,
                        size: iconSize == 0 ? 20.w : iconSize,
                        color: iconColor,
                      )
                    : Container(
                        width: 20.w,
                        height: 20.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          color: backgroundIconColor,
                          boxShadow: [
                            BoxShadow(
                              color: backgroundIconColor,
                              spreadRadius: 3,
                              blurRadius: 5,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.r),
                          child: image,
                        ),
                      ),
              ),
              title: Text(
                text,
                style: TextStyle(color: textColor),
              ),
              children: subItem)
          : ListTile(
              leading: Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  // color: Color.fromRGBO(233, 236, 239, 1),
                  color: backgroundIconColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: isShowIcon
                    ? Icon(
                        icon,
                        size: iconSize == 0 ? 20.w : iconSize,
                        color: iconColor,
                      )
                    : image,
              ),
              title: Text(
                text,
                style: TextStyle(color: textColor),
              ),
            ),
    );
  }
}
