import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/config/space.dart';
import 'package:app_restaurant/widgets/button/button_app.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SeeBillModal extends StatefulWidget {
  final Function eventCloseButton;
  const SeeBillModal({
    Key? key,
    required this.eventCloseButton,
  }) : super(key: key);

  @override
  State<SeeBillModal> createState() => _SeeBillModalState();
}

class _SeeBillModalState extends State<SeeBillModal>
    with TickerProviderStateMixin {
  int _counter = 1;
  bool isDelete = false;
  void _increase() {
    setState(() {
      _counter++;
    });
  }

  void _decrease() {
    if (_counter == 1) {
      setState(() {
        isDelete = true;
      });
    } else {
      setState(() {
        _counter--;
      });
    }
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
                    child: Padding(
                      padding: EdgeInsets.all(20.w),
                      child: Column(
                        children: [
                          Flexible(
                            fit: FlexFit.tight,
                            child: Column(
                              children: [
                                Container(
                                    width: 1.sw,
                                    // height: 100.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.r),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 4,
                                          offset: const Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 1.sw,
                                          // height: 30.h,
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              begin: Alignment.topRight,
                                              end: Alignment.bottomLeft,
                                              colors: [
                                                Color.fromRGBO(33, 82, 255, 1),
                                                Color.fromRGBO(33, 212, 253, 1),
                                              ],
                                            ),
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10.r),
                                                topRight:
                                                    Radius.circular(10.r)),
                                            color: Colors.blue,
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                top: 10.h,
                                                left: 10.w,
                                                bottom: 10.h),
                                            child: TextApp(
                                              text: "Tổng quan",
                                              fontsize: 18.sp,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 1.sw,
                                          // height: 30.h,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15.r),
                                            color: Colors.white,
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(20.w),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    TextApp(
                                                        text:
                                                            "22-02-2024 13:44:51",
                                                        fontsize: 14.sp),
                                                    SizedBox(
                                                      width: 5.w,
                                                    ),
                                                    Icon(
                                                      Icons.access_time_filled,
                                                      size: 14.sp,
                                                      color: Colors.grey,
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 15.h,
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    TextApp(
                                                      text: "Tổng tiền",
                                                      fontsize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    TextApp(
                                                        text: "200,000 đ",
                                                        fontsize: 14.sp),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    )),
                                SizedBox(
                                  height: 20.h,
                                ),
                                Flexible(
                                  fit: FlexFit.tight,
                                  child: Container(
                                      width: 1.sw,
                                      // height: 100.h,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 2,
                                            blurRadius: 4,
                                            offset: const Offset(0,
                                                3), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            width: 1.sw,
                                            // height: 30.h,
                                            decoration: BoxDecoration(
                                              gradient: const LinearGradient(
                                                begin: Alignment.topRight,
                                                end: Alignment.bottomLeft,
                                                colors: [
                                                  Color.fromRGBO(
                                                      33, 82, 255, 1),
                                                  Color.fromRGBO(
                                                      33, 212, 253, 1),
                                                ],
                                              ),
                                              borderRadius: BorderRadius.only(
                                                  topLeft:
                                                      Radius.circular(10.r),
                                                  topRight:
                                                      Radius.circular(10.r)),
                                              color: Colors.blue,
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  top: 10.h,
                                                  left: 10.w,
                                                  bottom: 10.h),
                                              child: TextApp(
                                                text:
                                                    "Danh sách món ăn được chọn",
                                                fontsize: 18.sp,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                              child: Container(
                                            width: 1.sw,
                                            // height: 100.h,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(10.r),
                                                  bottomRight:
                                                      Radius.circular(10.r)),
                                              color: Colors.white,
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 20.w, right: 20.w),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  // SizedBox(
                                                  //   height: 200.h,
                                                  //   child:
                                                  // ),
                                                  Flexible(
                                                    child: ListView.builder(
                                                        itemCount: 10,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return !isDelete
                                                              ? Column(
                                                                  children: [
                                                                    Padding(
                                                                      padding: EdgeInsets.only(
                                                                          bottom:
                                                                              10.h),
                                                                      child: SizedBox(
                                                                          width: 1.sw,
                                                                          child: Padding(
                                                                            padding:
                                                                                EdgeInsets.all(20.w),
                                                                            child:
                                                                                Column(
                                                                              children: [
                                                                                Row(
                                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  children: [
                                                                                    SizedBox(
                                                                                      width: 50.w,
                                                                                      height: 50.w,
                                                                                      child: Image.asset(
                                                                                        "assets/images/banner1.png",
                                                                                        fit: BoxFit.cover,
                                                                                      ),
                                                                                    ),
                                                                                    space50W,
                                                                                    Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                                      children: [
                                                                                        TextApp(text: "Ten mon an"),
                                                                                        TextApp(text: "Gia mon an")
                                                                                      ],
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                                SizedBox(
                                                                                  height: 15.h,
                                                                                ),
                                                                                Container(
                                                                                    width: 1.sw,
                                                                                    decoration: BoxDecoration(
                                                                                      borderRadius: BorderRadius.all(Radius.circular(8.r)),

                                                                                      // color:
                                                                                      //     Colors.pink,
                                                                                    ),
                                                                                    child: IntrinsicHeight(
                                                                                      child: Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                                                                        children: [
                                                                                          InkWell(
                                                                                            onTap: _decrease,
                                                                                            child: Container(
                                                                                              width: 50.w,
                                                                                              height: 25.w,
                                                                                              decoration: BoxDecoration(
                                                                                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(8.r), bottomLeft: Radius.circular(8.r)),
                                                                                                  gradient: const LinearGradient(
                                                                                                    begin: Alignment.topRight,
                                                                                                    end: Alignment.bottomLeft,
                                                                                                    colors: [
                                                                                                      Color.fromRGBO(33, 82, 255, 1),
                                                                                                      Color.fromRGBO(33, 212, 253, 1)
                                                                                                    ],
                                                                                                  )),
                                                                                              child: Center(
                                                                                                child: TextApp(text: "-", textAlign: TextAlign.center, color: Colors.white, fontsize: 14.sp),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                              child: Container(
                                                                                            decoration: BoxDecoration(
                                                                                              border: Border.all(width: 0.4, color: Colors.grey),
                                                                                            ),
                                                                                            child: Center(
                                                                                              child: TextApp(
                                                                                                text: "$_counter",
                                                                                                textAlign: TextAlign.center,
                                                                                              ),
                                                                                            ),
                                                                                          )),
                                                                                          InkWell(
                                                                                            onTap: _increase,
                                                                                            child: Container(
                                                                                              width: 50.w,
                                                                                              height: 25.w,
                                                                                              decoration: BoxDecoration(
                                                                                                  borderRadius: BorderRadius.only(topRight: Radius.circular(8.r), bottomRight: Radius.circular(8.r)),
                                                                                                  gradient: const LinearGradient(
                                                                                                    begin: Alignment.topRight,
                                                                                                    end: Alignment.bottomLeft,
                                                                                                    colors: [
                                                                                                      Color.fromRGBO(33, 82, 255, 1),
                                                                                                      Color.fromRGBO(33, 212, 253, 1)
                                                                                                    ],
                                                                                                  )),
                                                                                              child: Center(
                                                                                                child: TextApp(
                                                                                                  text: "+",
                                                                                                  textAlign: TextAlign.center,
                                                                                                  color: Colors.white,
                                                                                                  fontsize: 14.sp,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          )
                                                                                        ],
                                                                                      ),
                                                                                    )),
                                                                              ],
                                                                            ),
                                                                          )),
                                                                    ),
                                                                    const Divider(
                                                                      height: 1,
                                                                      color: Colors
                                                                          .grey,
                                                                    )
                                                                  ],
                                                                )
                                                              : Container();
                                                        }),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ))
                                        ],
                                      )),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
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
                          backgroundColor:
                              const Color.fromRGBO(131, 146, 171, 1),
                          outlineColor: const Color.fromRGBO(131, 146, 171, 1),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        )));
  }
}
