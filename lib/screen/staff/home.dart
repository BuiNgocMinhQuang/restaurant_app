import 'package:app_restaurant/widgets/list_pop_menu.dart';
import 'package:app_restaurant/widgets/modal/booking_table_modal.dart';
import 'package:app_restaurant/widgets/modal/move_table_modal.dart';
import 'package:app_restaurant/widgets/modal/pay_bill_modal.dart';
import 'package:app_restaurant/widgets/modal/see_bill_modal.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
                          InforTable(),
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
                                                child: PopUpMenuUsingTable(
                                                    eventButton1: () {
                                                  setState(() {
                                                    isShowBookingTableModal =
                                                        true;
                                                  });
                                                }, eventButton2: () {
                                                  setState(() {
                                                    isShowMoveTableModal = true;
                                                  });
                                                }, eventButton3: () {
                                                  setState(() {
                                                    isShowSeeBillModal = true;
                                                  });
                                                }, eventButton4: () {
                                                  setState(() {
                                                    isShowPayBillModal = true;
                                                  });
                                                })),
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
                          InforTable(),
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
                                                child: PopUpMenuUsingTable(
                                                    eventButton1: () {
                                                  setState(() {
                                                    isShowBookingTableModal =
                                                        true;
                                                  });
                                                }, eventButton2: () {
                                                  setState(() {
                                                    isShowMoveTableModal = true;
                                                  });
                                                }, eventButton3: () {
                                                  setState(() {
                                                    isShowSeeBillModal = true;
                                                  });
                                                }, eventButton4: () {
                                                  setState(() {
                                                    isShowPayBillModal = true;
                                                  });
                                                })),
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
                          InforTable(),
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
                                                child: PopUpMenuUsingTable(
                                                    eventButton1: () {
                                                  setState(() {
                                                    isShowBookingTableModal =
                                                        true;
                                                  });
                                                }, eventButton2: () {
                                                  setState(() {
                                                    isShowMoveTableModal = true;
                                                  });
                                                }, eventButton3: () {
                                                  setState(() {
                                                    isShowSeeBillModal = true;
                                                  });
                                                }, eventButton4: () {
                                                  setState(() {
                                                    isShowPayBillModal = true;
                                                  });
                                                })),
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
                          InforTable(),
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
      // drawer: StaffSileMenu()
    );
  }
}

class InforTable extends StatelessWidget {
  const InforTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}
