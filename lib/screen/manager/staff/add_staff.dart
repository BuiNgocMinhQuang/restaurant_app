import 'dart:convert';
import 'dart:developer';

import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/config/space.dart';
import 'package:app_restaurant/config/text.dart';
import 'package:app_restaurant/model/manager/manager_list_store_model.dart';
import 'package:app_restaurant/utils/storage.dart';
import 'package:app_restaurant/widgets/button/button_gradient.dart';

import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:app_restaurant/env/index.dart';
import 'package:app_restaurant/constant/api/index.dart';

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
  final surNameController = TextEditingController();
  final nameController = TextEditingController();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passworldController = TextEditingController();
  final rePassworldController = TextEditingController();
  final addressController = TextEditingController();
  final twitterController = TextEditingController();
  final facebookController = TextEditingController();
  final instagramController = TextEditingController();
  String selectedShopId = '';
  int? currentRoleOfStaff;
  List cityList = [];
  List districList = [];
  List wardList = [];

  String? currentCity;
  String? currentDistric;
  String? currentWard;

  int? currentIndexCity;
  int? currentIndexDistric;
  int? currentIndexWard;

  List<String> nameListStore = [];
  List<String> shopIDList = [];
  List<String> listRole = [
    "Nhân viên phục vụ",
    "Trưởng nhóm",
    "Quản lý",
    "Kế toán",
    "Đầu bếp",
  ];
  void getListAreaInit({
    required int? city,
    required int? district,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$areas'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'city': city,
          'district': district,
        }),
      );
      final data = jsonDecode(response.body);

      try {
        if (response.statusCode == 200) {
          setState(() {
            cityList.clear();
            districList.clear();
            wardList.clear();
            cityList.addAll(data['cities']);
            districList.addAll(data['districts']);
            wardList.addAll(data['wards']);

            //get current City
            var cityListMap = cityList.asMap();
            // var myCity = null;
            currentCity = null;
            //get current District
            var districtListMap = districList.asMap();
            // var myDistrict = districtListMap[managerInforData?.userAddress2];
            currentDistric = null;

            //get Current Ward
            var wardListMap = wardList.asMap();
            // var myWard = wardListMap[managerInforData?.userAddress3];
            currentWard = null;
          });
        } else {
          print("LOI GI DO dadadadadadadada");
        }
      } catch (error) {
        print("LOI GI DO $error");
      }
    } catch (error) {
      print("LOI GI DO $error");
    }
  }

  void getListArea({
    required int? city,
    required int? district,
  }) async {
    print("DATA TRUYEN NN ${{
      'city': city,
      'district': district,
    }}");
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$areas'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'city': city,
          'district': district,
        }),
      );
      final data = jsonDecode(response.body);

      try {
        if (response.statusCode == 200) {
          setState(() {
            cityList.clear();
            districList.clear();
            wardList.clear();
            cityList.addAll(data['cities']);
            districList.addAll(data['districts']);
            wardList.addAll(data['wards']);

            //get current City
            var cityListMap = cityList.asMap();
            var myCity = cityListMap[city];
            currentCity = myCity;
            //get current District
            var districtListMap = districList.asMap();
            var myDistrict = districtListMap[district];
            currentDistric = myDistrict;
            //get Current Ward
            // var wardListMap = wardList.asMap();
            // var myWard = wardListMap[null];
            // currentWard = myWard;
          });
        } else {
          print("LOI GI DO dadadadadadadada");
        }
      } catch (error) {
        print("LOI GI DO $error");
      }
    } catch (error) {
      print("LOI GI DO $error");
    }
  }

  void getListStore() async {
    var token = StorageUtils.instance.getString(key: 'token_manager');
    final responseListStore = await http.post(
      Uri.parse('$baseUrl$managerGetListStores'),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    final dataListStoreRes = jsonDecode(responseListStore.body);
    // log(token.toString());

    try {
      if (dataListStoreRes['status'] == 200) {
        setState(() {
          var listStore = ListStoreModel.fromJson(dataListStoreRes);

          listStore.data.where((element) {
            nameListStore.add(element.storeName ?? '');
            return true;
          }).toList();

          listStore.data.where((element) {
            shopIDList.add(element.shopId.toString());
            return true;
          }).toList();
          log(shopIDList.toString());
        });
      } else {
        print("ERRRO GET LIST STORE 111111");
      }
    } catch (error) {
      print("ERRRO GET LIST STORE $error");
    }
  }

  void handleCreateNewStaff({
    required String shopID,
    required int staffPosition,
    required String staffFirstName,
    required String staffLastName,
    required String staffFullName,
    required String staffPhone,
    required String staffEmail,
    required String staffPassword,
    required String staffRePassword,
    required int? staffAddress1,
    required int? staffAddress2,
    required int? staffAddress3,
    required String? staffAddress4,
    required String? staffTwitter,
    required String? staffFacebook,
    required String? staffInstagram,
  }) async {
    var token = StorageUtils.instance.getString(key: 'token_manager');
    final response = await http.post(Uri.parse('$baseUrl$addStaffApi'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          'is_api': true,
          'shop_id': shopID,
          'position': staffPosition,
          'first_name': staffFirstName,
          'last_name': staffLastName,
          'full_name': staffFullName,
          'email': staffEmail,
          'phone': staffPhone,
          'password': staffPassword,
          'confirm_password': staffRePassword,
          'address_1': staffAddress1,
          'address_2': staffAddress2,
          'address_3': staffAddress3,
          'address_4': staffAddress4,
          'twitter': staffTwitter,
          'facebook': staffFacebook,
          'instagram': staffInstagram,
        }));
    final data = jsonDecode(response.body);

    log(data.toString());

    try {
      if (data['status'] == 200) {
      } else {
        print("ERRRO GET LIST STORE 111111");
      }
    } catch (error) {
      print("ERRRO GET LIST STORE $error");
    }
  }

  @override
  void initState() {
    super.initState();
    getListStore();
    getListAreaInit(city: null, district: null);
  }

  sectionController() {
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
                      offset: const Offset(0, 3), // changes position of shadow
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
                            items: nameListStore,
                            dropdownDecoratorProps: DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                fillColor:
                                    const Color.fromARGB(255, 226, 104, 159),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color.fromRGBO(214, 51, 123, 0.6),
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
                            onChanged: (store) {
                              selectedShopId =
                                  shopIDList.indexOf(store ?? '').toString();
                              var indexSelected =
                                  nameListStore.indexOf(store ?? '');
                              setState(() {
                                selectedShopId = shopIDList[indexSelected];
                              });
                            },
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
                            onChanged: (role) {
                              setState(() {
                                currentRoleOfStaff =
                                    listRole.indexOf(role ?? '') + 1;
                                log(currentRoleOfStaff.toString());
                              });
                            },
                            dropdownDecoratorProps: DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                fillColor:
                                    const Color.fromARGB(255, 226, 104, 159),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color.fromRGBO(214, 51, 123, 0.6),
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
                                fillColor:
                                    const Color.fromARGB(255, 226, 104, 159),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color.fromRGBO(214, 51, 123, 0.6),
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
                                    color: Color.fromRGBO(214, 51, 123, 0.6),
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
                                    color: Color.fromRGBO(214, 51, 123, 0.6),
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
                              bool phoneValid = RegExp(r'^(?:[+0]9)?[0-9]{10}$')
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
                                    color: Color.fromRGBO(214, 51, 123, 0.6),
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
                                    color: Color.fromRGBO(214, 51, 123, 0.6),
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
                                    color: Color.fromRGBO(214, 51, 123, 0.6),
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
                              } else if (value != passworldController.text) {
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
                                        rePasswordVisible = !rePasswordVisible;
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
                                    color: Color.fromRGBO(214, 51, 123, 0.6),
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
                    ],
                  ),
                )),
            space35H,
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
                      offset: const Offset(0, 3), // changes position of shadow
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
                            // validator: (value) {
                            //   if (value == "Chọn tỉnh/thành phố") {
                            //     return canNotNull;
                            //   } else {
                            //     return null;
                            //   }
                            // },
                            onChanged: (changeCity) {
                              getListArea(
                                  city: cityList.indexOf(changeCity),
                                  district: null);
                              setState(() {
                                currentIndexCity = cityList.indexOf(changeCity);
                                currentDistric = null;
                                currentIndexDistric = null;
                                currentWard = null;
                                currentIndexWard = null;
                              });
                            },
                            items: cityList,
                            dropdownDecoratorProps: DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                fillColor:
                                    const Color.fromARGB(255, 226, 104, 159),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color.fromRGBO(214, 51, 123, 0.6),
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
                            selectedItem: currentCity,
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
                            // validator: (value) {
                            //   if (value == "Chọn quận/huyện") {
                            //     return canNotNull;
                            //   } else {
                            //     return null;
                            //   }
                            // },
                            items: districList,
                            onChanged: (changeDistric) {
                              getListArea(
                                  city: currentIndexCity,
                                  district: districList.indexOf(changeDistric));
                              setState(() {
                                currentIndexDistric =
                                    districList.indexOf(changeDistric);
                                currentWard = null;
                                currentIndexWard = null;
                              });
                            },
                            dropdownDecoratorProps: DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                fillColor:
                                    const Color.fromARGB(255, 226, 104, 159),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color.fromRGBO(214, 51, 123, 0.6),
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
                            selectedItem: currentDistric,
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
                            // validator: (value) {
                            //   if (value == "Chọn phường/xã") {
                            //     return canNotNull;
                            //   } else {
                            //     return null;
                            //   }
                            // },
                            items: wardList,
                            onChanged: (changeWard) {
                              getListArea(
                                  city: currentIndexCity,
                                  district: currentIndexDistric);
                              setState(() {
                                currentIndexWard = wardList.indexOf(changeWard);
                                var wardListMap = wardList.asMap();
                                var myWard =
                                    wardListMap[wardList.indexOf(changeWard)];
                                currentWard = myWard;
                              });
                            },
                            dropdownDecoratorProps: DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                fillColor:
                                    const Color.fromARGB(255, 226, 104, 159),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color.fromRGBO(214, 51, 123, 0.6),
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
                            selectedItem: currentWard,
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
                            decoration: InputDecoration(
                                fillColor:
                                    const Color.fromARGB(255, 226, 104, 159),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color.fromRGBO(214, 51, 123, 0.6),
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
                    ],
                  ),
                )),
            space35H,
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
                      offset: const Offset(0, 3), // changes position of shadow
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
                            controller: twitterController,
                            style: TextStyle(fontSize: 14.sp, color: grey),
                            cursorColor: grey,
                            decoration: InputDecoration(
                                fillColor:
                                    const Color.fromARGB(255, 226, 104, 159),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color.fromRGBO(214, 51, 123, 0.6),
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
                            controller: facebookController,
                            style: TextStyle(fontSize: 14.sp, color: grey),
                            cursorColor: grey,
                            decoration: InputDecoration(
                                fillColor:
                                    const Color.fromARGB(255, 226, 104, 159),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color.fromRGBO(214, 51, 123, 0.6),
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
                            controller: instagramController,
                            style: TextStyle(fontSize: 14.sp, color: grey),
                            cursorColor: grey,
                            decoration: InputDecoration(
                                fillColor:
                                    const Color.fromARGB(255, 226, 104, 159),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color.fromRGBO(214, 51, 123, 0.6),
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
                    ],
                  ),
                )),
            space25H,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // SizedBox(
                //   width: 100.w,
                //   child: ButtonGradient(
                //     color1: color1GreyButton,
                //     color2: color2GreyButton,
                //     event: () {},
                //     text: "Về trước",
                //     fontSize: 12.sp,
                //     radius: 8.r,
                //     textColor: blueText,
                //   ),
                // ),
                // space15W,
                SizedBox(
                  width: 100.w,
                  child: ButtonGradient(
                    color1: color1DarkButton,
                    color2: color2DarkButton,
                    event: () {
                      if (_formField.currentState!.validate()) {
                        handleCreateNewStaff(
                          shopID: selectedShopId,
                          staffPosition: currentRoleOfStaff ?? 1,
                          staffFirstName: surNameController.text,
                          staffLastName: nameController.text,
                          staffFullName: fullNameController.text,
                          staffPhone: phoneController.text,
                          staffEmail: emailController.text,
                          staffPassword: passworldController.text,
                          staffRePassword: rePassworldController.text,
                          staffAddress1: currentIndexCity,
                          staffAddress2: currentIndexDistric,
                          staffAddress3: currentIndexWard,
                          staffAddress4: addressController.text,
                          staffTwitter: twitterController.text,
                          staffFacebook: facebookController.text,
                          staffInstagram: instagramController.text,
                        );
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
      ),
    );
  }

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
                  children: [sectionController()],
                ),
              )),
            ),
          ],
        ));
  }
}
