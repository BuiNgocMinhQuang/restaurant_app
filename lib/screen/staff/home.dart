import 'dart:async';

import 'package:app_restaurant/widgets/list_custom_dialog.dart';
import 'package:app_restaurant/widgets/list_pop_menu.dart';
import 'package:app_restaurant/widgets/shimmer/shimmer_list.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StaffBookingTable extends StatefulWidget {
  const StaffBookingTable({
    Key? key,
  }) : super(key: key);

  @override
  State<StaffBookingTable> createState() => _StaffBookingTableState();
}

class _StaffBookingTableState extends State<StaffBookingTable>
    with TickerProviderStateMixin {
  bool isLoading = true;
  void saveBookingModal() {}

  void saveMoveTableModal() {}

  void savePayBillModal() {}

  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _showSuccesModal(context);
    // });

    // Timer(const Duration(seconds: 3), () {
    //   setState(() {
    //     isLoading = true;
    //   });
    // });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(
      length: 4,
      vsync: this,
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Padding(
        padding:
            EdgeInsets.only(top: 10.h, left: 25.w, right: 25.w, bottom: 10.h),
        child: !isLoading
            ? ShimmerBookingTable()
            : Column(
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
                                      EdgeInsets.only(left: 20.w, right: 20.w),
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
                                  tabs: const [
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
                      SizedBox(
                        width: 1.sw,
                        // color: Colors.pink,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20.h,
                            ),
                            const InforTable(),
                            SizedBox(
                              height: 20.h,
                            ),
                            Expanded(
                              child: GridView.builder(
                                  itemCount: 5,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
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
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      TextApp(
                                                        text: "Bàn 1"
                                                            .toUpperCase(),
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      TextApp(
                                                          text: "TC: 200,000",
                                                          color: Colors.white),
                                                      TextApp(
                                                          text:
                                                              "Giờ vào: 13:44",
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
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return BookingTableDialog(
                                                            eventSaveButton:
                                                                saveBookingModal,
                                                            isUsingTable: true,
                                                          );
                                                        });
                                                  }, eventButton2: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return MoveTableDialog(
                                                            eventSaveButton:
                                                                saveMoveTableModal,
                                                          );
                                                        });
                                                  }, eventButton3: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return const SeeBillDialog();
                                                        });
                                                  }, eventButton4: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return PayBillDialog(
                                                            eventSaveButton:
                                                                savePayBillModal,
                                                          );
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
                      SizedBox(
                        width: 1.sw,
                        // color: Colors.pink,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20.h,
                            ),
                            const InforTable(),
                            SizedBox(
                              height: 20.h,
                            ),
                            Expanded(
                              child: GridView.builder(
                                  itemCount: 5,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
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
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      TextApp(
                                                        text: "Bàn 1"
                                                            .toUpperCase(),
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      TextApp(
                                                          text: "TC: 200,000",
                                                          color: Colors.white),
                                                      TextApp(
                                                          text:
                                                              "Giờ vào: 13:44",
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
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return BookingTableDialog(
                                                            eventSaveButton:
                                                                saveBookingModal,
                                                            isUsingTable: true,
                                                          );
                                                        });
                                                  }, eventButton2: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return MoveTableDialog(
                                                            eventSaveButton:
                                                                saveMoveTableModal,
                                                          );
                                                        });
                                                  }, eventButton3: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return const SeeBillDialog();
                                                        });
                                                  }, eventButton4: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return PayBillDialog(
                                                            eventSaveButton:
                                                                savePayBillModal,
                                                          );
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

                      SizedBox(
                        width: 1.sw,
                        // color: Colors.pink,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20.h,
                            ),
                            const InforTable(),
                            SizedBox(
                              height: 20.h,
                            ),
                            Expanded(
                              child: GridView.builder(
                                  itemCount: 5,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
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
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      TextApp(
                                                        text: "Bàn 1"
                                                            .toUpperCase(),
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      TextApp(
                                                          text: "TC: 200,000",
                                                          color: Colors.white),
                                                      TextApp(
                                                          text:
                                                              "Giờ vào: 13:44",
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
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return BookingTableDialog(
                                                            eventSaveButton:
                                                                saveBookingModal,
                                                            isUsingTable: true,
                                                          );
                                                        });
                                                  }, eventButton2: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return MoveTableDialog(
                                                            eventSaveButton:
                                                                saveMoveTableModal,
                                                          );
                                                        });
                                                  }, eventButton3: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return const SeeBillDialog();
                                                        });
                                                  }, eventButton4: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return PayBillDialog(
                                                            eventSaveButton:
                                                                savePayBillModal,
                                                          );
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

                      SizedBox(
                        width: 1.sw,
                        // color: Colors.pink,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20.h,
                            ),
                            const InforTable(),
                            SizedBox(
                              height: 20.h,
                            ),
                            Expanded(
                              child: GridView.builder(
                                  itemCount: 5,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
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
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      TextApp(
                                                        text: "Bàn 1"
                                                            .toUpperCase(),
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      TextApp(
                                                          text: "TC: 200,000",
                                                          color: Colors.white),
                                                      TextApp(
                                                          text:
                                                              "Giờ vào: 13:44",
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
                    ]),
                  )),
                  SizedBox(
                    height: 15.h,
                  ),
                ],
              ),
      )),
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
