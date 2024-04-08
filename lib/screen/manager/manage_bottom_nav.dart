import 'dart:convert';
import 'dart:developer';

import 'package:app_restaurant/bloc/manager/manager_login/manager_login_bloc.dart';
import 'package:app_restaurant/bloc/manager/room/list_room_bloc.dart';
import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/config/void_show_dialog.dart';
import 'package:app_restaurant/model/manager/manager_list_store_model.dart';
import 'package:app_restaurant/routers/app_router_config.dart';
import 'package:app_restaurant/screen/manager/food_menu/add_food.dart';
import 'package:app_restaurant/screen/manager/staff/add_staff.dart';
import 'package:app_restaurant/screen/manager/store/booking_table.dart';
import 'package:app_restaurant/screen/manager/store/brought_receipt.dart';
import 'package:app_restaurant/screen/manager/home.dart';
import 'package:app_restaurant/screen/manager/inventory/import_inventory.dart';
import 'package:app_restaurant/screen/manager/store/list_bill.dart';
import 'package:app_restaurant/screen/manager/food_menu/list_food.dart';
import 'package:app_restaurant/screen/manager/staff/list_staff.dart';
import 'package:app_restaurant/screen/manager/store/list_stores.dart';
import 'package:app_restaurant/screen/manager/user_infor/manage_infor.dart';
import 'package:app_restaurant/screen/manager/inventory/list_inventory.dart';
import 'package:app_restaurant/screen/manager/user_infor/notifications.dart';
import 'package:app_restaurant/utils/storage.dart';
import 'package:app_restaurant/widgets/button/button_gradient.dart';
import 'package:app_restaurant/widgets/item_drawer.dart';
import 'package:app_restaurant/widgets/sub_item_drawer.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:app_restaurant/env/index.dart';
import 'package:app_restaurant/constant/api/index.dart';

class ManagerFabTab extends StatefulWidget {
  ManagerFabTab({Key? key, required this.selectedIndex}) : super(key: key);
  int selectedIndex = 2;
  @override
  State<ManagerFabTab> createState() => _ManagerFabTabState();
}

class _ManagerFabTabState extends State<ManagerFabTab> {
  int currentIndex = 2;
  bool isHaveNoti = true;
  String shopIDPar = '';
  List<DataListStore> listStoreManagerData = [];
  void tapDrawerChangeBotNav(int index) {
    checkTokenExpires();
    final CurvedNavigationBarState? navBarState =
        bottomNavigationKey.currentState;
    navBarState!.setPage(index);
  }

  void hanldeLogOut() async {
    BlocProvider.of<ManagerLoginBloc>(context).add(const ManagerLogout());
    StorageUtils.instance.removeKey(key: 'token_manager');
    context.go("/");
  }

  void checkTokenExpires() async {
    var tokenExpiresTime =
        StorageUtils.instance.getString(key: 'token_manager_expires');
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
        showLoginSessionExpiredDialog(
            context: context,
            okEvent: () {
              hanldeLogOut();
            });
      } else {
        print("Giu phien dang nhap");
      }
    } else {
      print("Dang nhap hoai luon");
    }
  }

  void getListStore() async {
    var token = StorageUtils.instance.getString(key: 'token_manager');
    final responseListStore = await http.post(
      Uri.parse('$baseUrl$managerGetListStores'),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    final dataListStore = jsonDecode(responseListStore.body);
    print("DATA LIST STORES $dataListStore");

    try {
      if (dataListStore['status'] == 200) {
        setState(() {
          var listStoreManagerDataRes = ListStoreModel.fromJson(dataListStore);
          listStoreManagerData.addAll(listStoreManagerDataRes.data);
        });
      } else {
        print("ERRRO GET LIST STORE 111111");
      }
    } catch (error) {
      print("ERRRO GET LIST STORE $error");
    }
  }

  var tokenManager =
      StorageUtils.instance.getString(key: 'token_manager') ?? '';
  void getDataTabIndex({required String roomId, required String shopID}) async {
    await Future.delayed(const Duration(seconds: 0));
    BlocProvider.of<ListRoomBloc>(context).add(
      GetListRoom(
          token: tokenManager,
          client: "user",
          shopId: shopID,
          isApi: true,
          roomId: roomId),
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      checkTokenExpires();
      getListStore();
    });
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   WidgetsBinding.instance.addPostFrameCallback((_) => () {
    //         checkTokenExpires();
    //         getListStore();
    //       });
    // });
  }

  // final List<Widget> pages = const [
  //   ListStores(), //index = 0
  //   ListStaff(), //index = 1
  //   ManagerHome(), //index = 2
  //   ListFoodManager(), //index = 3
  //   ManagerInformation(), //index = 4
  //   AddStaff(), //index = 5
  //   ManagerAddFood(), //index 6
  //   ManagerBookingTable(), //index = 7
  //   ManagerListBill(), //index = 8
  //   ManagerBroughtReceipt(), //index = 9
  //   ListInventory(), //index 10
  //   ImportInventory() //11
  // ];

  final PageStorageBucket bucket = PageStorageBucket();
  GlobalKey<CurvedNavigationBarState> bottomNavigationKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    log(listStoreManagerData.length.toString());
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
                                    ? ManagerBookingTable(
                                        shopID: shopIDPar,
                                      )
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
                      color: Colors.white,
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
                    checkTokenExpires();
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
                              checkTokenExpires();

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
                      iconColor: currentIndex == 1 || currentIndex == 5
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
                              checkTokenExpires();

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
                              checkTokenExpires();

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
                              log("PRESSS");
                              setState(() {
                                checkTokenExpires();

                                currentIndex = 3;
                                tapDrawerChangeBotNav(3);
                              });
                              // checkTokenExpires();

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
                              checkTokenExpires();

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
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: listStoreManagerData.length,
                    itemBuilder: (context, index) {
                      var imagePath1 =
                          (listStoreManagerData[index].storeImages ?? '')
                              .replaceAll('["', '');
                      var imagePath2 = imagePath1.replaceAll('"]', '');
                      return InkWell(
                        onTap: () {},
                        child: ItemDrawer(
                          image: CachedNetworkImage(
                            fit: BoxFit.fill,
                            imageUrl: httpImage + imagePath2,
                            placeholder: (context, url) => SizedBox(
                              height: 10.w,
                              width: 10.w,
                              child: const Center(
                                  child: CircularProgressIndicator()),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                          isShowIcon: false,
                          isExpand: true,
                          text: listStoreManagerData[index].storeName,
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
                                textColor: currentIndex == 7
                                    ? Colors.blue
                                    : Colors.black,
                                event: () {
                                  setState(() {
                                    log("VAOOOO");

                                    shopIDPar = listStoreManagerData[index]
                                        .shopId
                                        .toString();
                                    getDataTabIndex(
                                        roomId: "", shopID: shopIDPar);
                                    currentIndex = 7;
                                  });
                                  checkTokenExpires();

                                  // context.go("/manager_booking_table");
                                  Navigator.pop(context);
                                }),
                            SizedBox(
                              height: 10.h,
                            ),
                            SubItemDrawer(
                                text: "Danh sách hóa đơn",
                                textColor: currentIndex == 8
                                    ? Colors.blue
                                    : Colors.black,
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
                                textColor: currentIndex == 9
                                    ? Colors.blue
                                    : Colors.black,
                                event: () {
                                  setState(() {
                                    currentIndex = 9;
                                  });
                                  checkTokenExpires();

                                  Navigator.pop(context);
                                }),
                          ],
                        ),
                      );
                    }),
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
                              checkTokenExpires();

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
                              checkTokenExpires();

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
                              hanldeLogOut();
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
            checkTokenExpires();
          });
        },
        letIndexChange: (index) => true,
      ),
    );
  }
}
