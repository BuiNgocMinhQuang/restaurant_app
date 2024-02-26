import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/widgets/bill_infor_container.dart';
import 'package:app_restaurant/widgets/item_drawer.dart';
import 'package:app_restaurant/widgets/modal/booking_table_modal.dart';
import 'package:app_restaurant/widgets/button/button_app.dart';
import 'package:app_restaurant/widgets/button/button_gradient.dart';
import 'package:app_restaurant/widgets/sub_item_drawer.dart';
import 'package:app_restaurant/widgets/text/copy_right_text.dart';
import 'package:app_restaurant/widgets/modal/move_table_modal.dart';
import 'package:app_restaurant/widgets/modal/pay_bill_modal.dart';
import 'package:app_restaurant/widgets/modal/see_bill_modal.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class StaffBookingTable extends StatefulWidget {
  const StaffBookingTable({super.key});

  @override
  State<StaffBookingTable> createState() => _StaffBookingTableState();
}

class _StaffBookingTableState extends State<StaffBookingTable>
    with TickerProviderStateMixin {
  bool isShowEditModal = false;
  bool isShowMoveTableModal = false;
  bool isShowBookingTableModal = false;
  bool isShowSeeBillModal = false;
  bool isShowPayBillModal = false;

  void closeBookingModal() {
    setState(() {
      isShowBookingTableModal = false;
    });
  }

  void closeMoveModal() {
    setState(() {
      isShowMoveTableModal = false;
    });
  }

  void closeSeeBillModal() {
    setState(() {
      isShowSeeBillModal = false;
    });
  }

  void closePayBillModal() {
    setState(() {
      isShowPayBillModal = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(
      length: 4,
      vsync: this,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Quản lí bàn"),
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
              child: Padding(
            padding: EdgeInsets.only(
                top: 10.h, left: 25.w, right: 25.w, bottom: 10.h),
            child: Column(
              children: [
                SizedBox(
                  width: 1.sw,
                  child: SizedBox(
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            height: 40.h,
                            color: Colors.white,
                            child: TabBar(
                                labelPadding:
                                    EdgeInsets.only(left: 20, right: 20),
                                labelColor: Colors.blue,
                                labelStyle: TextStyle(
                                    fontSize: 14.sp,
                                    fontFamily: 'OpenSans',
                                    fontWeight: FontWeight.bold),
                                unselectedLabelColor:
                                    Colors.black.withOpacity(0.5),
                                controller: _tabController,
                                isScrollable: true,
                                indicatorSize: TabBarIndicatorSize.label,
                                tabs: [
                                  Tab(
                                    text: "Phòng số 1",
                                  ),
                                  Tab(
                                    text: "Phòng số 2",
                                  ),
                                  Tab(
                                    text: "Phòng số 3",
                                  ),
                                  Tab(
                                    text: "Phòng số 4",
                                  ),
                                ]),
                          ))),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Expanded(
                    child: Container(
                  width: 1.sw,
                  color: Colors.white,
                  child: TabBarView(controller: _tabController, children: [
                    //Tab All
                    Container(
                      width: 1.sw,
                      // color: Colors.pink,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20.h,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    color: Colors.green,
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  TextApp(text: "Đang phục vụ")
                                ],
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    color: Colors.yellow,
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  TextApp(text: "Bàn trống")
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Expanded(
                            child: GridView.builder(
                                itemCount: 5,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                ),
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.all(10.w),
                                    child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                          color: Colors.blue,
                                        ),
                                        width: 50,
                                        height: 50,
                                        child: Stack(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    TextApp(
                                                      text:
                                                          "Bàn 1".toUpperCase(),
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    TextApp(
                                                        text: "TC: 200,000",
                                                        color: Colors.white),
                                                    TextApp(
                                                        text: "Giờ vào: 13:44",
                                                        color: Colors.white)
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Positioned(
                                                top: 0,
                                                right: 0,
                                                child: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      isShowEditModal = true;
                                                    });
                                                  },
                                                  child: Icon(
                                                    Icons.edit,
                                                    color: Colors.white,
                                                  ),
                                                )),
                                          ],
                                        )),
                                  );
                                }),
                          )
                        ],
                      ),
                    ),
                    //Tab Paid
                    Container(
                      width: 1.sw,
                      // color: Colors.pink,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20.h,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    color: Colors.green,
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  TextApp(text: "Đang phục vụ")
                                ],
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    color: Colors.yellow,
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  TextApp(text: "Bàn trống")
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Expanded(
                            child: GridView.builder(
                                itemCount: 5,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                ),
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.all(10.w),
                                    child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                          color: Colors.blue,
                                        ),
                                        width: 50,
                                        height: 50,
                                        child: Stack(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    TextApp(
                                                      text:
                                                          "Bàn 1".toUpperCase(),
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    TextApp(
                                                        text: "TC: 200,000",
                                                        color: Colors.white),
                                                    TextApp(
                                                        text: "Giờ vào: 13:44",
                                                        color: Colors.white)
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Positioned(
                                                top: 0,
                                                right: 0,
                                                child: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      isShowEditModal = true;
                                                    });
                                                  },
                                                  child: Icon(
                                                    Icons.edit,
                                                    color: Colors.white,
                                                  ),
                                                )),
                                          ],
                                        )),
                                  );
                                }),
                          )
                        ],
                      ),
                    ),

                    Container(
                      width: 1.sw,
                      // color: Colors.pink,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20.h,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    color: Colors.green,
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  TextApp(text: "Đang phục vụ")
                                ],
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    color: Colors.yellow,
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  TextApp(text: "Bàn trống")
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Expanded(
                            child: GridView.builder(
                                itemCount: 5,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                ),
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.all(10.w),
                                    child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                          color: Colors.blue,
                                        ),
                                        width: 50,
                                        height: 50,
                                        child: Stack(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    TextApp(
                                                      text:
                                                          "Bàn 1".toUpperCase(),
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    TextApp(
                                                        text: "TC: 200,000",
                                                        color: Colors.white),
                                                    TextApp(
                                                        text: "Giờ vào: 13:44",
                                                        color: Colors.white)
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Positioned(
                                                top: 0,
                                                right: 0,
                                                child: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      isShowEditModal = true;
                                                    });
                                                  },
                                                  child: Icon(
                                                    Icons.edit,
                                                    color: Colors.white,
                                                  ),
                                                )),
                                          ],
                                        )),
                                  );
                                }),
                          )
                        ],
                      ),
                    ),

                    Container(
                      width: 1.sw,
                      // color: Colors.pink,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20.h,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    color: Colors.green,
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  TextApp(text: "Đang phục vụ")
                                ],
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    color: Colors.yellow,
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  TextApp(text: "Bàn trống")
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Expanded(
                            child: GridView.builder(
                                itemCount: 5,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                ),
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.all(10.w),
                                    child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                          color: Colors.blue,
                                        ),
                                        width: 50,
                                        height: 50,
                                        child: Stack(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    TextApp(
                                                      text:
                                                          "Bàn 1".toUpperCase(),
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    TextApp(
                                                        text: "TC: 200,000",
                                                        color: Colors.white),
                                                    TextApp(
                                                        text: "Giờ vào: 13:44",
                                                        color: Colors.white)
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Positioned(
                                                top: 0,
                                                right: 0,
                                                child: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      isShowEditModal = true;
                                                    });
                                                  },
                                                  child: Icon(
                                                    Icons.edit,
                                                    color: Colors.white,
                                                  ),
                                                )),
                                          ],
                                        )),
                                  );
                                }),
                          )
                        ],
                      ),
                    ),
                  ]),
                )),
                SizedBox(
                  height: 15.h,
                ),
              ],
            ),
          )),
          Visibility(
              visible: isShowEditModal,
              child: Container(
                  width: 1.sw,
                  height: 1.sh,
                  color: Colors.black.withOpacity(0.3),
                  child: Center(
                      child: Padding(
                    padding: EdgeInsets.only(
                        top: 100.h, bottom: 100.h, left: 35.w, right: 35.w),
                    child: Container(
                        width: 1.sw,
                        height: 1.sh / 3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.r),
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            Expanded(
                                child: SingleChildScrollView(
                                    child: Padding(
                              padding: EdgeInsets.all(20.w),
                              child: Column(
                                children: [
                                  ButtonGradient(
                                    color1:
                                        const Color.fromRGBO(33, 82, 255, 1),
                                    color2:
                                        const Color.fromRGBO(33, 212, 253, 1),
                                    event: () {
                                      setState(() {
                                        isShowEditModal = false;
                                        isShowBookingTableModal = true;
                                      });
                                    },
                                    text: "Quản lý bàn",
                                    fontSize: 12.sp,
                                    radius: 8.r,
                                    textColor: Colors.white,
                                  ),
                                  ////////
                                  SizedBox(
                                    height: 30.h,
                                  ),
                                  //////
                                  ButtonGradient(
                                    color1:
                                        const Color.fromRGBO(33, 82, 255, 1),
                                    color2:
                                        const Color.fromRGBO(33, 212, 253, 1),
                                    event: () {
                                      setState(() {
                                        isShowEditModal = false;
                                        isShowMoveTableModal = true;
                                      });
                                    },
                                    text: "Chuyển bàn",
                                    fontSize: 12.sp,
                                    radius: 8.r,
                                    textColor: Colors.white,
                                  ),
                                  /////
                                  SizedBox(
                                    height: 30.h,
                                  ),
                                  ButtonGradient(
                                    color1:
                                        const Color.fromRGBO(33, 82, 255, 1),
                                    color2:
                                        const Color.fromRGBO(33, 212, 253, 1),
                                    event: () {
                                      setState(() {
                                        isShowEditModal = false;
                                        isShowSeeBillModal = true;
                                      });
                                    },
                                    text: "Xem hoá đơn",
                                    fontSize: 12.sp,
                                    radius: 8.r,
                                    textColor: Colors.white,
                                  ),
                                  /////
                                  SizedBox(
                                    height: 30.h,
                                  ),
                                  ButtonGradient(
                                    color1:
                                        const Color.fromRGBO(33, 82, 255, 1),
                                    color2:
                                        const Color.fromRGBO(33, 212, 253, 1),
                                    event: () {
                                      setState(() {
                                        isShowEditModal = false;
                                        isShowPayBillModal = true;
                                      });
                                    },
                                    text: "Thanh toán",
                                    fontSize: 12.sp,
                                    radius: 8.r,
                                    textColor: Colors.white,
                                  ),

                                  ////
                                ],
                              ),
                            ))),
                            Container(
                              width: 1.sw,
                              height: 80.h,
                              decoration: BoxDecoration(
                                border: const Border(
                                    top: BorderSide(
                                        width: 1, color: Colors.grey),
                                    bottom: BorderSide(
                                        width: 0, color: Colors.grey),
                                    left: BorderSide(
                                        width: 0, color: Colors.grey),
                                    right: BorderSide(
                                        width: 0, color: Colors.grey)),
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(15.w),
                                    bottomRight: Radius.circular(15.w)),
                                // color: Colors.green,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ButtonApp(
                                    event: () {
                                      setState(() {
                                        print("CLOSE");
                                        isShowEditModal = false;
                                      });
                                    },
                                    text: "Đóng",
                                    colorText: Colors.white,
                                    backgroundColor:
                                        Color.fromRGBO(131, 146, 171, 1),
                                    outlineColor:
                                        Color.fromRGBO(131, 146, 171, 1),
                                  ),
                                  SizedBox(
                                    width: 20.w,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )),
                  )))),
          Visibility(
              visible: isShowBookingTableModal,
              child: BookingTableModal(
                eventCloseButton: closeBookingModal,
                isUsingTable: true,
              )),
          Visibility(
              visible: isShowMoveTableModal,
              child: MoveTableModal(eventCloseButton: closeMoveModal)),
          Visibility(
              visible: isShowSeeBillModal,
              child: SeeBillModal(eventCloseButton: closeSeeBillModal)),
          Visibility(
              visible: isShowPayBillModal,
              child: PayBillModal(eventCloseButton: closePayBillModal))
        ],
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
                  onTap: () {},
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 100.w,
                        height: 25.h,
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Text(
                        "hlaldo",
                      ),
                    ],
                  ),
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
                      SubItemDrawer(
                          text: "Danh sách cửa hàng",
                          event: () {
                            Navigator.pop(context);
                          }),
                    ],
                    icon: Icons.store),
                SizedBox(
                  height: 25.h,
                ),
                ItemDrawer(
                    isExpand: false,
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
    );
  }
}
