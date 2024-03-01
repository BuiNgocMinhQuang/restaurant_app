import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/config/space.dart';
import 'package:app_restaurant/screen/manager/add_food.dart';
import 'package:app_restaurant/screen/manager/add_staff.dart';
import 'package:app_restaurant/screen/manager/booking_table.dart';
import 'package:app_restaurant/screen/manager/brought_receipt.dart';
import 'package:app_restaurant/screen/manager/home.dart';
import 'package:app_restaurant/screen/manager/list_bill.dart';
import 'package:app_restaurant/screen/manager/list_food.dart';
import 'package:app_restaurant/screen/manager/list_staff.dart';
import 'package:app_restaurant/screen/manager/list_stores.dart';
import 'package:app_restaurant/screen/manager/manager_infor.dart';
import 'package:app_restaurant/screen/manager/notifications.dart';
import 'package:app_restaurant/widgets/button/button_gradient.dart';
import 'package:app_restaurant/widgets/item_drawer.dart';
import 'package:app_restaurant/widgets/sub_item_drawer.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ManagerFabTab extends StatefulWidget {
  ManagerFabTab({Key? key, required this.selectedIndex}) : super(key: key);
  int selectedIndex = 8;
  @override
  State<ManagerFabTab> createState() => _ManagerFabTabState();
}

class _ManagerFabTabState extends State<ManagerFabTab> {
  int currentIndex = 8;
  bool isHaveNoti = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final List<Widget> pages = const [
    ListStores(), //index = 1
    ListStaff(), //index = 2
    AddStaff(), //index = 3
    ManagerHome(), //index = 0
    ListFoodManager(), //index = 4
    ManagerInformation(), //index = 5
    ManagerBookingTable(), //index = 6
    ManagerListBill(), //index = 7
    ManagerBroughtReceipt(), //index = 8
    ManagerAddFood(), //index 9
  ];
  final ScrollController _scrollController = ScrollController();

  final PageStorageBucket bucket = PageStorageBucket();
  @override
  Widget build(BuildContext context) {
    Widget currentScreen = currentIndex == 0
        ? const ManagerHome()
        : currentIndex == 1
            ? const ListStores()
            : currentIndex == 2
                ? const ListStaff()
                : currentIndex == 3
                    ? const AddStaff()
                    : currentIndex == 4
                        ? const ListFoodManager()
                        : currentIndex == 5
                            ? const ManagerInformation()
                            : currentIndex == 6
                                ? const ManagerBookingTable()
                                : currentIndex == 7
                                    ? const ManagerListBill()
                                    : currentIndex == 8
                                        ? const ManagerBroughtReceipt()
                                        : const ManagerAddFood();

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
                      size: 35.w,
                    ),
                    onPressed: () => Scaffold.of(context).openDrawer()),
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ManagerNotifications()),
              );
            },
            child: Padding(
              padding: EdgeInsets.all(8.w),
              child: isHaveNoti
                  ? Stack(
                      children: [
                        Icon(
                          Icons.notifications,
                          size: 35.w,
                          color: Colors.white,
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red,
                            ),
                            width: 15.w,
                            height: 15.w,
                          ),
                        )
                      ],
                    )
                  : Icon(
                      Icons.notifications,
                      size: 35.w,
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
      body: PageStorage(bucket: bucket, child: currentScreen),
      // body: PageStorage(
      //     bucket: bucket,
      //     child: SafeArea(
      //       child: Stack(
      //         children: [
      //           currentScreen,
      //           Positioned(
      //             left: 10,
      //             top: 20,
      //             child: Builder(
      //               builder: (context) => // Ensure Scaffold is in context
      //                   IconButton(
      //                       icon: Icon(Icons.menu),
      //                       onPressed: () => Scaffold.of(context).openDrawer()),
      //             ),
      //           ),
      //         ],
      //       ),
      //     )),

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
                      currentScreen = const ManagerHome();
                      currentIndex = 0;
                    });
                    Navigator.pop(context);
                  },
                  child: ItemDrawer(
                    isExpand: false,
                    text: "Trang chủ",
                    iconColor: currentIndex == 0 ? Colors.white : Colors.black,
                    backgroundIconColor: currentIndex == 0
                        ? Colors.blue
                        : const Color.fromRGBO(233, 236, 239, 1),
                    icon: Icons.home,
                    subItem: const [],
                  ),
                ),
                TextApp(
                  text: 'Quản lý',
                  color: grey,
                  fontsize: 20,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(
                  height: 25.h,
                ),
                InkWell(
                  onTap: () {},
                  child: ItemDrawer(
                      isExpand: true,
                      // item: DrawerItem.staff,
                      text: 'Cửa hàng',
                      iconColor:
                          currentIndex == 1 ? Colors.white : Colors.black,
                      backgroundIconColor: currentIndex == 1
                          ? Colors.blue
                          : const Color.fromRGBO(233, 236, 239, 1),
                      subItem: [
                        SubItemDrawer(
                            text: "Danh sách cửa hàng",
                            textColor:
                                currentIndex == 1 ? Colors.blue : Colors.black,
                            event: () {
                              setState(() {
                                currentScreen = const ListStores();
                                currentIndex = 1;
                              });
                              Navigator.pop(context);
                            }),
                      ],
                      icon: Icons.store),
                ),
                SizedBox(
                  height: 25.h,
                ),
                InkWell(
                  onTap: () {},
                  child: ItemDrawer(
                      isExpand: true,
                      // item: DrawerItem.staff,
                      text: 'Nhân viên',
                      iconColor: currentIndex == 2 || currentIndex == 3
                          ? Colors.white
                          : Colors.black,
                      backgroundIconColor:
                          currentIndex == 2 || currentIndex == 3
                              ? Colors.blue
                              : const Color.fromRGBO(233, 236, 239, 1),
                      subItem: [
                        SubItemDrawer(
                            text: "Danh sách nhân viên",
                            textColor:
                                currentIndex == 2 ? Colors.blue : Colors.black,
                            event: () {
                              setState(() {
                                currentScreen = const ListStaff();
                                currentIndex = 2;
                              });
                              Navigator.pop(context);
                            }),
                        SizedBox(
                          height: 10.h,
                        ),
                        SubItemDrawer(
                            text: "Thêm nhân viên",
                            textColor:
                                currentIndex == 3 ? Colors.blue : Colors.black,
                            event: () {
                              setState(() {
                                currentScreen = const AddStaff();
                                currentIndex = 3;
                              });
                              Navigator.pop(context);
                            })
                      ],
                      icon: Icons.group),
                ),
                SizedBox(
                  height: 25.h,
                ),
                InkWell(
                  onTap: () {},
                  child: ItemDrawer(
                      isExpand: true,
                      // item: DrawerItem.staff,
                      text: 'Thực đơn',
                      subItem: [
                        SubItemDrawer(
                            text: "Danh sách món ăn",
                            textColor:
                                currentIndex == 4 ? Colors.blue : Colors.black,
                            event: () {
                              setState(() {
                                currentScreen = const ListFoodManager();
                                currentIndex = 4;
                              });
                              Navigator.pop(context);
                            }),
                        SizedBox(
                          height: 10.h,
                        ),
                        SubItemDrawer(
                            text: "Thêm món ăn",
                            textColor:
                                currentIndex == 9 ? Colors.blue : Colors.black,
                            event: () {
                              setState(() {
                                currentScreen = const ManagerAddFood();
                                currentIndex = 9;
                              });
                              Navigator.pop(context);
                            })
                      ],
                      iconColor: currentIndex == 4 || currentIndex == 9
                          ? Colors.white
                          : Colors.black,
                      backgroundIconColor:
                          currentIndex == 4 || currentIndex == 9
                              ? Colors.blue
                              : const Color.fromRGBO(233, 236, 239, 1),
                      icon: Icons.restaurant),
                ),
                SizedBox(
                  height: 25.h,
                ),
                TextApp(
                  text: 'Tất cả cửa hàng',
                  color: grey,
                  fontsize: 20,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(
                  height: 25.h,
                ),
                InkWell(
                  onTap: () {},
                  child: ItemDrawer(
                      isExpand: true,
                      // item: DrawerItem.staff,
                      text: 'Cửa hàng 1',
                      iconColor: currentIndex == 6 ||
                              currentIndex == 7 ||
                              currentIndex == 8
                          ? Colors.white
                          : Colors.black,
                      backgroundIconColor: currentIndex == 6 ||
                              currentIndex == 7 ||
                              currentIndex == 8
                          ? Colors.blue
                          : const Color.fromRGBO(233, 236, 239, 1),
                      subItem: [
                        SubItemDrawer(
                            text: "Đặt bàn",
                            textColor:
                                currentIndex == 6 ? Colors.blue : Colors.black,
                            event: () {
                              setState(() {
                                currentScreen = const ManagerBookingTable();
                                currentIndex = 6;
                              });
                              Navigator.pop(context);
                            }),
                        SizedBox(
                          height: 10.h,
                        ),
                        SubItemDrawer(
                            text: "Danh sách hóa đơn",
                            textColor:
                                currentIndex == 7 ? Colors.blue : Colors.black,
                            event: () {
                              setState(() {
                                currentScreen = const ManagerListBill();
                                currentIndex = 7;
                              });
                              Navigator.pop(context);
                            }),
                        SizedBox(
                          height: 10.h,
                        ),
                        SubItemDrawer(
                            text: "Hóa đơn mang về",
                            textColor:
                                currentIndex == 8 ? Colors.blue : Colors.black,
                            event: () {
                              setState(() {
                                currentScreen = const ManagerBroughtReceipt();
                                currentIndex = 8;
                              });
                              Navigator.pop(context);
                            })
                      ],
                      icon: Icons.person),
                )
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
                            child:
                                const Icon(Icons.power_settings_new_outlined),
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          Center(
                            child: TextApp(
                              text: "Tên chủ cửa hàng",
                              textAlign: TextAlign.center,
                              color: Colors.white,
                            ),
                          ),
                          Center(
                            child: TextApp(
                                text: "chucuahang@gmail.com",
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
                              context.go("/");
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

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            currentScreen = const ManagerHome();
            currentIndex = 0;
          });
        },
        child: const Icon(Icons.home),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue,
        shape: const CircularNotchedRectangle(),
        child: SizedBox(
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
                            currentScreen = const ListStores();
                            currentIndex = 1;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.store,
                              size: 30,
                              color: currentIndex == 1
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            const Text(
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
                            currentScreen = const ListStaff();
                            currentIndex = 2;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.group,
                              size: 32,
                              color: currentIndex == 2 || currentIndex == 3
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            const Text(
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
                            currentScreen = const ListFoodManager();
                            currentIndex = 4;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.restaurant,
                              size: 32,
                              color: currentIndex == 4
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            const Text(
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
                            currentScreen = const ManagerInformation();
                            currentIndex = 5;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.person,
                              size: 32,
                              color: currentIndex == 5
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            const Text(
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
