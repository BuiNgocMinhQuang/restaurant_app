import 'package:app_restaurant/bloc/login/login_bloc.dart';
import 'package:app_restaurant/config/space.dart';
import 'package:app_restaurant/config/void_show_dialog.dart';
import 'package:app_restaurant/screen/staff/receipt/brought_receipt.dart';
import 'package:app_restaurant/screen/staff/home.dart';
import 'package:app_restaurant/screen/staff/receipt/list_bill.dart';
import 'package:app_restaurant/screen/staff/food_menu/list_food.dart';
import 'package:app_restaurant/screen/staff/user_infor/user_infor.dart';
import 'package:app_restaurant/utils/storage.dart';
import 'package:app_restaurant/widgets/button/button_gradient.dart';
import 'package:app_restaurant/widgets/item_drawer.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    checkTokenExpires();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void showTokenExpiredDialog() {
    BlocProvider.of<LoginBloc>(context).add(const LogoutStaff());
    StorageUtils.instance.removeKey(key: 'auth_staff');
    StorageUtils.instance.removeKey(key: 'staff_infor_data');
    context.go("/staff_sign_in");
  }

  void checkTokenExpires() {
    var tokenExpiresTime =
        StorageUtils.instance.getString(key: 'token_expires');
    if (tokenExpiresTime != '') {
      DateTime now = DateTime.now().toUtc();
      print("TIME NOW $now");

      var tokenExpires = DateTime.parse(tokenExpiresTime!);
      print("TIME TOKEN $tokenExpires");
      if (now.year >= tokenExpires.year &&
          now.month >= tokenExpires.month &&
          now.day >= tokenExpires.day &&
          now.hour >= tokenExpires.hour &&
          now.minute >= tokenExpires.minute &&
          now.second >= tokenExpires.second) {
        print("Het han token");
        showLoginSessionExpiredDialog(context, showTokenExpiredDialog);
      } else {
        print("Giu phien dang nhap");
      }
    } else {
      print("Dang nhap hoai luon");
    }
  }

  void tapDrawerChangeBotNav(int index) {
    print("NHAN DRAWER TAB");
    checkTokenExpires();
    final CurvedNavigationBarState? navBarState =
        bottomNavigationKey.currentState;
    navBarState!.setPage(index);
  }

  final List<Widget> pages = [
    const ListFoodStaff(), //index 0
    const StaffBroughtReceipt(), //index 1
    const StaffBookingTable(), //index 2
    const StaffListBill(), //index 3
    const StaffUserInformation() //index 4
  ];
  GlobalKey<CurvedNavigationBarState> bottomNavigationKey = GlobalKey();

  final PageStorageBucket bucket = PageStorageBucket();
  @override
  Widget build(BuildContext context) {
    Widget currentScreen = currentIndex == 0
        ? const ListFoodStaff()
        : currentIndex == 1
            ? const StaffBroughtReceipt()
            : currentIndex == 2
                ? const StaffBookingTable()
                : currentIndex == 3
                    ? const StaffListBill()
                    : const StaffUserInformation();

    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            centerTitle: true,
            title: SizedBox(
              // width: 100.w,
              height: 50.w,
              child: Image.asset(
                "assets/images/logo-thv.png",
                fit: BoxFit.cover,
              ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(35.w))),
            leading: InkWell(
              onTap: () {},
              child: Builder(
                builder: (context) => // Ensure Scaffold is in context
                    IconButton(
                        icon: Icon(
                          Icons.menu,
                          size: 25.w,
                          color: Colors.white,
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
                  child:
                      Padding(padding: EdgeInsets.only(left: 30, bottom: 10.w)),
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
                          currentIndex = 2;
                          tapDrawerChangeBotNav(2);
                        });
                        Navigator.pop(context);
                      },
                      child: ItemDrawer(
                        isExpand: false,
                        text: "Trang chủ",
                        iconColor:
                            currentIndex == 2 ? Colors.white : Colors.black,
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
                          currentIndex = 0;
                          tapDrawerChangeBotNav(0);
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
                          currentIndex = 1;
                          tapDrawerChangeBotNav(1);
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
                          currentIndex = 3;
                          tapDrawerChangeBotNav(3);
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
                          currentIndex = 4;
                          tapDrawerChangeBotNav(4);
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
                                  showTokenExpiredDialog();
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
          bottomNavigationBar: CurvedNavigationBar(
            index: 2,
            key: bottomNavigationKey,
            // height: 150.h,
            color: Colors.blue,
            backgroundColor: Colors.transparent,
            items: <Widget>[
              Icon(
                Icons.restaurant,
                size: 30.h,
                color: currentIndex == 0 ? Colors.white : Colors.black,
              ),
              Icon(Icons.delivery_dining,
                  size: 30.h,
                  color: currentIndex == 1 ? Colors.white : Colors.black),
              Icon(Icons.home,
                  size: 30.h,
                  color: currentIndex == 2 ? Colors.white : Colors.black),
              Icon(Icons.receipt,
                  size: 30.h,
                  color: currentIndex == 3 ? Colors.white : Colors.black),
              Icon(Icons.person,
                  size: 30.h,
                  color: currentIndex == 4 ? Colors.white : Colors.black),
            ],
            onTap: (index) {
              setState(() {
                currentIndex = index;
                checkTokenExpires();
              });
            },
            letIndexChange: (index) => true,
          ),
        );
      },
    );
  }
}
