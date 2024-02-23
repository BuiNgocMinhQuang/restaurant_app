import 'package:app_restaurant/widgets/button_app.dart';
import 'package:app_restaurant/widgets/button_gradient.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectModal extends StatelessWidget {
  const SelectModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                          color1: const Color.fromRGBO(33, 82, 255, 1),
                          color2: const Color.fromRGBO(33, 212, 253, 1),
                          event: () {
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
                            // setState(() {
                            //   isShowEditModal = false;
                            //   isShowMoveTableModal = true;
                            // });
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
                            // setState(() {
                            //   isShowEditModal = false;
                            //   isShowSeeBillModal = true;
                            // });
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
                            // setState(() {
                            //   isShowEditModal = false;
                            //   isShowPayBillModal = true;
                            // });
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
                            // setState(() {
                            //   print("CLOSE");
                            //   isShowEditModal = false;
                            // });
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
        )));
  }
}
