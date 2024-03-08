import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/config/space.dart';
import 'package:app_restaurant/screen/manager/add_food.dart';
import 'package:app_restaurant/screen/manager/add_staff.dart';
import 'package:app_restaurant/screen/manager/booking_table.dart';
import 'package:app_restaurant/screen/manager/brought_receipt.dart';
import 'package:app_restaurant/screen/manager/home.dart';
import 'package:app_restaurant/screen/manager/import_inventory.dart';
import 'package:app_restaurant/screen/manager/list_bill.dart';
import 'package:app_restaurant/screen/manager/list_food.dart';
import 'package:app_restaurant/screen/manager/list_staff.dart';
import 'package:app_restaurant/screen/manager/list_stores.dart';
import 'package:app_restaurant/screen/manager/manage_infor.dart';
import 'package:app_restaurant/screen/manager/list_inventory.dart';
import 'package:app_restaurant/screen/manager/notifications.dart';
import 'package:app_restaurant/widgets/button/button_gradient.dart';
import 'package:app_restaurant/widgets/item_drawer.dart';
import 'package:app_restaurant/widgets/sub_item_drawer.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ManagerFabTab extends StatefulWidget {
  ManagerFabTab({Key? key, required this.selectedIndex}) : super(key: key);
  int selectedIndex = 2;
  @override
  State<ManagerFabTab> createState() => _ManagerFabTabState();
}

class _ManagerFabTabState extends State<ManagerFabTab> {
  int currentIndex = 2;
  bool isHaveNoti = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void tapDrawerChangeBotNav(int index) {
    final CurvedNavigationBarState? navBarState =
        bottomNavigationKey.currentState;
    navBarState!.setPage(index);
  }

  final List<Widget> pages = const [
    ListStores(), //index = 0
    ListStaff(), //index = 1
    ManagerHome(), //index = 2
    ListFoodManager(), //index = 3
    ManagerInformation(), //index = 4
    AddStaff(), //index = 5
    ManagerAddFood(), //index 6
    ManagerBookingTable(), //index = 7
    ManagerListBill(), //index = 8
    ManagerBroughtReceipt(), //index = 9
    ListInventory(), //index 10
    ImportInventory() //11
  ];
  final ScrollController _scrollController = ScrollController();

  final PageStorageBucket bucket = PageStorageBucket();
  GlobalKey<CurvedNavigationBarState> bottomNavigationKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    Widget currentScreen = currentIndex == 0
        ? const ListStores()
        : currentIndex == 1
            ? const ListStaff()
            : currentIndex == 2
                ? const ManagerHome()
                : currentIndex == 3
                    ? const ListFoodManager()
                    : currentIndex == 4
                        ? const ManagerInformation()
                        : currentIndex == 5
                            ? const AddStaff()
                            : currentIndex == 6
                                ? const ManagerAddFood()
                                : currentIndex == 7
                                    ? const ManagerBookingTable()
                                    : currentIndex == 8
                                        ? const ManagerListBill()
                                        : currentIndex == 9
                                            ? const ManagerBroughtReceipt()
                                            : currentIndex == 10
                                                ? const ListInventory()
                                                : const ImportInventory();

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
                      // currentScreen = const ManagerHome();
                      currentIndex = 2;
                      tapDrawerChangeBotNav(2);
                    });
                    Navigator.pop(context);
                  },
                  child: ItemDrawer(
                    isExpand: false,
                    text: "Trang chủ",
                    iconColor: currentIndex == 2 ? Colors.white : Colors.black,
                    backgroundIconColor: currentIndex == 2
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
                      text: 'Cửa hàng',
                      iconColor:
                          currentIndex == 0 ? Colors.white : Colors.black,
                      backgroundIconColor: currentIndex == 0
                          ? Colors.blue
                          : const Color.fromRGBO(233, 236, 239, 1),
                      subItem: [
                        SubItemDrawer(
                            text: "Danh sách cửa hàng",
                            textColor:
                                currentIndex == 0 ? Colors.blue : Colors.black,
                            event: () {
                              setState(() {
                                // currentScreen = const ListStores();
                                currentIndex = 0;

                                tapDrawerChangeBotNav(0);
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
                      text: 'Nhân viên',
                      iconColor: currentIndex == 1 || currentIndex == 1
                          ? Colors.white
                          : Colors.black,
                      backgroundIconColor:
                          currentIndex == 1 || currentIndex == 5
                              ? Colors.blue
                              : const Color.fromRGBO(233, 236, 239, 1),
                      subItem: [
                        SubItemDrawer(
                            text: "Danh sách nhân viên",
                            textColor:
                                currentIndex == 1 ? Colors.blue : Colors.black,
                            event: () {
                              setState(() {
                                // currentScreen = const ListStaff();
                                currentIndex = 1;
                                tapDrawerChangeBotNav(1);
                              });
                              Navigator.pop(context);
                            }),
                        SizedBox(
                          height: 10.h,
                        ),
                        SubItemDrawer(
                            text: "Thêm nhân viên",
                            textColor:
                                currentIndex == 5 ? Colors.blue : Colors.black,
                            event: () {
                              setState(() {
                                currentIndex = 5;
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
                      text: 'Thực đơn',
                      subItem: [
                        SubItemDrawer(
                            text: "Danh sách món ăn",
                            textColor:
                                currentIndex == 3 ? Colors.blue : Colors.black,
                            event: () {
                              setState(() {
                                currentIndex = 3;
                                tapDrawerChangeBotNav(3);
                              });
                              Navigator.pop(context);
                            }),
                        SizedBox(
                          height: 10.h,
                        ),
                        SubItemDrawer(
                            text: "Thêm món ăn",
                            textColor:
                                currentIndex == 6 ? Colors.blue : Colors.black,
                            event: () {
                              setState(() {
                                currentIndex = 6;
                              });
                              Navigator.pop(context);
                            })
                      ],
                      iconColor: currentIndex == 3 || currentIndex == 6
                          ? Colors.white
                          : Colors.black,
                      backgroundIconColor:
                          currentIndex == 3 || currentIndex == 6
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
                      text: 'Cửa hàng 1',
                      iconColor: currentIndex == 7 ||
                              currentIndex == 8 ||
                              currentIndex == 9
                          ? Colors.white
                          : Colors.black,
                      backgroundIconColor: currentIndex == 7 ||
                              currentIndex == 8 ||
                              currentIndex == 9
                          ? Colors.blue
                          : const Color.fromRGBO(233, 236, 239, 1),
                      subItem: [
                        SubItemDrawer(
                            text: "Đặt bàn",
                            textColor:
                                currentIndex == 7 ? Colors.blue : Colors.black,
                            event: () {
                              setState(() {
                                currentIndex = 7;
                              });
                              Navigator.pop(context);
                            }),
                        SizedBox(
                          height: 10.h,
                        ),
                        SubItemDrawer(
                            text: "Danh sách hóa đơn",
                            textColor:
                                currentIndex == 8 ? Colors.blue : Colors.black,
                            event: () {
                              setState(() {
                                currentIndex = 8;
                              });
                              Navigator.pop(context);
                            }),
                        SizedBox(
                          height: 10.h,
                        ),
                        SubItemDrawer(
                            text: "Hóa đơn mang về",
                            textColor:
                                currentIndex == 9 ? Colors.blue : Colors.black,
                            event: () {
                              setState(() {
                                currentIndex = 9;
                              });
                              Navigator.pop(context);
                            }),
                      ],
                      icon: Icons.person),
                ),
                SizedBox(
                  height: 25.h,
                ),
                TextApp(
                  text: 'Kho hàng',
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
                      text: 'Cửa hàng 1',
                      iconColor: currentIndex == 10 || currentIndex == 11
                          ? Colors.white
                          : Colors.black,
                      backgroundIconColor:
                          currentIndex == 10 || currentIndex == 11
                              ? Colors.blue
                              : const Color.fromRGBO(233, 236, 239, 1),
                      subItem: [
                        SubItemDrawer(
                            text: "Danh sách tồn kho",
                            textColor:
                                currentIndex == 10 ? Colors.blue : Colors.black,
                            event: () {
                              setState(() {
                                currentIndex = 10;
                              });
                              Navigator.pop(context);
                            }),
                        SizedBox(
                          height: 10.h,
                        ),
                        SubItemDrawer(
                            text: "Nhập kho",
                            textColor:
                                currentIndex == 11 ? Colors.blue : Colors.black,
                            event: () {
                              setState(() {
                                currentIndex = 11;
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
      bottomNavigationBar: CurvedNavigationBar(
        index: 2,
        key: bottomNavigationKey,
        // height: 150.h,
        color: Colors.blue,
        backgroundColor: Colors.transparent,
        items: <Widget>[
          Icon(
            Icons.store,
            size: 30.h,
            color: currentIndex == 0 ? Colors.white : Colors.black,
          ),
          Icon(Icons.group,
              size: 30.h,
              color: currentIndex == 1 ? Colors.white : Colors.black),
          Icon(Icons.home,
              size: 30.h,
              color: currentIndex == 2 ? Colors.white : Colors.black),
          Icon(Icons.restaurant,
              size: 30.h,
              color: currentIndex == 3 ? Colors.white : Colors.black),
          Icon(Icons.person,
              size: 30.h,
              color: currentIndex == 4 ? Colors.white : Colors.black),
        ],
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        letIndexChange: (index) => true,
      ),
    );
  }
}
