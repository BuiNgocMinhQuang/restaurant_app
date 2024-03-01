import 'package:app_restaurant/widgets/bill_infor_container.dart';
import 'package:app_restaurant/widgets/list_pop_menu.dart';
import 'package:app_restaurant/widgets/manage_brought_receipt.dart';
import 'package:app_restaurant/widgets/modal/cancle_bill_modal.dart';
import 'package:app_restaurant/widgets/modal/print_bill_modal.dart';
import 'package:app_restaurant/widgets/text/copy_right_text.dart';
import 'package:app_restaurant/widgets/custom_tab.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ManagerBroughtReceipt extends StatefulWidget {
  const ManagerBroughtReceipt({super.key});

  @override
  State<ManagerBroughtReceipt> createState() => _ManagerBroughtReceiptState();
}

class _ManagerBroughtReceiptState extends State<ManagerBroughtReceipt>
    with TickerProviderStateMixin {
  bool isShowBillModal = false;
  // bool isShowPayForBillModal = false;
  bool isShowPrintBillModal = false;
  bool isShowCancleBillModal = false;
  _showPayForBillModal(context) {
    AwesomeDialog(
            context: context,
            dialogType: DialogType.question,
            animType: AnimType.rightSlide,
            headerAnimationLoop: true,
            title: 'Bạn có chắc chắn thực hiện tác vụ này!',
            desc: 'Sau khi bạn xác nhận sẽ không thể trở lại.',
            btnOkOnPress: () {},
            btnOkText: "Xác Nhận",
            btnCancelOnPress: () {},
            btnCancelText: "Hủy")
        .show();
  }

  void closeShowBillModal() {
    setState(() {
      isShowBillModal = false;
    });
  }

  void closePrintBillModal() {
    setState(() {
      isShowPrintBillModal = false;
    });
  }

  void closeCancleBillModal() {
    setState(() {
      isShowCancleBillModal = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final TabController tabController = TabController(length: 4, vsync: this);

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
                      height: 100,
                      // color: Colors.red,
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            height: 40.h,
                            color: Colors.white,
                            child: TabBar(
                                labelPadding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                labelColor: Colors.black,
                                unselectedLabelColor:
                                    Colors.black.withOpacity(0.5),
                                labelStyle: const TextStyle(color: Colors.red),
                                controller: tabController,
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
                                ]),
                          ))),
                  Expanded(
                    child: Container(
                      width: 1.sw,
                      // height: 500,
                      color: Colors.white,
                      child: TabBarView(controller: tabController, children: [
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
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const ManageBroughtReceipt()),
                                        );
                                      },
                                      eventButton2: () {
                                        _showPayForBillModal(context);
                                      },
                                      eventButton3: () {
                                        setState(() {
                                          isShowPrintBillModal = true;
                                        });
                                      },
                                      eventButton4: () {
                                        setState(() {
                                          isShowCancleBillModal = true;
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
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ManageBroughtReceipt()),
                                      );
                                    },
                                    eventButton2: () {
                                      _showPayForBillModal(context);
                                    },
                                    eventButton3: () {
                                      setState(() {
                                        isShowPrintBillModal = true;
                                      });
                                    },
                                    eventButton4: () {
                                      setState(() {
                                        isShowCancleBillModal = true;
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
                                    typePopMenu: PopUpMenuPrintBill(
                                      eventButton1: () {
                                        setState(() {
                                          isShowPrintBillModal = true;
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
                  const CopyRightText(),
                  SizedBox(
                    height: 20.h,
                  ),
                ],
              ),
            )),
            Visibility(
                visible: isShowPrintBillModal,
                child: PrintBillModal(eventCloseButton: closePrintBillModal)),
            Visibility(
                visible: isShowCancleBillModal,
                child: CancleBillModal(eventCloseButton: closeCancleBillModal))
          ],
        ));
  }
}
