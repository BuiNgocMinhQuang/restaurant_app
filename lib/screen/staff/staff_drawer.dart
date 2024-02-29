import 'package:app_restaurant/main.dart';
import 'package:app_restaurant/screen/staff/staff_bottom_nav.dart';
import 'package:app_restaurant/widgets/button/button_gradient.dart';
import 'package:app_restaurant/widgets/item_drawer.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class StaffSileMenu extends StatefulWidget {
  const StaffSileMenu({super.key});

  @override
  State<StaffSileMenu> createState() => _StaffSileMenuState();
}

class _StaffSileMenuState extends State<StaffSileMenu> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 100.w,
                height: 100.w,
                child: Image.asset(
                  "assets/images/logo-thv.png",
                  fit: BoxFit.contain,
                ),
              ),
              const Divider(
                color: Colors.black45,
              ),
              SizedBox(
                height: 10.h,
              ),
              ItemDrawer(
                isExpand: false,
                text: "Trang chủ",
                icon: Icons.home,
                subItem: [],
              ),
              SizedBox(
                height: 25.h,
              ),
              GestureDetector(
                onTap: () {},
                child: ItemDrawer(
                    isExpand: false,
                    // item: DrawerItem.staff,
                    text: 'Danh sách món ăn',
                    subItem: [],
                    icon: Icons.dinner_dining),
              ),
              SizedBox(
                height: 25.h,
              ),
              GestureDetector(
                onTap: () {},
                child: ItemDrawer(
                    isExpand: false,
                    // item: DrawerItem.staff,
                    text: 'Hóa đơn mang về',
                    subItem: [],
                    icon: Icons.receipt),
              ),
              SizedBox(
                height: 25.h,
              ),
              GestureDetector(
                onTap: () {},
                child: ItemDrawer(
                    isExpand: false,
                    // item: DrawerItem.staff,
                    text: 'Danh sách hóa đơn',
                    subItem: [],
                    icon: Icons.shopping_bag),
              ),
              SizedBox(
                height: 25.h,
              ),
              GestureDetector(
                onTap: () {
                  // Navigator.pushReplacement(context,
                  //     MaterialPageRoute(builder: (context) => MyApp()));
                },
                child: ItemDrawer(
                    isExpand: false,
                    // item: DrawerItem.staff,
                    text: 'Thông tin cá nhân',
                    subItem: [],
                    icon: Icons.person),
              ),
            ],
          ),
          SizedBox(
            height: 20.h,
          ),
          Padding(
              padding: EdgeInsets.all(15.w),
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 180.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: const DecorationImage(
                          image: AssetImage("assets/images/curved9.jpg"),
                          fit: BoxFit.fill,
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.all(15.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white),
                          child: Icon(Icons.power_settings_new_outlined),
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        Center(
                          child: TextApp(
                            text: "Ten nhan vien",
                            textAlign: TextAlign.center,
                            color: Colors.white,
                          ),
                        ),
                        Center(
                          child: TextApp(
                              text: "nhanvien@gmail.com",
                              textAlign: TextAlign.center,
                              color: Colors.white),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        ButtonGradient(
                          color1: Colors.white,
                          color2: Colors.white,
                          event: () {
                            // context.go("/staff_sign_in");
                          },
                          text: "Đăng xuất",
                          textColor: Colors.black,
                          radius: 8.w,
                        )
                      ],
                    ),
                  )
                ],
              ))
        ],
      ),
    );
  }
}
