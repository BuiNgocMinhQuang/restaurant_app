import 'dart:convert';
import 'dart:developer';

import 'package:app_restaurant/config/space.dart';
import 'package:app_restaurant/config/void_show_dialog.dart';
import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/config/text.dart';
import 'package:app_restaurant/routers/app_router_config.dart';
import 'package:app_restaurant/utils/storage.dart';
import 'package:app_restaurant/widgets/button/button_gradient.dart';
import 'package:app_restaurant/widgets/text/copy_right_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:app_restaurant/env/index.dart';
import 'package:app_restaurant/constant/api/index.dart';

class ManagerChangePassword extends StatefulWidget {
  const ManagerChangePassword({super.key});

  @override
  State<ManagerChangePassword> createState() => _ManagerChangePasswordState();
}

class _ManagerChangePasswordState extends State<ManagerChangePassword> {
  bool passwordVisible = true;
  bool rePasswordVisible = true;

  final _formField = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final rePassworldController = TextEditingController();
  void handleChangePassword({
    required String password,
    required String rePassword,
  }) async {
    try {
      var tokenCheckOtp = StorageUtils.instance
          .getString(key: 'tokenManagerCheckOTP')
          .toString();
      var emailCheckOtp = StorageUtils.instance
          .getString(key: 'emailManagerCheckOTP')
          .toString();
      var paramOTP =
          StorageUtils.instance.getString(key: 'OTPtoManager').toString();

      final respons = await http.post(
        Uri.parse('$baseUrl$changePasswordManagerWhenForget'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          "email": emailCheckOtp,
          "token": tokenCheckOtp,
          "otp": paramOTP,
          "password_new": password,
          "confirm_password_new": rePassword,
        }),
      );
      final data = jsonDecode(respons.body);

      if (data['status'] == 200) {
        final messRes = data['message'];
        final messText = messRes['text'];

        navigatorKey.currentContext?.go('/');

        Future.delayed(const Duration(milliseconds: 300), () {
          showCustomDialogModal(
            typeDialog: "succes",
            context: navigatorKey.currentContext,
            textDesc: messText,
            title: "Thành công",
            colorButton: Colors.green,
            btnText: "OK",
          );
        });
      } else {
        log("ERROR handleChangePassword 1");

        final messRes = data['message'];
        final messFailed = messRes['text'];

        showCustomDialogModal(
            context: navigatorKey.currentContext,
            textDesc: messFailed,
            title: "Thất bại",
            colorButton: Colors.red,
            btnText: "OK",
            typeDialog: "error");
      }
    } catch (error) {
      log("ERROR handleChangePassword 2 $error");
    }
  }

  @override
  void dispose() {
    passwordController.dispose();
    rePassworldController.dispose();
    super.dispose();
  }

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
                                          color: Colors.black.withOpacity(0.5)),
                                    ),
                                    Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(20.w),
                                          child: ButtonGradient(
                                            color1: pupple,
                                            color2: red,
                                            event: () {
                                              context.go('/');
                                            },
                                            fontSize: 12.sp,
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
                                                Text(
                                                  updatePassword,
                                                  style: TextStyle(
                                                    color: const Color.fromRGBO(
                                                        52, 71, 103, 1),
                                                    fontFamily: "Icomoon",
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 24.sp,
                                                  ),
                                                ),
                                                space20W,
                                                TextFormField(
                                                  onTapOutside: (event) {
                                                    FocusManager
                                                        .instance.primaryFocus
                                                        ?.unfocus();
                                                  },
                                                  controller:
                                                      passwordController,
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
                                                            mounted
                                                                ? setState(
                                                                    () {
                                                                      passwordVisible =
                                                                          !passwordVisible;
                                                                    },
                                                                  )
                                                                : null;
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
                                                      hintText: password,
                                                      isDense: true,
                                                      contentPadding:
                                                          EdgeInsets.all(15.w)),
                                                ),
                                                space20H,
                                                TextFormField(
                                                  onTapOutside: (event) {
                                                    FocusManager
                                                        .instance.primaryFocus
                                                        ?.unfocus();
                                                  },
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
                                                        passwordController
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
                                                            mounted
                                                                ? setState(
                                                                    () {
                                                                      rePasswordVisible =
                                                                          !rePasswordVisible;
                                                                    },
                                                                  )
                                                                : null;
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
                                                      hintText: reTypePassword,
                                                      isDense: true,
                                                      contentPadding:
                                                          EdgeInsets.all(15.w)),
                                                ),
                                                space40H,
                                                ButtonGradient(
                                                  color1: color1BlueButton,
                                                  color2: color2BlueButton,
                                                  event: () {
                                                    if (_formField.currentState!
                                                        .validate()) {
                                                      handleChangePassword(
                                                          password:
                                                              passwordController
                                                                  .text,
                                                          rePassword:
                                                              rePassworldController
                                                                  .text);
                                                    }
                                                  },
                                                  text: confirm,
                                                  fontSize: 12.sp,
                                                  radius: 8.r,
                                                  textColor: Colors.white,
                                                ),
                                                space20H,
                                              ],
                                            ),
                                          )),
                                    ),
                                    space30H,
                                    SizedBox(
                                      width: 1.sw,
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
