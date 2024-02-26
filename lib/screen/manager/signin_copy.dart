import 'package:app_restaurant/widgets/background_welcome.dart';
import 'package:app_restaurant/widgets/button_gradient.dart';
import 'package:app_restaurant/widgets/copy_right_text.dart';
import 'package:app_restaurant/widgets/text_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app_restaurant/config/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ManagerSignInCopy extends StatefulWidget {
  const ManagerSignInCopy({super.key});

  @override
  State<ManagerSignInCopy> createState() => _ManagerSignInCopyState();
}

class _ManagerSignInCopyState extends State<ManagerSignInCopy> {
  bool light = false;
  bool passwordVisible = true;
  bool passToogle = true;
  final _formField = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passworldController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color.fromRGBO(248, 249, 250, 1),
        body: SafeArea(
          child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Form(
                  key: _formField,
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
                                            borderRadius:
                                                BorderRadius.circular(15.r),
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
                                            borderRadius:
                                                BorderRadius.circular(15.r),
                                            color:
                                                Colors.black.withOpacity(0.5)),
                                      ),
                                      Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(20.w),
                                            child: ButtonGradient(
                                              color1: pupple,
                                              color2: red,
                                              event: () {
                                                context.go("/staff_sign_in");
                                              },
                                              fontSize: 12.sp,
                                              text:
                                                  "Đăng nhập với tư cách nhân viên",
                                              textColor: Colors.white,
                                            ),
                                          ),
                                          const BackgroundWelcome()
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 1.sh > 933
                                                ? 1.sh / 3
                                                : 1.sh / 4,
                                            left: 10.w,
                                            right: 10.w),
                                        child: Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15.r),
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
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
                                                  Text(
                                                    "Đăng nhập",
                                                    style: TextStyle(
                                                      color:
                                                          const Color.fromRGBO(
                                                              52, 71, 103, 1),
                                                      fontFamily: "Icomoon",
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 24.sp,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10.w,
                                                  ),
                                                  Container(
                                                    height: 40.h,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.r),
                                                        color: Colors.amber,
                                                        gradient:
                                                            const LinearGradient(
                                                          begin: Alignment
                                                              .topRight,
                                                          end: Alignment
                                                              .bottomLeft,
                                                          colors: [
                                                            organe,
                                                            yellow,
                                                          ],
                                                        )),
                                                    child: Center(
                                                      child: TextApp(
                                                          text:
                                                              "Bạn đang đăng nhập với tư cách chủ cửa hàng!",
                                                          textAlign:
                                                              TextAlign.center,
                                                          color: Colors.white,
                                                          fontFamily:
                                                              "OpenSans",
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontsize: 12.sp),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 30.w,
                                                  ),
                                                  TextFormField(
                                                    controller: emailController,
                                                    keyboardType: TextInputType
                                                        .emailAddress,
                                                    style: TextStyle(
                                                        fontSize: 12.sp,
                                                        color: grey),
                                                    cursorColor: grey,
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return "Email không được để trống";
                                                      }
                                                      bool emailValid = RegExp(
                                                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                                          .hasMatch(value);
                                                      if (!emailValid) {
                                                        return "Email hop le";
                                                      }
                                                    },
                                                    decoration: InputDecoration(
                                                      suffix: InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            passToogle =
                                                                !passToogle;
                                                          });
                                                        },
                                                      ),
                                                      fillColor:
                                                          const Color.fromARGB(
                                                              255,
                                                              226,
                                                              104,
                                                              159),
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
                                                            BorderRadius
                                                                .circular(8.r),
                                                      ),
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.r),
                                                      ),
                                                      hintText: 'Email',
                                                      isDense: true,
                                                      contentPadding:
                                                          EdgeInsets.all(15.w),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 20.w,
                                                  ),
                                                  TextFormField(
                                                    controller:
                                                        passworldController,
                                                    obscureText:
                                                        passwordVisible,
                                                    style: TextStyle(
                                                        fontSize: 12.sp,
                                                        color: grey),
                                                    cursorColor: grey,
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return "Mật khẩu không được để trống";
                                                      } else {
                                                        return null;
                                                      }
                                                    },
                                                    decoration: InputDecoration(
                                                        suffixIconColor:
                                                            Color.fromARGB(255,
                                                                226, 104, 159),
                                                        suffixIcon: IconButton(
                                                            onPressed: () {
                                                              setState(
                                                                () {
                                                                  passwordVisible =
                                                                      !passwordVisible;
                                                                },
                                                              );
                                                            },
                                                            icon: Icon(passwordVisible
                                                                ? Icons
                                                                    .visibility_off
                                                                : Icons
                                                                    .visibility)),
                                                        fillColor: const Color
                                                            .fromARGB(
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
                                                              BorderRadius
                                                                  .circular(
                                                                      8.r),
                                                        ),
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.r),
                                                        ),
                                                        hintText: 'Mật khẩu',
                                                        isDense: true,
                                                        contentPadding:
                                                            EdgeInsets.all(
                                                                15.w)),
                                                  ),
                                                  SizedBox(
                                                    height: 20.h,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      SizedBox(
                                                        width: 50.w,
                                                        height: 30.w,
                                                        child: FittedBox(
                                                          fit: BoxFit.fill,
                                                          child:
                                                              CupertinoSwitch(
                                                            value: light,
                                                            activeColor:
                                                                const Color
                                                                    .fromRGBO(
                                                                    58,
                                                                    65,
                                                                    111,
                                                                    .95),
                                                            onChanged:
                                                                (bool value) {
                                                              setState(() {
                                                                light = value;
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10.w,
                                                      ),
                                                      TextApp(
                                                          text:
                                                              "Ghi nhớ tài khoản",
                                                          textAlign:
                                                              TextAlign.center,
                                                          color: grey,
                                                          fontFamily:
                                                              "OpenSans",
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontsize: 12.sp),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 20.h,
                                                  ),
                                                  ButtonGradient(
                                                    color1:
                                                        const Color.fromRGBO(
                                                            33, 82, 255, 1),
                                                    color2:
                                                        const Color.fromRGBO(
                                                            33, 212, 253, 1),
                                                    event: () {
                                                      if (_formField
                                                          .currentState!
                                                          .validate()) {
                                                        print("Login Succecs");
                                                        context.go(
                                                            '/manager_home');
                                                        emailController.clear();
                                                        passworldController
                                                            .clear();
                                                      }
                                                    },
                                                    text: "Đăng nhập",
                                                    fontSize: 12.sp,
                                                    radius: 8.r,
                                                    textColor: Colors.white,
                                                  ),
                                                  SizedBox(
                                                    height: 20.h,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        width: 100,
                                                        height: 1, // Thickness
                                                        color: Color.fromRGBO(
                                                            103, 116, 142, 1),
                                                      ),
                                                      SizedBox(
                                                        width: 12.w,
                                                      ),
                                                      Text(
                                                        "hoặc",
                                                        style: TextStyle(
                                                          fontSize: 12.sp,
                                                          color: Color.fromRGBO(
                                                              103, 116, 142, 1),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 12.w,
                                                      ),
                                                      Container(
                                                        width: 100,
                                                        height: 1, // Thickness
                                                        color: Color.fromRGBO(
                                                            103, 116, 142, 1),
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 20.h,
                                                  ),
                                                  ButtonGradient(
                                                    color1:
                                                        const Color.fromRGBO(
                                                            20, 23, 39, 1),
                                                    color2:
                                                        const Color.fromRGBO(
                                                            58, 65, 111, 1),
                                                    event: () {
                                                      context.go(
                                                          "/manager_sign_up");
                                                    },
                                                    text: "Đăng ký",
                                                    fontSize: 12.sp,
                                                    radius: 8.r,
                                                    textColor: Colors.white,
                                                  ),
                                                  SizedBox(
                                                    height: 20.h,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      context.go(
                                                          "/manager_forgot_password");
                                                    },
                                                    child: TextApp(
                                                      text: "Quên mật khẩu?",
                                                      color:
                                                          const Color.fromRGBO(
                                                              52, 71, 103, 1),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: "OpenSans",
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )),
                                      ),
                                      SizedBox(
                                        height: 30.h,
                                      ),
                                      SizedBox(
                                        width: 1.sw / 2,
                                        child: const CopyRightText(),
                                      ),
                                    ],
                                  )
                                ],
                              )
                            ],
                          )),
                    ],
                  ))),
        ));
  }
}
