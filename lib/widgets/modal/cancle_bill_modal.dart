import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/config/space.dart';
import 'package:app_restaurant/widgets/button/button_app.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

List<String> optionsCancle = [
  "Đổi trả lại",
  "Thêm nhầm đơn hàng",
  "Khách báo hủy",
  "Khác"
];

class CancleBillModal extends StatefulWidget {
  final Function eventCloseButton;
  const CancleBillModal({Key? key, required this.eventCloseButton})
      : super(key: key);

  @override
  State<CancleBillModal> createState() => _CancleBillModalState();
}

class _CancleBillModalState extends State<CancleBillModal> {
  String currentOptions = optionsCancle[0];

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 1.sw,
        height: 1.sh,
        color: Colors.black.withOpacity(0.3),
        child: Center(
            child: Padding(
          padding: EdgeInsets.only(
              top: 150.h, bottom: 160.h, left: 35.w, right: 35.w),
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
                        TextApp(
                          text: "Hủy đơn",
                          fontsize: 18.sp,
                          color: blueText,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                    space10H,
                    const Divider(
                      height: 1,
                      color: Colors.black,
                    ),
                    space10H,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextApp(
                          text: "Lý do hủy đơn",
                          fontsize: 14.sp,
                          color: blueText,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                    space5H,
                    Column(
                      children: [
                        Row(
                          children: [
                            Radio(
                              activeColor: Colors.black,
                              value: optionsCancle[0],
                              groupValue: currentOptions,
                              onChanged: (value) {
                                setState(() {
                                  currentOptions = value.toString();
                                });
                              },
                            ),
                            TextApp(
                              text: optionsCancle[0],
                              color: Colors.black,
                              fontsize: 14.sp,
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Radio(
                              activeColor: Colors.black,
                              value: optionsCancle[1],
                              groupValue: currentOptions,
                              onChanged: (value) {
                                setState(() {
                                  currentOptions = value.toString();
                                });
                              },
                            ),
                            TextApp(
                              text: optionsCancle[1],
                              color: Colors.black,
                              fontsize: 14.sp,
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Radio(
                              activeColor: Colors.black,
                              value: optionsCancle[2],
                              groupValue: currentOptions,
                              onChanged: (value) {
                                setState(() {
                                  currentOptions = value.toString();
                                });
                              },
                            ),
                            TextApp(
                              text: optionsCancle[2],
                              color: Colors.black,
                              fontsize: 14.sp,
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Radio(
                              activeColor: Colors.black,
                              value: optionsCancle[3],
                              groupValue: currentOptions,
                              onChanged: (value) {
                                setState(() {
                                  currentOptions = value.toString();
                                });
                              },
                            ),
                            TextApp(
                              text: optionsCancle[3],
                              color: Colors.black,
                              fontsize: 14.sp,
                            )
                          ],
                        )
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
                            widget.eventCloseButton();
                          },
                          text: "Đóng".toUpperCase(),
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
                          text: "Xác nhận".toUpperCase(),
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
