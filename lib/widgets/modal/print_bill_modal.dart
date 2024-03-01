import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/config/space.dart';
import 'package:app_restaurant/widgets/button/button_app.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrintBillModal extends StatelessWidget {
  final Function eventCloseButton;
  const PrintBillModal({Key? key, required this.eventCloseButton})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 1.sw,
        height: 1.sh,
        color: Colors.black.withOpacity(0.3),
        child: Center(
            child: Padding(
          padding:
              EdgeInsets.only(top: 80.h, bottom: 80.h, left: 35.w, right: 35.w),
          child: Container(
              width: 1.sw,
              // height: 1.sh,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                color: Colors.white,
              ),
              child: Padding(
                padding: EdgeInsets.only(
                    top: 20.w, bottom: 20.w, left: 10.w, right: 10.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextApp(
                              text: "Phòng 1",
                              fontsize: 18.sp,
                              color: blueText,
                              fontWeight: FontWeight.bold,
                            ),
                            TextApp(
                              text: "Bàn 1",
                              fontsize: 16.sp,
                              color: blueText,
                            ),
                          ],
                        ),
                      ],
                    ),
                    space10H,
                    const Divider(
                      height: 1,
                      color: Colors.black,
                    ),
                    space10H,
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextApp(
                          text: "Shop 1",
                          fontsize: 18.sp,
                          color: blueText,
                          fontWeight: FontWeight.bold,
                        ),
                        space5W,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextApp(
                              text: "Địa chỉ: ",
                              fontsize: 16.sp,
                              color: blueText,
                            ),
                            space10W,
                            TextApp(
                              text: "123 duong abc",
                              fontsize: 16.sp,
                              color: blueText,
                            ),
                          ],
                        )
                      ],
                    ),
                    space5H,
                    const MySeparator(color: Colors.grey),
                    space10H,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            TextApp(
                              text: "Giờ vào: ",
                              fontsize: 16.sp,
                              color: blueText,
                              fontWeight: FontWeight.bold,
                            ),
                            TextApp(
                              text: "27-02-2024",
                              fontsize: 16.sp,
                              color: blueText,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            TextApp(
                              text: "Giờ ra:  ",
                              fontsize: 16.sp,
                              color: blueText,
                              fontWeight: FontWeight.bold,
                            ),
                            TextApp(
                              text: "29-02-2024",
                              fontsize: 16.sp,
                              color: blueText,
                            ),
                          ],
                        )
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextApp(
                          text: "16:04:57",
                          fontsize: 16.sp,
                          color: blueText,
                        ),
                        TextApp(
                          text: "11:45:19",
                          fontsize: 16.sp,
                          color: blueText,
                        ),
                      ],
                    ),
                    space5H,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            TextApp(
                              text: "Tên khách hàng: ",
                              fontsize: 16.sp,
                              color: blueText,
                              fontWeight: FontWeight.bold,
                            ),
                            TextApp(
                              text: "Nguyen Van A",
                              fontsize: 16.sp,
                              color: blueText,
                            ),
                          ],
                        ),
                      ],
                    ),
                    space35H,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextApp(
                          text: "Tổng tiền món ",
                          fontsize: 16.sp,
                          color: blueText,
                          fontWeight: FontWeight.bold,
                        ),
                        TextApp(
                          text: "45,000",
                          fontsize: 16.sp,
                          color: blueText,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextApp(
                          text: "Giảm giá ",
                          fontsize: 16.sp,
                          color: blueText,
                          fontWeight: FontWeight.bold,
                        ),
                        TextApp(
                          text: "20,000",
                          fontsize: 16.sp,
                          color: blueText,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextApp(
                          text: "Khách cần trả ",
                          fontsize: 16.sp,
                          color: blueText,
                          fontWeight: FontWeight.bold,
                        ),
                        TextApp(
                          text: "45,000",
                          fontsize: 16.sp,
                          color: blueText,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextApp(
                          text: "Khách thanh toán ",
                          fontsize: 16.sp,
                          color: blueText,
                          fontWeight: FontWeight.bold,
                        ),
                        TextApp(
                          text: "45,000",
                          fontsize: 16.sp,
                          color: blueText,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextApp(
                          text: "Loại thanh toán ",
                          fontsize: 16.sp,
                          color: blueText,
                          fontWeight: FontWeight.bold,
                        ),
                        TextApp(
                          text: "Tiền mặt",
                          fontsize: 16.sp,
                          color: blueText,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextApp(
                          text: "Tiền thừa trả khách ",
                          fontsize: 16.sp,
                          color: blueText,
                          fontWeight: FontWeight.bold,
                        ),
                        TextApp(
                          text: "45,000",
                          fontsize: 16.sp,
                          color: blueText,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                    space15H,
                    const Divider(
                      height: 1,
                      color: Colors.black,
                    ),
                    space15H,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ButtonApp(
                          event: () {
                            eventCloseButton();
                          },
                          text: "Đóng",
                          colorText: Colors.white,
                          backgroundColor:
                              const Color.fromRGBO(131, 146, 171, 1),
                          outlineColor: const Color.fromRGBO(131, 146, 171, 1),
                        ),
                        SizedBox(
                          width: 20.w,
                        ),
                        ButtonApp(
                          event: () {
                            // widget.eventSaveButton();
                          },
                          text: "In",
                          colorText: Colors.white,
                          backgroundColor:
                              const Color.fromRGBO(23, 193, 232, 1),
                          outlineColor: const Color.fromRGBO(23, 193, 232, 1),
                        ),
                        SizedBox(
                          width: 20.w,
                        ),
                      ],
                    ),
                  ],
                ),
              )),
        )));
  }
}

class MySeparator extends StatelessWidget {
  const MySeparator({Key? key, this.height = 1, this.color = Colors.black})
      : super(key: key);
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 3.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
        );
      },
    );
  }
}
