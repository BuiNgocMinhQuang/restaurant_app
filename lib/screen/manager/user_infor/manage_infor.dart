import 'dart:io';

import 'package:app_restaurant/bloc/login/login_bloc.dart';
import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/config/space.dart';
import 'package:app_restaurant/config/text.dart';
import 'package:app_restaurant/widgets/button/button_gradient.dart';
import 'package:app_restaurant/widgets/shimmer/shimmer_list.dart';
import 'package:app_restaurant/widgets/text/copy_right_text.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class ManagerInformation extends StatefulWidget {
  const ManagerInformation({super.key});

  @override
  State<ManagerInformation> createState() => _ManagerInformationState();
}

class _ManagerInformationState extends State<ManagerInformation> {
  final _formField1 = GlobalKey<FormState>();
  final _formField2 = GlobalKey<FormState>();
  bool currentPasswordVisible = true;
  bool newPasswordVisible = true;
  bool reNewPasswordVisible = true;
  final surNameController = TextEditingController();
  final nameController = TextEditingController();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final currentPassworldController = TextEditingController();
  final newPassworldController = TextEditingController();
  final reNewPassworldController = TextEditingController();
  final twitterController = TextEditingController();
  final facebookController = TextEditingController();
  final instagramController = TextEditingController();
  final address1Controller = TextEditingController();
  final address2Controller = TextEditingController();
  final address3Controller = TextEditingController();
  final address4Controller = TextEditingController();
  File? selectedImage;
  void pickImage() async {
    final returndImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returndImage == null) return;
    setState(() {
      selectedImage = File(returndImage.path);
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    await Future.delayed(const Duration(seconds: 0));

    mounted
        ? fullNameController.text = context
                .read<LoginBloc>()
                .state
                .managerInforModel
                ?.data
                ?.userFullName ??
            ''
        : null;
    mounted
        ? surNameController.text = context
                .read<LoginBloc>()
                .state
                .managerInforModel
                ?.data
                ?.userFirstName ??
            ''
        : null;

    mounted
        ? nameController.text = context
                .read<LoginBloc>()
                .state
                .managerInforModel
                ?.data
                ?.userLastName ??
            ''
        : null;
    mounted
        ? emailController.text = context
                .read<LoginBloc>()
                .state
                .managerInforModel
                ?.data
                ?.userEmail ??
            ''
        : null;
    mounted
        ? phoneController.text = context
                .read<LoginBloc>()
                .state
                .managerInforModel
                ?.data
                ?.userPhone ??
            ''
        : null;
    mounted
        ? address4Controller.text = context
                .read<LoginBloc>()
                .state
                .managerInforModel
                ?.data
                ?.userAddress4 ??
            ''
        : null;
    // mounted
    //     ? twitterController.text = context
    //             .read<LoginBloc>()
    //             .state
    //             .staffInforDataModel
    //             ?.data
    //             ?.staffTwitter ??
    //         ''
    //     : null;
    // mounted
    //     ? facebookController.text = context
    //             .read<LoginBloc>()
    //             .state
    //             .staffInforDataModel
    //             ?.data
    //             ?.staffFacebook ??
    //         ''
    //     : null;
    // mounted
    //     ? instagramController.text = context
    //             .read<LoginBloc>()
    //             .state
    //             .staffInforDataModel
    //             ?.data
    //             ?.staffInstagram ??
    //         ''
    //     : null;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        fullNameController.text =
            state.managerInforModel?.data?.userFullName ?? '';
        surNameController.text =
            state.managerInforModel?.data?.userFirstName ?? '';
        nameController.text = state.managerInforModel?.data?.userLastName ?? '';
        emailController.text = state.managerInforModel?.data?.userEmail ?? '';
        phoneController.text = state.managerInforModel?.data?.userPhone ?? '';
        address4Controller.text =
            state.managerInforModel?.data?.userAddress4 ?? '';
        return Scaffold(
          body: SafeArea(
              child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.only(top: 40.h, left: 10.w, right: 10.w),
                        child: Container(
                          width: double.infinity,
                          // height: 100.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.r),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(
                                    0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(10.w),
                            child: IntrinsicHeight(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  InkWell(
                                      onTap: () {
                                        pickImage();
                                      },
                                      child: Stack(
                                        children: [
                                          Container(
                                            width: 100.w,
                                            height: 150.w,
                                            color: Colors.grey,
                                            child: selectedImage != null
                                                ? Image.file(
                                                    selectedImage!,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Container(
                                                    // width: 100.w,
                                                    color: Colors.grey,
                                                    child: Icon(Icons.person),
                                                  ),
                                          ),
                                          Positioned(
                                              top: 5.w,
                                              right: 5.w,
                                              child: Icon(Icons.edit))
                                        ],
                                      )),
                                  space25W,
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextApp(
                                        text: fullNameController.text,
                                        fontWeight: FontWeight.bold,
                                        fontsize: 18.sp,
                                      ),
                                      TextApp(
                                        text: "Tài khoản đã được xác nhận",
                                        fontsize: 14.sp,
                                        color: Color.fromRGBO(130, 214, 22, 1),
                                        fontWeight: FontWeight.bold,
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Form(
                        key: _formField1,
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 40.h, left: 10.w, right: 10.w),
                              child: Container(
                                  width: double.infinity,
                                  // height: heightView / 2,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.r),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: const Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(20.w),
                                    child: Column(
                                      children: [
                                        Text(
                                          "Thông tin cơ bản",
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
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            TextApp(
                                              text: " Họ và tên",
                                              fontsize: 10.sp,
                                              fontWeight: FontWeight.bold,
                                              color: blueText,
                                            ),
                                            SizedBox(
                                              height: 10.h,
                                            ),
                                            TextFormField(
                                              controller: fullNameController,
                                              keyboardType: TextInputType.name,
                                              style: TextStyle(
                                                  fontSize: 12.sp, color: grey),
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
                                                          255, 226, 104, 159),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color:
                                                                Color.fromRGBO(
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
                                                  // hintText: 'Tên',
                                                  isDense: true,
                                                  contentPadding:
                                                      EdgeInsets.all(15.w)),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 20.h,
                                        ),
                                        IntrinsicHeight(
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    TextApp(
                                                      text: " Họ",
                                                      fontsize: 10.sp,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: blueText,
                                                    ),
                                                    SizedBox(
                                                      height: 10.h,
                                                    ),
                                                    TextFormField(
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
                                                              fillColor: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      226,
                                                                      104,
                                                                      159),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderSide: BorderSide(
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
                                                              // hintText: 'Họ',
                                                              isDense: true,
                                                              contentPadding:
                                                                  EdgeInsets
                                                                      .all(15
                                                                          .w)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10.w,
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    TextApp(
                                                      text: " Tên",
                                                      fontsize: 10.sp,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: blueText,
                                                    ),
                                                    SizedBox(
                                                      height: 10.h,
                                                    ),
                                                    TextFormField(
                                                      keyboardType:
                                                          TextInputType.name,
                                                      controller:
                                                          nameController,
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
                                                              // hintText: 'Tên',
                                                              isDense: true,
                                                              contentPadding:
                                                                  EdgeInsets
                                                                      .all(15
                                                                          .w)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20.h,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            TextApp(
                                              text: " Số điện thoại",
                                              fontsize: 10.sp,
                                              fontWeight: FontWeight.bold,
                                              color: blueText,
                                            ),
                                            SizedBox(
                                              height: 10.h,
                                            ),
                                            TextFormField(
                                              controller: phoneController,
                                              keyboardType: TextInputType.name,
                                              style: TextStyle(
                                                  fontSize: 12.sp, color: grey),
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
                                                }
                                              },
                                              decoration: InputDecoration(
                                                  fillColor:
                                                      const Color.fromARGB(
                                                          255, 226, 104, 159),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color:
                                                                Color.fromRGBO(
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
                                                  // hintText: 'Tên',
                                                  isDense: true,
                                                  contentPadding:
                                                      EdgeInsets.all(15.w)),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 20.h,
                                        ),
                                        IntrinsicHeight(
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    TextApp(
                                                      text: " Tỉnh/Thành phố",
                                                      fontsize: 10.sp,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: blueText,
                                                    ),
                                                    SizedBox(
                                                      height: 10.h,
                                                    ),
                                                    TextFormField(
                                                      keyboardType:
                                                          TextInputType.name,
                                                      style: TextStyle(
                                                          fontSize: 12.sp,
                                                          color: grey),
                                                      cursorColor: grey,
                                                      decoration:
                                                          InputDecoration(
                                                              fillColor: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      226,
                                                                      104,
                                                                      159),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderSide: BorderSide(
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
                                                              // hintText: 'Họ',
                                                              isDense: true,
                                                              contentPadding:
                                                                  EdgeInsets
                                                                      .all(15
                                                                          .w)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10.w,
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    TextApp(
                                                      text: " Quận/Huyện",
                                                      fontsize: 10.sp,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: blueText,
                                                    ),
                                                    SizedBox(
                                                      height: 10.h,
                                                    ),
                                                    TextFormField(
                                                      keyboardType:
                                                          TextInputType.name,
                                                      style: TextStyle(
                                                          fontSize: 12.sp,
                                                          color: grey),
                                                      cursorColor: grey,
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
                                                              // hintText: 'Tên',
                                                              isDense: true,
                                                              contentPadding:
                                                                  EdgeInsets
                                                                      .all(15
                                                                          .w)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20.h,
                                        ),
                                        IntrinsicHeight(
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    TextApp(
                                                      text: " Phường/Xã",
                                                      fontsize: 10.sp,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: blueText,
                                                    ),
                                                    SizedBox(
                                                      height: 10.h,
                                                    ),
                                                    TextFormField(
                                                      keyboardType:
                                                          TextInputType.name,
                                                      style: TextStyle(
                                                          fontSize: 12.sp,
                                                          color: grey),
                                                      cursorColor: grey,
                                                      decoration:
                                                          InputDecoration(
                                                              fillColor: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      226,
                                                                      104,
                                                                      159),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderSide: BorderSide(
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
                                                              // hintText: 'Họ',
                                                              isDense: true,
                                                              contentPadding:
                                                                  EdgeInsets
                                                                      .all(15
                                                                          .w)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10.w,
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    TextApp(
                                                      text: " Số nhà, đường",
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
                                                          address4Controller,
                                                      keyboardType:
                                                          TextInputType.name,
                                                      style: TextStyle(
                                                          fontSize: 12.sp,
                                                          color: grey),
                                                      cursorColor: grey,
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
                                                              // hintText: 'Tên',
                                                              isDense: true,
                                                              contentPadding:
                                                                  EdgeInsets
                                                                      .all(15
                                                                          .w)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        space20H,
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            TextApp(
                                              text: " Email",
                                              fontsize: 12.sp,
                                              fontWeight: FontWeight.bold,
                                              color: blueText,
                                            ),
                                            SizedBox(
                                              height: 10.h,
                                            ),
                                            TextFormField(
                                              controller: emailController,
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              style: TextStyle(
                                                  fontSize: 12.sp, color: grey),
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
                                                  fillColor:
                                                      const Color.fromARGB(
                                                          255, 226, 104, 159),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color:
                                                                Color.fromRGBO(
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
                                                      EdgeInsets.all(15.w)),
                                            ),
                                          ],
                                        ),
                                        // SizedBox(
                                        //   height: 20.h,
                                        // ),
                                        // Column(
                                        //   crossAxisAlignment:
                                        //       CrossAxisAlignment.start,
                                        //   children: [
                                        //     TextApp(
                                        //       text: " Twitter",
                                        //       fontsize: 12.sp,
                                        //       fontWeight: FontWeight.bold,
                                        //       color: blueText,
                                        //     ),
                                        //     SizedBox(
                                        //       height: 10.h,
                                        //     ),
                                        //     TextField(
                                        //       controller: twitterController,
                                        //       style: TextStyle(
                                        //           fontSize: 14.sp, color: grey),
                                        //       cursorColor: grey,
                                        //       decoration: InputDecoration(
                                        //           fillColor:
                                        //               const Color.fromARGB(
                                        //                   255, 226, 104, 159),
                                        //           focusedBorder:
                                        //               OutlineInputBorder(
                                        //             borderSide:
                                        //                 const BorderSide(
                                        //                     color:
                                        //                         Color.fromRGBO(
                                        //                             214,
                                        //                             51,
                                        //                             123,
                                        //                             0.6),
                                        //                     width: 2.0),
                                        //             borderRadius:
                                        //                 BorderRadius.circular(
                                        //                     8.r),
                                        //           ),
                                        //           border: OutlineInputBorder(
                                        //             borderRadius:
                                        //                 BorderRadius.circular(
                                        //                     8.r),
                                        //           ),
                                        //           hintText: 'Twitter',
                                        //           isDense: true,
                                        //           contentPadding:
                                        //               EdgeInsets.all(15.w)),
                                        //     ),
                                        //   ],
                                        // ),
                                        // space20H,
                                        // Column(
                                        //   crossAxisAlignment:
                                        //       CrossAxisAlignment.start,
                                        //   children: [
                                        //     TextApp(
                                        //       text: " Facebook",
                                        //       fontsize: 12.sp,
                                        //       fontWeight: FontWeight.bold,
                                        //       color: blueText,
                                        //     ),
                                        //     SizedBox(
                                        //       height: 10.h,
                                        //     ),
                                        //     TextField(
                                        //       controller: facebookController,
                                        //       style: TextStyle(
                                        //           fontSize: 14.sp, color: grey),
                                        //       cursorColor: grey,
                                        //       decoration: InputDecoration(
                                        //           fillColor:
                                        //               const Color.fromARGB(
                                        //                   255, 226, 104, 159),
                                        //           focusedBorder:
                                        //               OutlineInputBorder(
                                        //             borderSide:
                                        //                 const BorderSide(
                                        //                     color:
                                        //                         Color.fromRGBO(
                                        //                             214,
                                        //                             51,
                                        //                             123,
                                        //                             0.6),
                                        //                     width: 2.0),
                                        //             borderRadius:
                                        //                 BorderRadius.circular(
                                        //                     8.r),
                                        //           ),
                                        //           border: OutlineInputBorder(
                                        //             borderRadius:
                                        //                 BorderRadius.circular(
                                        //                     8.r),
                                        //           ),
                                        //           hintText: 'Facebook',
                                        //           isDense: true,
                                        //           contentPadding:
                                        //               EdgeInsets.all(15.w)),
                                        //     ),
                                        //   ],
                                        // ),
                                        // space20H,
                                        // Column(
                                        //   crossAxisAlignment:
                                        //       CrossAxisAlignment.start,
                                        //   children: [
                                        //     TextApp(
                                        //       text: " Instagram",
                                        //       fontsize: 12.sp,
                                        //       fontWeight: FontWeight.bold,
                                        //       color: blueText,
                                        //     ),
                                        //     SizedBox(
                                        //       height: 10.h,
                                        //     ),
                                        //     TextField(
                                        //       controller: instagramController,
                                        //       style: TextStyle(
                                        //           fontSize: 14.sp, color: grey),
                                        //       cursorColor: grey,
                                        //       decoration: InputDecoration(
                                        //           fillColor:
                                        //               const Color.fromARGB(
                                        //                   255, 226, 104, 159),
                                        //           focusedBorder:
                                        //               OutlineInputBorder(
                                        //             borderSide:
                                        //                 const BorderSide(
                                        //                     color:
                                        //                         Color.fromRGBO(
                                        //                             214,
                                        //                             51,
                                        //                             123,
                                        //                             0.6),
                                        //                     width: 2.0),
                                        //             borderRadius:
                                        //                 BorderRadius.circular(
                                        //                     8.r),
                                        //           ),
                                        //           border: OutlineInputBorder(
                                        //             borderRadius:
                                        //                 BorderRadius.circular(
                                        //                     8.r),
                                        //           ),
                                        //           hintText: 'Instagram',
                                        //           isDense: true,
                                        //           contentPadding:
                                        //               EdgeInsets.all(15.w)),
                                        //     ),
                                        //   ],
                                        // ),
                                        space20H,
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            SizedBox(
                                              width: 200.w,
                                              child: ButtonGradient(
                                                color1: color1DarkButton,
                                                color2: color2DarkButton,
                                                event: () {
                                                  if (_formField1.currentState!
                                                      .validate()) {
                                                    surNameController.clear();
                                                    nameController.clear();
                                                    fullNameController.clear();
                                                    emailController.clear();
                                                    phoneController.clear();
                                                  }
                                                },
                                                text: "Cập nhật thông tin",
                                                fontSize: 12.sp,
                                                radius: 8.r,
                                                textColor: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 20.h,
                                        ),
                                      ],
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      ),

                      //Password form

                      Form(
                        key: _formField2,
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 40.h, left: 10.w, right: 10.w),
                          child: Container(
                              width: double.infinity,
                              // height: heightView / 2,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.r),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: const Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(20.w),
                                child: Column(
                                  children: [
                                    Text(
                                      "Mật khẩu",
                                      style: TextStyle(
                                        color: const Color.fromRGBO(
                                            52, 71, 103, 1),
                                        fontFamily: "Icomoon",
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24.sp,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextApp(
                                          text: " Mật khẩu hiện tại",
                                          fontsize: 12.sp,
                                          fontWeight: FontWeight.bold,
                                          color: blueText,
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        TextFormField(
                                          controller:
                                              currentPassworldController,
                                          obscureText: currentPasswordVisible,
                                          style: TextStyle(
                                              fontSize: 12.sp, color: grey),
                                          cursorColor: grey,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return canNotNull;
                                            } else if (value.length < 8) {
                                              return passwordRequiedLength;
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
                                                        currentPasswordVisible =
                                                            !currentPasswordVisible;
                                                      },
                                                    );
                                                  },
                                                  icon: Icon(
                                                      currentPasswordVisible
                                                          ? Icons.visibility_off
                                                          : Icons.visibility)),
                                              fillColor: const Color.fromARGB(
                                                  255, 226, 104, 159),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Color.fromRGBO(
                                                        214, 51, 123, 0.6),
                                                    width: 2.0),
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                              ),
                                              hintText: 'Mật khẩu hiện tại',
                                              isDense: true,
                                              contentPadding:
                                                  EdgeInsets.all(15.w)),
                                        ),
                                      ],
                                    ),
                                    space20H,
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextApp(
                                          text: " Mật khẩu mới",
                                          fontsize: 12.sp,
                                          fontWeight: FontWeight.bold,
                                          color: blueText,
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        TextFormField(
                                          controller: newPassworldController,
                                          obscureText: newPasswordVisible,
                                          style: TextStyle(
                                              fontSize: 12.sp, color: grey),
                                          cursorColor: grey,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return canNotNull;
                                            } else if (value.length < 8) {
                                              return passwordRequiedLength;
                                            } else if (value ==
                                                currentPassworldController
                                                    .text) {
                                              return newPasswordMustNotSameAsCurrentPassword;
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
                                                        newPasswordVisible =
                                                            !newPasswordVisible;
                                                      },
                                                    );
                                                  },
                                                  icon: Icon(newPasswordVisible
                                                      ? Icons.visibility_off
                                                      : Icons.visibility)),
                                              fillColor: const Color.fromARGB(
                                                  255, 226, 104, 159),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Color.fromRGBO(
                                                        214, 51, 123, 0.6),
                                                    width: 2.0),
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                              ),
                                              hintText: 'Mật khẩu mới',
                                              isDense: true,
                                              contentPadding:
                                                  EdgeInsets.all(15.w)),
                                        ),
                                      ],
                                    ),
                                    space20H,
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextApp(
                                          text: " Nhập lại mật khẩu mới",
                                          fontsize: 12.sp,
                                          fontWeight: FontWeight.bold,
                                          color: blueText,
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        TextFormField(
                                          controller: reNewPassworldController,
                                          obscureText: reNewPasswordVisible,
                                          style: TextStyle(
                                              fontSize: 12.sp, color: grey),
                                          cursorColor: grey,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return canNotNull;
                                            } else if (value.length < 8) {
                                              return passwordRequiedLength;
                                            } else if (value !=
                                                newPassworldController.text) {
                                              return rePasswordNotCorrect;
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
                                                        reNewPasswordVisible =
                                                            !reNewPasswordVisible;
                                                      },
                                                    );
                                                  },
                                                  icon: Icon(
                                                      reNewPasswordVisible
                                                          ? Icons.visibility_off
                                                          : Icons.visibility)),
                                              fillColor: const Color.fromARGB(
                                                  255, 226, 104, 159),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Color.fromRGBO(
                                                        214, 51, 123, 0.6),
                                                    width: 2.0),
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                              ),
                                              hintText: 'Nhập lại mật khẩu mới',
                                              isDense: true,
                                              contentPadding:
                                                  EdgeInsets.all(15.w)),
                                        ),
                                      ],
                                    ),
                                    space20H,
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SizedBox(
                                          width: 200.w,
                                          child: ButtonGradient(
                                            color1: color1DarkButton,
                                            color2: color2DarkButton,
                                            event: () {
                                              if (_formField2.currentState!
                                                  .validate()) {
                                                currentPassworldController
                                                    .clear();
                                                newPassworldController.clear();
                                                reNewPassworldController
                                                    .clear();
                                              }
                                            },
                                            text: "Cập nhật mật khẩu",
                                            fontSize: 12.sp,
                                            radius: 8.r,
                                            textColor: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      ),
                      space25H,

                      CopyRightText(),
                      space35H,
                    ],
                  ))),
        );
      },
    );
  }
}
