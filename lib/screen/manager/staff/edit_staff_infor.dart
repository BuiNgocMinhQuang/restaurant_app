import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:app_restaurant/config/void_show_dialog.dart';
import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/config/space.dart';
import 'package:app_restaurant/config/text.dart';
import 'package:app_restaurant/model/manager/manager_list_store_model.dart';
import 'package:app_restaurant/utils/storage.dart';
import 'package:app_restaurant/widgets/button/button_gradient.dart';
import 'package:app_restaurant/widgets/text/copy_right_text.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:app_restaurant/env/index.dart';
import 'package:app_restaurant/constant/api/index.dart';
import 'package:app_restaurant/model/manager/staff/show_data_details_staff_model.dart';

class EditStaffInformation extends StatefulWidget {
  final String staffNo;
  const EditStaffInformation({Key? key, required this.staffNo})
      : super(key: key);

  @override
  State<EditStaffInformation> createState() => _EditStaffInformationState();
}

class _EditStaffInformationState extends State<EditStaffInformation> {
  final _formField1 = GlobalKey<FormState>();
  final _formField2 = GlobalKey<FormState>();
  bool currentPasswordVisible = true;
  bool newPasswordVisible = true;
  bool reNewPasswordVisible = true;
  bool light = false;
  final surNameController = TextEditingController();
  final nameController = TextEditingController();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final currentPassworldController = TextEditingController();
  final newPassworldController = TextEditingController();
  final reNewPassworldController = TextEditingController();
  final address4Controller = TextEditingController();
  final twitterTextController = TextEditingController();
  final facebookTextController = TextEditingController();
  final instagramTextController = TextEditingController();
  String currentAvatar = 'assets/user/images/avt/no_image.png';
  int? currentRoleOfStaff;
  String? roleStaffString;

  List cityList = [];
  List districList = [];
  List wardList = [];

  String? currentCity;
  String? currentDistric;
  String? currentWard;

  int? currentIndexCity;
  int? currentIndexDistric;
  int? currentIndexWard;

  ListStaffDataModel? staffDataModel;
  List<String> listRole = [
    "Nhân viên phục vụ",
    "Đầu bếp",
    "Trưởng nhóm",
    "Quản lý",
    "Kế toán"
  ];
  List<String> nameListStore = [];
  String? selectedShopId;
  String selectedShopIdInit = '';
  List<String> shopIDList = [];

  File? selectedImage;

  void getDataStaff({
    required String staffNo,
  }) async {
    try {
      var token = StorageUtils.instance.getString(key: 'token_manager');

      final respons = await http.post(
        Uri.parse('$baseUrl$getStaffInforByManager'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          'is_api': true,
          'staff_no': staffNo,
        }),
      );
      final data = jsonDecode(respons.body);
      print(" DATA STAFF INFOR ${data}");
      try {
        if (data['status'] == 200) {
          setState(() {
            staffDataModel = ListStaffDataModel.fromJson(data);
            init();
          });
        } else {
          print("ERROR CREATE FOOOD");
        }
      } catch (error) {
        print("ERROR CREATE $error");
      }
    } catch (error) {
      print("ERROR CREATE $error");
    }
  }

  void init() async {
    var imagePath1 = (staffDataModel?.staff.staffAvatar ??
        'assets/user/images/avt/no_image.png');

    mounted ? currentAvatar = imagePath1 : currentAvatar;

    mounted
        ? fullNameController.text = staffDataModel?.staff.staffFullName ?? ''
        : null;
    mounted
        ? surNameController.text = staffDataModel?.staff.staffFirstName ?? ''
        : null;

    mounted
        ? nameController.text = staffDataModel?.staff.staffLastName ?? ''
        : null;
    mounted
        ? emailController.text = staffDataModel?.staff.staffEmail ?? ''
        : null;
    mounted
        ? phoneController.text = staffDataModel?.staff.staffPhone ?? ''
        : null;
    mounted
        ? address4Controller.text = staffDataModel?.staff.staffAddress4 ?? ''
        : null;
    mounted
        ? twitterTextController.text = staffDataModel?.staff.staffTwitter ?? ''
        : null;
    mounted
        ? facebookTextController.text =
            staffDataModel?.staff.staffFacebook ?? ''
        : null;
    mounted
        ? instagramTextController.text =
            staffDataModel?.staff.staffInstagram ?? ''
        : null;
    // log(staffDataModel?.stores[0].shopId.toString() ?? 'ddd');
    var hehe = staffDataModel?.stores.where((element) {
      log(element.shopId.toString());
      if (element.shopId == staffDataModel?.staff.shopId) {
        log("OKOK");
        setState(() {
          selectedShopIdInit = element.storeName ?? '';
        });
      } else {
        log("COOK");
      }
      return true;
    });
    log(hehe.toString());

    mounted
        ? roleStaffString = staffDataModel?.staff.staffPosition == 1
            ? "Nhân viên phục vụ"
            : staffDataModel?.staff.staffPosition == 2
                ? "Trưởng nhóm"
                : staffDataModel?.staff.staffPosition == 3
                    ? "Quản lý"
                    : staffDataModel?.staff.staffPosition == 4
                        ? "Kế toán"
                        : "Đầu bếp"
        : null;

    getListAreaInit(
        city: staffDataModel?.staff.staffAddress1,
        district: staffDataModel?.staff.staffAddress2);
  }

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
            var myCity = cityListMap[staffDataModel?.staff.staffAddress1];
            currentCity = myCity;
            //get current District
            var districtListMap = districList.asMap();
            var myDistrict =
                districtListMap[staffDataModel?.staff.staffAddress2];
            currentDistric = myDistrict;

            //get Current Ward
            var wardListMap = wardList.asMap();
            var myWard = wardListMap[staffDataModel?.staff.staffAddress4];
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

  void pickImage() async {
    final returndImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returndImage == null) return;
    setState(() {
      selectedImage = File(returndImage.path);
    });
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
        });
      } else {
        print("ERRRO GET LIST STORE 111111");
      }
    } catch (error) {
      print("ERRRO GET LIST STORE $error");
    }
  }

  void handleUpdateInforStaff({
    required String staffNo,
    required String shopID,
    required int staffPosition,
    required String staffFirstName,
    required String staffLastName,
    required String staffFullName,
    required String staffEmail,
    required String staffPhone,
    required int? staffAddress1,
    required int? staffAddress2,
    required int? staffAddress3,
    required String? staffAddress4,
    required String? staffTwitter,
    required String? staffFacebook,
    required String? staffInstagram,
  }) async {
    try {
      var token = StorageUtils.instance.getString(key: 'token_manager');

      final respons = await http.post(
        Uri.parse('$baseUrl$handleEditStaffInforByManager'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          'type': "updateProfile",
          'is_api': true,
          'key': staffNo,
          'data': {
            'shop_id': shopID,
            'position': staffPosition,
            'first_name': staffFirstName,
            'last_name': staffLastName,
            'full_name': staffFullName,
            'email': staffEmail,
            'phone': staffPhone,
            'address_1': staffAddress1,
            'address_2': staffAddress2,
            'address_3': staffAddress3,
            'address_4': staffAddress4,
            'twitter': staffTwitter,
            'facebook': staffFacebook,
            'instagram': staffInstagram,
          }
        }),
      );
      final data = jsonDecode(respons.body);
      print(" DATA CREATE FOOD ${data}");
      try {
        if (data['status'] == 200) {
          // var hahah = DetailsStoreModel.fromJson(data);
          light = false;
          getDataStaff(staffNo: widget.staffNo);
        } else {
          print("ERROR CREATE FOOOD");
        }
      } catch (error) {
        print("ERROR CREATE $error");
      }
    } catch (error) {
      print("ERROR CREATE $error");
    }
  }

  void handleChangeStatusStaff({
    required String staffNo,
  }) async {
    try {
      var token = StorageUtils.instance.getString(key: 'token_manager');

      final respons = await http.post(
        Uri.parse('$baseUrl$updateStatusStaff'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({'is_api': true, 'staff_no': staffNo}),
      );
      final data = jsonDecode(respons.body);
      print(" DATA CREATE FOOD ${data}");
      try {
        if (data['status'] == 200) {
          // var hahah = DetailsStoreModel.fromJson(data);
          light = false;
          getDataStaff(staffNo: widget.staffNo);
        } else {
          print("ERROR CREATE FOOOD");
        }
      } catch (error) {
        print("ERROR CREATE $error");
      }
    } catch (error) {
      print("ERROR CREATE $error");
    }
  }

  @override
  void initState() {
    super.initState();
    getListStore();
    getDataStaff(staffNo: widget.staffNo);
  }

  @override
  Widget build(BuildContext context) {
    // selectedShopId = dd;

    return Scaffold(
      appBar: AppBar(
        title: Text("Thông tin nhân viên"),
      ),
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
                              Container(
                                width: 100.w,
                                height: 100.w,
                                color: const Color.fromRGBO(158, 158, 158, 1),
                                child: CachedNetworkImage(
                                  fit: BoxFit.fill,
                                  imageUrl: httpImage + currentAvatar,
                                  placeholder: (context, url) => SizedBox(
                                    height: 10.w,
                                    width: 10.w,
                                    child: const Center(
                                        child: CircularProgressIndicator()),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                              space25W,
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  TextApp(
                                    text: staffDataModel?.staff.staffFullName ??
                                        '',
                                    fontWeight: FontWeight.bold,
                                    fontsize: 18.sp,
                                  ),
                                  TextApp(
                                    text: staffDataModel?.staff.staffPosition ==
                                            1
                                        ? "Nhân viên phục vụ"
                                        : staffDataModel?.staff.staffPosition ==
                                                2
                                            ? "Trưởng nhóm"
                                            : staffDataModel
                                                        ?.staff.staffPosition ==
                                                    3
                                                ? "Quản lý"
                                                : staffDataModel?.staff
                                                            .staffPosition ==
                                                        4
                                                    ? "Kế toán"
                                                    : "Đầu bếp",
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
                                    space20H,
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
                                                  text:
                                                      " Thuộc cửa hàng cửa hàng",
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
                                                        "Chọn cửa hàng") {
                                                      return canNotNull;
                                                    } else {
                                                      return null;
                                                    }
                                                  },
                                                  items: nameListStore,
                                                  dropdownDecoratorProps:
                                                      DropDownDecoratorProps(
                                                    dropdownSearchDecoration:
                                                        InputDecoration(
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
                                                      isDense: true,
                                                      contentPadding:
                                                          EdgeInsets.all(15.w),
                                                      hintText: "Chọn cửa hàng",
                                                    ),
                                                  ),
                                                  onChanged: (store) {
                                                    selectedShopId = shopIDList
                                                        .indexOf(store ?? '')
                                                        .toString();
                                                    var indexSelected =
                                                        nameListStore.indexOf(
                                                            store ?? '');
                                                    setState(() {
                                                      selectedShopId =
                                                          shopIDList[
                                                              indexSelected];
                                                    });
                                                  },
                                                  selectedItem:
                                                      selectedShopIdInit,
                                                  // selectedItem: "Chọn cửa hàng",
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    space20H,
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
                                                DropdownSearch(
                                                  validator: (value) {
                                                    if (value ==
                                                        "Chọn chức vụ") {
                                                      return canNotNull;
                                                    } else {
                                                      return null;
                                                    }
                                                  },
                                                  items: listRole,
                                                  onChanged: (role) {
                                                    setState(() {
                                                      currentRoleOfStaff =
                                                          listRole.indexOf(
                                                                  role ?? '') +
                                                              1;
                                                      log(currentRoleOfStaff
                                                          .toString());
                                                    });
                                                  },
                                                  dropdownDecoratorProps:
                                                      DropDownDecoratorProps(
                                                    dropdownSearchDecoration:
                                                        InputDecoration(
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
                                                      isDense: true,
                                                      contentPadding:
                                                          EdgeInsets.all(15.w),
                                                      hintText: "Chọn chức vụ",
                                                    ),
                                                  ),
                                                  selectedItem: roleStaffString,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    space20H,
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
                                                  text: " Họ và tên",
                                                  fontsize: 12.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: blueText,
                                                ),
                                                SizedBox(
                                                  height: 10.h,
                                                ),
                                                TextFormField(
                                                  maxLength: 255,
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
                                                  maxLength: 255,
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
                                                            color:
                                                                Color.fromRGBO(
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
                                                  text: " Tên",
                                                  fontsize: 12.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: blueText,
                                                ),
                                                SizedBox(
                                                  height: 10.h,
                                                ),
                                                TextFormField(
                                                  maxLength: 255,
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
                                                    getListArea(
                                                        city: cityList.indexOf(
                                                            changeCity),
                                                        district: null);
                                                    setState(() {
                                                      currentIndexCity =
                                                          cityList.indexOf(
                                                              changeCity);
                                                      currentDistric = null;
                                                      currentIndexDistric =
                                                          null;
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
                                                  key: Key(currentDistric
                                                      .toString()),

                                                  validator: (value) {
                                                    if (value ==
                                                        "Chọn quận/huyện") {
                                                      return canNotNull;
                                                    }
                                                  },

                                                  selectedItem: currentDistric,

                                                  items: districList,
                                                  onChanged: (changeDistric) {
                                                    getListArea(
                                                        city: currentIndexCity ??
                                                            staffDataModel
                                                                ?.staff
                                                                .staffAddress1,
                                                        district:
                                                            districList.indexOf(
                                                                changeDistric));
                                                    setState(() {
                                                      currentIndexDistric =
                                                          districList.indexOf(
                                                              changeDistric);
                                                      currentWard = null;
                                                      currentIndexWard = null;
                                                    });
                                                  },

                                                  dropdownDecoratorProps:
                                                      DropDownDecoratorProps(
                                                    dropdownSearchDecoration:
                                                        InputDecoration(
                                                      hintMaxLines: 1,
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
                                                      isDense: true,
                                                      contentPadding:
                                                          EdgeInsets.all(15.w),
                                                      hintStyle: TextStyle(
                                                          fontSize: 14.sp),
                                                      hintText:
                                                          "Chọn quận/huyện",
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
                                                  key: Key(
                                                      currentWard.toString()),

                                                  validator: (value) {
                                                    if (value ==
                                                        "Chọn phường/xã") {
                                                      return canNotNull;
                                                    }
                                                  },

                                                  selectedItem: currentWard,

                                                  items: wardList,
                                                  onChanged: (changeWard) {
                                                    getListArea(
                                                        city: currentIndexCity,
                                                        district:
                                                            currentIndexDistric);
                                                    setState(() {
                                                      currentIndexWard =
                                                          wardList.indexOf(
                                                              changeWard);
                                                      var wardListMap =
                                                          wardList.asMap();
                                                      var myWard = wardListMap[
                                                          wardList.indexOf(
                                                              changeWard)];
                                                      currentWard = myWard;
                                                    });
                                                  },

                                                  dropdownDecoratorProps:
                                                      DropDownDecoratorProps(
                                                    dropdownSearchDecoration:
                                                        InputDecoration(
                                                      hintMaxLines: 1,
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
                                                      isDense: true,
                                                      contentPadding:
                                                          EdgeInsets.all(15.w),
                                                      hintStyle: TextStyle(
                                                          fontSize: 14.sp),
                                                      hintText:
                                                          "Chọn phường/xã",
                                                    ),
                                                  ),
                                                  // selectedItem:
                                                  //     "Chọn quận/huyện",
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
                                                  maxLength: 255,
                                                  onTapOutside: (event) {
                                                    FocusManager
                                                        .instance.primaryFocus
                                                        ?.unfocus();
                                                  },
                                                  controller:
                                                      address4Controller,
                                                  keyboardType:
                                                      TextInputType.name,
                                                  style: TextStyle(
                                                      fontSize: 12.sp,
                                                      color: grey),
                                                  cursorColor: grey,
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
                                          controller: twitterTextController,
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
                                          controller: facebookTextController,
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
                                          controller: instagramTextController,
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
                                                  print({
                                                    "type": "updateProfile",
                                                    "is_api": true,
                                                    "staff_no": staffDataModel
                                                        ?.staff.staffNo,
                                                    "data": {
                                                      "shop_id": (selectedShopId ==
                                                                  null ||
                                                              selectedShopId ==
                                                                  '')
                                                          ? staffDataModel
                                                              ?.staff.shopId
                                                          : selectedShopId,
                                                      "staff_position":
                                                          currentRoleOfStaff ??
                                                              staffDataModel
                                                                  ?.staff
                                                                  .staffPosition,
                                                      "staff_first_name":
                                                          surNameController
                                                              .text,
                                                      "staff_last_name":
                                                          nameController.text,
                                                      "staff_full_name":
                                                          fullNameController
                                                              .text,
                                                      "staff_email":
                                                          emailController.text,
                                                      "staff_phone":
                                                          phoneController.text,
                                                      "staff_address_1":
                                                          currentIndexCity,
                                                      "staff_address_2":
                                                          currentIndexDistric,
                                                      "staff_address_3":
                                                          currentIndexWard,
                                                      "staff_address_4":
                                                          address4Controller
                                                                      .text ==
                                                                  ''
                                                              ? null
                                                              : address4Controller
                                                                  .text,
                                                      "staff_twitter":
                                                          twitterTextController
                                                                      .text ==
                                                                  ''
                                                              ? null
                                                              : twitterTextController
                                                                  .text,
                                                      "staff_facebook":
                                                          facebookTextController
                                                                      .text ==
                                                                  ''
                                                              ? null
                                                              : facebookTextController
                                                                  .text,
                                                      "staff_instagram":
                                                          instagramTextController
                                                                      .text ==
                                                                  ''
                                                              ? null
                                                              : instagramTextController
                                                                  .text,
                                                    }
                                                  });
                                                  handleUpdateInforStaff(
                                                    staffNo: staffDataModel
                                                            ?.staff.staffNo
                                                            .toString() ??
                                                        '',
                                                    shopID: ((selectedShopId ==
                                                                    null ||
                                                                selectedShopId ==
                                                                    '')
                                                            ? staffDataModel
                                                                ?.staff.shopId
                                                            : selectedShopId) ??
                                                        '',
                                                    staffPosition:
                                                        (currentRoleOfStaff ??
                                                                staffDataModel
                                                                    ?.staff
                                                                    .staffPosition) ??
                                                            1,
                                                    staffFirstName:
                                                        surNameController.text,
                                                    staffLastName:
                                                        nameController.text,
                                                    staffFullName:
                                                        fullNameController.text,
                                                    staffEmail:
                                                        emailController.text,
                                                    staffPhone:
                                                        phoneController.text,
                                                    staffAddress1:
                                                        currentIndexCity,
                                                    staffAddress2:
                                                        currentIndexDistric,
                                                    staffAddress3:
                                                        currentIndexWard,
                                                    staffAddress4:
                                                        address4Controller
                                                                    .text ==
                                                                ''
                                                            ? null
                                                            : address4Controller
                                                                .text,
                                                    staffTwitter:
                                                        twitterTextController
                                                                    .text ==
                                                                ''
                                                            ? null
                                                            : twitterTextController
                                                                .text,
                                                    staffFacebook:
                                                        facebookTextController
                                                                    .text ==
                                                                ''
                                                            ? null
                                                            : facebookTextController
                                                                .text,
                                                    staffInstagram:
                                                        instagramTextController
                                                                    .text ==
                                                                ''
                                                            ? null
                                                            : instagramTextController
                                                                .text,
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
                                      controller: currentPassworldController,
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
                                            currentPassworldController.text) {
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
                                            });
                                            currentPassworldController.clear();
                                            newPassworldController.clear();
                                            reNewPassworldController.clear();
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
//Status Account

                  Padding(
                    padding:
                        EdgeInsets.only(top: 20.h, left: 10.w, right: 10.w),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Trạng thái tài khoản",
                                style: TextStyle(
                                  color: const Color.fromRGBO(52, 71, 103, 1),
                                  fontFamily: "Icomoon",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24.sp,
                                ),
                              ),
                              space10H,
                              TextApp(
                                text: lockAccountDes,
                                color: blueText,
                                fontsize: 12.sp,
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 50.w,
                                        height: 30.w,
                                        child: FittedBox(
                                          fit: BoxFit.fill,
                                          child: CupertinoSwitch(
                                            value: light,
                                            activeColor: const Color.fromRGBO(
                                                58, 65, 111, .95),
                                            onChanged: (bool value) {
                                              setState(() {
                                                light = value;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                      space20W,
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          TextApp(
                                              text: "Xác nhận",
                                              fontsize: 12.sp,
                                              fontWeight: FontWeight.bold,
                                              color: blueText),
                                          TextApp(
                                            text: youWantToFixAccountStatus,
                                            fontsize: 12.sp,
                                          ),
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                              space20H,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 200.w,
                                    child: ButtonGradient(
                                      color1:
                                          staffDataModel?.staff.activeFlg == 0
                                              ? color1BlueButton
                                              : organe,
                                      color2:
                                          staffDataModel?.staff.activeFlg == 0
                                              ? color2BlueButton
                                              : yellow,
                                      event: () {
                                        light
                                            ? showConfirmDialog(context, () {
                                                handleChangeStatusStaff(
                                                    staffNo: staffDataModel
                                                            ?.staff.staffNo
                                                            .toString() ??
                                                        '');
                                              })
                                            : showCustomDialogModal(
                                                context: context,
                                                textDesc:
                                                    "Sau khi bạn xác nhận sẽ thay đổi trạng thái",
                                                title:
                                                    "Bạn phải đồng ý để thực hiện tác vụ này",
                                                colorButton: Colors.blue,
                                                btnText: "OK",
                                                typeDialog: "info");
                                      },
                                      text: staffDataModel?.staff.activeFlg == 0
                                          ? "Bỏ chặn tài khoản"
                                          : "Chặn tài khoản",
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
                  space20H,

                  const CopyRightText(),
                  space35H,
                ],
              ))),
    );
  }
}
