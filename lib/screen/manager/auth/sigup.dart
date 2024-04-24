import 'dart:convert';
import 'package:app_restaurant/bloc/manager/manager_login/manager_login_bloc.dart';
import 'package:app_restaurant/config/space.dart';
import 'package:app_restaurant/config/text.dart';
import 'package:app_restaurant/routers/app_router_config.dart';
import 'package:app_restaurant/widgets/background/background_welcome.dart';
import 'package:app_restaurant/widgets/button/button_gradient.dart';
import 'package:app_restaurant/widgets/text/copy_right_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/config/void_show_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:app_restaurant/env/index.dart';
import 'package:app_restaurant/constant/api/index.dart';

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
  String? errorsPhoneField;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    surNameController.clear();
    nameController.clear();
    fullNameController.clear();
    emailController.clear();
    phoneController.clear();
    passworldController.clear();
    rePassworldController.clear();
  }

  void handleRegister({
    required String firstName,
    required String lastName,
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
    required bool agreeConditon,
  }) async {
    try {
      final response = await http.post(Uri.parse('$baseUrl$managerRegister'),
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode({
            "first_name": firstName,
            "last_name": lastName,
            "full_name": fullName,
            "email": email,
            "phone": phone,
            "password": password,
            "confirm_password": confirmPassword,
            "agree_conditon": agreeConditon
          }));
      final data = jsonDecode(response.body);

      if (data['status'] == 200) {
        BlocProvider.of<ManagerLoginBloc>(navigatorKey.currentContext!).add(
          ManagerLoginButtonPressed(
              email: email, password: password, remember: false),
        );
      } else if (data['status'] == 500) {
        var messRes = data['message'];
        var messFailed = messRes['text'];
        showCustomDialogModal(
            context: navigatorKey.currentContext,
            textDesc: messFailed,
            title: "Thất bại",
            colorButton: Colors.red,
            btnText: "OK",
            typeDialog: "error");
      } else {
        var messRes = data['errors'];
        var messErrorEmail1 = messRes['email'].toString();
        var messErrorEmail2 = messErrorEmail1.replaceAll("[", "");
        var messErrorEmail3 = messErrorEmail2.replaceAll("]", "");
        var messErrorEmail4 = messErrorEmail3.replaceAll("Nội dung", "Email");

        var messErrorPhone1 = messRes['phone'].toString();
        var messErrorPhone2 = messErrorPhone1.replaceAll("[", "");
        var messErrorPhone3 = messErrorPhone2.replaceAll("]", "");
        var messErrorPhone4 =
            messErrorPhone3.replaceAll("Số điện thoại", "Email");
        var messError = '$messErrorEmail4\n  $messErrorPhone4\n';
        showCustomDialogModal(
            context: navigatorKey.currentContext,
            textDesc: messError,
            title: "Thất bại",
            colorButton: Colors.red,
            btnText: "OK",
            typeDialog: "error");
      }
    } catch (error) {
      // print("ZO ELSE $error");
    }
  }

  @override
  Widget build(BuildContext context) {
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
                                                  signIn,
                                                  style: TextStyle(
                                                    color: const Color.fromRGBO(
                                                        52, 71, 103, 1),
                                                    fontFamily: "Icomoon",
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 24.sp,
                                                  ),
                                                ),
                                                space30H,
                                                TextFormField(
                                                  maxLength: 8,
                                                  onTapOutside: (event) {
                                                    FocusManager
                                                        .instance.primaryFocus
                                                        ?.unfocus();
                                                  },
                                                  keyboardType:
                                                      TextInputType.name,
                                                  controller: surNameController,
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
                                                      hintText: 'Họ',
                                                      isDense: true,
                                                      contentPadding:
                                                          EdgeInsets.all(15.w)),
                                                ),
                                                space5H,
                                                TextFormField(
                                                  maxLength: 24,
                                                  onTapOutside: (event) {
                                                    FocusManager
                                                        .instance.primaryFocus
                                                        ?.unfocus();
                                                  },
                                                  controller: nameController,
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
                                                      hintText: 'Tên',
                                                      isDense: true,
                                                      contentPadding:
                                                          EdgeInsets.all(15.w)),
                                                ),
                                                space5H,
                                                TextFormField(
                                                  maxLength: 32,
                                                  onTapOutside: (event) {
                                                    FocusManager
                                                        .instance.primaryFocus
                                                        ?.unfocus();
                                                  },
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
                                                space5H,
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
                                                space20H,
                                                TextFormField(
                                                  onTapOutside: (event) {
                                                    FocusManager
                                                        .instance.primaryFocus
                                                        ?.unfocus();
                                                  },
                                                  inputFormatters: <TextInputFormatter>[
                                                    FilteringTextInputFormatter
                                                        .allow(RegExp("[0-9]")),
                                                  ],
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
                                                    if (errorsPhoneField !=
                                                        null) {
                                                      return errorsPhoneField;
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
                                                      hintText: phoneNumber,
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
                                                      hintText: reTypePassword,
                                                      isDense: true,
                                                      contentPadding:
                                                          EdgeInsets.all(15.w)),
                                                ),
                                                space20H,
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
                                                              text: iAgreeWith,
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
                                                                  termsAndCondition,
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
                                                space20H,
                                                ButtonGradient(
                                                  color1: color1DarkButton,
                                                  color2: color2DarkButton,
                                                  event: () {
                                                    if (_formField.currentState!
                                                        .validate()) {
                                                      handleRegister(
                                                        firstName:
                                                            surNameController
                                                                .text,
                                                        lastName:
                                                            nameController.text,
                                                        fullName:
                                                            fullNameController
                                                                .text,
                                                        email: emailController
                                                            .text,
                                                        phone: phoneController
                                                            .text
                                                            .toString(),
                                                        password:
                                                            passworldController
                                                                .text,
                                                        confirmPassword:
                                                            rePassworldController
                                                                .text,
                                                        agreeConditon:
                                                            isChecked,
                                                      );
                                                    }
                                                  },
                                                  text: "Đăng ký",
                                                  fontSize: 12.sp,
                                                  radius: 8.r,
                                                  textColor: Colors.white,
                                                ),
                                                space20H,
                                                RichText(
                                                  text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                          text:
                                                              alreadyHaveAccount,
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
                                                          text: " $login",
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
                                                space10H
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
