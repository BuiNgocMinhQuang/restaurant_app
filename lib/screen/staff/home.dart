import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/config/fake_data.dart';
import 'package:app_restaurant/config/text.dart';
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
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class StaffBookingTable extends StatefulWidget {
  StaffBookingTable({
    Key? key,
  }) : super(key: key);

  @override
  State<StaffBookingTable> createState() => _StaffBookingTableState();
}

class _StaffBookingTableState extends State<StaffBookingTable>
    with TickerProviderStateMixin {
  // bool isShowEditModal = false;
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
  void initState() {
    // TODO: implement initState
    super.initState();

    // if (widget.isLogin) {
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     _showSuccesModal(context);
    //   });
    // }
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
                                                    showDialog(
                                                        context: context,
                                                        builder: (_) =>
                                                            EditModal(
                                                              eventButton1: () {
                                                                setState(() {
                                                                  isShowBookingTableModal =
                                                                      true;
                                                                });
                                                              },
                                                              eventButton2: () {
                                                                setState(() {
                                                                  isShowMoveTableModal =
                                                                      true;
                                                                });
                                                              },
                                                              eventButton3: () {
                                                                setState(() {
                                                                  isShowSeeBillModal =
                                                                      true;
                                                                });
                                                              },
                                                              eventButton4: () {
                                                                setState(() {
                                                                  isShowPayBillModal =
                                                                      true;
                                                                });
                                                              },
                                                            ));
                                                  },
                                                  child: const Icon(
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
                                          color: Colors.green,
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
                                                    showDialog(
                                                        context: context,
                                                        builder: (_) =>
                                                            EditModal(
                                                              eventButton1: () {
                                                                setState(() {
                                                                  isShowBookingTableModal =
                                                                      true;
                                                                });
                                                              },
                                                              eventButton2: () {
                                                                setState(() {
                                                                  isShowMoveTableModal =
                                                                      true;
                                                                });
                                                              },
                                                              eventButton3: () {
                                                                setState(() {
                                                                  isShowSeeBillModal =
                                                                      true;
                                                                });
                                                              },
                                                              eventButton4: () {
                                                                setState(() {
                                                                  isShowPayBillModal =
                                                                      true;
                                                                });
                                                              },
                                                            ));
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
                                          color: Colors.orange,
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
                                                    showDialog(
                                                        context: context,
                                                        builder: (_) =>
                                                            EditModal(
                                                              eventButton1: () {
                                                                setState(() {
                                                                  isShowBookingTableModal =
                                                                      true;
                                                                });
                                                              },
                                                              eventButton2: () {
                                                                setState(() {
                                                                  isShowMoveTableModal =
                                                                      true;
                                                                });
                                                              },
                                                              eventButton3: () {
                                                                setState(() {
                                                                  isShowSeeBillModal =
                                                                      true;
                                                                });
                                                              },
                                                              eventButton4: () {
                                                                setState(() {
                                                                  isShowPayBillModal =
                                                                      true;
                                                                });
                                                              },
                                                            ));
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
                                          color: Colors.red,
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
                                                  onTap: () {},
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
              visible: isShowBookingTableModal,
              child: BookingTableModal(
                eventCloseButton: closeBookingModal,
                eventSaveButton: closeBookingModal,
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
                  onTap: () {
                    // context.go("/staff_list_food");
                  },
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
                  onTap: () {},
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

class EditModal extends StatelessWidget {
  Function eventButton1;
  Function eventButton2;
  Function eventButton3;
  Function eventButton4;
  EditModal({
    Key? key,
    required this.eventButton1,
    required this.eventButton2,
    required this.eventButton3,
    required this.eventButton4,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding:
          EdgeInsets.only(top: 100.h, bottom: 100.h, left: 35.w, right: 35.w),
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
                      color1: const Color.fromRGBO(33, 82, 255, 1),
                      color2: const Color.fromRGBO(33, 212, 253, 1),
                      event: () {
                        eventButton1();
                        Navigator.pop(context);

                        // setState(() {
                        //   isShowEditModal = false;
                        //   isShowBookingTableModal = true;
                        // });
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
                      color1: const Color.fromRGBO(33, 82, 255, 1),
                      color2: const Color.fromRGBO(33, 212, 253, 1),
                      event: () {
                        eventButton2();
                        Navigator.pop(context);
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
                      color1: const Color.fromRGBO(33, 82, 255, 1),
                      color2: const Color.fromRGBO(33, 212, 253, 1),
                      event: () {
                        eventButton3();
                        Navigator.pop(context);
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
                      color1: const Color.fromRGBO(33, 82, 255, 1),
                      color2: const Color.fromRGBO(33, 212, 253, 1),
                      event: () {
                        eventButton4();
                        Navigator.pop(context);
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
                      top: BorderSide(width: 1, color: Colors.grey),
                      bottom: BorderSide(width: 0, color: Colors.grey),
                      left: BorderSide(width: 0, color: Colors.grey),
                      right: BorderSide(width: 0, color: Colors.grey)),
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
                        Navigator.pop(context);
                      },
                      text: "Đóng",
                      colorText: Colors.white,
                      backgroundColor: Color.fromRGBO(131, 146, 171, 1),
                      outlineColor: Color.fromRGBO(131, 146, 171, 1),
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                  ],
                ),
              ),
            ],
          )),
    ));
  }
}
