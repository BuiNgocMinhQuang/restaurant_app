import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/widgets/button_gradient.dart';
import 'package:app_restaurant/widgets/copy_right_text.dart';
import 'package:app_restaurant/widgets/gradient_text.dart';
import 'package:app_restaurant/widgets/text_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class StaffForgotPassword extends StatefulWidget {
  const StaffForgotPassword({super.key});

  @override
  State<StaffForgotPassword> createState() => _StaffForgotPasswordState();
}

class _StaffForgotPasswordState extends State<StaffForgotPassword> {
  bool light = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(248, 249, 250, 1),
        body: SafeArea(
          child: SingleChildScrollView(
              child: Column(
            children: [
              Padding(
                  padding: EdgeInsets.only(left: 20.w, right: 20.w),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Stack(
                            children: [
                              Container(
                                width: double.infinity,
                                height: 1.sh / 2,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.r),
                                    image: const DecorationImage(
                                      image: AssetImage(
                                          "assets/images/curved9.jpg"),
                                      fit: BoxFit.fill,
                                    )),
                              ),
                              Container(
                                width: double.infinity,
                                height: 1.sh / 2,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.r),
                                    color: Colors.black.withOpacity(0.5)),
                              ),
                              Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(30.w),
                                    child: ButtonGradient(
                                      color1:
                                          const Color.fromRGBO(121, 40, 202, 1),
                                      color2:
                                          const Color.fromRGBO(255, 0, 128, 1),
                                      event: () {
                                        context.go("/staff_sign_in");
                                      },
                                      text: "Đăng nhập với tư cách nhân viên",
                                      textColor: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 1.sh > 933 ? 1.sh / 3 : 1.sh / 4,
                                    left: 10.w,
                                    right: 10.w),
                                child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.r),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: const Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(20.w),
                                      child: Column(
                                        children: [
                                          GradientText(
                                            'Quên mật khẩu',
                                            style: TextStyle(
                                              color: const Color.fromRGBO(
                                                  52, 71, 103, 1),
                                              fontFamily: "Icomoon",
                                              fontWeight: FontWeight.bold,
                                              fontSize: 26.sp,
                                            ),
                                            gradient:
                                                const LinearGradient(colors: [
                                              Color.fromRGBO(33, 212, 253, 1),
                                              Color.fromRGBO(33, 82, 255, 1),
                                            ]),
                                          ),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          Center(
                                            child: TextApp(
                                              text:
                                                  "Chúng tôi sẽ gửi mã xác nhận về email của bạn trong vòng 60 giây",
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 30.h,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              TextApp(
                                                text: " Mã cửa hàng",
                                                fontsize: 10.sp,
                                                fontWeight: FontWeight.bold,
                                                color: blueText,
                                              ),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              TextField(
                                                cursorColor:
                                                    const Color.fromRGBO(
                                                        73, 80, 87, 1),
                                                decoration: InputDecoration(
                                                    fillColor:
                                                        const Color.fromARGB(
                                                            255, 226, 104, 159),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      214,
                                                                      51,
                                                                      123,
                                                                      0.6),
                                                              width: 2.0),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.r),
                                                    ),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.r),
                                                    ),
                                                    hintText: 'Mã cửa hàng',
                                                    isDense: true,
                                                    contentPadding:
                                                        EdgeInsets.all(
                                                            1.sw > 600
                                                                ? 20.w
                                                                : 15.w)),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 20.h,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              TextApp(
                                                text: " Email",
                                                fontsize: 10.sp,
                                                fontWeight: FontWeight.bold,
                                                color: blueText,
                                              ),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              TextField(
                                                cursorColor:
                                                    const Color.fromRGBO(
                                                        73, 80, 87, 1),
                                                decoration: InputDecoration(
                                                    fillColor:
                                                        const Color.fromARGB(
                                                            255, 226, 104, 159),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      214,
                                                                      51,
                                                                      123,
                                                                      0.6),
                                                              width: 2.0),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.r),
                                                    ),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.r),
                                                    ),
                                                    hintText: 'Email',
                                                    isDense: true,
                                                    contentPadding:
                                                        EdgeInsets.all(
                                                            1.sw > 600
                                                                ? 20.w
                                                                : 15.w)),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 40.h,
                                          ),
                                          ButtonGradient(
                                            color1: const Color.fromRGBO(
                                                33, 82, 255, 1),
                                            color2: const Color.fromRGBO(
                                                33, 212, 253, 1),
                                            event: () {},
                                            text: "Gửi",
                                            radius: 8.r,
                                            textColor: Colors.white,
                                          ),
                                        ],
                                      ),
                                    )),
                              ),
                              SizedBox(
                                height: 30.h,
                              ),
                              SizedBox(
                                width: 1.sw / 2,
                                // height: 80,
                                child: const CopyRightText(),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  )),
            ],
          )),
        ));
  }
}
