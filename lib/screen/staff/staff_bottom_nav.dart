import 'dart:convert';
import 'dart:developer';

import 'package:app_restaurant/bloc/staff/login/staff_login_bloc.dart';
import 'package:app_restaurant/config/void_show_dialog.dart';
import 'package:app_restaurant/model/staff/staff_infor_model.dart';
import 'package:app_restaurant/screen/manager/user_infor/notifications.dart';
import 'package:app_restaurant/screen/staff/receipt/brought_receipt.dart';
import 'package:app_restaurant/screen/staff/home.dart';
import 'package:app_restaurant/screen/staff/receipt/list_bill.dart';
import 'package:app_restaurant/screen/staff/food_menu/list_food.dart';
import 'package:app_restaurant/screen/staff/user_infor/user_infor.dart';
import 'package:app_restaurant/utils/storage.dart';
import 'package:app_restaurant/widgets/button/button_gradient.dart';
import 'package:app_restaurant/widgets/tabs&drawer/item_drawer_and_tab.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:app_restaurant/env/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:app_restaurant/constant/api/index.dart';

// ignore: must_be_immutable
class StaffFabTab extends StatefulWidget {
  StaffFabTab({super.key, required this.selectedIndex});
  int selectedIndex = 2;
  @override
  State<StaffFabTab> createState() => _StaffFabTabState();
}

class _StaffFabTabState extends State<StaffFabTab> {
  int currentIndex = 2;
  DataStaffInfor? staffInforData;

  @override
  void initState() {
    super.initState();

    checkTokenExpires();
    getInfor();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void handleLogout() async {
    BlocProvider.of<LoginBloc>(context).add(const LogoutStaff());
  }

  void checkTokenExpires() async {
    var tokenExpiresTime =
        StorageUtils.instance.getString(key: 'token_staff_expires');
    if (tokenExpiresTime != '') {
      DateTime now = DateTime.now().toUtc();
      log("TIME NOW $now");

      var tokenExpires = DateTime.parse(tokenExpiresTime!);
      if (now.compareTo(tokenExpires) > 0 || now.compareTo(tokenExpires) == 0) {
        log("het han token");
        // StorageUtils.instance.removeKey(key: 'token_manager');
        // context.go('/');
        mounted
            ? setState(() {
                showLoginSessionExpiredDialog(
                    context: context,
                    okEvent: () {
                      handleLogout();
                    });
              })
            : null;
      } else if (now.compareTo(tokenExpires) < 0) {
        log("Giu phien dang nhap");
      }
    } else {
      log("Dang nhap hoai luon");
    }
  }

  void tapDrawerChangeBotNav(int index) {
    checkTokenExpires();
    final CurvedNavigationBarState? navBarState =
        bottomNavigationKey.currentState;
    navBarState!.setPage(index);
  }

  void getInfor() async {
    try {
      var token = StorageUtils.instance.getString(key: 'token_staff');
      log("TOKEN CURRENT $token");
      final response = await http.post(
        Uri.parse('$baseUrl$userInformationApi'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token"
        },
        // headers: {"Authorization": "Bearer $token"},
      );
      final data = jsonDecode(response.body);
      // var message = data['message'];

      try {
        if (data['status'] == 200) {
          var staffInforDataRes = StaffInfor.fromJson(data);
          setState(() {
            staffInforData = staffInforDataRes.data;
          });

          log("GET INFOR STAFF OK 1");
        } else {
          log("GET INFOR STAFF ERROR 1");
        }
      } catch (error) {
        log("GET INFOR STAFF ERROR 2  $error");
      }
    } catch (error) {
      log("GET INFOR STAFF ERROR 3 $error");
    }
  }

  // final List<Widget> pages = [
  //   const ListFoodStaff(), //index 0
  //   const StaffBroughtReceipt(), //index 1
  //   const StaffBookingTable(), //index 2
  //   const StaffListBill(), //index 3
  //   const StaffUserInformation() //index 4
  // ];
  GlobalKey<CurvedNavigationBarState> bottomNavigationKey = GlobalKey();

  final PageStorageBucket bucket = PageStorageBucket();
  bool isHaveNoti = true;

  @override
  Widget build(BuildContext context) {
    log(staffInforData?.staffPosition.toString() ?? 'dadadad');
    Widget currentScreen = currentIndex == 0
        ? const ListFoodStaff()
        : currentIndex == 1
            ? (staffInforData?.staffPosition.toString() == '5'
                ? const RecipeForChef()
                : const StaffBroughtReceipt())
            : currentIndex == 2
                ? (staffInforData?.staffPosition.toString() == '5'
                    ? const ChefHomeScreen()
                    : const StaffBookingTable())
                : currentIndex == 3
                    ? const StaffListBill()
                    : const StaffUserInformation();

    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            foregroundColor: Colors.white,
            centerTitle: true,
            title: SizedBox(
              // width: 100.w,
              height: 50.w,
              child: Image.asset(
                "assets/images/logo-thv.png",
                fit: BoxFit.cover,
              ),
            ),
            leading: InkWell(
              onTap: () {},
              child: Builder(
                builder: (context) => // Ensure Scaffold is in context
                    IconButton(
                        icon: Icon(
                          Icons.menu,
                          size: 30.w,
                          color: Colors.black,
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
                              SizedBox(
                                width: 30.w,
                                height: 30.w,
                                child: Image.asset(
                                  'assets/images/bell.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.red,
                                  ),
                                  width: 15.w,
                                  height: 15.w,
                                ),
                              )
                            ],
                          )
                        : SizedBox(
                            width: 30.w,
                            height: 30.w,
                            child: Image.asset(
                              'assets/images/bell.png',
                              fit: BoxFit.contain,
                            ),
                          )),
              )
            ],
            bottom: PreferredSize(
                preferredSize: Size.fromHeight(20.w),
                child: SizedBox(
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
                            : const Color.fromRGBO(233, 236, 239, 1),
                        icon: Icons.home,
                        subItem: const [],
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
                              : const Color.fromRGBO(233, 236, 239, 1),
                          subItem: const [],
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
                              : const Color.fromRGBO(233, 236, 239, 1),
                          subItem: const [],
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
                          subItem: const [],
                          iconColor:
                              currentIndex == 3 ? Colors.white : Colors.black,
                          backgroundIconColor: currentIndex == 3
                              ? Colors.blue
                              : const Color.fromRGBO(233, 236, 239, 1),
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
                              : const Color.fromRGBO(233, 236, 239, 1),
                          subItem: const [],
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
                                child: const Icon(
                                    Icons.power_settings_new_outlined),
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
                                  handleLogout();
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
            backgroundColor: Colors.white,
            items: <Widget>[
              Icon(
                Icons.restaurant,
                size: 30.h,
                color: currentIndex == 0 ? Colors.white : Colors.black,
              ),
              Icon(
                  staffInforData?.staffPosition.toString() == '5'
                      ? Icons.book
                      : Icons.delivery_dining,
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
