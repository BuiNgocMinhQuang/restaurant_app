import 'dart:convert';
import 'dart:developer';

import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/config/space.dart';
import 'package:app_restaurant/config/text.dart';
import 'package:app_restaurant/config/void_show_dialog.dart';
import 'package:app_restaurant/model/manager/manager_list_store_model.dart';
import 'package:app_restaurant/routers/app_router_config.dart';
import 'package:app_restaurant/utils/storage.dart';
import 'package:app_restaurant/widgets/button/button_gradient.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:app_restaurant/env/index.dart';
import 'package:app_restaurant/constant/api/index.dart';
import 'dart:math' as math;

import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

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
  final storeNameTextController = TextEditingController();
  final roleNameTextController = TextEditingController();
  final cityNameTextController = TextEditingController();
  final districNameTextController = TextEditingController();
  final wardNameTextController = TextEditingController();

  String? selectedShopId;
  String? currentRoleOfStaff;
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
          mounted
              ? setState(() {
                  cityList.clear();
                  districList.clear();
                  wardList.clear();
                  cityList.addAll(data['cities']);
                  districList.addAll(data['districts']);
                  wardList.addAll(data['wards']);
                  currentCity = null;
                  currentDistric = null;
                  currentWard = null;
                })
              : null;
        } else {
          log("ERROR getListAreaInit 1");
        }
      } catch (error) {
        log("ERROR getListAreaInit 2 $error");
      }
    } catch (error) {
      log("ERROR getListAreaInit 3 $error");
    }
  }

  void getListArea({
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
          mounted
              ? setState(() {
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
                })
              : null;
        } else {
          log("ERROR getListArea 1");
        }
      } catch (error) {
        log("ERROR getListArea 2 $error");
      }
    } catch (error) {
      log("ERROR getListArea 3 $error");
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

    try {
      if (dataListStoreRes['status'] == 200) {
        mounted
            ? setState(() {
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
              })
            : null;
      } else {
        log("ERRRO getListStore 1");
      }
    } catch (error) {
      log("ERRRO getListStore 2 $error");
    }
  }

  void handleCreateNewStaff({
    required String shopID,
    required String staffPosition,
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
    log(shopID.toString());
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
    try {
      if (data['status'] == 200) {
        showCustomDialogModal(
          context: navigatorKey.currentContext,
          textDesc: "Thêm nhân viên thành công",
          title: "Thành công",
          colorButton: Colors.green,
          btnText: "OK",
          typeDialog: "succes",
        );
        mounted
            ? setState(() {
                surNameController.clear();
                nameController.clear();
                fullNameController.clear();
                phoneController.clear();
                emailController.clear();
                passworldController.clear();
                rePassworldController.clear();
                addressController.clear();
                twitterController.clear();
                facebookController.clear();
                instagramController.clear();
                currentCity = null;
                currentDistric = null;
                currentWard = null;
                currentIndexCity = null;
                currentIndexDistric = null;
                currentIndexWard = null;
                storeNameTextController.clear();
                roleNameTextController.clear();
                cityNameTextController.clear();
                districNameTextController.clear();
                wardNameTextController.clear();
              })
            : null;
      } else {
        log("ERRRO handleCreateNewStaff 1");
        showCustomDialogModal(
          context: context,
          textDesc: "Thông tin nhân viên đã tồn tại",
          title: "Thất bại",
          colorButton: Colors.red,
          btnText: "OK",
          typeDialog: "error",
        );
      }
    } catch (error) {
      log("ERRRO handleCreateNewStaff 2 $error");
    }
  }

  @override
  void initState() {
    getListStore();
    getListAreaInit(city: null, district: null);
    super.initState();
  }

  @override
  void dispose() {
    surNameController.dispose();
    nameController.dispose();
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passworldController.dispose();
    rePassworldController.dispose();
    addressController.dispose();
    twitterController.dispose();
    facebookController.dispose();
    instagramController.dispose();
    storeNameTextController.dispose();
    roleNameTextController.dispose();
    cityNameTextController.dispose();
    districNameTextController.dispose();
    wardNameTextController.dispose();
    super.dispose();
  }

  sectionController() {
    return Container(
      width: 1.sw,
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
                  // boxShadow: [
                  //   // BoxShadow(
                  //   //   color: Colors.grey.withOpacity(0.5),
                  //   //   spreadRadius: 5,
                  //   //   blurRadius: 7,
                  //   //   offset: const Offset(0, 3), // changes position of shadow
                  //   // ),
                  // ],
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
                            fontsize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: blueText,
                          ),
                          space10H,
                          TextFormField(
                            readOnly: true,
                            onTapOutside: (event) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            onTap: () {
                              showMaterialModalBottomSheet(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(15.r),
                                    topLeft: Radius.circular(15.r),
                                  ),
                                ),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                context: context,
                                builder: (context) => SizedBox(
                                  height: 1.sh / 2,
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 1.sw,
                                        padding: EdgeInsets.all(20.w),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        child: TextApp(
                                          text: "Chọn cửa hàng",
                                          color: Colors.white,
                                          fontsize: 20.sp,
                                          fontWeight: FontWeight.bold,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Expanded(
                                        child: ListView.builder(
                                          padding: EdgeInsets.only(top: 10.w),
                                          itemCount: nameListStore.length,
                                          itemBuilder: (context, index) {
                                            return Column(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 20.w),
                                                  child: InkWell(
                                                    onTap: () async {
                                                      Navigator.pop(context);

                                                      mounted
                                                          ? setState(() {
                                                              storeNameTextController
                                                                      .text =
                                                                  nameListStore[
                                                                      index];

                                                              selectedShopId =
                                                                  shopIDList[
                                                                      index];
                                                            })
                                                          : null;
                                                    },
                                                    child: Row(
                                                      children: [
                                                        TextApp(
                                                          text: nameListStore[
                                                              index],
                                                          color: Colors.black,
                                                          fontsize: 20.sp,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Divider(
                                                  height: 25.h,
                                                )
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            controller: storeNameTextController,
                            style:
                                TextStyle(fontSize: 14.sp, color: Colors.black),
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
                                hintText: 'Chọn cửa hàng',
                                hintStyle:
                                    TextStyle(fontSize: 14.sp, color: grey),
                                suffixIcon: Transform.rotate(
                                  angle: 90 * math.pi / 180,
                                  child: Icon(
                                    Icons.chevron_right,
                                    size: 28.sp,
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                ),
                                isDense: true,
                                contentPadding: EdgeInsets.all(20.w)),
                          ),
                        ],
                      ),
                      space20H,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextApp(
                            text: " Chức vụ",
                            fontsize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: blueText,
                          ),
                          space10H,
                          TextFormField(
                            readOnly: true,
                            onTapOutside: (event) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            onTap: () {
                              showMaterialModalBottomSheet(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(15.r),
                                    topLeft: Radius.circular(15.r),
                                  ),
                                ),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                context: context,
                                builder: (context) => SizedBox(
                                  height: 1.sh / 2,
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 1.sw,
                                        padding: EdgeInsets.all(20.w),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        child: TextApp(
                                          text: "Chọn chức vụ",
                                          color: Colors.white,
                                          fontsize: 20.sp,
                                          fontWeight: FontWeight.bold,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Expanded(
                                        child: ListView.builder(
                                          padding: EdgeInsets.only(top: 10.w),
                                          itemCount: listRole.length,
                                          itemBuilder: (context, index) {
                                            return Column(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 20.w),
                                                  child: InkWell(
                                                    onTap: () async {
                                                      Navigator.pop(context);

                                                      mounted
                                                          ? setState(() {
                                                              roleNameTextController
                                                                      .text =
                                                                  listRole[
                                                                      index];

                                                              currentRoleOfStaff =
                                                                  (index + 1)
                                                                      .toString();
                                                            })
                                                          : null;
                                                    },
                                                    child: Row(
                                                      children: [
                                                        TextApp(
                                                          text: listRole[index],
                                                          color: Colors.black,
                                                          fontsize: 20.sp,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Divider(
                                                  height: 25.h,
                                                )
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            controller: roleNameTextController,
                            style:
                                TextStyle(fontSize: 14.sp, color: Colors.black),
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
                                hintText: 'Chọn chức vụ',
                                hintStyle:
                                    TextStyle(fontSize: 14.sp, color: grey),
                                suffixIcon: Transform.rotate(
                                  angle: 90 * math.pi / 180,
                                  child: Icon(
                                    Icons.chevron_right,
                                    size: 28.sp,
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                ),
                                isDense: true,
                                contentPadding: EdgeInsets.all(20.w)),
                          ),
                        ],
                      ),
                      space20H,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextApp(
                            text: " Tên đầy đủ",
                            fontsize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: blueText,
                          ),
                          space10H,
                          TextFormField(
                            onTapOutside: (event) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            controller: fullNameController,
                            style:
                                TextStyle(fontSize: 14.sp, color: Colors.black),
                            cursorColor: grey,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return fullnameIsRequied;
                              } else if (value.length > 32) {
                                return "Độ dài tối đa 32 kí tự";
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
                                hintStyle:
                                    TextStyle(fontSize: 14.sp, color: grey),
                                hintText: 'Tên đầy đủ',
                                isDense: true,
                                contentPadding: EdgeInsets.all(20.w)),
                          ),
                        ],
                      ),
                      space20H,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextApp(
                            text: " Họ",
                            fontsize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: blueText,
                          ),
                          space10H,
                          TextFormField(
                            onTapOutside: (event) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            controller: surNameController,
                            style:
                                TextStyle(fontSize: 14.sp, color: Colors.black),
                            cursorColor: grey,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return surNameIsRequied;
                              } else if (value.length > 24) {
                                return "Độ dài tối đa 24 kí tự";
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
                              hintStyle:
                                  TextStyle(fontSize: 14.sp, color: grey),
                              isDense: true,
                              contentPadding: EdgeInsets.all(20.w),
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
                            fontsize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: blueText,
                          ),
                          space10H,
                          TextFormField(
                            onTapOutside: (event) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            controller: nameController,
                            style:
                                TextStyle(fontSize: 14.sp, color: Colors.black),
                            cursorColor: grey,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return nameIsRequied;
                              } else if (value.length > 8) {
                                return "Độ dài tối đa 8 kí tự";
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
                              hintStyle:
                                  TextStyle(fontSize: 14.sp, color: grey),
                              isDense: true,
                              contentPadding: EdgeInsets.all(20.w),
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
                            fontsize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: blueText,
                          ),
                          space10H,
                          TextFormField(
                            onTapOutside: (event) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp("[0-9]")),
                            ],
                            controller: phoneController,
                            style:
                                TextStyle(fontSize: 14.sp, color: Colors.black),
                            cursorColor: grey,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return phoneIsRequied;
                              } else if (value.length > 15) {
                                return "Độ dài tối đa 15 kí tự";
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
                              hintStyle:
                                  TextStyle(fontSize: 14.sp, color: grey),
                              isDense: true,
                              contentPadding: EdgeInsets.all(20.w),
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
                            fontsize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: blueText,
                          ),
                          space10H,
                          TextFormField(
                            onTapOutside: (event) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            controller: emailController,
                            style:
                                TextStyle(fontSize: 14.sp, color: Colors.black),
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
                              hintStyle:
                                  TextStyle(fontSize: 14.sp, color: grey),
                              isDense: true,
                              contentPadding: EdgeInsets.all(20.w),
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
                            fontsize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: blueText,
                          ),
                          space10H,
                          TextFormField(
                            onTapOutside: (event) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            controller: passworldController,
                            obscureText: passwordVisible,
                            style:
                                TextStyle(fontSize: 14.sp, color: Colors.black),
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
                                  const Color.fromARGB(255, 226, 104, 159),
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
                              hintStyle:
                                  TextStyle(fontSize: 14.sp, color: grey),
                              isDense: true,
                              contentPadding: EdgeInsets.all(20.w),
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
                            fontsize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: blueText,
                          ),
                          space10H,
                          TextFormField(
                            onTapOutside: (event) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            controller: rePassworldController,
                            obscureText: rePasswordVisible,
                            style:
                                TextStyle(fontSize: 14.sp, color: Colors.black),
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
                                  const Color.fromARGB(255, 226, 104, 159),
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
                              hintStyle:
                                  TextStyle(fontSize: 14.sp, color: grey),
                              isDense: true,
                              contentPadding: EdgeInsets.all(20.w),
                            ),
                          ),
                        ],
                      ),
                      space20H,
                    ],
                  ),
                )),
            Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.r),
                  color: Colors.white,
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.grey.withOpacity(0.5),
                  //     spreadRadius: 5,
                  //     blurRadius: 7,
                  //     offset: const Offset(0, 3), // changes position of shadow
                  //   ),
                  // ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextApp(
                        text: "Địa chỉ",
                        color: const Color.fromRGBO(52, 71, 103, 1),
                        fontFamily: "OpenSans",
                        fontWeight: FontWeight.bold,
                        fontsize: 20.sp,
                      ),
                      space10H,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextApp(
                            text: " Tỉnh/Thành phố",
                            fontsize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: blueText,
                          ),
                          space10H,
                          TextFormField(
                            readOnly: true,
                            onTapOutside: (event) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            onTap: () {
                              showMaterialModalBottomSheet(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(15.r),
                                    topLeft: Radius.circular(15.r),
                                  ),
                                ),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                context: context,
                                builder: (context) => SizedBox(
                                  height: 1.sh / 2,
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 1.sw,
                                        padding: EdgeInsets.all(20.w),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        child: TextApp(
                                          text: "Chọn tỉnh/thành phố",
                                          color: Colors.white,
                                          fontsize: 20.sp,
                                          fontWeight: FontWeight.bold,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Expanded(
                                        child: ListView.builder(
                                          padding: EdgeInsets.only(top: 10.w),
                                          itemCount: cityList.length,
                                          itemBuilder: (context, index) {
                                            return Column(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 20.w),
                                                  child: InkWell(
                                                    onTap: () async {
                                                      Navigator.pop(context);

                                                      getListArea(
                                                          city: index,
                                                          district: null);
                                                      mounted
                                                          ? setState(() {
                                                              cityNameTextController
                                                                      .text =
                                                                  cityList[
                                                                      index];
                                                              districNameTextController
                                                                  .clear();
                                                              wardNameTextController
                                                                  .clear();
                                                              currentIndexCity =
                                                                  index;
                                                              currentDistric =
                                                                  null;
                                                              currentIndexDistric =
                                                                  null;
                                                              currentWard =
                                                                  null;
                                                              currentIndexWard =
                                                                  null;
                                                            })
                                                          : null;
                                                    },
                                                    child: Row(
                                                      children: [
                                                        TextApp(
                                                          text: cityList[index],
                                                          color: Colors.black,
                                                          fontsize: 20.sp,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Divider(
                                                  height: 25.h,
                                                )
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            controller: cityNameTextController,
                            style:
                                TextStyle(fontSize: 14.sp, color: Colors.black),
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
                                hintText: 'Chọn tỉnh/thành phố',
                                hintStyle:
                                    TextStyle(fontSize: 14.sp, color: grey),
                                suffixIcon: Transform.rotate(
                                  angle: 90 * math.pi / 180,
                                  child: Icon(
                                    Icons.chevron_right,
                                    size: 28.sp,
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                ),
                                isDense: true,
                                contentPadding: EdgeInsets.all(20.w)),
                          ),
                        ],
                      ),
                      space20H,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextApp(
                            text: " Quận/Huyện",
                            fontsize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: blueText,
                          ),
                          space10H,
                          TextFormField(
                            readOnly: true,
                            onTapOutside: (event) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            onTap: () {
                              showMaterialModalBottomSheet(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(15.r),
                                    topLeft: Radius.circular(15.r),
                                  ),
                                ),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                context: context,
                                builder: (context) => SizedBox(
                                  height: 1.sh / 2,
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 1.sw,
                                        padding: EdgeInsets.all(20.w),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        child: TextApp(
                                          text: "Chọn quận/Huyện",
                                          color: Colors.white,
                                          fontsize: 20.sp,
                                          fontWeight: FontWeight.bold,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Expanded(
                                        child: ListView.builder(
                                          padding: EdgeInsets.only(top: 10.w),
                                          itemCount: districList.length,
                                          itemBuilder: (context, index) {
                                            return Column(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 20.w),
                                                  child: InkWell(
                                                    onTap: () async {
                                                      Navigator.pop(context);

                                                      getListArea(
                                                          city:
                                                              currentIndexCity,
                                                          district: index);
                                                      mounted
                                                          ? setState(() {
                                                              districNameTextController
                                                                      .text =
                                                                  districList[
                                                                      index];
                                                              wardNameTextController
                                                                  .clear();
                                                              currentIndexDistric =
                                                                  index;
                                                              currentWard =
                                                                  null;
                                                              currentIndexWard =
                                                                  null;
                                                            })
                                                          : null;
                                                    },
                                                    child: Row(
                                                      children: [
                                                        TextApp(
                                                          text: districList[
                                                              index],
                                                          color: Colors.black,
                                                          fontsize: 20.sp,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Divider(
                                                  height: 25.h,
                                                )
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            controller: districNameTextController,
                            style:
                                TextStyle(fontSize: 14.sp, color: Colors.black),
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
                                hintText: 'Chọn quận/Huyện',
                                hintStyle:
                                    TextStyle(fontSize: 14.sp, color: grey),
                                suffixIcon: Transform.rotate(
                                  angle: 90 * math.pi / 180,
                                  child: Icon(
                                    Icons.chevron_right,
                                    size: 28.sp,
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                ),
                                isDense: true,
                                contentPadding: EdgeInsets.all(20.w)),
                          ),
                        ],
                      ),
                      space20H,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextApp(
                            text: " Phường/Xã",
                            fontsize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: blueText,
                          ),
                          space10H,
                          TextFormField(
                            readOnly: true,
                            onTapOutside: (event) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            onTap: () {
                              showMaterialModalBottomSheet(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(15.r),
                                    topLeft: Radius.circular(15.r),
                                  ),
                                ),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                context: context,
                                builder: (context) => SizedBox(
                                  height: 1.sh / 2,
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 1.sw,
                                        padding: EdgeInsets.all(20.w),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        child: TextApp(
                                          text: "Chọn phường/xã",
                                          color: Colors.white,
                                          fontsize: 20.sp,
                                          fontWeight: FontWeight.bold,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Expanded(
                                        child: ListView.builder(
                                          padding: EdgeInsets.only(top: 10.w),
                                          itemCount: wardList.length,
                                          itemBuilder: (context, index) {
                                            return Column(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 20.w),
                                                  child: InkWell(
                                                    onTap: () async {
                                                      Navigator.pop(context);

                                                      getListArea(
                                                          city:
                                                              currentIndexCity,
                                                          district:
                                                              currentIndexDistric);
                                                      mounted
                                                          ? setState(() {
                                                              wardNameTextController
                                                                      .text =
                                                                  wardList[
                                                                      index];

                                                              currentIndexWard =
                                                                  index;
                                                              var wardListMap =
                                                                  wardList
                                                                      .asMap();
                                                              var myWard =
                                                                  wardListMap[
                                                                      index];
                                                              currentWard =
                                                                  myWard;
                                                            })
                                                          : null;
                                                    },
                                                    child: Row(
                                                      children: [
                                                        TextApp(
                                                          text: wardList[index],
                                                          color: Colors.black,
                                                          fontsize: 20.sp,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Divider(
                                                  height: 25.h,
                                                )
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            controller: wardNameTextController,
                            style:
                                TextStyle(fontSize: 14.sp, color: Colors.black),
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
                                hintText: 'Chọn phường/xã',
                                hintStyle:
                                    TextStyle(fontSize: 14.sp, color: grey),
                                suffixIcon: Transform.rotate(
                                  angle: 90 * math.pi / 180,
                                  child: Icon(
                                    Icons.chevron_right,
                                    size: 28.sp,
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                ),
                                isDense: true,
                                contentPadding: EdgeInsets.all(20.w)),
                          ),
                        ],
                      ),
                      space20H,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextApp(
                            text: " Số nhà, đường",
                            fontsize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: blueText,
                          ),
                          space10H,
                          TextFormField(
                            onTapOutside: (event) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            controller: addressController,
                            style:
                                TextStyle(fontSize: 14.sp, color: Colors.black),
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
                                hintStyle:
                                    TextStyle(fontSize: 14.sp, color: grey),
                                isDense: true,
                                contentPadding: EdgeInsets.all(20.w)),
                          ),
                        ],
                      ),
                      space20H,
                    ],
                  ),
                )),
            Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.r),
                  color: Colors.white,
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.grey.withOpacity(0.5),
                  //     spreadRadius: 5,
                  //     blurRadius: 7,
                  //     offset: const Offset(0, 3), // changes position of shadow
                  //   ),
                  // ],
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
                            fontsize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: blueText,
                          ),
                          space10H,
                          TextField(
                            onTapOutside: (event) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
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
                                hintStyle: TextStyle(fontSize: 14.sp),
                                isDense: true,
                                contentPadding: EdgeInsets.all(20.w)),
                          ),
                        ],
                      ),
                      space20H,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextApp(
                            text: " Facebook",
                            fontsize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: blueText,
                          ),
                          space10H,
                          TextField(
                            onTapOutside: (event) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
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
                                hintStyle: TextStyle(fontSize: 14.sp),
                                isDense: true,
                                contentPadding: EdgeInsets.all(20.w)),
                          ),
                        ],
                      ),
                      space20H,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextApp(
                            text: " Instagram",
                            fontsize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: blueText,
                          ),
                          space10H,
                          TextField(
                            onTapOutside: (event) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
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
                                hintStyle: TextStyle(fontSize: 14.sp),
                                isDense: true,
                                contentPadding: EdgeInsets.all(20.w)),
                          ),
                        ],
                      ),
                      space20H,
                    ],
                  ),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 100.w,
                  margin: EdgeInsets.only(right: 20.w),
                  child: ButtonGradient(
                    color1: color1DarkButton,
                    color2: color2DarkButton,
                    event: () {
                      if (_formField.currentState!.validate()) {
                        handleCreateNewStaff(
                          shopID: selectedShopId ?? '',
                          staffPosition: currentRoleOfStaff ?? '1',
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
                    fontSize: 14.sp,
                    radius: 8.r,
                    textColor: Colors.white,
                  ),
                )
              ],
            ),
            space25H,
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
                child: Column(
                  children: [sectionController()],
                ),
              ),
            ),
          ],
        ));
  }
}
