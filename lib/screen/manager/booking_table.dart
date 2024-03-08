import 'package:app_restaurant/widgets/list_custom_dialog.dart';
import 'package:app_restaurant/widgets/list_pop_menu.dart';
import 'package:app_restaurant/widgets/shimmer/shimmer_list.dart';
import 'package:app_restaurant/widgets/text/copy_right_text.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ManagerBookingTable extends StatefulWidget {
  const ManagerBookingTable({super.key});

  @override
  State<ManagerBookingTable> createState() => _ManagerBookingTableState();
}

class _ManagerBookingTableState extends State<ManagerBookingTable>
    with TickerProviderStateMixin {
  void saveBookingModal() {}

  void saveMoveTableModal() {}

  void savePayBillModal() {}
  bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(
      length: 1,
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
                                  labelPadding: const EdgeInsets.only(
                                      left: 20, right: 20),
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
                    ]),
                  )),
                  SizedBox(
                    height: 15.h,
                  ),
                  const CopyRightText(),
                  SizedBox(
                    height: 35.h,
                  ),
                ],
              ),
      )),
    );
  }
}
