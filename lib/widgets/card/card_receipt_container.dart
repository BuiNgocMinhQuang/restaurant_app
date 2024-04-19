import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BroughtReceiptContainer extends StatelessWidget {
  final String statusText;
  final String dateTime;
  final String price;
  final Widget typePopMenu;

  const BroughtReceiptContainer(
      {Key? key,
      required this.typePopMenu,
      required this.statusText,
      required this.dateTime,
      required this.price})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            width: 1.sw,
            // height: 100.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(10.w),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          TextApp(
                            text: "Tên khách hàng: ",
                            color: orangeColorApp,
                            fontWeight: FontWeight.bold,
                            fontsize: 14.sp,
                          ),
                          TextApp(
                            text: "Khách lẻ",
                            fontsize: 14.sp,
                            color: menuGrey,
                            fontWeight: FontWeight.bold,
                          )
                        ],
                      ),
                      typePopMenu
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    children: [TextApp(text: dateTime)],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextApp(
                        text: price,
                        fontsize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      if (statusText == "Hoàn thành")
                        TextApp(
                          text: statusText,
                          color: Colors.green,
                          fontsize: 14.sp,
                        )
                      else if (statusText == "Đang chế biến")
                        TextApp(
                          text: statusText,
                          color: newBlueText,
                          fontsize: 14.sp,
                        )
                      else if (statusText == "Đã huỷ")
                        TextApp(
                          text: statusText,
                          color: const Color.fromARGB(255, 207, 28, 15),
                          fontsize: 14.sp,
                        )
                      else
                        TextApp(
                          text: statusText,
                          color: newBlueText,
                          fontsize: 14.sp,
                        )
                    ],
                  ),
                ],
              ),
            )),
        SizedBox(
          height: 20.h,
        )
      ],
    );
  }
}

class BillInforContainer extends StatelessWidget {
  final String statusText;
  final String tableName;
  final String roomName;
  final String dateTime;
  final String price;
  final Widget typePopMenu;
  const BillInforContainer({
    Key? key,
    required this.typePopMenu,
    required this.statusText,
    required this.tableName,
    required this.roomName,
    required this.dateTime,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            width: 1.sw,
            // height: 100.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(10.w),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          TextApp(
                            text: tableName,
                            color: orangeColorApp,
                            fontWeight: FontWeight.bold,
                            fontsize: 14.sp,
                          ),
                          TextApp(text: " | "),
                          TextApp(
                            text: roomName,
                            fontsize: 14.sp,
                            color: menuGrey,
                            fontWeight: FontWeight.bold,
                          )
                        ],
                      ),
                      typePopMenu
                    ],
                  ),
                  // SizedBox(
                  //   height: 10.h,
                  // ),
                  Row(
                    children: [TextApp(text: dateTime)],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextApp(
                        text: price,
                        fontsize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      if (statusText == "Đã thanh toán")
                        TextApp(
                          text: statusText,
                          color: Colors.green,
                          fontsize: 14.sp,
                        )
                      else if (statusText == "Chưa thanh toán")
                        TextApp(
                          text: statusText,
                          color: newBlueText,
                          fontsize: 14.sp,
                        )
                      else if (statusText == "Hoá đơn bị huỷ")
                        TextApp(
                          text: statusText,
                          color: const Color.fromARGB(255, 207, 28, 15),
                          fontsize: 14.sp,
                        )
                      else
                        TextApp(
                          text: statusText,
                          color: newBlueText,
                          fontsize: 14.sp,
                        )
                    ],
                  ),
                ],
              ),
            )),
        SizedBox(
          height: 20.h,
        )
      ],
    );
  }
}
