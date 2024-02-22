import 'package:app_restaurant/widgets/bill_infor_container.dart';
import 'package:app_restaurant/widgets/copy_right_text.dart';
import 'package:app_restaurant/widgets/custom_tab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BroughtReceipt extends StatefulWidget {
  const BroughtReceipt({super.key});

  @override
  State<BroughtReceipt> createState() => _BroughtReceiptState();
}

class _BroughtReceiptState extends State<BroughtReceipt>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 4, vsync: this);

    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: Padding(
          padding:
              EdgeInsets.only(top: 10.h, left: 25.w, right: 25.w, bottom: 10.h),
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
                              labelColor: Colors.black,
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
                                CustomTab(text: "Tất cả", icon: Icons.list_alt),
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
                            child:
                                BillInforContainer(statusText: "Đang chế biến"),
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
                            Text(
                              "Chưa có hoá đơn :(",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16.sp, color: Colors.black),
                            ),
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
                                statusText: "Hóa đơn đã hủy"),
                          );
                        }),
                  ]),
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              const CopyRightText()
            ],
          ),
        )));
  }
}
