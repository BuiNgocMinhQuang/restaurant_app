import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/config/space.dart';
import 'package:app_restaurant/config/text.dart';
import 'package:app_restaurant/widgets/button/button_gradient.dart';
import 'package:app_restaurant/widgets/item_drawer.dart';
import 'package:app_restaurant/widgets/sub_item_drawer.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

List<String> listStore = [
  "Cửa hàng 1",
  "Cửa hàng 2",
  "Cửa hàng 3",
  "Cửa hàng 4"
];
List<String> listRole = ["Nhân viên", "Trưởng nhóm", "Quản lý", "Kế toán"];

List<Object> listProvinces = [
  {
    "_id": "60eaaa6f1173335842c35663",
    "name": "An Giang",
    "slug": "an-giang",
    "type": "tinh",
    "name_with_type": "Tỉnh An Giang",
    "code": "89",
    "isDeleted": false
  },
  {
    "_id": "60eaaa6f1173335842c3565b",
    "name": "Bà Rịa - Vũng Tàu",
    "slug": "ba-ria---vung-tau",
    "type": "tinh",
    "name_with_type": "Tỉnh Bà Rịa - Vũng Tàu",
    "code": "77",
    "isDeleted": false
  },
  {
    "_id": "60eaaa6f1173335842c35668",
    "name": "Bạc Liêu",
    "slug": "bac-lieu",
    "type": "tinh",
    "name_with_type": "Tỉnh Bạc Liêu",
    "code": "95",
    "isDeleted": false
  },
];

List<Object> listDistricts = [
  {
    "_id": "60eaaa6f1173335842c3536a",
    "name": "Ba Đình",
    "type": "quan",
    "slug": "ba-dinh",
    "name_with_type": "Quận Ba Đình",
    "path": "Ba Đình, Hà Nội",
    "path_with_type": "Quận Ba Đình, Thành phố Hà Nội",
    "code": "001",
    "parent_code": "01",
    "isDeleted": false
  },
  {
    "_id": "60eaaa6f1173335842c3536b",
    "name": "Hoàn Kiếm",
    "type": "quan",
    "slug": "hoan-kiem",
    "name_with_type": "Quận Hoàn Kiếm",
    "path": "Hoàn Kiếm, Hà Nội",
    "path_with_type": "Quận Hoàn Kiếm, Thành phố Hà Nội",
    "code": "002",
    "parent_code": "01",
    "isDeleted": false
  },
  {
    "_id": "60eaaa6f1173335842c3536c",
    "name": "Tây Hồ",
    "type": "quan",
    "slug": "tay-ho",
    "name_with_type": "Quận Tây Hồ",
    "path": "Tây Hồ, Hà Nội",
    "path_with_type": "Quận Tây Hồ, Thành phố Hà Nội",
    "code": "003",
    "parent_code": "01",
    "isDeleted": false
  },
];

List<Object> listwards = [
  {
    "_id": "60eaaa721173335842c35ebd",
    "name": " A Dơi",
    "type": "xa",
    "slug": "a-doi",
    "name_with_type": "Xã  A Dơi",
    "path": " A Dơi, Hướng Hóa, Quảng Trị",
    "path_with_type": "Xã  A Dơi, Huyện Hướng Hóa, Tỉnh Quảng Trị",
    "code": "19483",
    "parent_code": "465",
    "isDeleted": false
  },
  {
    "_id": "60eaaa721173335842c369a0",
    "name": " An Lạc",
    "type": "phuong",
    "slug": "an-lac",
    "name_with_type": "Phường  An Lạc",
    "path": " An Lạc, Bình Tân, Hồ Chí Minh",
    "path_with_type": "Phường  An Lạc, Quận Bình Tân, Thành phố Hồ Chí Minh",
    "code": "27460",
    "parent_code": "777",
    "isDeleted": false
  },
  {
    "_id": "60eaaa721173335842c365d2",
    "name": " Đắk Lao",
    "type": "xa",
    "slug": "dak-lao",
    "name_with_type": "Xã  Đắk Lao",
    "path": " Đắk Lao, Đắk Mil, Đắk Nông",
    "path_with_type": "Xã  Đắk Lao, Huyện Đắk Mil, Tỉnh Đắk Nông",
    "code": "24667",
    "parent_code": "663",
    "isDeleted": false
  },
];

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
                                // popupProps: PopupProps.menu(
                                //   showSelectedItems: true,
                                //   disabledItemFn: (String s) => s.startsWith(''),
                                // ),

                                validator: (value) {
                                  if (value == "Chọn cửa hàng") {
                                    return canNotNull;
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
                                // popupProps: PopupProps.menu(
                                //   showSelectedItems: true,
                                //   disabledItemFn: (String s) => s.startsWith(''),
                                // ),
                                validator: (value) {
                                  if (value == "Chọn chức vụ") {
                                    return canNotNull;
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
                                  color1: const Color.fromRGBO(20, 23, 39, 1),
                                  color2: const Color.fromRGBO(58, 65, 111, 1),
                                  event: () {
                                    if (_formField.currentState!.validate()) {
                                      setState(() {
                                        currentSection++;
                                      });
                                      surNameController.clear();
                                      nameController.clear();
                                      fullNameController.clear();
                                      emailController.clear();
                                      phoneController.clear();
                                      passworldController.clear();
                                      rePassworldController.clear();
                                    }
                                    // else {
                                    // setState(() {
                                    //   currentSection++;
                                    // });
                                    // }
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
                                // popupProps: PopupProps.menu(
                                //   showSelectedItems: true,
                                //   disabledItemFn: (String s) => s.startsWith(''),
                                // ),
                                validator: (value) {
                                  if (value == "Chọn tỉnh/thành phố") {
                                    return canNotNull;
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
                                // popupProps: PopupProps.menu(
                                //   showSelectedItems: true,
                                //   disabledItemFn: (String s) => s.startsWith(''),
                                // ),
                                validator: (value) {
                                  if (value == "Chọn quận/huyện") {
                                    return canNotNull;
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
                                // popupProps: PopupProps.menu(
                                //   showSelectedItems: true,
                                //   disabledItemFn: (String s) => s.startsWith(''),
                                // ),
                                validator: (value) {
                                  if (value == "Chọn phường/xã") {
                                    return canNotNull;
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
                                  color1:
                                      const Color.fromRGBO(206, 212, 218, 1),
                                  color2:
                                      const Color.fromRGBO(235, 239, 244, 1),
                                  event: () {
                                    setState(() {
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
                                  color1: const Color.fromRGBO(20, 23, 39, 1),
                                  color2: const Color.fromRGBO(58, 65, 111, 1),
                                  event: () {
                                    if (_formField2.currentState!.validate()) {
                                      setState(() {
                                        currentSection++;
                                      });
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
                                color1: const Color.fromRGBO(206, 212, 218, 1),
                                color2: const Color.fromRGBO(235, 239, 244, 1),
                                event: () {
                                  setState(() {
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
                                color1: const Color.fromRGBO(20, 23, 39, 1),
                                color2: const Color.fromRGBO(58, 65, 111, 1),
                                event: () {},
                                text: "Lưu",
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thêm nhân viên"),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
                child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(40.w),
                    child: Container(
                      width: 1.sw,
                      height: 30.h,
                      color: Colors.black,
                    ),
                  ),
                  sectionController()
                  // AboutStaffModal()
                ],
              ),
            )),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 100.w,
                  height: 100.w,
                  child: Image.asset(
                    "assets/images/logo-thv.png",
                    fit: BoxFit.contain,
                  ),
                ),
                const Divider(
                  color: Colors.black45,
                ),
                space10H,
                TextApp(
                  text: 'Tất cả cửa hàng',
                  color: grey,
                  fontsize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
                space25H,
                ItemDrawer(
                    // item: DrawerItem.stores,
                    text: 'Cửa hàng 1',
                    subItem: [
                      SubItemDrawer(
                          text: "Đặt bàn",
                          event: () {
                            Navigator.pop(context);
                          }),
                      SizedBox(
                        height: 10.h,
                      ),
                      SubItemDrawer(
                          text: "Danh sách hóa đơn",
                          event: () {
                            Navigator.pop(context);
                          }),
                      SizedBox(
                        height: 10.h,
                      ),
                      SubItemDrawer(
                          text: "Hóa đơn mang về",
                          event: () {
                            Navigator.pop(context);
                          })
                    ],
                    icon: Icons.store),
                space25H,
                ItemDrawer(
                    // item: DrawerItem.stores,
                    text: 'Cửa hàng 2',
                    subItem: [
                      SubItemDrawer(
                          text: "Đặt bàn",
                          event: () {
                            Navigator.pop(context);
                          }),
                      SizedBox(
                        height: 10.h,
                      ),
                      SubItemDrawer(
                          text: "Danh sách hóa đơn",
                          event: () {
                            Navigator.pop(context);
                          }),
                      SizedBox(
                        height: 10.h,
                      ),
                      SubItemDrawer(
                          text: "Hóa đơn mang về",
                          event: () {
                            Navigator.pop(context);
                          })
                    ],
                    icon: Icons.store),
              ],
            ),
            space20H,
            Padding(
                padding: EdgeInsets.all(15.w),
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 180.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          image: const DecorationImage(
                            image: AssetImage("assets/images/curved9.jpg"),
                            fit: BoxFit.fill,
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.all(15.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 50.w,
                            height: 50.w,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white),
                            child: Icon(Icons.power_settings_new_outlined),
                          ),
                          space15H,
                          Center(
                            child: TextApp(
                              text: "Ten Chu Cua Hang",
                              textAlign: TextAlign.center,
                              color: Colors.white,
                            ),
                          ),
                          Center(
                            child: TextApp(
                                text: "chucuahang@gmail.com",
                                textAlign: TextAlign.center,
                                color: Colors.white),
                          ),
                          space10H,
                          ButtonGradient(
                            color1: Colors.white,
                            color2: Colors.white,
                            event: () {},
                            text: "Đăng xuất",
                            textColor: Colors.black,
                            radius: 8.r,
                          )
                        ],
                      ),
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
