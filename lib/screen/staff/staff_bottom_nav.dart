import 'package:app_restaurant/config/space.dart';
import 'package:app_restaurant/screen/staff/brought_receipt.dart';
import 'package:app_restaurant/screen/staff/home.dart';
import 'package:app_restaurant/screen/staff/list_bill.dart';
import 'package:app_restaurant/screen/staff/list_food.dart';
import 'package:app_restaurant/screen/staff/user_infor.dart';
import 'package:app_restaurant/widgets/button/button_gradient.dart';
import 'package:app_restaurant/widgets/item_drawer.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class StaffFabTab extends StatefulWidget {
  StaffFabTab({required this.selectedIndex});
  int selectedIndex = 2;
  @override
  State<StaffFabTab> createState() => _StaffFabTabState();
}

class _StaffFabTabState extends State<StaffFabTab> {
  int currentIndex = 2;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  // final List<Widget> pages = [
  //   HomeScreen(),
  //   TeamScreen(),
  //   ProfileScreen(),
  //   MoreScreen(),
  // ];
  final List<Widget> pages = [
    const ListFoodStaff(),
    const StaffBroughtReceipt(),
    StaffBookingTable(),
    const StaffListBill(),
    const StaffUserInformation()
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  @override
  Widget build(BuildContext context) {
    Widget currentScreen = currentIndex == 0
        ? const ListFoodStaff()
        : currentIndex == 1
            ? const StaffBroughtReceipt()
            : currentIndex == 2
                ? StaffBookingTable()
                : currentIndex == 3
                    ? const StaffListBill()
                    : const StaffUserInformation();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Container(
          // width: 100.w,
          height: 50.w,
          child: Image.asset(
            "assets/images/logo-thv.png",
            fit: BoxFit.cover,
          ),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(35.w))),
        leading: InkWell(
          onTap: () {},
          child: Builder(
            builder: (context) => // Ensure Scaffold is in context
                IconButton(
                    icon: Icon(
                      Icons.menu,
                      size: 25.w,
                    ),
                    onPressed: () => Scaffold.of(context).openDrawer()),
          ),
        ),
        actions: [
          InkWell(
            onTap: () {},
            child: Padding(
              padding: EdgeInsets.all(8.w),
              child: Icon(
                Icons.notifications,
                size: 25.w,
                color: Colors.white,
              ),
            ),
          )
        ],
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(20.w),
            child: Container(
              child: Padding(padding: EdgeInsets.only(left: 30, bottom: 20)),
            )),
      ),
      drawer: Drawer(
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
                InkWell(
                  onTap: () {
                    setState(() {
                      currentScreen = StaffBookingTable();
                      currentIndex = 2;
                    });
                    Navigator.pop(context);
                  },
                  child: ItemDrawer(
                    isExpand: false,
                    text: "Trang chủ",
                    iconColor: currentIndex == 2 ? Colors.white : Colors.black,
                    backgroundIconColor: currentIndex == 2
                        ? Colors.blue
                        : Color.fromRGBO(233, 236, 239, 1),
                    icon: Icons.home,
                    subItem: [],
                  ),
                ),
                SizedBox(
                  height: 25.h,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      currentScreen = ListFoodStaff();
                      currentIndex = 0;
                    });
                    Navigator.pop(context);
                  },
                  child: ItemDrawer(
                      isExpand: false,
                      text: 'Danh sách món ăn',
                      iconColor:
                          currentIndex == 0 ? Colors.white : Colors.black,
                      backgroundIconColor: currentIndex == 0
                          ? Colors.blue
                          : Color.fromRGBO(233, 236, 239, 1),
                      subItem: [],
                      icon: Icons.dinner_dining),
                ),
                SizedBox(
                  height: 25.h,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      currentScreen = StaffBroughtReceipt();
                      currentIndex = 1;
                    });
                    Navigator.pop(context);
                  },
                  child: ItemDrawer(
                      isExpand: false,
                      text: 'Hóa đơn mang về',
                      iconColor:
                          currentIndex == 1 ? Colors.white : Colors.black,
                      backgroundIconColor: currentIndex == 1
                          ? Colors.blue
                          : Color.fromRGBO(233, 236, 239, 1),
                      subItem: [],
                      icon: Icons.receipt),
                ),
                SizedBox(
                  height: 25.h,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      currentScreen = StaffListBill();
                      currentIndex = 3;
                    });
                    Navigator.pop(context);
                  },
                  child: ItemDrawer(
                      isExpand: false,
                      text: 'Danh sách hóa đơn',
                      subItem: [],
                      iconColor:
                          currentIndex == 3 ? Colors.white : Colors.black,
                      backgroundIconColor: currentIndex == 3
                          ? Colors.blue
                          : Color.fromRGBO(233, 236, 239, 1),
                      icon: Icons.shopping_bag),
                ),
                SizedBox(
                  height: 25.h,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      currentScreen = StaffUserInformation();
                      currentIndex = 4;
                    });
                    Navigator.pop(context);
                  },
                  child: ItemDrawer(
                      isExpand: false,
                      text: 'Thông tin cá nhân',
                      iconColor:
                          currentIndex == 4 ? Colors.white : Colors.black,
                      backgroundIconColor: currentIndex == 4
                          ? Colors.blue
                          : Color.fromRGBO(233, 236, 239, 1),
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
                              context.go("/staff_sign_in");
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
      ),
      body: PageStorage(
        bucket: bucket,
        child: currentScreen,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            currentScreen = StaffBookingTable();
            currentIndex = 2;
          });
        },
        child: Icon(Icons.home),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue,
        shape: CircularNotchedRectangle(),
        child: Container(
            height: 60.h,
            child: Padding(
              padding: EdgeInsets.only(
                  top: 10.w, left: 20.w, right: 20.w, bottom: 0.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //Left
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MaterialButton(
                        minWidth: 40,
                        onPressed: () {
                          setState(() {
                            currentScreen = ListFoodStaff();
                            currentIndex = 0;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.restaurant,
                              size: 30,
                              color: currentIndex == 0
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            Text(
                              "",
                            )
                          ],
                        ),
                      ),
                      space20W,
                      MaterialButton(
                        minWidth: 40,
                        onPressed: () {
                          setState(() {
                            currentScreen = StaffBroughtReceipt();
                            currentIndex = 1;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.delivery_dining,
                              size: 32,
                              color: currentIndex == 1
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            Text(
                              "",
                            )
                          ],
                        ),
                      )
                    ],
                  ),

                  //Right

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MaterialButton(
                        minWidth: 40,
                        onPressed: () {
                          setState(() {
                            currentScreen = StaffListBill();
                            currentIndex = 3;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.receipt,
                              size: 32,
                              color: currentIndex == 3
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            Text(
                              "",
                            )
                          ],
                        ),
                      ),
                      space20W,
                      MaterialButton(
                        minWidth: 40,
                        onPressed: () {
                          setState(() {
                            currentScreen = StaffUserInformation();
                            currentIndex = 4;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.person,
                              size: 32,
                              color: currentIndex == 4
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            Text(
                              "",
                            )
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            )),
      ),
    );
  }
}
