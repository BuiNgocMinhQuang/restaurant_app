import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:app_restaurant/config/void_show_dialog.dart';
import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/config/space.dart';
import 'package:app_restaurant/config/text.dart';
import 'package:app_restaurant/env/index.dart';
import 'package:app_restaurant/model/staff_infor_model.dart';
import 'package:app_restaurant/routers/app_router_config.dart';
import 'package:app_restaurant/utils/storage.dart';
import 'package:app_restaurant/widgets/button/button_gradient.dart';
import 'package:app_restaurant/widgets/list_pop_menu.dart';
import 'package:app_restaurant/widgets/text/copy_right_text.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:app_restaurant/constant/api/index.dart';

class StaffUserInformation extends StatefulWidget {
  const StaffUserInformation({super.key});

  @override
  State<StaffUserInformation> createState() => _StaffUserInformationState();
}

class _StaffUserInformationState extends State<StaffUserInformation> {
  final _formField1 = GlobalKey<FormState>();
  final _formField2 = GlobalKey<FormState>();
  bool currentPasswordVisible = true;
  bool newPasswordVisible = true;
  bool reNewPasswordVisible = true;
  final shopIDController = TextEditingController();
  final surNameController = TextEditingController();
  final nameController = TextEditingController(); //
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final currentPassworldController = TextEditingController();
  final newPassworldController = TextEditingController();
  final reNewPassworldController = TextEditingController();
  final roleController = TextEditingController();
  final twitterController = TextEditingController();
  final facebookController = TextEditingController();
  final instagramController = TextEditingController();
  final address1Controller = TextEditingController();
  final address2Controller = TextEditingController();
  final address3Controller = TextEditingController();
  final address4Controller = TextEditingController();
  File? selectedImage;
  String currentAvatar = 'assets/user/images/avt/no_image.png';
  List cityList = [];
  List quanList = [];
  List xaList = [];
  Data? userInforData;
  bool isChangeCity = false;
  bool isChangeDistrict = false;
  int? initIndexCity;
  int? initIndexDistric;
  int? initIndexWard;
  int? currentIndexCity;
  int? currentIndexDistric;
  int? currentIndexWard;
  int? preChoose;
  void pickImage() async {
    final returndImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returndImage == null) return;
    setState(() {
      selectedImage = File(returndImage.path);
    });
    openImage();
  }

  void deletedAvatarStaff() async {
    try {
      var token = StorageUtils.instance.getString(key: 'token');
      final respons = await http.post(
        Uri.parse('$baseUrl$deleteAvatarStaff'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token"
        },
      );
      final data = jsonDecode(respons.body);
      print("DATA DELETED AVATAR STAFF  ${data}}");

      try {
        if (data['status'] == 200) {
          print("DELETED AVATAR STAFF  OK");
          getInfor();

          showSnackBarTopCustom(
              title: "Thành công",
              context: navigatorKey.currentContext,
              mess: "Xoá ảnh đại diện thành công",
              color: Colors.green);
        } else {
          print("ERROR DELETED AVATAR STAFF  1");
          showSnackBarTopCustom(
              title: "Thất bại",
              context: navigatorKey.currentContext,
              mess: "Thao tác thất bại",
              color: Colors.red);
        }
      } catch (error) {
        print("ERROR DELETED AVATAR STAFF  2 ${error}");
      }
    } catch (error) {
      print("ERROR DELETED AVATAR STAFF  3 $error");
    }
  }

  openImage() async {
    try {
      if (selectedImage != null) {
        Uint8List imagebytes =
            await selectedImage!.readAsBytes(); //convert to bytes
        String base64string =
            base64.encode(imagebytes); //convert bytes to base64 string
        print(base64string);

        setState(() {});
        try {
          print("TRUYEN NNNN ${{
            "d]staff_avatar": base64string,
          }}");
          var token = StorageUtils.instance.getString(key: 'token');
          final respons = await http.post(
            Uri.parse('$baseUrl$updateAvatarStaffApi'),
            headers: {
              'Content-type': 'application/json',
              'Accept': 'application/json',
              "Authorization": "Bearer $token"
            },
            body: jsonEncode({
              "staff_avatar": base64string,
            }),
          );
          final data = jsonDecode(respons.body);
          print("DATA CHANGE AVATAR STAFF  ${data}}");

          try {
            if (data['status'] == 200) {
              print("CHANGE AVATAR STAFF  OK");
              showSnackBarTopCustom(
                  title: "Thành công",
                  context: navigatorKey.currentContext,
                  mess: "Cập nhật ảnh đại diện thành công",
                  color: Colors.green);
            } else {
              print("ERROR CHANGE AVATAR STAFF  1");
              showSnackBarTopCustom(
                  title: "Thất bại",
                  context: navigatorKey.currentContext,
                  mess: "Thao tác thất bại",
                  color: Colors.red);
            }
          } catch (error) {
            print("ERROR CHANGE AVATAR STAFF  2 ${error}");
          }
        } catch (error) {
          print("ERROR CHANGE AVATAR STAFF  3 $error");
        }
      } else {
        print("No image is selected.");
      }
    } catch (e) {
      print("error while picking file.");
    }
  }

  @override
  void initState() {
    super.initState();
    getInfor();
  }

  void getInfor() async {
    try {
      var token = StorageUtils.instance.getString(key: 'token');
      print("TOKEN CURRENT $token");
      final response = await http.post(
        Uri.parse('$baseUrl$userInformationApi'),
        headers: {"Authorization": "Bearer $token"},
      );
      final data = jsonDecode(response.body);
      // var message = data['message'];

      try {
        if (data['status'] == 200) {
          var staffInforDataRes = StaffInfor.fromJson(data);
          setState(() {
            userInforData = staffInforDataRes.data;
            var imagePath1 =
                (userInforData?.staffAvatar ?? '').replaceAll('["', '');
            var imagePath2 = imagePath1.replaceAll('"]', '');
            currentAvatar = imagePath2;
            initIndexCity = userInforData?.staffAddress1;
            initIndexDistric = userInforData?.staffAddress2;
            initIndexWard = userInforData?.staffAddress3;
            log(currentAvatar.toString());
          });
          laythongitn(
              city: userInforData?.staffAddress1,
              district: userInforData?.staffAddress2);

          print("GET INFOR STAFF OK 1");
        } else {
          print("GET INFOR STAFF ERROR 1");
        }
      } catch (error) {
        print("GET INFOR STAFF ERROR 2  $error");
      }
    } catch (error) {
      print("GET INFOR STAFF ERROR 3 $error");
    }
  }

  void updateInforStaff({
    required String? firstName,
    required String? lastName,
    required String? fullName,
    required String? email,
    required String? phone,
    required String? twitter,
    required String? facebook,
    required String? instagram,
    required int? address1,
    required int? address2,
    required int? address3,
    required String? address4,
  }) async {
    print("CAI DONG TRUYEN LEN ${{
      "first_name": firstName,
      "last_name": lastName,
      "full_name": fullName,
      "email": email,
      "phone": phone,
      "address_1": address1,
      "address_2": address2,
      "address_3": address3,
      "address_4": address4,
      "twitter": twitter,
      "facebook": facebook,
      "instagram": instagram
    }}");
    try {
      var token = StorageUtils.instance.getString(key: 'token');
      final respons = await http.post(
        Uri.parse('$baseUrl$updateStaffInfor'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          "first_name": firstName,
          "last_name": lastName,
          "full_name": fullName,
          "email": email,
          "phone": phone,
          "address_1": address1,
          "address_2": address2,
          "address_3": address3,
          "address_4": address4,
          "twitter": twitter,
          "facebook": facebook,
          "instagram": instagram
        }),
      );
      final data = jsonDecode(respons.body);
      print("DATA UPDATE INFOR  ${data}}");
      final messText = data['message'];

      try {
        if (data['status'] == 200) {
          print("UPDATE INFOR  OK");
          getInfor();
          showSnackBarTopCustom(
              title: "Thành công",
              context: navigatorKey.currentContext,
              mess: messText['text'],
              color: Colors.green);
        } else {
          print("ERROR UPDATE INFOR  1");
          showSnackBarTopCustom(
              title: "Thất bại",
              context: navigatorKey.currentContext,
              mess: messText['text'],
              color: Colors.red);
        }
      } catch (error) {
        print("ERROR UPDATE INFOR  2 ${error}");
      }
    } catch (error) {
      print("ERROR UPDATE INFOR  3 $error");
    }
  }

  void changePasswordStaff({
    required String? currentPassword,
    required String? newPassword,
    required String? confirmNewPassword,
  }) async {
    try {
      print("TRUYEN NNNN ${{
        "password": currentPassword,
        "password_new": newPassword,
        "confirm_password_new": confirmNewPassword
      }}");
      var token = StorageUtils.instance.getString(key: 'token');
      final respons = await http.post(
        Uri.parse('$baseUrl$changePasswordStaffApi'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          "password": currentPassword,
          "password_new": newPassword,
          "confirm_password_new": confirmNewPassword
        }),
      );
      final data = jsonDecode(respons.body);
      print("DATA CHANGE PASS STAFF  ${data}}");
      final messText = data['message'];
      try {
        if (data['status'] == 200) {
          print("CHANGE PASS STAFF  OK");
          currentPassworldController.clear();
          newPassworldController.clear();
          reNewPassworldController.clear();
          getInfor();
          showSnackBarTopCustom(
              title: "Thành công",
              context: navigatorKey.currentContext,
              mess: messText['text'],
              color: Colors.green);
        } else {
          print("ERROR CHANGE PASS STAFF  1");
          showSnackBarTopCustom(
              title: "Thất bại",
              context: navigatorKey.currentContext,
              mess: messText['text'],
              color: Colors.red);
        }
      } catch (error) {
        print("ERROR CHANGE PASS STAFF  2 ${error}");
      }
    } catch (error) {
      print("ERROR CHANGE PASS STAFF  3 $error");
    }
  }

  void laythongitn({
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
      // print("DATA HHHHHHH ${data}");

      try {
        if (response.statusCode == 200) {
          setState(() {
            cityList.clear();
            quanList.clear();
            xaList.clear();
            cityList.addAll(data['cities']);
            quanList.addAll(data['districts']);
            xaList.addAll(data['wards']);
          });

          // print("============");
          // print(cityList);
          // print("============");
          // print(quanList);
          // print("============");
          // print(xaList);
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

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    shopIDController.text = userInforData?.shopId ?? '';
    fullNameController.text = userInforData?.staffFullName ?? '';
    surNameController.text = userInforData?.staffFirstName ?? '';
    nameController.text = userInforData?.staffLastName ?? '';
    emailController.text = userInforData?.staffEmail ?? '';
    phoneController.text = userInforData?.staffPhone ?? '';
    // currentPassworldController.text = userInforData?.staffLastName ?? '';
    // newPassworldController.text = userInforData?.staffLastName ?? '';
    // reNewPassworldController.text = userInforData?.staffLastName ?? '';
    roleController.text = userInforData?.staffPosition == 1
        ? 'Nhân viên'
        : userInforData?.staffPosition == 2
            ? 'Trưởng nhóm'
            : userInforData?.staffPosition == 3
                ? 'Quản lý'
                : userInforData?.staffPosition == 4
                    ? 'Kế toán'
                    : '';

    twitterController.text = userInforData?.staffTwitter ?? '';
    facebookController.text = userInforData?.staffFacebook ?? '';
    instagramController.text = userInforData?.staffInstagram ?? '';
    address1Controller.text = userInforData?.staffAddress1.toString() ?? '';
    address2Controller.text = userInforData?.staffAddress2.toString() ?? '';
    address3Controller.text = userInforData?.staffAddress3.toString() ?? '';
    address4Controller.text = userInforData?.staffAddress4 ?? '';
    //get current City
    var cityListMap = cityList.asMap();
    var myCity = cityListMap[userInforData?.staffAddress1];
    var currentCity = myCity;
    //get current District
    var districtListMap = quanList.asMap();
    var myDistrict = districtListMap[userInforData?.staffAddress2];
    var currentDistrict = myDistrict;
    //get Current Ward
    var wardListMap = xaList.asMap();
    var myWard = wardListMap[userInforData?.staffAddress3];
    var currentWard = myWard;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: RefreshIndicator(
        color: Colors.blue,
        onRefresh: () async {
          getInfor();
        },
        child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 40.h, left: 10.w, right: 10.w),
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
                          offset:
                              const Offset(0, 3), // changes position of shadow
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
                            Stack(
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
                                          child: Image.network(
                                            httpImage + currentAvatar,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                ),
                                Positioned(
                                    top: 0.w,
                                    right: 0.w,
                                    child: PopUpSettingAvatar(
                                      eventButton1: () {
                                        pickImage();
                                      },
                                      eventButton2: () {
                                        deletedAvatarStaff();
                                      },
                                    ))
                              ],
                            ),
                            space25W,
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TextApp(
                                  text: fullNameController.text,
                                  fontWeight: FontWeight.bold,
                                  fontsize: 18.sp,
                                ),
                                TextApp(
                                  text: roleController.text,
                                  fontsize: 14.sp,
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
                        padding:
                            EdgeInsets.only(top: 40.h, left: 10.w, right: 10.w),
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
                                      color:
                                          const Color.fromRGBO(52, 71, 103, 1),
                                      fontFamily: "Icomoon",
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24.sp,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30.h,
                                  ),
                                  IntrinsicHeight(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              TextApp(
                                                text: " Mã cửa hàng",
                                                fontsize: 12.sp,
                                                fontWeight: FontWeight.bold,
                                                color: blueText,
                                              ),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              TextFormField(
                                                // enabled: false,
                                                onTapOutside: (event) {
                                                  FocusManager
                                                      .instance.primaryFocus
                                                      ?.unfocus();
                                                },
                                                controller: shopIDController,
                                                readOnly: true,
                                                keyboardType:
                                                    TextInputType.name,
                                                style: TextStyle(
                                                    fontSize: 12.sp,
                                                    color: grey),
                                                cursorColor: grey,
                                                decoration: InputDecoration(
                                                    fillColor: Color.fromARGB(
                                                        255, 226, 104, 159),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Color.fromRGBO(
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
                                                    hintStyle: TextStyle(
                                                        fontSize: 14.sp),
                                                    isDense: true,
                                                    contentPadding:
                                                        EdgeInsets.all(15.w)),
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
                                                text: " Họ và tên",
                                                fontsize: 12.sp,
                                                fontWeight: FontWeight.bold,
                                                color: blueText,
                                              ),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              TextFormField(
                                                onTapOutside: (event) {
                                                  FocusManager
                                                      .instance.primaryFocus
                                                      ?.unfocus();
                                                },
                                                controller: fullNameController,
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
                                                          BorderRadius.circular(
                                                              8.r),
                                                    ),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.r),
                                                    ),
                                                    // hintText: 'Tên',
                                                    hintStyle: TextStyle(
                                                        fontSize: 14.sp),
                                                    isDense: true,
                                                    contentPadding:
                                                        EdgeInsets.all(15.w)),
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
                                                text: " Họ",
                                                fontsize: 12.sp,
                                                fontWeight: FontWeight.bold,
                                                color: blueText,
                                              ),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              TextFormField(
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
                                                    fillColor: Color.fromARGB(
                                                        255, 226, 104, 159),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Color.fromRGBO(
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
                                                    // hintText: 'Họ',
                                                    hintStyle: TextStyle(
                                                        fontSize: 14.sp),
                                                    isDense: true,
                                                    contentPadding:
                                                        EdgeInsets.all(15.w)),
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
                                                fontsize: 12.sp,
                                                fontWeight: FontWeight.bold,
                                                color: blueText,
                                              ),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              TextFormField(
                                                onTapOutside: (event) {
                                                  FocusManager
                                                      .instance.primaryFocus
                                                      ?.unfocus();
                                                },
                                                keyboardType:
                                                    TextInputType.name,
                                                controller: nameController,
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
                                                          BorderRadius.circular(
                                                              8.r),
                                                    ),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.r),
                                                    ),
                                                    // hintText: 'Tên',
                                                    hintStyle: TextStyle(
                                                        fontSize: 14.sp),
                                                    isDense: true,
                                                    contentPadding:
                                                        EdgeInsets.all(15.w)),
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
                                                text: " Chức vụ",
                                                fontsize: 12.sp,
                                                fontWeight: FontWeight.bold,
                                                color: blueText,
                                              ),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              TextFormField(
                                                onTapOutside: (event) {
                                                  FocusManager
                                                      .instance.primaryFocus
                                                      ?.unfocus();
                                                },
                                                readOnly: true,
                                                controller: roleController,
                                                keyboardType:
                                                    TextInputType.name,
                                                style: TextStyle(
                                                    fontSize: 12.sp,
                                                    color: grey),
                                                cursorColor: grey,
                                                decoration: InputDecoration(
                                                    fillColor: Color.fromARGB(
                                                        255, 226, 104, 159),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Color.fromRGBO(
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
                                                    // hintText: 'Họ',
                                                    hintStyle: TextStyle(
                                                        fontSize: 14.sp),
                                                    isDense: true,
                                                    contentPadding:
                                                        EdgeInsets.all(15.w)),
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
                                                text: " Số điện thoại",
                                                fontsize: 12.sp,
                                                fontWeight: FontWeight.bold,
                                                color: blueText,
                                              ),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              TextFormField(
                                                onTapOutside: (event) {
                                                  FocusManager
                                                      .instance.primaryFocus
                                                      ?.unfocus();
                                                },
                                                controller: phoneController,
                                                keyboardType:
                                                    TextInputType.name,
                                                style: TextStyle(
                                                    fontSize: 12.sp,
                                                    color: grey),
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
                                                              color: Color
                                                                  .fromRGBO(
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
                                                    hintStyle: TextStyle(
                                                        fontSize: 14.sp),
                                                    isDense: true,
                                                    contentPadding:
                                                        EdgeInsets.all(15.w)),
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
                                                  if (value ==
                                                      "Chọn tỉnh/thành phố") {
                                                    return canNotNull;
                                                  }
                                                },
                                                selectedItem: currentCity,
                                                items: cityList,
                                                onChanged: (changeCity) {
                                                  laythongitn(
                                                      city: cityList
                                                          .indexOf(changeCity),
                                                      district: null);

                                                  setState(() {
                                                    preChoose =
                                                        currentIndexCity;
                                                    print("VO CU $preChoose");
                                                    isChangeCity = true;
                                                    userInforData
                                                        ?.staffAddress2 = null;
                                                    currentIndexCity = cityList
                                                        .indexOf(changeCity);
                                                    print(
                                                        "VAN TREN TOP $currentIndexCity");
                                                  });
                                                },
                                                dropdownDecoratorProps:
                                                    DropDownDecoratorProps(
                                                  dropdownSearchDecoration:
                                                      InputDecoration(
                                                    // isCollapsed: true,

                                                    hintMaxLines: 1,
                                                    fillColor:
                                                        const Color.fromARGB(
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
                                                          BorderRadius.circular(
                                                              8.r),
                                                    ),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.r),
                                                    ),
                                                    isDense: true,
                                                    contentPadding:
                                                        EdgeInsets.all(15.w),
                                                    hintStyle: TextStyle(
                                                        fontSize: 14.sp),
                                                    hintText:
                                                        "Chọn tỉnh/thành phố",
                                                  ),
                                                ),
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
                                                fontsize: 12.sp,
                                                fontWeight: FontWeight.bold,
                                                color: blueText,
                                              ),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              DropdownSearch(
                                                validator: (value) {
                                                  if (value ==
                                                      "Chọn quận/huyện") {
                                                    return canNotNull;
                                                  }
                                                },
                                                selectedItem: currentDistrict,

                                                items: quanList,
                                                onChanged: (changeDistric) {
                                                  // var myInt = int.tryParse(
                                                  //     address1Controller.text);
                                                  laythongitn(
                                                      city: currentIndexCity ??
                                                          initIndexCity,
                                                      district:
                                                          quanList.indexOf(
                                                              changeDistric));
                                                  setState(() {
                                                    print(
                                                        "LOZNAO NULL $currentIndexCity");
                                                    print(
                                                        "LOZNAO NULL $initIndexCity");
                                                    isChangeDistrict = true;
                                                    initIndexDistric = quanList
                                                        .indexOf(changeDistric);
                                                  });
                                                },

                                                dropdownDecoratorProps:
                                                    DropDownDecoratorProps(
                                                  dropdownSearchDecoration:
                                                      InputDecoration(
                                                    hintMaxLines: 1,
                                                    fillColor:
                                                        const Color.fromARGB(
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
                                                          BorderRadius.circular(
                                                              8.r),
                                                    ),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.r),
                                                    ),
                                                    isDense: true,
                                                    contentPadding:
                                                        EdgeInsets.all(15.w),
                                                    hintStyle: TextStyle(
                                                        fontSize: 14.sp),
                                                    hintText: "Chọn quận/huyện",
                                                  ),
                                                ),
                                                // selectedItem:
                                                //     "Chọn quận/huyện",
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
                                                fontsize: 12.sp,
                                                fontWeight: FontWeight.bold,
                                                color: blueText,
                                              ),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              DropdownSearch(
                                                validator: (value) {
                                                  if (value ==
                                                      "Chọn phường/xã") {
                                                    return canNotNull;
                                                  }
                                                },
                                                selectedItem: isChangeDistrict
                                                    ? null
                                                    : currentWard,

                                                items: xaList,
                                                onChanged: (changeWard) {
                                                  // var xamoi = xaList
                                                  //     .indexOf(
                                                  //         changeWard);

                                                  setState(() {
                                                    initIndexWard = xaList
                                                        .indexOf(changeWard);
                                                  });
                                                },
                                                dropdownDecoratorProps:
                                                    DropDownDecoratorProps(
                                                  dropdownSearchDecoration:
                                                      InputDecoration(
                                                    hintMaxLines: 1,
                                                    fillColor:
                                                        const Color.fromARGB(
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
                                                          BorderRadius.circular(
                                                              8.r),
                                                    ),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.r),
                                                    ),
                                                    isDense: true,
                                                    contentPadding:
                                                        EdgeInsets.all(15.w),
                                                    hintStyle: TextStyle(
                                                        fontSize: 14.sp),
                                                    hintText: "Chọn phường/xã",
                                                  ),
                                                ),

                                                // selectedItem:
                                                //     "Chọn phường/xã",
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
                                                fontsize: 12.sp,
                                                fontWeight: FontWeight.bold,
                                                color: blueText,
                                              ),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              TextFormField(
                                                onTapOutside: (event) {
                                                  FocusManager
                                                      .instance.primaryFocus
                                                      ?.unfocus();
                                                },
                                                controller: address4Controller,
                                                keyboardType:
                                                    TextInputType.name,
                                                style: TextStyle(
                                                    fontSize: 12.sp,
                                                    color: grey),
                                                cursorColor: grey,
                                                decoration: InputDecoration(
                                                    fillColor:
                                                        const Color.fromARGB(
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
                                                          BorderRadius.circular(
                                                              8.r),
                                                    ),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.r),
                                                    ),
                                                    // hintText: 'Tên',
                                                    hintStyle: TextStyle(
                                                        fontSize: 14.sp),
                                                    isDense: true,
                                                    contentPadding:
                                                        EdgeInsets.all(15.w)),
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
                                        onTapOutside: (event) {
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                        },
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
                                            hintStyle:
                                                TextStyle(fontSize: 14.sp),
                                            hintText: 'Email',
                                            isDense: true,
                                            contentPadding:
                                                EdgeInsets.all(15.w)),
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
                                        text: " Twitter",
                                        fontsize: 12.sp,
                                        fontWeight: FontWeight.bold,
                                        color: blueText,
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      TextField(
                                        onTapOutside: (event) {
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                        },
                                        controller: twitterController,
                                        style: TextStyle(
                                            fontSize: 14.sp, color: grey),
                                        cursorColor: grey,
                                        decoration: InputDecoration(
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
                                            hintStyle:
                                                TextStyle(fontSize: 14.sp),
                                            hintText: 'Twitter',
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
                                        text: " Facebook",
                                        fontsize: 12.sp,
                                        fontWeight: FontWeight.bold,
                                        color: blueText,
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      TextField(
                                        onTapOutside: (event) {
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                        },
                                        controller: facebookController,
                                        style: TextStyle(
                                            fontSize: 14.sp, color: grey),
                                        cursorColor: grey,
                                        decoration: InputDecoration(
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
                                            hintStyle:
                                                TextStyle(fontSize: 14.sp),
                                            hintText: 'Facebook',
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
                                        text: " Instagram",
                                        fontsize: 12.sp,
                                        fontWeight: FontWeight.bold,
                                        color: blueText,
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      TextField(
                                        onTapOutside: (event) {
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                        },
                                        controller: instagramController,
                                        style: TextStyle(
                                            fontSize: 14.sp, color: grey),
                                        cursorColor: grey,
                                        decoration: InputDecoration(
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
                                            hintStyle:
                                                TextStyle(fontSize: 14.sp),
                                            hintText: 'Instagram',
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
                                            if (_formField1.currentState!
                                                .validate()) {
                                              showConfirmDialog(context, () {
                                                updateInforStaff(
                                                  firstName:
                                                      surNameController.text,
                                                  lastName: nameController.text,
                                                  fullName:
                                                      fullNameController.text,
                                                  email: emailController.text,
                                                  phone: phoneController.text,
                                                  twitter:
                                                      twitterController.text,
                                                  facebook:
                                                      facebookController.text,
                                                  instagram:
                                                      instagramController.text,
                                                  address1: currentIndexCity ??
                                                      userInforData
                                                          ?.staffAddress1,
                                                  address2: initIndexDistric ??
                                                      userInforData
                                                          ?.staffAddress2,
                                                  address3: initIndexWard ??
                                                      userInforData
                                                          ?.staffAddress3,
                                                  address4:
                                                      address4Controller.text,
                                                );
                                                getInfor();
                                                // setState(() {
                                                //   thanhphoIndex = null;
                                                //   quanIndex = null;
                                                //   xaIndex = null;
                                                // });
                                              });
                                              // surNameController
                                              //     .clear();
                                              // nameController
                                              //     .clear();
                                              // fullNameController
                                              //     .clear();
                                              // emailController
                                              //     .clear();
                                              // phoneController
                                              //     .clear();
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
                    padding:
                        EdgeInsets.only(top: 40.h, left: 10.w, right: 10.w),
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
                                  color: const Color.fromRGBO(52, 71, 103, 1),
                                  fontFamily: "Icomoon",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24.sp,
                                ),
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                    onTapOutside: (event) {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                    },
                                    controller: currentPassworldController,
                                    obscureText: currentPasswordVisible,
                                    style:
                                        TextStyle(fontSize: 12.sp, color: grey),
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
                                        suffixIconColor:
                                            Color.fromARGB(255, 226, 104, 159),
                                        suffixIcon: IconButton(
                                            onPressed: () {
                                              setState(
                                                () {
                                                  currentPasswordVisible =
                                                      !currentPasswordVisible;
                                                },
                                              );
                                            },
                                            icon: Icon(currentPasswordVisible
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
                                        hintStyle: TextStyle(fontSize: 14.sp),
                                        hintText: 'Mật khẩu hiện tại',
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
                                    text: " Mật khẩu mới",
                                    fontsize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                    color: blueText,
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  TextFormField(
                                    onTapOutside: (event) {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                    },
                                    controller: newPassworldController,
                                    obscureText: newPasswordVisible,
                                    style:
                                        TextStyle(fontSize: 12.sp, color: grey),
                                    cursorColor: grey,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return canNotNull;
                                      } else if (value.length < 8) {
                                        return passwordRequiedLength;
                                      } else if (value ==
                                          currentPassworldController.text) {
                                        return newPasswordMustNotSameAsCurrentPassword;
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
                                        hintStyle: TextStyle(fontSize: 14.sp),
                                        hintText: 'Mật khẩu mới',
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
                                    text: " Nhập lại mật khẩu mới",
                                    fontsize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                    color: blueText,
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  TextFormField(
                                    onTapOutside: (event) {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                    },
                                    controller: reNewPassworldController,
                                    obscureText: reNewPasswordVisible,
                                    style:
                                        TextStyle(fontSize: 12.sp, color: grey),
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
                                        suffixIconColor:
                                            Color.fromARGB(255, 226, 104, 159),
                                        suffixIcon: IconButton(
                                            onPressed: () {
                                              setState(
                                                () {
                                                  reNewPasswordVisible =
                                                      !reNewPasswordVisible;
                                                },
                                              );
                                            },
                                            icon: Icon(reNewPasswordVisible
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
                                        hintStyle: TextStyle(fontSize: 14.sp),
                                        hintText: 'Nhập lại mật khẩu mới',
                                        isDense: true,
                                        contentPadding: EdgeInsets.all(15.w)),
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
                                          showConfirmDialog(context, () {
                                            print("ConFIRM");
                                            changePasswordStaff(
                                                currentPassword:
                                                    currentPassworldController
                                                        .text,
                                                newPassword:
                                                    newPassworldController.text,
                                                confirmNewPassword:
                                                    reNewPassworldController
                                                        .text);
                                          });
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
            )),
      )),
    );
  }
}
