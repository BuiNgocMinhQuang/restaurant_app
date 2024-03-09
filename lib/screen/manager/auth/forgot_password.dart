import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/config/text.dart';
import 'package:app_restaurant/widgets/button/button_gradient.dart';
import 'package:app_restaurant/widgets/text/copy_right_text.dart';
import 'package:app_restaurant/widgets/text/gradient_text.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ManagerForgotPassword extends StatefulWidget {
  const ManagerForgotPassword({super.key});

  @override
  State<ManagerForgotPassword> createState() => _ManagerForgotPasswordState();
}

class _ManagerForgotPasswordState extends State<ManagerForgotPassword> {
  bool light = true;
  final _formField = GlobalKey<FormState>();
  final emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                                          color: Colors.black.withOpacity(0.5)),
                                    ),
                                    Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(30.w),
                                          child: ButtonGradient(
                                            color1: pupple,
                                            color2: red,
                                            event: () {
                                              context.go("/");
                                            },
                                            text: signInAsManager,
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
                                                GradientText(
                                                  forgotPassword,
                                                  style: TextStyle(
                                                    color: const Color.fromRGBO(
                                                        52, 71, 103, 1),
                                                    fontFamily: "Icomoon",
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 24.sp,
                                                  ),
                                                  gradient:
                                                      const LinearGradient(
                                                          colors: [
                                                        Color.fromRGBO(
                                                            33, 212, 253, 1),
                                                        Color.fromRGBO(
                                                            33, 82, 255, 1),
                                                      ]),
                                                ),
                                                SizedBox(
                                                  height: 10.h,
                                                ),
                                                Center(
                                                  child: TextApp(
                                                    text: sendCodeIn60Sec,
                                                    textAlign: TextAlign.center,
                                                    fontsize: 12.sp,
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
                                                      text: " Email",
                                                      fontsize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: blueText,
                                                    ),
                                                    SizedBox(
                                                      height: 10.h,
                                                    ),
                                                    TextFormField(
                                                      controller:
                                                          emailController,
                                                      style: TextStyle(
                                                          fontSize: 14.sp,
                                                          color: grey),
                                                      cursorColor: grey,
                                                      validator: (value) {
                                                        if (value!.isEmpty) {
                                                          return emailIsRequied;
                                                        }
                                                        bool emailValid = RegExp(
                                                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                                            .hasMatch(value);

                                                        if (!emailValid) {
                                                          return invalidEmail;
                                                        } else {
                                                          return null;
                                                        }
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                              fillColor:
                                                                  const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      226,
                                                                      104,
                                                                      159),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderSide: const BorderSide(
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
                                                              hintText: 'Email',
                                                              isDense: true,
                                                              contentPadding:
                                                                  EdgeInsets
                                                                      .all(15
                                                                          .w)),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 40.h,
                                                ),
                                                ButtonGradient(
                                                  color1: color1BlueButton,
                                                  color2: color2BlueButton,
                                                  event: () {
                                                    if (_formField.currentState!
                                                        .validate()) {
                                                      emailController.clear();
                                                      context.go(
                                                          "/manager_confirm_otp");
                                                    }
                                                  },
                                                  text: send,
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
                ),
              )),
        ));
  }
}
