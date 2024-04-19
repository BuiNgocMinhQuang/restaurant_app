import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/config/space.dart';
import 'package:app_restaurant/config/text.dart';
import 'package:app_restaurant/config/void_show_dialog.dart';
import 'package:app_restaurant/model/manager_infor_model.dart';
import 'package:app_restaurant/routers/app_router_config.dart';
import 'package:app_restaurant/utils/storage.dart';
import 'package:app_restaurant/widgets/button/button_gradient.dart';
import 'package:app_restaurant/widgets/text/copy_right_text.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:app_restaurant/constant/api/index.dart';
import 'package:app_restaurant/env/index.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ManagerInformation extends StatefulWidget {
  const ManagerInformation({super.key});

  @override
  State<ManagerInformation> createState() => _ManagerInformationState();
}

class _ManagerInformationState extends State<ManagerInformation> {
  final _formField1 = GlobalKey<FormState>();
  final _formField2 = GlobalKey<FormState>();
  final _formField3 = GlobalKey<FormState>();
  final _formField4 = GlobalKey<FormState>();
  bool currentPasswordVisible = true;
  bool newPasswordVisible = true;
  bool reNewPasswordVisible = true;
  bool passwordForOpenIDImageVisible = true;
  bool isChangeUI = false;
  DataManagerInfor? managerInforData;
  final surNameController = TextEditingController();
  final nameController = TextEditingController();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final currentPassworldController = TextEditingController();
  final newPassworldController = TextEditingController();
  final reNewPassworldController = TextEditingController();
  final address4Controller = TextEditingController();
  final passwordForOpenIDImage = TextEditingController();
  List cityList = [];
  List districList = [];
  List wardList = [];
  String currentAvatar = 'assets/user/images/avt/no_image.png';
  String currentImageFrontID = 'assets/img/no-image.png';
  String currentImageBackID = 'assets/img/no-image.png';
  String currentImageHoldID = 'assets/img/no-image.png';
  String? currentCity;
  String? currentDistric;
  String? currentWard;

  int? currentIndexCity;
  int? currentIndexDistric;
  int? currentIndexWard;
  File? selectedImage;
  File? selectedImageFrontID;
  File? selectedImageBackID;
  File? selectedImageHoldID;
  void pickImage() async {
    final returndImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returndImage == null) return;
    setState(() {
      selectedImage = File(returndImage.path);
    });
    openImage();
  }

  void pickImageFrontID() async {
    final returndImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returndImage == null) return;
    setState(() {
      selectedImageFrontID = File(returndImage.path);
    });
  }

  void pickImageBackID() async {
    final returndImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returndImage == null) return;
    setState(() {
      selectedImageBackID = File(returndImage.path);
    });
  }

  void pickImageHoldID() async {
    final returndImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returndImage == null) return;
    setState(() {
      selectedImageHoldID = File(returndImage.path);
    });
  }

  openImage() async {
    try {
      if (selectedImage != null) {
        Uint8List imagebytes =
            await selectedImage!.readAsBytes(); //convert to bytes
        String base64string =
            base64Encode(imagebytes); //convert bytes to base64 string

        try {
          print("TRUYEN NNNN ${{
            "staff_avatar": base64string,
          }}");
          var token = StorageUtils.instance.getString(key: 'token_manager');
          final respons = await http.post(
            Uri.parse('$baseUrl$managerUpdateAvatar'),
            headers: {
              'Content-type': 'application/json',
              'Accept': 'application/json',
              "Authorization": "Bearer $token"
            },
            body: jsonEncode({
              "user_avatar": base64string,
            }),
          );
          final data = jsonDecode(respons.body);
          print("DATA CHANGE AVATAR MANAGER  ${data}}");

          try {
            if (data['status'] == 200) {
              print("CHANGE AVATAR MANAGER  OK");
              showSnackBarTopCustom(
                  title: "Thành công",
                  context: navigatorKey.currentContext,
                  mess: "Cập nhật ảnh đại diện thành công",
                  color: Colors.green);
            } else {
              print("ERROR CHANGE AVATAR MANAGER  1");
              showSnackBarTopCustom(
                  title: "Thất bại",
                  context: navigatorKey.currentContext,
                  mess: "Thao tác thất bại",
                  color: Colors.red);
            }
          } catch (error) {
            print("ERROR CHANGE AVATAR MANAGER  2 ${error}");
            showSnackBarTopCustom(
                title: "Thất bại",
                context: navigatorKey.currentContext,
                mess: "Thao tác thất bại",
                color: Colors.red);
          }
        } catch (error) {
          print("ERROR CHANGE AVATAR MANAGER  3 $error");
          showSnackBarTopCustom(
              title: "Thất bại",
              context: navigatorKey.currentContext,
              mess: "Thao tác thất bại",
              color: Colors.red);
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

  @override
  void dispose() {
    surNameController.dispose();
    fullNameController.dispose();
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    currentPassworldController.dispose();
    newPassworldController.dispose();
    reNewPassworldController.dispose();
    address4Controller.dispose();
    passwordForOpenIDImage.dispose();
    super.dispose();
  }

  void checkPasswordToUpdateIdImage({
    required String password,
  }) async {
    try {
      var token = StorageUtils.instance.getString(key: 'token_manager');

      final response = await http.post(
        Uri.parse('$baseUrl$managerCheckPassword'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': "Bearer $token"
        },
        body: jsonEncode({
          'check_password': password,
        }),
      );
      final data = jsonDecode(response.body);
      final messRes = data['message'];
      final messText = messRes['text'];
      try {
        if (data['status'] == 200) {
          setState(() {
            isChangeUI = true;
            showCustomDialogModal(
                context: navigatorKey.currentContext,
                textDesc: messText,
                title: "Thành công",
                colorButton: Colors.green,
                btnText: "OK",
                typeDialog: "succes");
          });
        } else {
          showCustomDialogModal(
              context: navigatorKey.currentContext,
              textDesc: messText,
              title: "Thất bại",
              colorButton: Colors.red,
              btnText: "OK",
              typeDialog: "error");
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

  void getListAreaInit({
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
            var myCity = cityListMap[managerInforData?.userAddress1];
            currentCity = myCity;
            //get current District
            var districtListMap = districList.asMap();
            var myDistrict = districtListMap[managerInforData?.userAddress2];
            currentDistric = myDistrict;

            //get Current Ward
            var wardListMap = wardList.asMap();
            var myWard = wardListMap[managerInforData?.userAddress3];
            currentWard = myWard;
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

  void getInfor() async {
    try {
      var token = StorageUtils.instance.getString(key: 'token_manager');
      print("TOKEN CURRENT $token");
      final response = await http.post(
        Uri.parse('$baseUrl$userInformationApi'),
        headers: {"Authorization": "Bearer $token"},
      );
      final data = jsonDecode(response.body);

      try {
        if (data['status'] == 200) {
          var managerInforDataRes = ManagerInforModel.fromJson(data);
          setState(() {
            managerInforData = managerInforDataRes.data;
          });
          init();

          print("GET INFOR MANGAER OK 1");
        } else {
          print("GET INFOR MANGAER ERROR 1");
        }
      } catch (error) {
        print("GET INFOR MANGAER ERROR 2  $error");
      }
    } catch (error) {
      print("GET INFOR MANGAER ERROR 3 $error");
    }
  }

  void deletedAvatarManager() async {
    try {
      var token = StorageUtils.instance.getString(key: 'token_manager');
      final respons = await http.post(
        Uri.parse('$baseUrl$managerDeletedAvatar'),
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
          print("ERROR DELETED AVATAR MANAGER  1");
          showSnackBarTopCustom(
              title: "Thất bại",
              context: navigatorKey.currentContext,
              mess: "Thao tác thất bại",
              color: Colors.red);
        }
      } catch (error) {
        print("ERROR DELETED AVATAR MANAGER  2 ${error}");
      }
    } catch (error) {
      print("ERROR DELETED AVATAR MANAGER  3 $error");
    }
  }

  void changePasswordManager({
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
      var token = StorageUtils.instance.getString(key: 'token_manager');
      log(token.toString());
      final respons = await http.post(
        Uri.parse('$baseUrl$managerUpdatePassword'),
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

  void managerUpdateCitizenID() async {
    try {
      if (selectedImageFrontID != null &&
          selectedImageBackID != null &&
          selectedImageHoldID != null) {
        Uint8List selectedImageFrontIDBytes =
            await selectedImageFrontID!.readAsBytes(); //convert to bytes
        String base64SelectedImageFrontID =
            base64Encode(selectedImageFrontIDBytes);

        Uint8List selectedImageBackIDBytes =
            await selectedImageBackID!.readAsBytes(); //convert to bytes
        String base64SelectedImageBackID =
            base64Encode(selectedImageBackIDBytes);

        Uint8List selectedImageHoldIDBytes =
            await selectedImageHoldID!.readAsBytes(); //convert to bytes
        String base64SelectedImageHoldID =
            base64Encode(selectedImageHoldIDBytes);

        try {
          var token = StorageUtils.instance.getString(key: 'token_manager');
          final respons = await http.post(
            Uri.parse('$baseUrl$managerUpdateCitizenIDApi'),
            headers: {
              'Content-type': 'application/json',
              'Accept': 'application/json',
              "Authorization": "Bearer $token"
            },
            body: jsonEncode({
              "front_image_cccd": base64SelectedImageFrontID,
              "back_image_cccd": base64SelectedImageBackID,
              "hold_image_cccd": base64SelectedImageHoldID,
            }),
          );
          final data = jsonDecode(respons.body);
          print("DATA UPDATE INFOR  ${data}}");
          try {
            if (data['status'] == 200) {
              print("UPDATE INFOR  OK");
              getInfor();
              showSnackBarTopCustom(
                  title: "Thành công",
                  context: navigatorKey.currentContext,
                  mess: "Cập nhật hình ảnh thành công",
                  color: Colors.green);
            } else {
              print("ERROR UPDATE INFOR  1");
              showSnackBarTopCustom(
                  title: "Thất bại",
                  context: navigatorKey.currentContext,
                  mess: "Thao tác thất bại",
                  color: Colors.red);
            }
          } catch (error) {
            print("ERROR UPDATE INFOR  2 ${error}");
            showSnackBarTopCustom(
                title: "Thất bại",
                context: navigatorKey.currentContext,
                mess: "Thao tác thất bại",
                color: Colors.red);
          }
        } catch (error) {
          print("ERROR UPDATE INFOR  3 $error");
          showSnackBarTopCustom(
              title: "Thất bại",
              context: navigatorKey.currentContext,
              mess: "Thao tác thất bại",
              color: Colors.red);
        }
      } else {
        showCustomDialogModal(
            context: navigatorKey.currentContext,
            textDesc:
                "Bạn phải cập nhật đủ ảnh CCCD, nếu thay đối bất kỳ ảnh nào hãy cập nhật lại tất cả ảnh",
            title: "Thất bại",
            colorButton: Colors.red,
            btnText: "OK",
            typeDialog: "error");
      }
    } catch (error) {
      print("error while picking file.");
    }
  }

  void updateInforManager({
    required String? firstName,
    required String? lastName,
    required String? fullName,
    required String? email,
    required String? phone,
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
    }}");
    try {
      var token = StorageUtils.instance.getString(key: 'token_manager');
      final respons = await http.post(
        Uri.parse('$baseUrl$mangerUpdateInfor'),
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

  void init() async {
    var imagePath1 =
        (managerInforData?.userAvatar ?? 'assets/user/images/avt/no_image.png');
    // var imagePath2 = imagePath1.replaceAll('"]', '');
    var listImagePath = imagePath1;
    var imageFrontID1 =
        (managerInforData?.frontImageCccd ?? 'assets/img/no-image.png')
            .replaceAll('["', '');
    var imageFrontID2 = imageFrontID1.replaceAll('"]', '');
    var imageBackID1 =
        (managerInforData?.backImageCccd ?? 'assets/img/no-image.png')
            .replaceAll('["', '');
    var imageBackID2 = imageBackID1.replaceAll('"]', '');
    var imageHoldID1 =
        (managerInforData?.holdImageCccd ?? 'assets/img/no-image.png')
            .replaceAll('["', '');
    var imageHoldID2 = imageHoldID1.replaceAll('"]', '');
    mounted ? currentAvatar = listImagePath : currentAvatar;
    mounted ? currentImageFrontID = imageFrontID2 : currentImageFrontID;
    mounted ? currentImageBackID = imageBackID2 : currentImageBackID;
    mounted ? currentImageHoldID = imageHoldID2 : currentImageHoldID;

    mounted
        ? fullNameController.text = managerInforData?.userFullName ?? ''
        : null;
    mounted
        ? surNameController.text = managerInforData?.userFirstName ?? ''
        : null;

    mounted ? nameController.text = managerInforData?.userLastName ?? '' : null;
    mounted ? emailController.text = managerInforData?.userEmail ?? '' : null;
    mounted ? phoneController.text = managerInforData?.userPhone ?? '' : null;

    mounted
        ? address4Controller.text = managerInforData?.userAddress4 ?? ''
        : null;
    getListAreaInit(
        city: managerInforData?.userAddress1,
        district: managerInforData?.userAddress2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        width: 1.sw,
        color: Colors.white,
        child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 40.h, left: 10.w, right: 10.w),
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
                                  child: Container(
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
                                                            Icon(
                                                              Icons.image,
                                                              size: 35.sp,
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
                                                      Divider(),
                                                      space10H,
                                                      InkWell(
                                                        onTap: () async {
                                                          Navigator.pop(
                                                              context);
                                                          showConfirmDialog(
                                                              navigatorKey
                                                                  .currentContext!,
                                                              () {
                                                            deletedAvatarManager();
                                                          });
                                                        },
                                                        child: Row(
                                                          children: [
                                                            Icon(
                                                              Icons.delete,
                                                              size: 35.sp,
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
                                      child: Icon(
                                        Icons.edit,
                                        size: 25.sp,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            space25W,
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                        onTapOutside: (event) {
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                        },
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
                                                    // hintText: 'Họ',
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
                                                fontsize: 10.sp,
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
                                        onTapOutside: (event) {
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                        },
                                        controller: phoneController,
                                        keyboardType: TextInputType.name,
                                        style: TextStyle(
                                            fontSize: 12.sp, color: grey),
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
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextApp(
                                        text: " Tỉnh/Thành phố",
                                        fontsize: 10.sp,
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
                                          }
                                        },
                                        selectedItem: currentCity,
                                        items: cityList,
                                        onChanged: (changeCity) {
                                          getListArea(
                                              city:
                                                  cityList.indexOf(changeCity),
                                              district: null);
                                          setState(() {
                                            currentIndexCity =
                                                cityList.indexOf(changeCity);
                                            currentDistric = null;
                                            currentIndexDistric = null;
                                            currentWard = null;
                                            currentIndexWard = null;
                                          });
                                        },
                                        dropdownDecoratorProps:
                                            DropDownDecoratorProps(
                                          dropdownSearchDecoration:
                                              InputDecoration(
                                            // isCollapsed: true,

                                            hintMaxLines: 1,
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
                                            isDense: true,
                                            contentPadding:
                                                EdgeInsets.all(15.w),
                                            hintStyle:
                                                TextStyle(fontSize: 14.sp),
                                            hintText: "Chọn tỉnh/thành phố",
                                          ),
                                        ),
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
                                        fontsize: 10.sp,
                                        fontWeight: FontWeight.bold,
                                        color: blueText,
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      DropdownSearch(
                                        key: Key(currentDistric.toString()),

                                        validator: (value) {
                                          if (value == "Chọn quận/huyện") {
                                            return canNotNull;
                                          }
                                        },

                                        selectedItem: currentDistric,

                                        items: districList,
                                        onChanged: (changeDistric) {
                                          getListArea(
                                              city: currentIndexCity ??
                                                  managerInforData
                                                      ?.userAddress1,
                                              district: districList
                                                  .indexOf(changeDistric));
                                          setState(() {
                                            currentIndexDistric = districList
                                                .indexOf(changeDistric);
                                            currentWard = null;
                                            currentIndexWard = null;
                                          });
                                        },

                                        dropdownDecoratorProps:
                                            DropDownDecoratorProps(
                                          dropdownSearchDecoration:
                                              InputDecoration(
                                            hintMaxLines: 1,
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
                                            isDense: true,
                                            contentPadding:
                                                EdgeInsets.all(15.w),
                                            hintStyle:
                                                TextStyle(fontSize: 14.sp),
                                            hintText: "Chọn quận/huyện",
                                          ),
                                        ),
                                        // selectedItem:
                                        //     "Chọn quận/huyện",
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
                                        fontsize: 10.sp,
                                        fontWeight: FontWeight.bold,
                                        color: blueText,
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      DropdownSearch(
                                        key: Key(currentWard.toString()),

                                        validator: (value) {
                                          if (value == "Chọn phường/xã") {
                                            return canNotNull;
                                          }
                                        },

                                        selectedItem: currentWard,

                                        items: wardList,
                                        onChanged: (changeWard) {
                                          getListArea(
                                              city: currentIndexCity,
                                              district: currentIndexDistric);
                                          setState(() {
                                            currentIndexWard =
                                                wardList.indexOf(changeWard);
                                            var wardListMap = wardList.asMap();
                                            var myWard = wardListMap[
                                                wardList.indexOf(changeWard)];
                                            currentWard = myWard;
                                          });
                                        },

                                        dropdownDecoratorProps:
                                            DropDownDecoratorProps(
                                          dropdownSearchDecoration:
                                              InputDecoration(
                                            hintMaxLines: 1,
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
                                            isDense: true,
                                            contentPadding:
                                                EdgeInsets.all(15.w),
                                            hintStyle:
                                                TextStyle(fontSize: 14.sp),
                                            hintText: "Chọn phường/xã",
                                          ),
                                        ),
                                        // selectedItem:
                                        //     "Chọn quận/huyện",
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
                                        fontsize: 10.sp,
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
                                            fontSize: 12.sp, color: grey),
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
                                            // hintText: 'Tên',
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
                                            hintText: 'Email',
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
                                                updateInforManager(
                                                  firstName:
                                                      surNameController.text,
                                                  lastName: nameController.text,
                                                  fullName:
                                                      fullNameController.text,
                                                  email: emailController.text,
                                                  phone: phoneController.text,
                                                  address1: currentIndexCity ??
                                                      managerInforData
                                                          ?.userAddress1,
                                                  address2:
                                                      currentIndexDistric ??
                                                          managerInforData
                                                              ?.userAddress2,
                                                  address3: currentIndexWard ??
                                                      managerInforData
                                                          ?.userAddress3,
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
                                            changePasswordManager(
                                              currentPassword:
                                                  currentPassworldController
                                                      .text,
                                              newPassword:
                                                  newPassworldController.text,
                                              confirmNewPassword:
                                                  reNewPassworldController.text,
                                            );
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

                //CCCD FORM
                isChangeUI
                    ? Form(
                        key: _formField4,
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
                                      "Hình ảnh CCCD",
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
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            TextApp(
                                              text: "Mặt trước",
                                              fontsize: 12.sp,
                                              fontWeight: FontWeight.bold,
                                              color: blueText,
                                            ),
                                            space10H,
                                            InkWell(
                                              onTap: () {
                                                pickImageFrontID();
                                              },
                                              child: Container(
                                                width: 110.w,
                                                height: 80.w,
                                                color: Colors.grey,
                                                child: selectedImageFrontID !=
                                                        null
                                                    ? Image.file(
                                                        selectedImageFrontID!,
                                                        fit: BoxFit.cover,
                                                      )
                                                    : CachedNetworkImage(
                                                        fit: BoxFit.cover,
                                                        imageUrl: httpImage +
                                                            currentImageFrontID,
                                                        placeholder:
                                                            (context, url) =>
                                                                SizedBox(
                                                          child: Center(
                                                              child:
                                                                  CircularProgressIndicator()),
                                                          height: 10.w,
                                                          width: 10.w,
                                                        ),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Icon(Icons.error),
                                                      ),
                                              ),
                                            )
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            TextApp(
                                              text: "Mặt sau",
                                              fontsize: 12.sp,
                                              fontWeight: FontWeight.bold,
                                              color: blueText,
                                            ),
                                            space10H,
                                            InkWell(
                                              onTap: () {
                                                pickImageBackID();
                                              },
                                              child: Container(
                                                width: 110.w,
                                                height: 80.w,
                                                color: Colors.grey,
                                                child: selectedImageBackID !=
                                                        null
                                                    ? Image.file(
                                                        selectedImageBackID!,
                                                        fit: BoxFit.cover,
                                                      )
                                                    : CachedNetworkImage(
                                                        fit: BoxFit.cover,
                                                        imageUrl: httpImage +
                                                            currentImageBackID,
                                                        placeholder:
                                                            (context, url) =>
                                                                SizedBox(
                                                          height: 10.w,
                                                          width: 10.w,
                                                          child: const Center(
                                                              child:
                                                                  CircularProgressIndicator()),
                                                        ),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            const Icon(
                                                                Icons.error),
                                                      ),
                                              ),
                                            )
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            TextApp(
                                              text: "Khuôn mặt",
                                              fontsize: 12.sp,
                                              fontWeight: FontWeight.bold,
                                              color: blueText,
                                            ),
                                            space10H,
                                            InkWell(
                                              onTap: () {
                                                pickImageHoldID();
                                              },
                                              child: Container(
                                                width: 110.w,
                                                height: 80.w,
                                                color: Colors.grey,
                                                child: selectedImageHoldID !=
                                                        null
                                                    ? Image.file(
                                                        selectedImageHoldID!,
                                                        fit: BoxFit.cover,
                                                      )
                                                    : CachedNetworkImage(
                                                        fit: BoxFit.cover,
                                                        imageUrl: httpImage +
                                                            currentImageHoldID,
                                                        placeholder:
                                                            (context, url) =>
                                                                SizedBox(
                                                          height: 10.w,
                                                          width: 10.w,
                                                          child: const Center(
                                                              child:
                                                                  CircularProgressIndicator()),
                                                        ),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            const Icon(
                                                                Icons.error),
                                                      ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    space25H,
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 200.w,
                                          child: ButtonGradient(
                                            color1: color1DarkButton,
                                            color2: color2DarkButton,
                                            event: () {
                                              managerUpdateCitizenID();
                                            },
                                            text: "Xác nhận",
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
                      )
                    : Form(
                        key: _formField3,
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
                                      "Hình ảnh CCCD",
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
                                          text: " Mật khẩu",
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
                                          controller: passwordForOpenIDImage,
                                          obscureText:
                                              passwordForOpenIDImageVisible,
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
                                                        passwordForOpenIDImageVisible =
                                                            !passwordForOpenIDImageVisible;
                                                      },
                                                    );
                                                  },
                                                  icon: Icon(
                                                      passwordForOpenIDImageVisible
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
                                              hintText:
                                                  'Xác nhận mật khẩu để cập nhật thẻ CCCD',
                                              isDense: true,
                                              contentPadding:
                                                  EdgeInsets.all(15.w)),
                                        ),
                                      ],
                                    ),
                                    space25H,
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 200.w,
                                          child: ButtonGradient(
                                            color1: color1DarkButton,
                                            color2: color2DarkButton,
                                            event: () {
                                              if (_formField3.currentState!
                                                  .validate()) {
                                                checkPasswordToUpdateIdImage(
                                                    password:
                                                        passwordForOpenIDImage
                                                            .text);
                                              }

                                              // setState(() {
                                              //   isChangeUI = true;
                                              // });
                                            },
                                            text: "Xác nhận",
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
