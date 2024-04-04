import 'package:app_restaurant/bloc/login/staff_login_bloc.dart';
import 'package:app_restaurant/config/text.dart';
import 'package:app_restaurant/widgets/background_welcome.dart';
import 'package:app_restaurant/widgets/button/button_gradient.dart';
import 'package:app_restaurant/widgets/text/copy_right_text.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app_restaurant/config/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class StaffSignIn extends StatefulWidget {
  const StaffSignIn({super.key});

  @override
  State<StaffSignIn> createState() => _StaffSignInState();
}

class _StaffSignInState extends State<StaffSignIn> {
  // final _loginBloc = LoginBloc();
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromRGBO(248, 249, 250, 1),
      body: SafeArea(
          child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: StaffSignInFrom(),
      )),
    );
  }
}

class StaffSignInFrom extends StatefulWidget {
  const StaffSignInFrom({super.key});

  @override
  State<StaffSignInFrom> createState() => _StaffSignInFromState();
}

class _StaffSignInFromState extends State<StaffSignInFrom> {
  bool isRemember = false;
  bool passwordVisible = true;
  final _formField = GlobalKey<FormState>();
  final storeIdController = TextEditingController();
  final emailController = TextEditingController();
  final passworldController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return Form(
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
                                      color1: pupple,
                                      color2: red,
                                      event: () {
                                        context.go("/");
                                      },
                                      fontSize: 12.sp,
                                      text: signInAsManager,
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
                                          Text(
                                            "Đăng nhập",
                                            style: TextStyle(
                                              color: const Color.fromRGBO(
                                                  52, 71, 103, 1),
                                              fontFamily: "Icomoon",
                                              fontWeight: FontWeight.bold,
                                              fontSize: 26.sp,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          Container(
                                            height: 40.h,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                                gradient: const LinearGradient(
                                                  begin: Alignment.topRight,
                                                  end: Alignment.bottomLeft,
                                                  colors: [
                                                    organe,
                                                    yellow,
                                                  ],
                                                )),
                                            child: Center(
                                              child: TextApp(
                                                  text: youAreSignInAsStaff,
                                                  textAlign: TextAlign.center,
                                                  color: Colors.white,
                                                  fontFamily: "Icomoon",
                                                  fontWeight: FontWeight.bold,
                                                  fontsize: 12.sp),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 30.h,
                                          ),
                                          TextFormField(
                                            controller: storeIdController,
                                            style: TextStyle(
                                                fontSize: 14.sp, color: grey),
                                            cursorColor: grey,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return storeIdIsRequied;
                                              } else {
                                                return null;
                                              }
                                            },
                                            decoration: InputDecoration(
                                                fillColor: const Color.fromARGB(
                                                    255, 226, 104, 159),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Color.fromRGBO(
                                                          214, 51, 123, 0.6),
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
                                                contentPadding: EdgeInsets.all(
                                                    1.sw > 600 ? 20.w : 15.w)),
                                          ),
                                          SizedBox(
                                            height: 20.h,
                                          ),
                                          TextFormField(
                                            controller: emailController,
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            style: TextStyle(
                                                fontSize: 14.sp, color: grey),
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
                                              }
                                            },
                                            decoration: InputDecoration(
                                                fillColor: const Color.fromARGB(
                                                    255, 226, 104, 159),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Color.fromRGBO(
                                                          214, 51, 123, 0.6),
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
                                                contentPadding: EdgeInsets.all(
                                                    1.sw > 600 ? 20.w : 15.w)),
                                          ),
                                          SizedBox(
                                            height: 20.h,
                                          ),
                                          TextFormField(
                                            controller: passworldController,
                                            obscureText: passwordVisible,
                                            style: TextStyle(
                                                fontSize: 14.sp, color: grey),
                                            cursorColor: grey,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return passwordIsRequied;
                                              } else {
                                                return null;
                                              }
                                            },
                                            decoration: InputDecoration(
                                                suffixIconColor: Color.fromARGB(
                                                    255, 226, 104, 159),
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
                                                        ? Icons.visibility_off
                                                        : Icons.visibility)),
                                                fillColor: const Color.fromARGB(
                                                    255, 226, 104, 159),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Color.fromRGBO(
                                                          214, 51, 123, 0.6),
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
                                                hintText: 'Mật khẩu',
                                                isDense: true,
                                                contentPadding: EdgeInsets.all(
                                                    1.sw > 600 ? 20.w : 15.w)),
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
                                              SizedBox(
                                                width: 50.w,
                                                height: 30.w,
                                                child: FittedBox(
                                                  fit: BoxFit.fill,
                                                  child: CupertinoSwitch(
                                                    value: isRemember,
                                                    activeColor:
                                                        const Color.fromRGBO(
                                                            58, 65, 111, .95),
                                                    onChanged: (bool value) {
                                                      setState(() {
                                                        isRemember = value;
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10.h,
                                              ),
                                              TextApp(
                                                  text: "Ghi nhớ tài khoản",
                                                  textAlign: TextAlign.center,
                                                  color: grey,
                                                  fontFamily: "OpenSans",
                                                  fontWeight: FontWeight.normal,
                                                  fontsize: 12.sp),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 20.h,
                                          ),
                                          !(state.loginStatus ==
                                                  LoginStatus.loading)
                                              ? ButtonGradient(
                                                  color1: color1BlueButton,
                                                  color2: color2BlueButton,
                                                  event: () async {
                                                    // if (_formField.currentState!
                                                    //     .validate()) {
                                                    //   // context.go("/staff_home");
                                                    //   BlocProvider.of<
                                                    //               LoginBloc>(
                                                    //           context)
                                                    //       .add(
                                                    //     StaffLoginButtonPressed(
                                                    //       remember: isRemember,
                                                    //       shopId:
                                                    //           storeIdController
                                                    //               .text,
                                                    //       email: emailController
                                                    //           .text,
                                                    //       password:
                                                    //           passworldController
                                                    //               .text,
                                                    //     ),
                                                    //   );
                                                    //   storeIdController.clear();
                                                    //   emailController.clear();
                                                    //   passworldController
                                                    //       .clear();
                                                    // }
                                                    print(
                                                        "REMEBER ${isRemember}");
                                                    BlocProvider.of<LoginBloc>(
                                                            context)
                                                        .add(
                                                      StaffLoginButtonPressed(
                                                          shopId: "123456",
                                                          email:
                                                              "buingocminhquang2@gmail.com",
                                                          password: "123456789",
                                                          remember: isRemember),
                                                    );
                                                    //khong xoa
                                                  },
                                                  text: "Đăng nhập",
                                                  fontSize: 12.sp,
                                                  radius: 8.r,
                                                  textColor: Colors.white,
                                                )
                                              : const Center(
                                                  child:
                                                      CircularProgressIndicator()),
                                          SizedBox(
                                            height: 20.h,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              context
                                                  .go("/staff_forgot_password");
                                            },
                                            child: TextApp(
                                              text: "Quên mật khẩu?",
                                              color: const Color.fromRGBO(
                                                  52, 71, 103, 1),
                                              fontWeight: FontWeight.bold,
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
        );
      },
    );
  }
}

// 