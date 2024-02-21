import 'package:app_restaurant/provider/drawer_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:app_restaurant/model/drawer_item.dart';
import 'package:provider/provider.dart';

class ItemDrawer extends StatelessWidget {
  Color textColor;
  double fontSize;
  double iconSize;
  IconData icon;
  // DrawerItem item;
  final String text;
  bool isExpand;
  List<Widget> subItem;
  ItemDrawer({
    Key? key,
    required this.text,
    required this.subItem,
    required this.icon,
    // required this.item,
    this.isExpand = true,
    this.iconSize = 0,
    this.fontSize = 0,
    this.textColor = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final provider = Provider.of<DrawerProvider>(context);
    // final currentItem = provider.drawerItem;
    // final isSelectedItem = item == currentItem;

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: isExpand
          ? ExpansionTile(
              leading: Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: Color.fromRGBO(233, 236, 239, 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  size: iconSize == 0 ? 20.w : iconSize,
                  color: Color.fromRGBO(17, 17, 17, 1),
                ),
              ),
              title: Text(text),
              children: subItem)
          : ListTile(
              leading: Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: Color.fromRGBO(233, 236, 239, 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  size: iconSize == 0 ? 20.w : iconSize,
                  color: Color.fromRGBO(17, 17, 17, 1),
                ),
              ),
              title: Text(text),
            ),
    );
  }
}
