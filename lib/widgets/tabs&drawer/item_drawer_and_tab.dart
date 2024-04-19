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
  FontWeight fontWeight;
  final String text;
  bool isExpand;
  List<Widget> subItem;
  ItemDrawer(
      {Key? key,
      required this.text,
      required this.subItem,
      this.fontWeight = FontWeight.normal,
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
                style: TextStyle(color: textColor, fontWeight: fontWeight),
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
                style: TextStyle(color: textColor, fontWeight: fontWeight),
              ),
            ),
    );
  }
}

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

class CustomTab extends StatelessWidget {
  final String text;
  IconData icon;
  double sizeIcon;
  double fontSize;
  Color colorText;
  CustomTab({
    Key? key,
    required this.text,
    required this.icon,
    this.colorText = Colors.black,
    this.sizeIcon = 0,
    this.fontSize = 0,
  }) : super(key: key);

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
            Tab(
              text: text,
            )
          ],
        ));
  }
}
