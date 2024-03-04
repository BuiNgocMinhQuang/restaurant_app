import 'package:app_restaurant/config/all_void.dart';
import 'package:app_restaurant/widgets/bill_infor_container.dart';
import 'package:app_restaurant/widgets/list_custom_dialog.dart';
import 'package:app_restaurant/widgets/list_pop_menu.dart';
import 'package:app_restaurant/widgets/text/copy_right_text.dart';
import 'package:app_restaurant/widgets/custom_tab.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StaffBroughtReceipt extends StatefulWidget {
  const StaffBroughtReceipt({super.key});

  @override
  State<StaffBroughtReceipt> createState() => _StaffBroughtReceiptState();
}

class _StaffBroughtReceiptState extends State<StaffBroughtReceipt>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 4, vsync: this);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: 10.h, left: 25.w, right: 25.w, bottom: 10.h),
              child: Column(
                children: [
                  Container(
                    width: 1.sw,
                    height: 100,
                    // color: Colors.red,
                    child: Container(
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              height: 40.h,
                              color: Colors.white,
                              child: TabBar(
                                  labelPadding:
                                      EdgeInsets.only(left: 20, right: 20),
                                  labelColor: Colors.white,
                                  unselectedLabelColor:
                                      Colors.black.withOpacity(0.5),
                                  labelStyle: TextStyle(color: Colors.red),
                                  controller: _tabController,
                                  isScrollable: true,
                                  indicatorSize: TabBarIndicatorSize.label,
                                  indicator: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      8.r,
                                    ),
                                    color: Colors.blue,
                                    border: Border.all(color: Colors.blue),
                                  ),
                                  tabs: [
                                    CustomTab(
                                        text: "Tất cả", icon: Icons.list_alt),
                                    CustomTab(
                                      text: "Đã thanh toán",
                                      icon: Icons.credit_score,
                                    ),
                                    CustomTab(
                                        text: "Chưa thanh toán",
                                        icon: Icons.credit_card),
                                    CustomTab(
                                        text: "Hóa đơn đã hủy",
                                        icon: Icons.cancel_sharp),

                                    // Tab(text: "Đã thanh toán"),
                                    // Tab(text: "Chưa thanh toán"),
                                    // Tab(text: "Hóa đơn đã hủy"),
                                  ]),
                            ))),
                  ),
                  Expanded(
                    child: Container(
                      width: 1.sw,
                      // height: 500,
                      color: Colors.white,
                      child: TabBarView(controller: _tabController, children: [
                        //Tab All
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: 6,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: EdgeInsets.only(left: 5.w, right: 5.w),
                                child: BillInforContainer(
                                    typePopMenu: PopUpMenuBroughtReceipt(
                                      eventButton1: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return const ManageBroughtReceiptDialog();
                                            });
                                      },
                                      eventButton2: () {
                                        showConfirmDialog(context, () {});
                                      },
                                      eventButton3: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return const PrintBillDialog();
                                            });
                                      },
                                      eventButton4: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return const CancleBillDialog();
                                            });
                                      },
                                    ),
                                    statusText: "Đang chế biến"),
                              );
                            }),
                        //Tab Paid
                        SizedBox(
                            width: 1.sw,
                            height: 30.h,
                            // color: Colors.amber,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.receipt_long_rounded,
                                  size: 50.h,
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                TextApp(
                                    text: "Chưa có hoá đơn :(",
                                    textAlign: TextAlign.center,
                                    fontsize: 16.sp,
                                    color: Colors.black),
                              ],
                            )),
                        // ListView.builder(
                        //     shrinkWrap: true,
                        //     itemCount: 4,
                        //     itemBuilder: (BuildContext context, int index) {
                        //       return Padding(
                        //         padding: EdgeInsets.only(left: 5.w, right: 5.w),
                        //         child:
                        //             BillInforContainer(statusText: "Đã thanh toán"),
                        //       );
                        //     }),
                        //Tab Unpaid
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: 4,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: EdgeInsets.only(left: 5.w, right: 5.w),
                                child: BillInforContainer(
                                  typePopMenu: PopUpMenuBroughtReceipt(
                                    eventButton1: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return const ManageBroughtReceiptDialog();
                                          });
                                    },
                                    eventButton2: () {
                                      showConfirmDialog(context, () {});
                                    },
                                    eventButton3: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return const PrintBillDialog();
                                          });
                                    },
                                    eventButton4: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return const CancleBillDialog();
                                          });
                                    },
                                  ),
                                  statusText: "Đang chế biến",
                                ),
                              );
                            }),
                        //Tab cancle
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: 4,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: EdgeInsets.only(left: 5.w, right: 5.w),
                                child: BillInforContainer(
                                    typePopMenu: PopUpMenuBroughtReceipt(
                                      eventButton1: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return const ManageBroughtReceiptDialog();
                                            });
                                      },
                                      eventButton2: () {
                                        showConfirmDialog(context, () {});
                                      },
                                      eventButton3: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return const PrintBillDialog();
                                            });
                                      },
                                      eventButton4: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return const CancleBillDialog();
                                            });
                                      },
                                    ),
                                    statusText: "Hóa đơn đã hủy"),
                              );
                            }),
                      ]),
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                ],
              ),
            ),
            Positioned(
                bottom: 50.h,
                right: 50.w,
                child: MaterialButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const ManageBroughtReceiptDialog();
                        });
                  },
                  color: Colors.blue,
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                  shape: const CircleBorder(),
                  child: const Icon(
                    Icons.add,
                    size: 24,
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
