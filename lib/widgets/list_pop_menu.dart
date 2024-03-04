import 'package:flutter/material.dart';

class PopUpMenuBroughtReceipt extends StatelessWidget {
  final Function eventButton1;
  final Function eventButton2;
  final Function eventButton3;
  final Function eventButton4;
  const PopUpMenuBroughtReceipt({
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
          child: const Text("Quản lý hoá đơn"),
        ),
        PopupMenuItem(
          onTap: () {
            eventButton2();
          },
          child: const Text("Thanh toán hoá đơn"),
        ),
        PopupMenuItem(
          onTap: () {
            eventButton3();
          },
          child: const Text("In hoá đơn"),
        ),
        PopupMenuItem(
          onTap: () {
            eventButton4();
          },
          child: const Text("Huỷ hoá đơn"),
        )
      ],
    );
  }
}

class PopUpMenuUsingTable extends StatelessWidget {
  final Function eventButton1;
  final Function eventButton2;
  final Function eventButton3;
  final Function eventButton4;
  const PopUpMenuUsingTable({
    Key? key,
    required this.eventButton1,
    required this.eventButton2,
    required this.eventButton3,
    required this.eventButton4,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: const Icon(
        Icons.edit,
        color: Colors.white,
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          onTap: () {
            eventButton1();
          },
          child: const Text("Quản lý bàn"),
        ),
        PopupMenuItem(
          onTap: () {
            eventButton2();
          },
          child: const Text("Chuyển bàn"),
        ),
        PopupMenuItem(
          onTap: () {
            eventButton3();
          },
          child: const Text("Xem hoá đơn"),
        ),
        PopupMenuItem(
          onTap: () {
            eventButton4();
          },
          child: const Text("Thanh toán"),
        )
      ],
    );
  }
}

class PopUpMenuPrintBill extends StatelessWidget {
  final Function eventButton1;

  const PopUpMenuPrintBill({
    Key? key,
    required this.eventButton1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: const Icon(
        Icons.more_horiz_outlined,
        color: Colors.black,
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          onTap: () {
            eventButton1();
          },
          child: const Text("In hoá đơn"),
        ),
      ],
    );
  }
}

class PopUpMenuManageRoom extends StatelessWidget {
  final Function eventButton1;
  final Function eventButton2;
  final Function eventButton3;
  const PopUpMenuManageRoom({
    Key? key,
    required this.eventButton1,
    required this.eventButton2,
    required this.eventButton3,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: const Icon(
        Icons.more_horiz_outlined,
        color: Colors.black,
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          onTap: () {
            eventButton1();
          },
          child: const Text("Chỉnh sửa phòng"),
        ),
        PopupMenuItem(
          onTap: () {
            eventButton2();
          },
          child: const Text("Quản lí bàn"),
        ),
        PopupMenuItem(
          onTap: () {
            eventButton3();
          },
          child: const Text("Xoá phòng"),
        ),
      ],
    );
  }
}

class PopUpEditTable extends StatelessWidget {
  final Function eventButton1;
  final Function eventButton2;

  const PopUpEditTable({
    Key? key,
    required this.eventButton1,
    required this.eventButton2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: const Icon(
        Icons.more_vert_outlined,
        color: Colors.black,
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          onTap: () {
            eventButton1();
          },
          child: const Text("Cập nhật"),
        ),
        PopupMenuItem(
          onTap: () {
            eventButton2();
          },
          child: const Text("Xoá"),
        ),
      ],
    );
  }
}
