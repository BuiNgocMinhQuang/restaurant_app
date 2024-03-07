import 'dart:math';

import 'package:app_restaurant/config/text.dart';
import 'package:app_restaurant/widgets/background_welcome.dart';
import 'package:app_restaurant/widgets/button/button_gradient.dart';
import 'package:app_restaurant/widgets/text/copy_right_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/config/all_void.dart';

class ManagerSignUp extends StatefulWidget {
  const ManagerSignUp({super.key});

  @override
  State<ManagerSignUp> createState() => _ManagerSignUpState();
}

class _ManagerSignUpState extends State<ManagerSignUp> {
  bool isChecked = false;
  bool passwordVisible = true;
  bool rePasswordVisible = true;
  final _formField = GlobalKey<FormState>();
  final surNameController = TextEditingController();
  final nameController = TextEditingController();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passworldController = TextEditingController();
  final rePassworldController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    //style checkbox
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return blueText;
      }
      return blueText;
    }

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
                                          padding: EdgeInsets.all(20.w),
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
                                          top: 1.sh > 933 ? 1.sh / 3 : 1.sh / 4,
                                          left: 10.w,
                                          right: 10.w),
                                      child: Container(
                                          width: double.infinity,
                                          // height: heightView / 2,
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
                                                  "Đăng ký",
                                                  style: TextStyle(
                                                    color: const Color.fromRGBO(
                                                        52, 71, 103, 1),
                                                    fontFamily: "Icomoon",
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 24.sp,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 30.h,
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 1,
                                                      child: TextFormField(
                                                        keyboardType:
                                                            TextInputType.name,
                                                        controller:
                                                            surNameController,
                                                        style: TextStyle(
                                                            fontSize: 12.sp,
                                                            color: grey),
                                                        cursorColor: grey,
                                                        validator: (value) {
                                                          if (value!.isEmpty) {
                                                            return surNameIsRequied;
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
                                                                      color: Color.fromRGBO(
                                                                          214,
                                                                          51,
                                                                          123,
                                                                          0.6),
                                                                      width:
                                                                          2.0),
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
                                                                hintText: 'Họ',
                                                                isDense: true,
                                                                contentPadding:
                                                                    EdgeInsets
                                                                        .all(15
                                                                            .w)),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10.w,
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: TextFormField(
                                                        controller:
                                                            nameController,
                                                        keyboardType:
                                                            TextInputType.name,
                                                        style: TextStyle(
                                                            fontSize: 12.sp,
                                                            color: grey),
                                                        cursorColor: grey,
                                                        validator: (value) {
                                                          if (value!.isEmpty) {
                                                            return nameIsRequied;
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
                                                                      color: Color.fromRGBO(
                                                                          214,
                                                                          51,
                                                                          123,
                                                                          0.6),
                                                                      width:
                                                                          2.0),
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
                                                                hintText: 'Tên',
                                                                isDense: true,
                                                                contentPadding:
                                                                    EdgeInsets
                                                                        .all(15
                                                                            .w)),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 20.h,
                                                ),
                                                TextFormField(
                                                  controller:
                                                      fullNameController,
                                                  keyboardType:
                                                      TextInputType.name,
                                                  style: TextStyle(
                                                      fontSize: 12.sp,
                                                      color: grey),
                                                  cursorColor: grey,
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return fullnameIsRequied;
                                                    } else {
                                                      return null;
                                                    }
                                                  },
                                                  decoration: InputDecoration(
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
                                                      hintText: 'Họ và tên',
                                                      isDense: true,
                                                      contentPadding:
                                                          EdgeInsets.all(15.w)),
                                                ),
                                                SizedBox(
                                                  height: 20.h,
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
                                                  decoration: InputDecoration(
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
                                                          EdgeInsets.all(15.w)),
                                                ),
                                                SizedBox(
                                                  height: 20.h,
                                                ),
                                                TextFormField(
                                                  controller: phoneController,
                                                  keyboardType:
                                                      TextInputType.phone,
                                                  style: TextStyle(
                                                      fontSize: 12.sp,
                                                      color: grey),
                                                  cursorColor: grey,
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return phoneIsRequied;
                                                    }
                                                    bool phoneValid = RegExp(
                                                            r'^(?:[+0]9)?[0-9]{10}$')
                                                        .hasMatch(value);

                                                    if (!phoneValid) {
                                                      return invalidPhone;
                                                    } else {
                                                      return null;
                                                    }
                                                  },
                                                  decoration: InputDecoration(
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
                                                      hintText: 'Số điện thoại',
                                                      isDense: true,
                                                      contentPadding:
                                                          EdgeInsets.all(15.w)),
                                                ),
                                                SizedBox(
                                                  height: 20.h,
                                                ),
                                                TextFormField(
                                                  controller:
                                                      passworldController,
                                                  obscureText: passwordVisible,
                                                  style: TextStyle(
                                                      fontSize: 12.sp,
                                                      color: grey),
                                                  cursorColor: grey,
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return passwordIsRequied;
                                                    } else if (value.length <
                                                        8) {
                                                      return passwordRequiedLength;
                                                    } else {
                                                      return null;
                                                    }
                                                  },
                                                  decoration: InputDecoration(
                                                      suffixIconColor:
                                                          const Color.fromARGB(
                                                              255,
                                                              226,
                                                              104,
                                                              159),
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
                                                      hintText: 'Mật khẩu',
                                                      isDense: true,
                                                      contentPadding:
                                                          EdgeInsets.all(15.w)),
                                                ),
                                                SizedBox(
                                                  height: 20.h,
                                                ),
                                                TextFormField(
                                                  controller:
                                                      rePassworldController,
                                                  obscureText:
                                                      rePasswordVisible,
                                                  style: TextStyle(
                                                      fontSize: 12.sp,
                                                      color: grey),
                                                  cursorColor: grey,
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return rePasswordIsRequied;
                                                    } else if (value !=
                                                        passworldController
                                                            .text) {
                                                      return rePasswordNotCorrect;
                                                    } else {
                                                      return null;
                                                    }
                                                  },
                                                  decoration: InputDecoration(
                                                      suffixIconColor:
                                                          const Color.fromARGB(
                                                              255,
                                                              226,
                                                              104,
                                                              159),
                                                      suffixIcon: IconButton(
                                                          onPressed: () {
                                                            setState(
                                                              () {
                                                                rePasswordVisible =
                                                                    !rePasswordVisible;
                                                              },
                                                            );
                                                          },
                                                          icon: Icon(rePasswordVisible
                                                              ? Icons
                                                                  .visibility_off
                                                              : Icons
                                                                  .visibility)),
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
                                                      hintText:
                                                          'Nhập lại mật khẩu',
                                                      isDense: true,
                                                      contentPadding:
                                                          EdgeInsets.all(15.w)),
                                                ),
                                                SizedBox(
                                                  height: 20.h,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Checkbox(
                                                        checkColor:
                                                            Colors.white,
                                                        fillColor:
                                                            MaterialStateProperty
                                                                .resolveWith(
                                                                    getColor),
                                                        value: isChecked,
                                                        onChanged:
                                                            (bool? value) {
                                                          setState(() {
                                                            isChecked = value!;
                                                          });
                                                        }),
                                                    RichText(
                                                      text: TextSpan(
                                                        children: [
                                                          TextSpan(
                                                              text:
                                                                  "Tôi đồng ý với các",
                                                              style: TextStyle(
                                                                fontSize: 12.sp,
                                                                color: const Color
                                                                    .fromRGBO(
                                                                    52,
                                                                    71,
                                                                    103,
                                                                    1),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                fontFamily:
                                                                    "OpenSans",
                                                              )),
                                                          TextSpan(
                                                              text:
                                                                  " Điều khoản và Điều kiện",
                                                              recognizer:
                                                                  TapGestureRecognizer()
                                                                    ..onTap =
                                                                        () {
                                                                      launchURL();
                                                                      // Single tapped.
                                                                    },
                                                              style: TextStyle(
                                                                fontSize: 12.sp,
                                                                color: const Color
                                                                    .fromRGBO(
                                                                    52,
                                                                    71,
                                                                    103,
                                                                    1),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontFamily:
                                                                    "OpenSans",
                                                              )),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 20.h,
                                                ),
                                                ButtonGradient(
                                                  color1: color1DarkButton,
                                                  color2: color2DarkButton,
                                                  event: () {
                                                    if (_formField.currentState!
                                                        .validate()) {
                                                      surNameController.clear();
                                                      nameController.clear();
                                                      fullNameController
                                                          .clear();
                                                      emailController.clear();
                                                      phoneController.clear();
                                                      passworldController
                                                          .clear();
                                                      rePassworldController
                                                          .clear();
                                                    }
                                                  },
                                                  text: "Đăng ký",
                                                  fontSize: 12.sp,
                                                  radius: 8.r,
                                                  textColor: Colors.white,
                                                ),
                                                SizedBox(
                                                  height: 20.h,
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                          text:
                                                              "Bạn đã có tài khoản?",
                                                          style: TextStyle(
                                                            fontSize: 12.sp,
                                                            color: const Color
                                                                .fromRGBO(
                                                                52, 71, 103, 1),
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            fontFamily:
                                                                "OpenSans",
                                                          )),
                                                      TextSpan(
                                                          text: " Đăng nhập",
                                                          recognizer:
                                                              TapGestureRecognizer()
                                                                ..onTap = () {
                                                                  context
                                                                      .go("/");
                                                                  // Single tapped.
                                                                },
                                                          style: TextStyle(
                                                            fontSize: 12.sp,
                                                            color: const Color
                                                                .fromRGBO(
                                                                52, 71, 103, 1),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontFamily:
                                                                "OpenSans",
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10.h,
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