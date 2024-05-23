import 'dart:convert';
import 'dart:developer';
import 'package:app_restaurant/bloc/brought_receipt/brought_receipt_bloc.dart';
import 'package:app_restaurant/bloc/list_bill_shop/list_bill_shop_bloc.dart';
import 'package:app_restaurant/bloc/manager/manager_login/manager_login_bloc.dart';
import 'package:app_restaurant/bloc/manager/room/list_room_bloc.dart';
import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/config/space.dart';
import 'package:app_restaurant/config/void_show_dialog.dart';
import 'package:app_restaurant/model/manager/manager_list_store_model.dart';
import 'package:app_restaurant/model/manager_infor_model.dart';
import 'package:app_restaurant/screen/manager/food_menu/add_food.dart';
import 'package:app_restaurant/screen/manager/staff/add_staff.dart';
import 'package:app_restaurant/screen/manager/store/booking_table.dart';
import 'package:app_restaurant/screen/manager/store/brought_receipt.dart';
import 'package:app_restaurant/screen/manager/home.dart';
import 'package:app_restaurant/screen/manager/store/list_bill.dart';
import 'package:app_restaurant/screen/manager/food_menu/list_food.dart';
import 'package:app_restaurant/screen/manager/staff/list_staff.dart';
import 'package:app_restaurant/screen/manager/store/list_stores.dart';
import 'package:app_restaurant/screen/manager/user_infor/manage_infor.dart';
import 'package:app_restaurant/screen/manager/user_infor/notifications.dart';
import 'package:app_restaurant/utils/storage.dart';
import 'package:app_restaurant/widgets/button/button_gradient.dart';
import 'package:app_restaurant/widgets/tabs&drawer/item_drawer_and_tab.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:app_restaurant/env/index.dart';
import 'package:app_restaurant/constant/api/index.dart';

// ignore: must_be_immutable
class ManagerFabTab extends StatefulWidget {
  ManagerFabTab({Key? key, required this.selectedIndex}) : super(key: key);
  int selectedIndex = 2;
  @override
  State<ManagerFabTab> createState() => _ManagerFabTabState();
}

class _ManagerFabTabState extends State<ManagerFabTab> {
  int currentIndex = 2;
  int? selectedStoreIndex;
  bool isHaveNoti = true;
  String shopIDPar = '';
  List<DataListStore> listStoreManagerData = [];
  List<String> listImageBanner = [];
  DataManagerInfor? managerInforData;
  void tapDrawerChangeBotNav(int index) {
    checkTokenExpires();
    final CurvedNavigationBarState? navBarState =
        bottomNavigationKey.currentState;
    navBarState!.setPage(index);
  }

  void hanldeLogOut() async {
    BlocProvider.of<ManagerLoginBloc>(context).add(const ManagerLogout());
  }

  void checkTokenExpires() async {
    var tokenExpiresTime =
        StorageUtils.instance.getString(key: 'token_manager_expires');
    if (tokenExpiresTime != '') {
      DateTime now = DateTime.now().toUtc();
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
                      hanldeLogOut();
                    });
              })
            : null;
      } else if (now.compareTo(tokenExpires) < 0) {
        log("Giu phien dang nhap");
      }
    } else {
      log("Dang nhap hoai luon");
      // getListStore();
    }
  }

  void handleGetBannerList() async {
    mounted
        ? setState(() {
            listImageBanner.clear();
            listStoreManagerData.where((element) {
              listImageBanner.add(element.storeLogo ?? '');
              return true;
            }).toList();
          })
        : null;
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
    try {
      if (dataListStore['status'] == 200) {
        mounted
            ? setState(() {
                listStoreManagerData.clear();
                var listStoreManagerDataRes =
                    ListStoreModel.fromJson(dataListStore);
                listStoreManagerData.addAll(listStoreManagerDataRes.data);
              })
            : null;
      } else {
        log("ERRRO GET LIST STORE 111111");
        // showLoginSessionExpiredDialog(
        //     context: context,
        //     okEvent: () {
        //       hanldeLogOut();
        //     });
      }
    } catch (error) {
      log("ERRRO GET LIST STORE $error");
    }
  }

  var tokenManager =
      StorageUtils.instance.getString(key: 'token_manager') ?? '';
  void getDataTabIndex({required String roomId, required String shopID}) async {
    await Future.delayed(const Duration(seconds: 0));
    // ignore: use_build_context_synchronously
    BlocProvider.of<ListRoomBloc>(context).add(
      GetListRoom(
          token: tokenManager,
          client: "user",
          shopId: shopID,
          isApi: true,
          roomId: roomId),
    );
  }

  void getListBillShop(
      {required Map<String, int?> filtersFlg, required String shopID}) async {
    BlocProvider.of<ListBillShopBloc>(context).add(GetListBillShop(
        token: tokenManager,
        client: "user",
        shopId: shopID,
        limit: 15,
        page: 1,
        filters: filtersFlg));
  }

  void getListBroughtReceiptData(
      {required Map<String, int?> filtersFlg, required String shopID}) async {
    BlocProvider.of<BroughtReceiptBloc>(context).add(GetListBroughtReceipt(
        token: tokenManager,
        client: "user",
        shopId: shopID,
        limit: 15,
        page: 1,
        filters: filtersFlg));
  }

  void getInfor() async {
    try {
      var token = StorageUtils.instance.getString(key: 'token_manager');
      log("TOKEN CURRENT $token");
      final response = await http.post(
        Uri.parse('$baseUrl$userInformationApi'),
        headers: {"Authorization": "Bearer $token"},
      );
      final data = jsonDecode(response.body);
      try {
        if (data['status'] == 200) {
          var managerInforDataRes = ManagerInforModel.fromJson(data);
          mounted
              ? setState(() {
                  managerInforData = managerInforDataRes.data;
                })
              : null;

          log("GET INFOR MANGAER OK 1");
        } else {
          log("GET INFOR MANGAER ERROR 1");
        }
      } catch (error) {
        log("GET INFOR MANGAER ERROR 2  $error");
      }
    } catch (error) {
      log("GET INFOR MANGAER ERROR 3 $error");
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      checkTokenExpires();
      getInfor();
      getListStore();
    });
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
    Widget currentScreen = currentIndex == 0
        ? ListStores(
            bannerList: listImageBanner,
            managerInforData: managerInforData,
          )
        : currentIndex == 1
            ? const ListStaff()
            : currentIndex == 2
                ? const ManagerHome()
                : currentIndex == 3
                    ? ListFoodManager(listStores: listStoreManagerData)
                    : currentIndex == 4
                        ? const ManagerInformation()
                        : currentIndex == 5
                            ? const AddStaff()
                            : currentIndex == 6
                                ? ManagerAddFood(
                                    listStores: listStoreManagerData)
                                : currentIndex == 7
                                    ? ManagerBookingTable(
                                        shopID: shopIDPar,
                                      )
                                    : currentIndex == 8
                                        ? ManagerListBill(shopID: shopIDPar)
                                        : ManagerBroughtReceipt(
                                            shopID: shopIDPar);

    return Scaffold(
      onDrawerChanged: (isOpened) {
        getListStore();
      },
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
        // shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.vertical(bottom: Radius.circular(35.w))),
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
            child: const Padding(
              padding: EdgeInsets.only(left: 30, bottom: 20),
            )),
      ),
      body: PageStorage(bucket: bucket, child: currentScreen),
      drawer: Drawer(
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: SizedBox(
                    width: 100.w,
                    height: 100.w,
                    child: Image.asset(
                      "assets/images/logo-thv.png",
                      fit: BoxFit.contain,
                    ),
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
                    mounted
                        ? setState(() {
                            // currentScreen = const ManagerHome();
                            selectedStoreIndex = null;
                            currentIndex = 2;
                            tapDrawerChangeBotNav(2);
                          })
                        : null;
                    Navigator.pop(context);
                    checkTokenExpires();
                  },
                  child: ItemDrawer(
                    fontWeight:
                        currentIndex == 2 ? FontWeight.bold : FontWeight.normal,
                    isExpand: false,
                    text: "Trang chủ",
                    iconColor: currentIndex == 2 ? Colors.white : menuGrey,
                    backgroundIconColor: currentIndex == 2
                        ? Theme.of(context).colorScheme.primary
                        : const Color.fromRGBO(233, 236, 239, 1),
                    icon: Icons.home,
                    isShowIcon: false,
                    image: Container(
                      padding: EdgeInsets.all(5.w),
                      child: Image.asset("assets/images/report.png",
                          fit: BoxFit.cover),
                    ),
                    subItem: const [],
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15.w),
                  child: TextApp(
                    text: 'Quản lý',
                    color: grey,
                    fontsize: 18.sp,
                    fontWeight: FontWeight.bold,
                    textAlign: TextAlign.start,
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                InkWell(
                  onTap: () {},
                  child: ItemDrawer(
                    isExpand: true,
                    text: 'Cửa hàng',
                    fontWeight:
                        currentIndex == 0 ? FontWeight.bold : FontWeight.normal,
                    iconColor: currentIndex == 0 ? Colors.white : menuGrey,
                    backgroundIconColor: currentIndex == 0
                        ? Theme.of(context).colorScheme.primary
                        : const Color.fromRGBO(233, 236, 239, 1),
                    textColor: currentIndex == 0 ? Colors.black : menuGrey,
                    subItem: [
                      space15H,
                      SubItemDrawer(
                          fontWeight: currentIndex == 0
                              ? FontWeight.bold
                              : FontWeight.normal,
                          iconColor:
                              currentIndex == 0 ? Colors.black : menuGrey,
                          text: "Danh sách cửa hàng",
                          textColor:
                              currentIndex == 0 ? Colors.black : menuGrey,
                          event: () {
                            mounted
                                ? setState(() {
                                    // currentScreen = const ListStores();
                                    currentIndex = 0;
                                    // getInfor();
                                    selectedStoreIndex = null;

                                    handleGetBannerList();

                                    tapDrawerChangeBotNav(0);
                                  })
                                : null;
                            checkTokenExpires();

                            Navigator.pop(context);
                          }),
                      space15H,
                    ],
                    icon: Icons.store,
                    isShowIcon: false,
                    image: Container(
                      padding: EdgeInsets.all(5.w),
                      child: Image.asset("assets/images/store_icon.png",
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
                // SizedBox(
                //   height: 25.h,
                // ),
                InkWell(
                  onTap: () {},
                  child: ItemDrawer(
                    isExpand: true,
                    fontWeight: currentIndex == 1 || currentIndex == 5
                        ? FontWeight.bold
                        : FontWeight.normal,
                    text: 'Nhân viên',
                    textColor: currentIndex == 1 || currentIndex == 5
                        ? Colors.black
                        : menuGrey,
                    iconColor: currentIndex == 1 || currentIndex == 5
                        ? Colors.white
                        : menuGrey,
                    backgroundIconColor: currentIndex == 1 || currentIndex == 5
                        ? Theme.of(context).colorScheme.primary
                        : const Color.fromRGBO(233, 236, 239, 1),
                    subItem: [
                      space15H,
                      SubItemDrawer(
                          text: "Danh sách nhân viên",
                          fontWeight: currentIndex == 1
                              ? FontWeight.bold
                              : FontWeight.normal,
                          textColor:
                              currentIndex == 1 ? Colors.black : menuGrey,
                          iconColor:
                              currentIndex == 5 ? Colors.black : menuGrey,
                          event: () {
                            mounted
                                ? setState(() {
                                    // currentScreen = const ListStaff();

                                    currentIndex = 1;
                                    tapDrawerChangeBotNav(1);
                                    selectedStoreIndex = null;
                                  })
                                : null;
                            checkTokenExpires();

                            Navigator.pop(context);
                          }),
                      space20H,
                      SubItemDrawer(
                          text: "Thêm nhân viên",
                          fontWeight: currentIndex == 5
                              ? FontWeight.bold
                              : FontWeight.normal,
                          iconColor:
                              currentIndex == 5 ? Colors.black : menuGrey,
                          textColor:
                              currentIndex == 5 ? Colors.black : menuGrey,
                          event: () {
                            mounted
                                ? setState(() {
                                    currentIndex = 5;
                                    selectedStoreIndex = null;
                                  })
                                : null;
                            checkTokenExpires();

                            Navigator.pop(context);
                          }),
                      space15H,
                    ],
                    icon: Icons.group,
                    isShowIcon: false,
                    image: Container(
                      padding: EdgeInsets.all(5.w),
                      child: Image.asset("assets/images/staff_gr.png",
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
                // SizedBox(
                //   height: 25.h,
                // ),
                InkWell(
                  onTap: () {},
                  child: ItemDrawer(
                    isExpand: true,
                    fontWeight: currentIndex == 3 || currentIndex == 6
                        ? FontWeight.bold
                        : FontWeight.normal,
                    text: 'Thực đơn',
                    textColor: currentIndex == 3 || currentIndex == 6
                        ? Colors.black
                        : menuGrey,
                    subItem: [
                      space15H,
                      SubItemDrawer(
                          text: "Danh sách món ăn",
                          iconColor:
                              currentIndex == 3 ? Colors.black : menuGrey,
                          textColor:
                              currentIndex == 3 ? Colors.black : menuGrey,
                          event: () {
                            mounted
                                ? setState(() {
                                    checkTokenExpires();

                                    currentIndex = 3;
                                    tapDrawerChangeBotNav(3);
                                    selectedStoreIndex = null;
                                  })
                                : null;

                            Navigator.pop(context);
                          }),
                      space20H,
                      SubItemDrawer(
                          text: "Thêm món ăn",
                          iconColor:
                              currentIndex == 6 ? Colors.black : menuGrey,
                          textColor:
                              currentIndex == 6 ? Colors.black : menuGrey,
                          event: () {
                            mounted
                                ? setState(() {
                                    currentIndex = 6;
                                    selectedStoreIndex = null;
                                  })
                                : null;
                            checkTokenExpires();

                            Navigator.pop(context);
                          }),
                      space15H,
                    ],
                    iconColor: currentIndex == 3 || currentIndex == 6
                        ? Colors.white
                        : menuGrey,
                    backgroundIconColor: currentIndex == 3 || currentIndex == 6
                        ? Theme.of(context).colorScheme.primary
                        : const Color.fromRGBO(233, 236, 239, 1),
                    icon: Icons.restaurant,
                    isShowIcon: false,
                    image: Container(
                      padding: EdgeInsets.all(5.w),
                      child: Image.asset("assets/images/menu_food.png",
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
                // SizedBox(
                //   height: 25.h,
                // ),
                SizedBox(
                  height: 10.h,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15.w),
                  child: TextApp(
                    text: 'Tất cả cửa hàng',
                    color: grey,
                    fontsize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: listStoreManagerData.length,
                    itemBuilder: (context, index) {
                      var logoStore = listStoreManagerData[index].storeLogo;
                      return InkWell(
                        onTap: () {},
                        child: ItemDrawer(
                          textColor: index == selectedStoreIndex
                              ? Colors.black
                              : menuGrey,
                          fontWeight: index == selectedStoreIndex
                              ? FontWeight.bold
                              : FontWeight.normal,
                          image: logoStore == null
                              ? Image.asset(
                                  'assets/images/store.png',
                                  fit: BoxFit.contain,
                                )
                              : CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: httpImage + logoStore,
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
                          text:
                              listStoreManagerData[index].storeName.toString(),
                          iconColor: index == selectedStoreIndex
                              ? Colors.white
                              : menuGrey,
                          backgroundIconColor: index == selectedStoreIndex
                              ? Theme.of(context).colorScheme.primary
                              : const Color.fromRGBO(233, 236, 239, 1),
                          subItem: [
                            space15H,
                            SubItemDrawer(
                                iconColor: currentIndex == 7 &&
                                        index == selectedStoreIndex
                                    ? Colors.black
                                    : menuGrey,
                                fontWeight: currentIndex == 7 &&
                                        index == selectedStoreIndex
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                text: "Đặt bàn",
                                textColor: currentIndex == 7 &&
                                        index == selectedStoreIndex
                                    ? Colors.black
                                    : menuGrey,
                                event: () {
                                  mounted
                                      ? setState(() {
                                          shopIDPar =
                                              listStoreManagerData[index]
                                                  .shopId
                                                  .toString();
                                          getDataTabIndex(
                                              roomId: "", shopID: shopIDPar);
                                          selectedStoreIndex = index;
                                          currentIndex = 7;
                                        })
                                      : null;
                                  checkTokenExpires();
                                  Navigator.pop(context);
                                }),
                            space20H,
                            SubItemDrawer(
                                iconColor: currentIndex == 8 &&
                                        index == selectedStoreIndex
                                    ? Colors.black
                                    : menuGrey,
                                text: "Danh sách hóa đơn",
                                textColor: currentIndex == 8 &&
                                        index == selectedStoreIndex
                                    ? Colors.black
                                    : menuGrey,
                                event: () {
                                  mounted
                                      ? setState(() {
                                          shopIDPar =
                                              listStoreManagerData[index]
                                                  .shopId
                                                  .toString();
                                          getListBillShop(
                                              filtersFlg: {"pay_flg": null},
                                              shopID: shopIDPar);
                                          selectedStoreIndex = index;

                                          currentIndex = 8;
                                        })
                                      : null;
                                  Navigator.pop(context);
                                }),
                            space20H,
                            SubItemDrawer(
                                iconColor: currentIndex == 9 &&
                                        index == selectedStoreIndex
                                    ? Colors.black
                                    : menuGrey,
                                text: "Hóa đơn mang về",
                                textColor: currentIndex == 9 &&
                                        index == selectedStoreIndex
                                    ? Colors.black
                                    : menuGrey,
                                event: () {
                                  mounted
                                      ? setState(() {
                                          shopIDPar =
                                              listStoreManagerData[index]
                                                  .shopId
                                                  .toString();
                                          getListBroughtReceiptData(
                                              filtersFlg: {"pay_flg": null},
                                              shopID: shopIDPar);
                                          selectedStoreIndex = index;

                                          currentIndex = 9;
                                        })
                                      : null;
                                  checkTokenExpires();

                                  Navigator.pop(context);
                                }),
                            space15H,
                          ],
                        ),
                      );
                    }),
                SizedBox(
                  height: 15.h,
                ),
              ],
            ),
            Padding(
                padding: EdgeInsets.all(15.w),
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 200.h,
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
                              text: managerInforData?.userFullName ?? '',
                              textAlign: TextAlign.center,
                              color: Colors.white,
                            ),
                          ),
                          Center(
                            child: TextApp(
                                text: managerInforData?.userEmail ?? '',
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
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
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
        color: Colors.black.withOpacity(0.8),
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: Colors.black,
        items: <Widget>[
          // Icon(
          //   Icons.store,
          //   size: 30.h,
          //   color: currentIndex == 0 ? Colors.white : Colors.black,
          // ),
          //  Icon(Icons.group,
          //     size: 30.h,
          //     color: currentIndex == 1 ? Colors.white : Colors.black),
          // Icon(Icons.home,
          //     size: 30.h,
          //     color: currentIndex == 2 ? Colors.white : Colors.black),
          // Icon(Icons.restaurant,
          //     size: 30.h,
          //     color: currentIndex == 3 ? Colors.white : Colors.black),
          // Icon(Icons.person,
          //     size: 30.h,
          //     color: currentIndex == 4 ? Colors.white : Colors.black),
          SizedBox(
            width: 32.w,
            height: 32.w,
            child: Image.asset(
              "assets/images/store_icon.png",
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            width: 32.w,
            height: 32.w,
            child: Image.asset(
              "assets/images/staff_gr.png",
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            width: 32.w,
            height: 32.w,
            child: Image.asset(
              "assets/images/report.png",
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            width: 32.w,
            height: 32.w,
            child: Image.asset(
              "assets/images/menu_food.png",
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            width: 32.w,
            height: 32.w,
            child: Image.asset(
              "assets/images/infor_user.png",
              fit: BoxFit.cover,
            ),
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            getInfor();
            handleGetBannerList();
          }
          mounted
              ? setState(() {
                  currentIndex = index;
                  checkTokenExpires();
                })
              : null;
        },
        letIndexChange: (index) => true,
      ),
    );
  }
}
