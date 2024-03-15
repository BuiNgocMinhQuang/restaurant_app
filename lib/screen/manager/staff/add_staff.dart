import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/config/fake_data.dart';
import 'package:app_restaurant/config/space.dart';
import 'package:app_restaurant/config/text.dart';
import 'package:app_restaurant/widgets/button/button_gradient.dart';
import 'package:app_restaurant/widgets/item_drawer.dart';
import 'package:app_restaurant/widgets/sub_item_drawer.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddStaff extends StatefulWidget {
  const AddStaff({super.key});

  @override
  State<AddStaff> createState() => _AddStaffState();
}

class _AddStaffState extends State<AddStaff> {
  bool isShowListStores = false;
  bool isShowListRoles = false;
  bool passwordVisible = true;
  bool rePasswordVisible = true;
  int currentSection = 1;
  final _formField = GlobalKey<FormState>();
  final _formField2 = GlobalKey<FormState>();
  final surNameController = TextEditingController();
  final nameController = TextEditingController();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passworldController = TextEditingController();
  final rePassworldController = TextEditingController();
  final addressController = TextEditingController();
  sectionController() {
    switch (currentSection) {
      case 1:
        return Container(
          width: 1.sw,
          // height: 1.sh,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Form(
            key: _formField,
            child: Column(
              children: [
                Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.r),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextApp(
                            text: "Về nhân viên",
                            color: const Color.fromRGBO(52, 71, 103, 1),
                            fontFamily: "OpenSans",
                            fontWeight: FontWeight.bold,
                            fontsize: 20.sp,
                          ),
                          space10H,
                          TextApp(
                            text: "Thông tin bắt buộc",
                            color: Colors.grey,
                            fontFamily: "OpenSans",
                            fontWeight: FontWeight.normal,
                            fontsize: 14.sp,
                          ),
                          space20H,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextApp(
                                text: " Thuộc cửa hàng",
                                fontsize: 12.sp,
                                fontWeight: FontWeight.bold,
                                color: blueText,
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              DropdownSearch(
                                validator: (value) {
                                  if (value == "Chọn cửa hàng") {
                                    return canNotNull;
                                  } else {
                                    return null;
                                  }
                                },
                                items: listStore,
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                    fillColor: const Color.fromARGB(
                                        255, 226, 104, 159),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color:
                                              Color.fromRGBO(214, 51, 123, 0.6),
                                          width: 2.0),
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    isDense: true,
                                    contentPadding: EdgeInsets.all(15.w),
                                    hintText: "Chọn cửa hàng",
                                  ),
                                ),
                                onChanged: print,
                                selectedItem: "Chọn cửa hàng",
                              ),
                            ],
                          ),
                          space20H,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextApp(
                                text: " Chức vụ",
                                fontsize: 12.sp,
                                fontWeight: FontWeight.bold,
                                color: blueText,
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              DropdownSearch(
                                validator: (value) {
                                  if (value == "Chọn chức vụ") {
                                    return canNotNull;
                                  } else {
                                    return null;
                                  }
                                },
                                items: listRole,
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                    fillColor: const Color.fromARGB(
                                        255, 226, 104, 159),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color:
                                              Color.fromRGBO(214, 51, 123, 0.6),
                                          width: 2.0),
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    isDense: true,
                                    contentPadding: EdgeInsets.all(15.w),
                                    hintText: "Chọn chức vụ",
                                  ),
                                ),
                                onChanged: print,
                                selectedItem: "Chọn chức vụ",
                              ),
                            ],
                          ),
                          space20H,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextApp(
                                text: " Tên đầy đủ",
                                fontsize: 12.sp,
                                fontWeight: FontWeight.bold,
                                color: blueText,
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              TextFormField(
                                controller: fullNameController,
                                style: TextStyle(fontSize: 14.sp, color: grey),
                                cursorColor: grey,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return fullnameIsRequied;
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                    fillColor: const Color.fromARGB(
                                        255, 226, 104, 159),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color:
                                              Color.fromRGBO(214, 51, 123, 0.6),
                                          width: 2.0),
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    hintText: 'Tên đầy đủ',
                                    isDense: true,
                                    contentPadding: EdgeInsets.all(15.w)),
                              ),
                            ],
                          ),
                          space20H,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextApp(
                                text: " Họ",
                                fontsize: 12.sp,
                                fontWeight: FontWeight.bold,
                                color: blueText,
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              TextFormField(
                                controller: surNameController,
                                style: TextStyle(fontSize: 14.sp, color: grey),
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
                                      const Color.fromARGB(255, 226, 104, 159),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color:
                                            Color.fromRGBO(214, 51, 123, 0.6),
                                        width: 2.0),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  hintText: 'Họ',
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(15.w),
                                ),
                              ),
                            ],
                          ),
                          space20H,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextApp(
                                text: " Tên",
                                fontsize: 12.sp,
                                fontWeight: FontWeight.bold,
                                color: blueText,
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              TextFormField(
                                controller: nameController,
                                style: TextStyle(fontSize: 14.sp, color: grey),
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
                                      const Color.fromARGB(255, 226, 104, 159),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color:
                                            Color.fromRGBO(214, 51, 123, 0.6),
                                        width: 2.0),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  hintText: 'Tên',
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(15.w),
                                ),
                              ),
                            ],
                          ),
                          space20H,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextApp(
                                text: " Số điện thoại",
                                fontsize: 12.sp,
                                fontWeight: FontWeight.bold,
                                color: blueText,
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              TextFormField(
                                controller: phoneController,
                                style: TextStyle(fontSize: 14.sp, color: grey),
                                cursorColor: grey,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return phoneIsRequied;
                                  }
                                  bool phoneValid =
                                      RegExp(r'^(?:[+0]9)?[0-9]{10}$')
                                          .hasMatch(value);

                                  if (!phoneValid) {
                                    return invalidPhone;
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                  fillColor:
                                      const Color.fromARGB(255, 226, 104, 159),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color:
                                            Color.fromRGBO(214, 51, 123, 0.6),
                                        width: 2.0),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  hintText: 'Số điện thoại',
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(15.w),
                                ),
                              ),
                            ],
                          ),
                          space20H,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                style: TextStyle(fontSize: 14.sp, color: grey),
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
                                      const Color.fromARGB(255, 226, 104, 159),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color:
                                            Color.fromRGBO(214, 51, 123, 0.6),
                                        width: 2.0),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  hintText: 'Email',
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(15.w),
                                ),
                              ),
                            ],
                          ),
                          space20H,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextApp(
                                text: " Mật khẩu",
                                fontsize: 12.sp,
                                fontWeight: FontWeight.bold,
                                color: blueText,
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              TextFormField(
                                controller: passworldController,
                                obscureText: passwordVisible,
                                style: TextStyle(fontSize: 14.sp, color: grey),
                                cursorColor: grey,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return passwordIsRequied;
                                  } else if (value.length < 8) {
                                    return passwordRequiedLength;
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                  suffixIconColor:
                                      Color.fromARGB(255, 226, 104, 159),
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(
                                          () {
                                            passwordVisible = !passwordVisible;
                                          },
                                        );
                                      },
                                      icon: Icon(passwordVisible
                                          ? Icons.visibility_off
                                          : Icons.visibility)),
                                  fillColor:
                                      const Color.fromARGB(255, 226, 104, 159),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color:
                                            Color.fromRGBO(214, 51, 123, 0.6),
                                        width: 2.0),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  hintText: 'Mật khẩu',
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(15.w),
                                ),
                              ),
                            ],
                          ),
                          space20H,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextApp(
                                text: " Nhập lại mật khẩu",
                                fontsize: 12.sp,
                                fontWeight: FontWeight.bold,
                                color: blueText,
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              TextFormField(
                                controller: rePassworldController,
                                obscureText: rePasswordVisible,
                                style: TextStyle(fontSize: 14.sp, color: grey),
                                cursorColor: grey,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return rePasswordIsRequied;
                                  } else if (value !=
                                      passworldController.text) {
                                    return rePasswordNotCorrect;
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                  suffixIconColor:
                                      Color.fromARGB(255, 226, 104, 159),
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
                                          ? Icons.visibility_off
                                          : Icons.visibility)),
                                  fillColor:
                                      const Color.fromARGB(255, 226, 104, 159),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color:
                                            Color.fromRGBO(214, 51, 123, 0.6),
                                        width: 2.0),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  hintText: 'Nhập lại mật khẩu',
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(15.w),
                                ),
                              ),
                            ],
                          ),
                          space20H,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                width: 100.w,
                                child: ButtonGradient(
                                  color1: color1DarkButton,
                                  color2: color2DarkButton,
                                  event: () {
                                    if (_formField.currentState!.validate()) {
                                      final isLastStep =
                                          currentStep == getStep().length - 1;
                                      if (isLastStep) {
                                        print("Complete");
                                      } else {
                                        setState(() {
                                          currentSection++;
                                          currentStep += 1;
                                        });
                                      }
                                      surNameController.clear();
                                      nameController.clear();
                                      fullNameController.clear();
                                      emailController.clear();
                                      phoneController.clear();
                                      passworldController.clear();
                                      rePassworldController.clear();
                                    }
                                  },
                                  text: "Tiếp",
                                  fontSize: 12.sp,
                                  radius: 8.r,
                                  textColor: Colors.white,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    )),
              ],
            ),
          ),
        );

      case 2:
        return Container(
          width: 1.sw,
          // height: 1.sh,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Form(
            key: _formField2,
            child: Column(
              children: [
                Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.r),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextApp(
                            text: "Về nhân viên",
                            color: const Color.fromRGBO(52, 71, 103, 1),
                            fontFamily: "OpenSans",
                            fontWeight: FontWeight.bold,
                            fontsize: 20.sp,
                          ),
                          space10H,
                          TextApp(
                            text: "Thông tin bắt buộc",
                            color: Colors.grey,
                            fontFamily: "OpenSans",
                            fontWeight: FontWeight.normal,
                            fontsize: 14.sp,
                          ),
                          space20H,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextApp(
                                text: " Tỉnh/Thành phố",
                                fontsize: 12.sp,
                                fontWeight: FontWeight.bold,
                                color: blueText,
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              DropdownSearch(
                                validator: (value) {
                                  if (value == "Chọn tỉnh/thành phố") {
                                    return canNotNull;
                                  } else {
                                    return null;
                                  }
                                },
                                items: listProvinces,
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                    fillColor: const Color.fromARGB(
                                        255, 226, 104, 159),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color:
                                              Color.fromRGBO(214, 51, 123, 0.6),
                                          width: 2.0),
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    isDense: true,
                                    contentPadding: EdgeInsets.all(15.w),
                                    hintText: "Chọn tỉnh/thành phố",
                                  ),
                                ),
                                onChanged: print,
                                selectedItem: "Chọn tỉnh/thành phố",
                              ),
                            ],
                          ),
                          space20H,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextApp(
                                text: " Quận/Huyện",
                                fontsize: 12.sp,
                                fontWeight: FontWeight.bold,
                                color: blueText,
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              DropdownSearch(
                                validator: (value) {
                                  if (value == "Chọn quận/huyện") {
                                    return canNotNull;
                                  } else {
                                    return null;
                                  }
                                },
                                items: listRole,
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                    fillColor: const Color.fromARGB(
                                        255, 226, 104, 159),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color:
                                              Color.fromRGBO(214, 51, 123, 0.6),
                                          width: 2.0),
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    isDense: true,
                                    contentPadding: EdgeInsets.all(15.w),
                                    hintText: "Chọn quận/huyện",
                                  ),
                                ),
                                onChanged: print,
                                selectedItem: "Chọn quận/huyện",
                              ),
                            ],
                          ),
                          space20H,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextApp(
                                text: " Phường/Xã",
                                fontsize: 12.sp,
                                fontWeight: FontWeight.bold,
                                color: blueText,
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              DropdownSearch(
                                validator: (value) {
                                  if (value == "Chọn phường/xã") {
                                    return canNotNull;
                                  } else {
                                    return null;
                                  }
                                },
                                items: listRole,
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                    fillColor: const Color.fromARGB(
                                        255, 226, 104, 159),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color:
                                              Color.fromRGBO(214, 51, 123, 0.6),
                                          width: 2.0),
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    isDense: true,
                                    contentPadding: EdgeInsets.all(15.w),
                                    hintText: "Chọn phường/xã",
                                  ),
                                ),
                                onChanged: print,
                                selectedItem: "Chọn phường/xã",
                              ),
                            ],
                          ),
                          space20H,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextApp(
                                text: " Số nhà, đường",
                                fontsize: 12.sp,
                                fontWeight: FontWeight.bold,
                                color: blueText,
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              TextFormField(
                                controller: addressController,
                                style: TextStyle(fontSize: 14.sp, color: grey),
                                cursorColor: grey,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return canNotNull;
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                    fillColor: const Color.fromARGB(
                                        255, 226, 104, 159),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color:
                                              Color.fromRGBO(214, 51, 123, 0.6),
                                          width: 2.0),
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    hintText: 'Số nhà, đường',
                                    isDense: true,
                                    contentPadding: EdgeInsets.all(15.w)),
                              ),
                            ],
                          ),
                          space20H,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 100.w,
                                child: ButtonGradient(
                                  color1: color1GreyButton,
                                  color2: color2GreyButton,
                                  event: () {
                                    currentStep == 0
                                        ? null
                                        : setState(() {
                                            currentStep -= 1;
                                            currentSection--;
                                          });
                                  },
                                  text: "Về trước",
                                  fontSize: 12.sp,
                                  radius: 8.r,
                                  textColor: blueText,
                                ),
                              ),
                              SizedBox(
                                width: 100.w,
                                child: ButtonGradient(
                                  color1: color1DarkButton,
                                  color2: color2DarkButton,
                                  event: () {
                                    if (_formField2.currentState!.validate()) {
                                      final isLastStep =
                                          currentStep == getStep().length - 1;
                                      if (isLastStep) {
                                      } else {
                                        setState(() {
                                          currentStep += 1;
                                          currentSection++;
                                        });
                                      }
                                      addressController.clear();
                                    }
                                  },
                                  text: "Tiếp",
                                  fontSize: 12.sp,
                                  radius: 8.r,
                                  textColor: Colors.white,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    )),
              ],
            ),
          ),
        );

      case 3:
        return Container(
          width: 1.sw,
          // height: 1.sh,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Column(
            children: [
              Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.r),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextApp(
                          text: "Mạng xã hội",
                          color: const Color.fromRGBO(52, 71, 103, 1),
                          fontFamily: "OpenSans",
                          fontWeight: FontWeight.bold,
                          fontsize: 20.sp,
                        ),
                        space20H,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextApp(
                              text: " Twitter",
                              fontsize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: blueText,
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            TextField(
                              style: TextStyle(fontSize: 14.sp, color: grey),
                              cursorColor: grey,
                              decoration: InputDecoration(
                                  fillColor:
                                      const Color.fromARGB(255, 226, 104, 159),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color:
                                            Color.fromRGBO(214, 51, 123, 0.6),
                                        width: 2.0),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  hintText: 'Twitter',
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(15.w)),
                            ),
                          ],
                        ),
                        space20H,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextApp(
                              text: " Facebook",
                              fontsize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: blueText,
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            TextField(
                              style: TextStyle(fontSize: 14.sp, color: grey),
                              cursorColor: grey,
                              decoration: InputDecoration(
                                  fillColor:
                                      const Color.fromARGB(255, 226, 104, 159),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color:
                                            Color.fromRGBO(214, 51, 123, 0.6),
                                        width: 2.0),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  hintText: 'Facebook',
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(15.w)),
                            ),
                          ],
                        ),
                        space20H,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextApp(
                              text: " Instagram",
                              fontsize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: blueText,
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            TextField(
                              style: TextStyle(fontSize: 14.sp, color: grey),
                              cursorColor: grey,
                              decoration: InputDecoration(
                                  fillColor:
                                      const Color.fromARGB(255, 226, 104, 159),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color:
                                            Color.fromRGBO(214, 51, 123, 0.6),
                                        width: 2.0),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  hintText: 'Instagram',
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(15.w)),
                            ),
                          ],
                        ),
                        space20H,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 100.w,
                              child: ButtonGradient(
                                color1: color1GreyButton,
                                color2: color2GreyButton,
                                event: () {
                                  currentStep == 0
                                      ? null
                                      : setState(() {
                                          currentStep -= 1;
                                          currentSection--;
                                        });
                                },
                                text: "Về trước",
                                fontSize: 12.sp,
                                radius: 8.r,
                                textColor: blueText,
                              ),
                            ),
                            SizedBox(
                              width: 100.w,
                              child: ButtonGradient(
                                color1: color1DarkButton,
                                color2: color2DarkButton,
                                event: () {
                                  final isLastStep =
                                      currentStep == getStep().length - 1;
                                  if (isLastStep) {
                                  } else {
                                    setState(() {
                                      currentStep += 1;
                                    });
                                  }
                                },
                                text: save,
                                fontSize: 12.sp,
                                radius: 8.r,
                                textColor: Colors.white,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  )),
            ],
          ),
        );
    }
  }

  void closeListStores() {
    setState(() {
      isShowListStores = false;
    });
  }

  void closeListRoles() {
    setState(() {
      isShowListRoles = false;
    });
  }

  List<Step> getStep() => [
        Step(
            isActive: currentStep >= 0,
            state: currentStep > 0 ? StepState.complete : StepState.indexed,
            title: const Text(""),
            content: Container()),
        Step(
            isActive: currentStep >= 1,
            state: currentStep > 1 ? StepState.complete : StepState.indexed,
            title: const Text(""),
            content: Container()),
        Step(
            isActive: currentStep >= 2,
            state: currentStep > 2 ? StepState.complete : StepState.indexed,
            title: const Text(""),
            content: Container())
      ];
  int currentStep = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                  child: Padding(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 40.w, right: 40.w),
                      child: SizedBox(
                          width: 1.sw,
                          height: 100.h,
                          // color: Colors.white,
                          child: Theme(
                            data: ThemeData(canvasColor: Colors.white),
                            child: Stepper(
                              currentStep: currentStep,
                              type: StepperType.horizontal,
                              steps: getStep(),
                              onStepTapped: (step) {
                                setState(() {
                                  currentStep = step;
                                  currentSection = step + 1;
                                });
                              },
                              onStepContinue: () {
                                final isLastStep =
                                    currentStep == getStep().length - 1;
                                if (isLastStep) {
                                } else {
                                  setState(() {
                                    currentStep += 1;
                                  });
                                }
                              },
                              onStepCancel: () {
                                currentStep == 0
                                    ? null
                                    : setState(() {
                                        currentStep -= 1;
                                      });
                              },
                            ),
                          )),
                    ),
                    sectionController()
                    // AboutStaffModal()
                  ],
                ),
              )),
            ),
          ],
        ));
  }
}