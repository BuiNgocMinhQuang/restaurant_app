import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/widgets/button/button_gradient.dart';
import 'package:app_restaurant/widgets/item_drawer.dart';
import 'package:app_restaurant/widgets/sub_item_drawer.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sticky_headers/sticky_headers.dart';

class ManagerHome extends StatefulWidget {
  const ManagerHome({super.key});

  @override
  State<ManagerHome> createState() => _ManagerHomeState();
}

class _ManagerHomeState extends State<ManagerHome> {
  bool showModal = true;
  final ScrollController _scrollController = ScrollController();
  @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     _showSuccesModal(context);
  //   });
  // }

  _showSuccesModal(context) {
    AwesomeDialog(
      context: context,
      animType: AnimType.leftSlide,
      headerAnimationLoop: false,
      dialogType: DialogType.success,
      showCloseIcon: true,
      title: 'Thành công',
      desc: 'Đăng nhập thành công!',
      btnOkOnPress: () {
        debugPrint('OnClcik');
      },
      btnOkText: 'OK',
      // btnOkIcon: Icons.check_circle,
      onDismissCallback: (type) {
        debugPrint('Dialog Dissmiss from callback $type');
      },
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: ListView(
              controller: _scrollController,
              children: [
                StickyHeader(
                    controller: _scrollController,
                    // Optional
                    header: Container(
                      // height: 50.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.w),
                        color: Colors.white,
                      ),
                    ),
                    content:
                        ////
                        ListView.builder(
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            itemCount: 6,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                child: Row(
                                  children: [
                                    Image.network("https://picsum.photos/200"),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    const Expanded(
                                      child: Text(
                                        "Every city is good for travel.",
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            })),
              ],
            ),
          )),
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
                ItemDrawer(
                  isExpand: false,
                  text: "Trang chủ",
                  icon: Icons.home,
                  subItem: [],
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
                ItemDrawer(
                    // item: DrawerItem.stores,
                    text: 'Cửa hàng',
                    subItem: [
                      SubItemDrawer(text: "Danh sách cửa hàng", event: () {}),
                    ],
                    icon: Icons.store),
                SizedBox(
                  height: 25.h,
                ),
                ItemDrawer(
                    // item: DrawerItem.staff,
                    text: 'Nhân viên',
                    subItem: [
                      SubItemDrawer(
                          text: "Danh sách nhân viên",
                          event: () {
                            Navigator.pop(context);
                          }),
                      SizedBox(
                        height: 10.h,
                      ),
                      SubItemDrawer(
                          text: "Thêm nhân viên",
                          event: () {
                            Navigator.pop(context);
                          })
                    ],
                    icon: Icons.safety_divider),
                SizedBox(
                  height: 25.h,
                ),
                ItemDrawer(
                    // item: DrawerItem.menu,
                    text: 'Thực đơn',
                    subItem: [
                      SubItemDrawer(
                          text: "Danh sách món ăn",
                          event: () {
                            Navigator.pop(context);
                          }),
                    ],
                    icon: Icons.local_dining_outlined),
                SizedBox(
                  height: 25.h,
                ),
                const Divider(
                  color: Colors.black45,
                ),
                SizedBox(
                  height: 10.h,
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
                ItemDrawer(
                    // item: DrawerItem.stores,
                    text: 'Cửa hàng 1',
                    subItem: [
                      SubItemDrawer(
                          text: "Đặt bàn",
                          event: () {
                            Navigator.pop(context);
                          }),
                      SizedBox(
                        height: 10.h,
                      ),
                      SubItemDrawer(
                          text: "Danh sách hóa đơn",
                          event: () {
                            Navigator.pop(context);
                          }),
                      SizedBox(
                        height: 10.h,
                      ),
                      SubItemDrawer(
                          text: "Hóa đơn mang về",
                          event: () {
                            Navigator.pop(context);
                          })
                    ],
                    icon: Icons.store),
                SizedBox(
                  height: 25.h,
                ),
                ItemDrawer(
                    // item: DrawerItem.stores,
                    text: 'Cửa hàng 2',
                    subItem: [
                      SubItemDrawer(
                          text: "Đặt bàn",
                          event: () {
                            Navigator.pop(context);
                          }),
                      SizedBox(
                        height: 10.h,
                      ),
                      SubItemDrawer(
                          text: "Danh sách hóa đơn",
                          event: () {
                            Navigator.pop(context);
                          }),
                      SizedBox(
                        height: 10.h,
                      ),
                      SubItemDrawer(
                          text: "Hóa đơn mang về",
                          event: () {
                            Navigator.pop(context);
                          })
                    ],
                    icon: Icons.store),
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
                              text: "Ten Chu Cua Hang",
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
                            event: () {},
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
    );
  }
}
