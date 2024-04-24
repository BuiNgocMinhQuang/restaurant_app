import 'dart:convert';
import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/config/text.dart';
import 'package:app_restaurant/config/void_show_dialog.dart';
import 'package:app_restaurant/routers/app_router_config.dart';
import 'package:app_restaurant/utils/storage.dart';
import 'package:app_restaurant/widgets/button/button_gradient.dart';
import 'package:app_restaurant/widgets/text/copy_right_text.dart';
import 'package:app_restaurant/widgets/text/gradient_text.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:app_restaurant/env/index.dart';
import 'package:app_restaurant/constant/api/index.dart';

class StaffForgotPassword extends StatefulWidget {
  const StaffForgotPassword({super.key});

  @override
  State<StaffForgotPassword> createState() => _StaffForgotPasswordState();
}

class _StaffForgotPasswordState extends State<StaffForgotPassword> {
  final _formField = GlobalKey<FormState>();
  final storeIdController = TextEditingController();
  final emailController = TextEditingController();
  void handleForgotPassword({
    required String? shopID,
    required String? email,
  }) async {
    try {
      final respons = await http.post(
        Uri.parse('$baseUrl$forgotPasswordStaff'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          "shop_id": shopID.toString(),
          "email": email,
        }),
      );
      final data = jsonDecode(respons.body);
      if (data['status'] == 200) {
        final messRes = data['message'];

        final messText = messRes['text'];
        final otp = data['otp'];
        final tokenCheckOTP = otp['token'];
        StorageUtils.instance
            .setString(key: 'tokenStaffCheckOTP', val: tokenCheckOTP);
        StorageUtils.instance
            .setString(key: 'emailStaffCheckOTP', val: email ?? '');
        storeIdController.clear();
        emailController.clear();
        navigatorKey.currentContext?.go('/staff_confirm_otp');

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
        final messRes = data['message'];

        showFailedModal(
            context: navigatorKey.currentContext, desWhyFail: messRes);
        print("FOGOT PASSWORD ERROR 1");
      }
    } catch (error) {
      print("FOGOT PASSWORD ERROR ${error}");
    }
  }

  @override
  void dispose() {
    super.dispose();
    storeIdController.clear();
    emailController.clear();
  }

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
                                              context.go("/staff_sign_in");
                                            },
                                            text:
                                                "Đăng nhập với tư cách nhân viên",
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
                                                  'Quên mật khẩu',
                                                  style: TextStyle(
                                                    color: const Color.fromRGBO(
                                                        52, 71, 103, 1),
                                                    fontFamily: "Icomoon",
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 26.sp,
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
                                                    softWrap: true,
                                                    isOverFlow: false,
                                                    text: sendCodeIn60Sec,
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: blueText,
                                                    ),
                                                    SizedBox(
                                                      height: 10.h,
                                                    ),
                                                    TextFormField(
                                                      controller:
                                                          storeIdController,
                                                      cursorColor:
                                                          const Color.fromRGBO(
                                                              73, 80, 87, 1),
                                                      validator: (value) {
                                                        if (value!.isEmpty) {
                                                          return storeIdIsRequied;
                                                        } else {
                                                          return null;
                                                        }
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                              fillColor: const Color
                                                                  .fromARGB(255,
                                                                  226, 104, 159),
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
                                                              hintText:
                                                                  'Mã cửa hàng',
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
                                                      cursorColor:
                                                          const Color.fromRGBO(
                                                              73, 80, 87, 1),
                                                      validator: (value) {
                                                        if (value!.isEmpty) {
                                                          return emailIsRequied;
                                                        }
                                                        bool emailValid = RegExp(
                                                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                                            .hasMatch(value);

                                                        if (!emailValid) {
                                                          return invalidEmail;
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
                                                  color1: color1BlueButton,
                                                  color2: color2BlueButton,
                                                  event: () {
                                                    if (_formField.currentState!
                                                        .validate()) {
                                                      handleForgotPassword(
                                                        shopID:
                                                            storeIdController
                                                                .text,
                                                        email: emailController
                                                            .text,
                                                      );
                                                    }
                                                    // handleForgotPassword(
                                                    //   shopID: "123456",
                                                    //   email:
                                                    //       "buingocminhquang2@gmail.com",
                                                    // );
                                                  },
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
                ),
              )),
        ));
  }
}
