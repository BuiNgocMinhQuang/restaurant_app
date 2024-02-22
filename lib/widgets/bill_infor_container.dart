import 'package:app_restaurant/widgets/text_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BillInforContainer extends StatelessWidget {
  final String statusText;
  BillInforContainer({
    Key? key,
    required this.statusText,
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
              padding: EdgeInsets.all(20.w),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          TextApp(
                            text: "Số bàn",
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                          TextApp(text: " | "),
                          TextApp(text: "Tên nhân viên")
                        ],
                      ),
                      Icon(Icons.more_horiz)
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    children: [TextApp(text: "19-02-2024 11:11:47")],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextApp(
                        text: "200,000",
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
                          color: Color.fromARGB(255, 215, 184, 6),
                          fontsize: 14.sp,
                        )
                      else if (statusText == "Hóa đơn đã hủy")
                        TextApp(
                          text: statusText,
                          color: const Color.fromARGB(255, 207, 28, 15),
                          fontsize: 14.sp,
                        )
                      else
                        TextApp(
                          text: statusText,
                          color: Color.fromARGB(255, 215, 184, 6),
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
