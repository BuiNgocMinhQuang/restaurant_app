import 'package:app_restaurant/bloc/manager/manager_login/manager_login_bloc.dart';
import 'package:app_restaurant/config/space.dart';
import 'package:app_restaurant/config/text.dart';
import 'package:app_restaurant/widgets/background/background_welcome.dart';
import 'package:app_restaurant/widgets/button/button_gradient.dart';
import 'package:app_restaurant/widgets/text/copy_right_text.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app_restaurant/config/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ManagerSignIn extends StatefulWidget {
  const ManagerSignIn({super.key});

  @override
  State<ManagerSignIn> createState() => _ManagerSignInState();
}

class _ManagerSignInState extends State<ManagerSignIn> {
  bool isRemember = true;
  bool passwordVisible = true;
  final _formField = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passworldController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    passworldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ManagerLoginBloc, ManagerLoginState>(
        builder: (context, state) {
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
                              space15H,
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
                                              fontSize: 14.sp,
                                              text: signInAsStaff,
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
                                                    login,
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
                                                  space10H,
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
                                                              youAreSignInAsManager,
                                                          textAlign:
                                                              TextAlign.center,
                                                          color: Colors.white,
                                                          fontFamily:
                                                              "OpenSans",
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontsize: 14.sp),
                                                    ),
                                                  ),
                                                  space30H,
                                                  TextFormField(
                                                    onTapOutside: (event) {
                                                      FocusManager
                                                          .instance.primaryFocus
                                                          ?.unfocus();
                                                    },
                                                    controller: emailController,
                                                    keyboardType: TextInputType
                                                        .emailAddress,
                                                    style: TextStyle(
                                                        fontSize: 14.sp,
                                                        color: Colors.black),
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
                                                        labelText: "Email",
                                                        labelStyle: TextStyle(
                                                            fontSize: 14.sp,
                                                            color: grey),
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
                                                        // hintText: 'Email',
                                                        hintStyle: TextStyle(
                                                            fontSize: 14.sp,
                                                            color: grey),
                                                        isDense: true,
                                                        contentPadding:
                                                            EdgeInsets.all(
                                                                20.w)),
                                                  ),
                                                  space20H,
                                                  TextFormField(
                                                    onTapOutside: (event) {
                                                      FocusManager
                                                          .instance.primaryFocus
                                                          ?.unfocus();
                                                    },
                                                    controller:
                                                        passworldController,
                                                    obscureText:
                                                        passwordVisible,
                                                    style: TextStyle(
                                                        fontSize: 14.sp,
                                                        color: Colors.black),
                                                    cursorColor: grey,
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return passwordIsRequied;
                                                      } else {
                                                        return null;
                                                      }
                                                    },
                                                    decoration: InputDecoration(
                                                        labelText: password,
                                                        labelStyle:
                                                            TextStyle(
                                                                fontSize: 14.sp,
                                                                color: grey),
                                                        suffixIconColor:
                                                            const Color
                                                                .fromARGB(255,
                                                                226, 104, 159),
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
                                                            icon: Icon(
                                                              passwordVisible
                                                                  ? Icons
                                                                      .visibility_off
                                                                  : Icons
                                                                      .visibility,
                                                              size: 24.sp,
                                                            )),
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
                                                        // hintText: password,
                                                        hintStyle: TextStyle(
                                                            fontSize: 14.sp,
                                                            color: grey),
                                                        isDense: true,
                                                        contentPadding:
                                                            EdgeInsets.all(
                                                                20.w)),
                                                  ),
                                                  space10H,
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
                                                            value: isRemember,
                                                            activeColor:
                                                                const Color
                                                                    .fromRGBO(
                                                                    58,
                                                                    65,
                                                                    111,
                                                                    .95),
                                                            onChanged:
                                                                (bool value) {
                                                              mounted
                                                                  ? setState(
                                                                      () {
                                                                      isRemember =
                                                                          value;
                                                                    })
                                                                  : null;
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                      space10W,
                                                      TextApp(
                                                          text: rememberAccount,
                                                          textAlign:
                                                              TextAlign.center,
                                                          color: grey,
                                                          fontFamily:
                                                              "OpenSans",
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontsize: 14.sp),
                                                    ],
                                                  ),
                                                  space30H,
                                                  ButtonGradient(
                                                    color1: color1BlueButton,
                                                    color2: color2BlueButton,
                                                    event: () {
                                                      // if (_formField
                                                      //     .currentState!
                                                      //     .validate()) {
                                                      //   BlocProvider.of<
                                                      //               ManagerLoginBloc>(
                                                      //           context)
                                                      //       .add(
                                                      //     ManagerLoginButtonPressed(
                                                      //         email:
                                                      //             emailController
                                                      //                 .text,
                                                      //         password:
                                                      //             passworldController
                                                      //                 .text,
                                                      //         remember:
                                                      //             isRemember),
                                                      //   );
                                                      // }

                                                      BlocProvider.of<
                                                                  ManagerLoginBloc>(
                                                              context)
                                                          .add(
                                                        const ManagerLoginButtonPressed(
                                                            email:
                                                                "contact@thuonghieuvietsol.com",
                                                            password:
                                                                "thvTHV123!@#",
                                                            remember: true),
                                                      );
                                                    },
                                                    text: login,
                                                    fontSize: 14.sp,
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
                                                        color: const Color
                                                            .fromRGBO(
                                                            103, 116, 142, 1),
                                                      ),
                                                      SizedBox(
                                                        width: 12.w,
                                                      ),
                                                      Text(
                                                        "hoặc",
                                                        style: TextStyle(
                                                          fontSize: 14.sp,
                                                          color: const Color
                                                              .fromRGBO(
                                                              103, 116, 142, 1),
                                                        ),
                                                      ),
                                                      space10W,
                                                      Container(
                                                        width: 100,
                                                        height: 1, // Thickness
                                                        color: const Color
                                                            .fromRGBO(
                                                            103, 116, 142, 1),
                                                      )
                                                    ],
                                                  ),
                                                  space20H,
                                                  ButtonGradient(
                                                    color1: color1DarkButton,
                                                    color2: color2DarkButton,
                                                    event: () {
                                                      context.go(
                                                          "/manager_sign_up");
                                                    },
                                                    text: signIn,
                                                    fontSize: 14.sp,
                                                    radius: 8.r,
                                                    textColor: Colors.white,
                                                  ),
                                                  space20H,
                                                  InkWell(
                                                    onTap: () {
                                                      context.go(
                                                          "/manager_forgot_password");
                                                    },
                                                    child: TextApp(
                                                      text: forgotPassword,
                                                      color:
                                                          const Color.fromRGBO(
                                                              52, 71, 103, 1),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: "OpenSans",
                                                      fontsize: 14.sp,
                                                    ),
                                                  )
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
    });
  }
}
