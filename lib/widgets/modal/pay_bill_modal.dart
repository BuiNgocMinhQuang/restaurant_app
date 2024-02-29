import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/config/space.dart';
import 'package:app_restaurant/widgets/button/button_app.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PayBillModal extends StatefulWidget {
  Function eventCloseButton;
  PayBillModal({Key? key, required this.eventCloseButton}) : super(key: key);

  @override
  State<PayBillModal> createState() => _PayBillModalState();
}

List<String> options = ["Tiền mặt", "Thẻ", "Chuyển khoản"];

class _PayBillModalState extends State<PayBillModal> {
  final moneySaleController = TextEditingController();

  String currentOptions = options[0];
  int selectedOption = 1;
  double totalMoney = 600000;
  double moneyMustPay = 10000;
  double moneySale = 0;

  void caculateMoneyMustPay() {
    moneyMustPay = totalMoney - moneySale;
    print(moneyMustPay);
  }

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
              height: 1.sh,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      width: 1.sw,
                      height: 50,
                      decoration: BoxDecoration(
                        border: const Border(
                            top: BorderSide(width: 0, color: Colors.grey),
                            bottom: BorderSide(width: 1, color: Colors.grey),
                            left: BorderSide(width: 0, color: Colors.grey),
                            right: BorderSide(width: 0, color: Colors.grey)),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15.w),
                            topRight: Radius.circular(15.w)),
                        // color: Colors.amber,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 20.w),
                                child: TextApp(
                                  text: "Table 1",
                                  fontsize: 18.sp,
                                  color: blueText,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 20.w),
                                child: TextApp(
                                  text: "Room 1",
                                  fontsize: 14.sp,
                                  color: blueText,
                                  fontWeight: FontWeight.normal,
                                ),
                              )
                            ],
                          )
                        ],
                      )),
                  Flexible(
                      fit: FlexFit.tight,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(10.w),
                              child: Container(
                                width: 1.sw,
                                // height: 100.h,
                                // color: Colors.green,
                                child: Column(
                                  children: [
                                    Container(
                                        width: 1.sw,
                                        height: 40.h,
                                        color: Colors.grey,
                                        child: Padding(
                                            padding: EdgeInsets.only(left: 5.h),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                TextApp(
                                                  text: "Hóa đơn",
                                                  color: Colors.white,
                                                  fontsize: 14.sp,
                                                ),
                                              ],
                                            ))),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            TextApp(
                                              text: "Tên món ăn",
                                              color: Colors.black,
                                              fontsize: 14.sp,
                                            ),
                                            TextApp(
                                              text: "thit heo nuong",
                                              color: Colors.black,
                                              fontsize: 14.sp,
                                            ),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            TextApp(
                                              text: "Số lượng",
                                              color: Colors.black,
                                              fontsize: 14.sp,
                                            ),
                                            TextApp(
                                              text: "3",
                                              color: Colors.black,
                                              fontsize: 14.sp,
                                            ),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            TextApp(
                                              text: "Giá",
                                              color: Colors.black,
                                              fontsize: 14.sp,
                                            ),
                                            TextApp(
                                              text: "200,000",
                                              color: Colors.black,
                                              fontsize: 14.sp,
                                            ),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            TextApp(
                                              text: "Tổng",
                                              color: Colors.black,
                                              fontsize: 14.sp,
                                            ),
                                            TextApp(
                                              text: "600,000",
                                              color: Colors.black,
                                              fontsize: 14.sp,
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                    // Column(
                                    //   children: [
                                    //     ListView.builder(
                                    //         itemCount: 3,
                                    //         itemBuilder: (context, index) {
                                    //           return Row(
                                    //             crossAxisAlignment:
                                    //                 CrossAxisAlignment.center,
                                    //             mainAxisAlignment:
                                    //                 MainAxisAlignment
                                    //                     .spaceBetween,
                                    //             children: [
                                    //               Column(
                                    //                 mainAxisAlignment:
                                    //                     MainAxisAlignment
                                    //                         .center,
                                    //                 children: [
                                    //                   TextApp(
                                    //                     text: "Tên món ăn",
                                    //                     color: Colors.black,
                                    //                     fontsize: 14.sp,
                                    //                   ),
                                    //                   TextApp(
                                    //                     text: "thit heo nuong",
                                    //                     color: Colors.black,
                                    //                     fontsize: 14.sp,
                                    //                   ),
                                    //                 ],
                                    //               ),
                                    //               Column(
                                    //                 mainAxisAlignment:
                                    //                     MainAxisAlignment
                                    //                         .center,
                                    //                 children: [
                                    //                   TextApp(
                                    //                     text: "Số lượng",
                                    //                     color: Colors.black,
                                    //                     fontsize: 14.sp,
                                    //                   ),
                                    //                   TextApp(
                                    //                     text: "3",
                                    //                     color: Colors.black,
                                    //                     fontsize: 14.sp,
                                    //                   ),
                                    //                 ],
                                    //               ),
                                    //               Column(
                                    //                 mainAxisAlignment:
                                    //                     MainAxisAlignment
                                    //                         .center,
                                    //                 children: [
                                    //                   TextApp(
                                    //                     text: "Giá",
                                    //                     color: Colors.black,
                                    //                     fontsize: 14.sp,
                                    //                   ),
                                    //                   TextApp(
                                    //                     text: "200,000",
                                    //                     color: Colors.black,
                                    //                     fontsize: 14.sp,
                                    //                   ),
                                    //                 ],
                                    //               ),
                                    //               Column(
                                    //                 mainAxisAlignment:
                                    //                     MainAxisAlignment
                                    //                         .center,
                                    //                 children: [
                                    //                   TextApp(
                                    //                     text: "Tổng",
                                    //                     color: Colors.black,
                                    //                     fontsize: 14.sp,
                                    //                   ),
                                    //                   TextApp(
                                    //                     text: "600,000",
                                    //                     color: Colors.black,
                                    //                     fontsize: 14.sp,
                                    //                   ),
                                    //                 ],
                                    //               ),
                                    //             ],
                                    //           );
                                    //         })
                                    //   ],
                                    // )
                                  ],
                                ),
                              ),
                            ),
                            Divider(
                              height: 1,
                              color: Colors.grey,
                            ),
                            Padding(
                              padding: EdgeInsets.all(10.w),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextApp(
                                        text: "Tổng",
                                        color: Colors.black,
                                        fontsize: 14.sp,
                                      ),
                                      TextApp(
                                        text: "600,000",
                                        color: Colors.black,
                                        fontsize: 14.sp,
                                      ),
                                    ],
                                  ),
                                  space20H,
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextApp(
                                          text: "22-02-2024 13:44:51",
                                          fontsize: 14.sp),
                                      space5W,
                                      Icon(
                                        Icons.access_time_filled,
                                        size: 14.sp,
                                        color: Colors.grey,
                                      )
                                    ],
                                  ),
                                  space20H,
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextApp(
                                        text: "Tổng tiền món",
                                        color: Colors.black,
                                        fontsize: 14.sp,
                                      ),
                                      TextApp(
                                        text: totalMoney.toString(),
                                        color: Colors.black,
                                        fontsize: 14.sp,
                                      ),
                                    ],
                                  ),
                                  space20H,
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextApp(
                                        text: "Giảm giá",
                                        color: Colors.black,
                                        fontsize: 14.sp,
                                      ),
                                      Container(
                                        width: 200.w,
                                        // height: 20.h,
                                        child: TextField(
                                          style: TextStyle(
                                              fontSize: 12.sp, color: grey),
                                          controller: moneySaleController,
                                          onEditingComplete: () {
                                            caculateMoneyMustPay();
                                          },
                                          cursorColor: grey,
                                          decoration: InputDecoration(
                                              fillColor: const Color.fromARGB(
                                                  255, 226, 104, 159),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Color.fromRGBO(
                                                        214, 51, 123, 0.6),
                                                    width: 2.0),
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                              ),
                                              hintText: '',
                                              isDense: true,
                                              contentPadding:
                                                  EdgeInsets.all(15.w)),
                                        ),
                                      )
                                    ],
                                  ),
                                  space20H,
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextApp(
                                        text: "Khách cần trả",
                                        color: Colors.black,
                                        fontsize: 14.sp,
                                      ),
                                      TextApp(
                                        text: moneyMustPay.toString(),
                                        color: Colors.black,
                                        fontsize: 14.sp,
                                      ),
                                    ],
                                  ),
                                  space20H,
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextApp(
                                        text: "Khách thanh toán",
                                        color: Colors.black,
                                        fontsize: 14.sp,
                                      ),
                                      Container(
                                        width: 200.w,
                                        // height: 20.h,
                                        child: TextField(
                                          style: TextStyle(
                                              fontSize: 12.sp, color: grey),
                                          cursorColor: grey,
                                          decoration: InputDecoration(
                                              fillColor: const Color.fromARGB(
                                                  255, 226, 104, 159),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Color.fromRGBO(
                                                        214, 51, 123, 0.6),
                                                    width: 2.0),
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                              ),
                                              hintText: '',
                                              isDense: true,
                                              contentPadding:
                                                  EdgeInsets.all(15.w)),
                                        ),
                                      )
                                    ],
                                  ),
                                  space20H,
                                  Container(
                                      width: 1.sw,
                                      // color: Colors.amber,
                                      height: 30.h,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Radio(
                                                activeColor: Colors.black,
                                                value: options[0],
                                                groupValue: currentOptions,
                                                onChanged: (value) {
                                                  setState(() {
                                                    currentOptions =
                                                        value.toString();
                                                  });
                                                },
                                              ),
                                              TextApp(
                                                text: options[0],
                                                color: Colors.black,
                                                fontsize: 14.sp,
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Radio(
                                                activeColor: Colors.black,
                                                value: options[1],
                                                groupValue: currentOptions,
                                                onChanged: (value) {
                                                  setState(() {
                                                    currentOptions =
                                                        value.toString();
                                                  });
                                                },
                                              ),
                                              TextApp(
                                                text: options[1],
                                                color: Colors.black,
                                                fontsize: 14.sp,
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Radio(
                                                activeColor: Colors.black,
                                                value: options[2],
                                                groupValue: currentOptions,
                                                onChanged: (value) {
                                                  setState(() {
                                                    currentOptions =
                                                        value.toString();
                                                  });
                                                },
                                              ),
                                              TextApp(
                                                text: options[2],
                                                color: Colors.black,
                                                fontsize: 14.sp,
                                              )
                                            ],
                                          )
                                        ],
                                      )),
                                  space20H,
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextApp(
                                        text: "Tiền thừa trả khách",
                                        color: Colors.black,
                                        fontsize: 14.sp,
                                      ),
                                      TextApp(
                                        text: "600,000",
                                        color: Colors.black,
                                        fontsize: 14.sp,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )),
                  Container(
                    width: 1.sw,
                    height: 80,
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ButtonApp(
                          event: () {
                            widget.eventCloseButton();
                          },
                          text: "Đóng",
                          colorText: Colors.white,
                          backgroundColor: Color.fromRGBO(131, 146, 171, 1),
                          outlineColor: Color.fromRGBO(131, 146, 171, 1),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        )));
  }
}
