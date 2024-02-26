import 'package:app_restaurant/widgets/bill_infor_container.dart';
import 'package:app_restaurant/widgets/text/copy_right_text.dart';
import 'package:app_restaurant/widgets/custom_tab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StaffListBill extends StatefulWidget {
  const StaffListBill({super.key});

  @override
  State<StaffListBill> createState() => _StaffListBillState();
}

class _StaffListBillState extends State<StaffListBill>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(
      length: 4,
      vsync: this,
    );
    print("_tabController + ${_tabController.index}");
    return Scaffold(
        appBar: AppBar(
          title: Text("Danh sách hoá đơn"),
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
            child: Padding(
          padding:
              EdgeInsets.only(top: 10.h, left: 25.w, right: 25.w, bottom: 10.h),
          child: Column(
            children: [
              SizedBox(
                width: 1.sw,
                height: 100,
                // color: Colors.red,
                child: SizedBox(
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
                color: Colors.white,
                child: TabBarView(controller: _tabController, children: [
                  //Tab All
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: 4,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: EdgeInsets.only(left: 5.w, right: 5.w),
                          child:
                              BillInforContainer(statusText: "Đã thanh toán"),
                        );
                      }),
                  //Tab Paid
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: 4,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: EdgeInsets.only(left: 5.w, right: 5.w),
                          child:
                              BillInforContainer(statusText: "Đã thanh toán"),
                        );
                      }),
                  //Tab Unpaid
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: 4,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: EdgeInsets.only(left: 5.w, right: 5.w),
                          child: BillInforContainer(
                            statusText: "Chưa thanh toán",
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
                          child:
                              BillInforContainer(statusText: "Hóa đơn đã hủy"),
                        );
                      }),
                ]),
              )),
              SizedBox(
                height: 15.h,
              ),
            ],
          ),
        )));
  }
}
