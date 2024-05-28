import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:app_restaurant/config/void_show_dialog.dart';
import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/config/space.dart';
import 'package:app_restaurant/config/text.dart';
import 'package:app_restaurant/env/index.dart';
import 'package:app_restaurant/model/staff/staff_infor_model.dart';
import 'package:app_restaurant/routers/app_router_config.dart';
import 'package:app_restaurant/utils/storage.dart';
import 'package:app_restaurant/widgets/button/button_gradient.dart';
import 'package:app_restaurant/widgets/text/copy_right_text.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:app_restaurant/constant/api/index.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'dart:math' as math;

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
  final cityNameTextController = TextEditingController();
  final districNameTextController = TextEditingController();
  final wardNameTextController = TextEditingController();
  File? selectedImage;
  String currentAvatar = 'assets/user/images/avt/no_image.png';
  List cityList = [];
  List districList = [];
  List wardList = [];
  DataStaffInfor? staffInforData;

  String? currentCity;
  String? currentDistric;
  String? currentWard;
  String? dayroi;
  int? currentIndexCity;
  int? currentIndexDistric;
  int? currentIndexWard;
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
      var token = StorageUtils.instance.getString(key: 'token_staff');
      final respons = await http.post(
        Uri.parse('$baseUrl$deleteAvatarStaff'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token"
        },
      );
      final data = jsonDecode(respons.body);
      try {
        if (data['status'] == 200) {
          getInfor();
          showSnackBarTopCustom(
              title: "Thành công",
              context: navigatorKey.currentContext,
              mess: "Xoá ảnh đại diện thành công",
              color: Colors.green);
        } else {
          log("ERROR deletedAvatarStaff  1");
          showSnackBarTopCustom(
              title: "Thất bại",
              context: navigatorKey.currentContext,
              mess: "Thao tác thất bại",
              color: Colors.red);
        }
      } catch (error) {
        log("ERROR deletedAvatarStaff 2 $error");
      }
    } catch (error) {
      log("ERROR deletedAvatarStaff 3 $error");
    }
  }

  openImage() async {
    try {
      if (selectedImage != null) {
        Uint8List imagebytes =
            selectedImage!.readAsBytesSync(); //convert to bytes
        String base64string =
            base64Encode(imagebytes); //convert bytes to base64 string
        // base64.encode(imagebytes);

        try {
          var token = StorageUtils.instance.getString(key: 'token_staff');
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
          log("DATA CHANGE AVATAR STAFF  $data}");

          try {
            if (data['status'] == 200) {
              log("CHANGE AVATAR STAFF  OK");
              showSnackBarTopCustom(
                  title: "Thành công",
                  context: navigatorKey.currentContext,
                  mess: "Cập nhật ảnh đại diện thành công",
                  color: Colors.green);
            } else {
              log("ERROR CHANGE AVATAR STAFF  1");
              showSnackBarTopCustom(
                  title: "Thất bại",
                  context: navigatorKey.currentContext,
                  mess: "Thao tác thất bại",
                  color: Colors.red);
            }
          } catch (error) {
            log("ERROR CHANGE AVATAR STAFF  2 $error");
          }
        } catch (error) {
          log("ERROR CHANGE AVATAR STAFF  3 $error");
        }
      } else {
        log("No image is selected.");
      }
    } catch (e) {
      log("error while picking file.");
    }
  }

  void getInfor() async {
    try {
      var token = StorageUtils.instance.getString(key: 'token_staff');
      log("TOKEN CURRENT $token");
      final response = await http.post(
        Uri.parse('$baseUrl$userInformationApi'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token"
        },
        // headers: {"Authorization": "Bearer $token"},
      );
      final data = jsonDecode(response.body);
      // var message = data['message'];

      try {
        if (data['status'] == 200) {
          var staffInforDataRes = StaffInfor.fromJson(data);
          mounted
              ? setState(() {
                  staffInforData = staffInforDataRes.data;
                })
              : null;
          init();
        } else {
          log(" ERROR getInfor 1");
        }
      } catch (error) {
        log("ERROR getInfor 2  $error");
      }
    } catch (error) {
      log("ERROR getInfor 3 $error");
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
    try {
      var token = StorageUtils.instance.getString(key: 'token_staff');
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
      final messText = data['message'];

      try {
        if (data['status'] == 200) {
          getInfor();
          showSnackBarTopCustom(
              title: "Thành công",
              context: navigatorKey.currentContext,
              mess: messText['text'],
              color: Colors.green);
        } else {
          log("ERROR updateInforStaff  1");
          showSnackBarTopCustom(
              title: "Thất bại",
              context: navigatorKey.currentContext,
              mess: messText['text'],
              color: Colors.red);
        }
      } catch (error) {
        log("ERROR updateInforStaff 2 $error");
      }
    } catch (error) {
      log("ERROR updateInforStaff 3 $error");
    }
  }

  void changePasswordStaff({
    required String? currentPassword,
    required String? newPassword,
    required String? confirmNewPassword,
  }) async {
    try {
      var token = StorageUtils.instance.getString(key: 'token_staff');
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
      final messText = data['message'];
      try {
        if (data['status'] == 200) {
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
          log("ERROR changePasswordStaff  1");
          showSnackBarTopCustom(
              title: "Thất bại",
              context: navigatorKey.currentContext,
              mess: messText['text'],
              color: Colors.red);
        }
      } catch (error) {
        log("ERROR changePasswordStaff 2 $error");
      }
    } catch (error) {
      log("ERROR changePasswordStaff 3 $error");
    }
  }

  void getListAreaInit({
    required int? city,
    required int? district,
  }) async {
    log("DATA TRUYEN NN ${{
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
                  var myCity = cityListMap[staffInforData?.staffAddress1];
                  currentCity = myCity;
                  //get current District
                  var districtListMap = districList.asMap();
                  var myDistrict =
                      districtListMap[staffInforData?.staffAddress2];
                  currentDistric = myDistrict;

                  //get Current Ward
                  var wardListMap = wardList.asMap();
                  var myWard = wardListMap[staffInforData?.staffAddress3];
                  currentWard = myWard;
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
    log("DATA TRUYEN NN ${{
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
                })
              : null;
        } else {
          log("ERROR getListArea 1 ");
        }
      } catch (error) {
        log("ERROR getListArea 2 $error");
      }
    } catch (error) {
      log("ERROR getListArea 3 $error");
    }
  }

  void init() async {
    await Future.delayed(const Duration(seconds: 0));
    var imagePath1 =
        (staffInforData?.staffAvatar ?? 'assets/user/images/avt/no_image.png');
    // var imagePath2 = imagePath1.replaceAll('"]', '');
    var listImagePath = imagePath1;
    mounted ? currentAvatar = listImagePath : currentAvatar;

    mounted
        ? fullNameController.text = staffInforData?.staffFullName ?? ''
        : null;
    mounted
        ? surNameController.text = staffInforData?.staffFirstName ?? ''
        : null;

    mounted ? nameController.text = staffInforData?.staffLastName ?? '' : null;
    mounted ? emailController.text = staffInforData?.staffEmail ?? '' : null;
    mounted ? phoneController.text = staffInforData?.staffPhone ?? '' : null;
    mounted
        ? roleController.text = (staffInforData?.staffPosition == 1
            ? 'Nhân viên'
            : staffInforData?.staffPosition == 2
                ? 'Trưởng nhóm'
                : staffInforData?.staffPosition == 3
                    ? 'Quản lý'
                    : staffInforData?.staffPosition == 4
                        ? 'Kế toán'
                        : 'Đầu bếp')
        : null;
    mounted
        ? twitterController.text = staffInforData?.staffTwitter ?? ''
        : null;
    mounted
        ? facebookController.text = staffInforData?.staffFacebook ?? ''
        : null;
    mounted
        ? instagramController.text = staffInforData?.staffInstagram ?? ''
        : null;
    mounted ? shopIDController.text = staffInforData?.shopId ?? '' : null;

    mounted
        ? address4Controller.text = staffInforData?.staffAddress4 ?? ''
        : null;

    getListAreaInit(
        city: staffInforData?.staffAddress1,
        district: staffInforData?.staffAddress2);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) => getInfor());
    });
    super.initState();
  }

  @override
  void dispose() {
    shopIDController.dispose();
    surNameController.dispose();
    nameController.dispose(); //
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    currentPassworldController.dispose();
    newPassworldController.dispose();
    reNewPassworldController.dispose();
    roleController.dispose();
    twitterController.dispose();
    facebookController.dispose();
    instagramController.dispose();
    address1Controller.dispose();
    address2Controller.dispose();
    address3Controller.dispose();
    address4Controller.dispose();
    cityNameTextController.dispose();
    districNameTextController.dispose();
    wardNameTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: RefreshIndicator(
        color: Theme.of(context).colorScheme.primary,
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
                                  height: 125.w,
                                  color: Colors.grey,
                                  child: selectedImage != null
                                      ? Image.file(
                                          selectedImage!,
                                          fit: BoxFit.fill,
                                        )
                                      : CachedNetworkImage(
                                          fit: BoxFit.fill,
                                          imageUrl: httpImage + currentAvatar,
                                          placeholder: (context, url) =>
                                              SizedBox(
                                            height: 10.w,
                                            width: 10.w,
                                            child: const Center(
                                                child:
                                                    CircularProgressIndicator()),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                ),
                                Positioned(
                                  top: 5.w,
                                  right: 5.w,
                                  child: SizedBox(
                                    width: 20.w,
                                    height: 20.w,
                                    child: InkWell(
                                      onTap: () {
                                        showMaterialModalBottomSheet(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(25.r),
                                                topLeft: Radius.circular(25.r),
                                              ),
                                            ),
                                            clipBehavior:
                                                Clip.antiAliasWithSaveLayer,
                                            context: context,
                                            builder: (context) => Container(
                                                  height: 1.sh / 3,
                                                  padding: EdgeInsets.all(20.w),
                                                  child: Column(
                                                    children: [
                                                      InkWell(
                                                        onTap: () async {
                                                          Navigator.pop(
                                                              context);
                                                          pickImage();
                                                        },
                                                        child: Row(
                                                          children: [
                                                            SizedBox(
                                                              width: 35.w,
                                                              height: 35.w,
                                                              child: SvgPicture
                                                                  .asset(
                                                                'assets/svg/picture.svg',
                                                                fit: BoxFit
                                                                    .contain,
                                                              ),
                                                            ),
                                                            space10W,
                                                            TextApp(
                                                              text:
                                                                  "Thay đổi ảnh đại diện",
                                                              color:
                                                                  Colors.black,
                                                              fontsize: 18.sp,
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      space10H,
                                                      const Divider(),
                                                      space10H,
                                                      InkWell(
                                                        onTap: () async {
                                                          Navigator.pop(
                                                              context);
                                                          showConfirmDialog(
                                                              navigatorKey
                                                                  .currentContext!,
                                                              () {
                                                            deletedAvatarStaff();
                                                          });
                                                        },
                                                        child: Row(
                                                          children: [
                                                            SizedBox(
                                                              width: 35.w,
                                                              height: 35.w,
                                                              child: SvgPicture
                                                                  .asset(
                                                                'assets/svg/delete_icon.svg',
                                                                fit: BoxFit
                                                                    .contain,
                                                              ),
                                                            ),
                                                            space10W,
                                                            TextApp(
                                                              text:
                                                                  "Xoá ảnh đại diện",
                                                              color:
                                                                  Colors.black,
                                                              fontsize: 18.sp,
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ));
                                      },
                                      child: SizedBox(
                                        width: 35.w,
                                        height: 35.w,
                                        child: SvgPicture.asset(
                                          'assets/svg/edit_icon.svg',
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
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
                                                fontsize: 14.sp,
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
                                                    fontSize: 14.sp,
                                                    color: Colors.black),
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
                                                    hintStyle: TextStyle(
                                                        fontSize: 14.sp,
                                                        color: grey),
                                                    isDense: true,
                                                    contentPadding:
                                                        EdgeInsets.all(20.w)),
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
                                                fontsize: 14.sp,
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
                                                    fontSize: 14.sp,
                                                    color: Colors.black),
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
                                                        fontSize: 14.sp,
                                                        color: grey),
                                                    isDense: true,
                                                    contentPadding:
                                                        EdgeInsets.all(20.w)),
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
                                                fontsize: 14.sp,
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
                                                    fontSize: 14.sp,
                                                    color: Colors.black),
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
                                                    hintStyle: TextStyle(
                                                        fontSize: 14.sp,
                                                        color: grey),
                                                    isDense: true,
                                                    contentPadding:
                                                        EdgeInsets.all(20.w)),
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
                                                fontsize: 14.sp,
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
                                                    fontSize: 14.sp,
                                                    color: Colors.black),
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
                                                        fontSize: 14.sp,
                                                        color: grey),
                                                    isDense: true,
                                                    contentPadding:
                                                        EdgeInsets.all(20.w)),
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
                                                fontsize: 14.sp,
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
                                                    fontSize: 14.sp,
                                                    color: Colors.black),
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
                                                    hintStyle: TextStyle(
                                                        fontSize: 14.sp,
                                                        color: grey),
                                                    isDense: true,
                                                    contentPadding:
                                                        EdgeInsets.all(20.w)),
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
                                                fontsize: 14.sp,
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
                                                    fontSize: 14.sp,
                                                    color: Colors.black),
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
                                                  return null;
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
                                                    hintStyle: TextStyle(
                                                        fontSize: 14.sp,
                                                        color: grey),
                                                    isDense: true,
                                                    contentPadding:
                                                        EdgeInsets.all(20.w)),
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
                                        text: " Tỉnh/Thành phố",
                                        fontsize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                        color: blueText,
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      TextFormField(
                                        readOnly: true,
                                        onTapOutside: (event) {
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                        },
                                        onTap: () {
                                          showMaterialModalBottomSheet(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(15.r),
                                                topLeft: Radius.circular(15.r),
                                              ),
                                            ),
                                            clipBehavior:
                                                Clip.antiAliasWithSaveLayer,
                                            context: context,
                                            builder: (context) => Container(
                                              height: 1.sh / 2,
                                              child: Column(
                                                children: [
                                                  Container(
                                                    width: 1.sw,
                                                    padding:
                                                        EdgeInsets.all(20.w),
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                    child: TextApp(
                                                      text:
                                                          "Chọn tỉnh/thành phố",
                                                      color: Colors.white,
                                                      fontsize: 20.sp,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: ListView.builder(
                                                      padding: EdgeInsets.only(
                                                          top: 10.w),
                                                      itemCount:
                                                          cityList.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return Column(
                                                          children: [
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left:
                                                                          20.w),
                                                              child: InkWell(
                                                                onTap:
                                                                    () async {
                                                                  Navigator.pop(
                                                                      context);

                                                                  getListArea(
                                                                      city:
                                                                          index,
                                                                      district:
                                                                          null);
                                                                  mounted
                                                                      ? setState(
                                                                          () {
                                                                          cityNameTextController.text =
                                                                              cityList[index];
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
                                                                      text: cityList[
                                                                          index],
                                                                      color: Colors
                                                                          .black,
                                                                      fontsize:
                                                                          20.sp,
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
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            color: Colors.black),
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
                                            hintText: 'Chọn tỉnh/thành phố',
                                            hintStyle: TextStyle(
                                                fontSize: 14.sp, color: grey),
                                            suffixIcon: Transform.rotate(
                                              angle: 90 * math.pi / 180,
                                              child: Icon(
                                                Icons.chevron_right,
                                                size: 28.sp,
                                                color: Colors.black
                                                    .withOpacity(0.5),
                                              ),
                                            ),
                                            isDense: true,
                                            contentPadding:
                                                EdgeInsets.all(20.w)),
                                      ),
                                    ],
                                  ),
                                  space20H,
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextApp(
                                        text: " Quận/Huyện",
                                        fontsize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                        color: blueText,
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      TextFormField(
                                        readOnly: true,
                                        onTapOutside: (event) {
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                        },
                                        onTap: () {
                                          showMaterialModalBottomSheet(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(15.r),
                                                topLeft: Radius.circular(15.r),
                                              ),
                                            ),
                                            clipBehavior:
                                                Clip.antiAliasWithSaveLayer,
                                            context: context,
                                            builder: (context) => SizedBox(
                                              height: 1.sh / 2,
                                              child: Column(
                                                children: [
                                                  Container(
                                                    width: 1.sw,
                                                    padding:
                                                        EdgeInsets.all(20.w),
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                    child: TextApp(
                                                      text: "Chọn quận/huyện",
                                                      color: Colors.white,
                                                      fontsize: 20.sp,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: ListView.builder(
                                                      padding: EdgeInsets.only(
                                                          top: 10.w),
                                                      itemCount:
                                                          districList.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return Column(
                                                          children: [
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left:
                                                                          20.w),
                                                              child: InkWell(
                                                                onTap:
                                                                    () async {
                                                                  Navigator.pop(
                                                                      context);

                                                                  getListArea(
                                                                      city: currentIndexCity ??
                                                                          staffInforData
                                                                              ?.staffAddress1,
                                                                      district:
                                                                          index);
                                                                  mounted
                                                                      ? setState(
                                                                          () {
                                                                          districNameTextController.text =
                                                                              districList[index];
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
                                                                      color: Colors
                                                                          .black,
                                                                      fontsize:
                                                                          20.sp,
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
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            color: Colors.black),
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
                                            hintText: 'Chọn quận/huyện',
                                            hintStyle: TextStyle(
                                                fontSize: 14.sp, color: grey),
                                            suffixIcon: Transform.rotate(
                                              angle: 90 * math.pi / 180,
                                              child: Icon(
                                                Icons.chevron_right,
                                                size: 28.sp,
                                                color: Colors.black
                                                    .withOpacity(0.5),
                                              ),
                                            ),
                                            isDense: true,
                                            contentPadding:
                                                EdgeInsets.all(20.w)),
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
                                        text: " Phường/Xã",
                                        fontsize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                        color: blueText,
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      TextFormField(
                                        readOnly: true,
                                        onTapOutside: (event) {
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                        },
                                        onTap: () {
                                          showMaterialModalBottomSheet(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(15.r),
                                                topLeft: Radius.circular(15.r),
                                              ),
                                            ),
                                            clipBehavior:
                                                Clip.antiAliasWithSaveLayer,
                                            context: context,
                                            builder: (context) => SizedBox(
                                              height: 1.sh / 2,
                                              child: Column(
                                                children: [
                                                  Container(
                                                    width: 1.sw,
                                                    padding:
                                                        EdgeInsets.all(20.w),
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                    child: TextApp(
                                                      text: "Chọn phường/xã",
                                                      color: Colors.white,
                                                      fontsize: 20.sp,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: ListView.builder(
                                                      padding: EdgeInsets.only(
                                                          top: 10.w),
                                                      itemCount:
                                                          wardList.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return Column(
                                                          children: [
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left:
                                                                          20.w),
                                                              child: InkWell(
                                                                onTap:
                                                                    () async {
                                                                  Navigator.pop(
                                                                      context);

                                                                  getListArea(
                                                                      city:
                                                                          currentIndexCity,
                                                                      district:
                                                                          currentIndexDistric);
                                                                  mounted
                                                                      ? setState(
                                                                          () {
                                                                          wardNameTextController.text =
                                                                              wardList[index];

                                                                          currentIndexWard =
                                                                              index;
                                                                          var wardListMap =
                                                                              wardList.asMap();
                                                                          var myWard =
                                                                              wardListMap[index];
                                                                          currentWard =
                                                                              myWard;
                                                                        })
                                                                      : null;
                                                                },
                                                                child: Row(
                                                                  children: [
                                                                    TextApp(
                                                                      text: wardList[
                                                                          index],
                                                                      color: Colors
                                                                          .black,
                                                                      fontsize:
                                                                          20.sp,
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
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            color: Colors.black),
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
                                            hintText: 'Chọn phường/xã',
                                            hintStyle: TextStyle(
                                                fontSize: 14.sp, color: grey),
                                            suffixIcon: Transform.rotate(
                                              angle: 90 * math.pi / 180,
                                              child: Icon(
                                                Icons.chevron_right,
                                                size: 28.sp,
                                                color: Colors.black
                                                    .withOpacity(0.5),
                                              ),
                                            ),
                                            isDense: true,
                                            contentPadding:
                                                EdgeInsets.all(20.w)),
                                      ),
                                    ],
                                  ),
                                  space20H,
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextApp(
                                        text: " Số nhà, đường",
                                        fontsize: 14.sp,
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
                                        controller: address4Controller,
                                        keyboardType: TextInputType.name,
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            color: Colors.black),
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
                                            hintStyle: TextStyle(
                                                fontSize: 14.sp, color: grey),
                                            isDense: true,
                                            contentPadding:
                                                EdgeInsets.all(20.w)),
                                      ),
                                    ],
                                  ),
                                  space20H,
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextApp(
                                        text: " Email",
                                        fontsize: 14.sp,
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
                                          }
                                          return null;
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
                                            hintStyle: TextStyle(
                                                fontSize: 14.sp, color: grey),
                                            hintText: 'Email',
                                            isDense: true,
                                            contentPadding:
                                                EdgeInsets.all(20.w)),
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
                                        fontsize: 14.sp,
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
                                                EdgeInsets.all(20.w)),
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
                                        fontsize: 14.sp,
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
                                                EdgeInsets.all(20.w)),
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
                                        fontsize: 14.sp,
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
                                                EdgeInsets.all(20.w)),
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
                                                      staffInforData
                                                          ?.staffAddress1,
                                                  address2:
                                                      currentIndexDistric ??
                                                          staffInforData
                                                              ?.staffAddress2,
                                                  address3: currentIndexWard ??
                                                      staffInforData
                                                          ?.staffAddress3,
                                                  address4:
                                                      address4Controller.text,
                                                );
                                              });
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
                                    fontsize: 14.sp,
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
                                    style: TextStyle(
                                        fontSize: 14.sp, color: Colors.black),
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
                                        suffixIconColor: const Color.fromARGB(
                                            255, 226, 104, 159),
                                        suffixIcon: IconButton(
                                            onPressed: () {
                                              mounted
                                                  ? setState(
                                                      () {
                                                        currentPasswordVisible =
                                                            !currentPasswordVisible;
                                                      },
                                                    )
                                                  : null;
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
                                        hintStyle: TextStyle(
                                            fontSize: 14.sp, color: grey),
                                        hintText: 'Mật khẩu hiện tại',
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
                                    text: " Mật khẩu mới",
                                    fontsize: 14.sp,
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
                                    style: TextStyle(
                                        fontSize: 14.sp, color: Colors.black),
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
                                        suffixIconColor: const Color.fromARGB(
                                            255, 226, 104, 159),
                                        suffixIcon: IconButton(
                                            onPressed: () {
                                              mounted
                                                  ? setState(
                                                      () {
                                                        newPasswordVisible =
                                                            !newPasswordVisible;
                                                      },
                                                    )
                                                  : null;
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
                                        hintStyle: TextStyle(
                                            fontSize: 14.sp, color: grey),
                                        hintText: 'Mật khẩu mới',
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
                                    text: " Nhập lại mật khẩu mới",
                                    fontsize: 14.sp,
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
                                    style: TextStyle(
                                        fontSize: 14.sp, color: Colors.black),
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
                                        suffixIconColor: const Color.fromARGB(
                                            255, 226, 104, 159),
                                        suffixIcon: IconButton(
                                            onPressed: () {
                                              mounted
                                                  ? setState(
                                                      () {
                                                        reNewPasswordVisible =
                                                            !reNewPasswordVisible;
                                                      },
                                                    )
                                                  : null;
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
                                        hintStyle: TextStyle(
                                            fontSize: 14.sp, color: grey),
                                        hintText: 'Nhập lại mật khẩu mới',
                                        isDense: true,
                                        contentPadding: EdgeInsets.all(20.w)),
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

                const CopyRightText(),
                space35H,
              ],
            )),
      )),
    );
  }
}
