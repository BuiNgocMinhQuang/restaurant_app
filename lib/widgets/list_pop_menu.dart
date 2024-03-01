import 'package:flutter/material.dart';

class PopUpMenuBroughtReceipt extends StatelessWidget {
  Function eventButton1;
  Function eventButton2;
  Function eventButton3;
  Function eventButton4;
  PopUpMenuBroughtReceipt({
    Key? key,
    required this.eventButton1,
    required this.eventButton2,
    required this.eventButton3,
    required this.eventButton4,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      // icon: Icon(
      //   Icons.edit,
      //   color: Colors.black,
      // ),

      itemBuilder: (context) => [
        PopupMenuItem(
          onTap: () {
            eventButton1();
          },
          child: Text("Quản lý hoá đơn"),
        ),
        PopupMenuItem(
          onTap: () {
            eventButton2();
          },
          child: Text("Thanh toán hoá đơn"),
        ),
        PopupMenuItem(
          onTap: () {
            eventButton3();
          },
          child: Text("In hoá đơn"),
        ),
        PopupMenuItem(
          onTap: () {
            eventButton4();
          },
          child: Text("Huỷ hoá đơn"),
        )
      ],
    );
  }
}

class PopUpMenuUsingTable extends StatelessWidget {
  Function eventButton1;
  Function eventButton2;
  Function eventButton3;
  Function eventButton4;
  PopUpMenuUsingTable({
    Key? key,
    required this.eventButton1,
    required this.eventButton2,
    required this.eventButton3,
    required this.eventButton4,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: Icon(
        Icons.edit,
        color: Colors.white,
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          onTap: () {
            eventButton1();
          },
          child: Text("Quản lý bàn"),
        ),
        PopupMenuItem(
          onTap: () {
            eventButton2();
          },
          child: Text("Chuyển bàn"),
        ),
        PopupMenuItem(
          onTap: () {
            eventButton3();
          },
          child: Text("Xem hoá đơn"),
        ),
        PopupMenuItem(
          onTap: () {
            eventButton4();
          },
          child: Text("Thanh toán"),
        )
      ],
    );
  }
}
