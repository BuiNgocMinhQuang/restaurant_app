import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/config/text.dart';
import 'package:app_restaurant/model/manager/manager_list_store_model.dart';
import 'package:app_restaurant/routers/app_router_config.dart';
import 'package:app_restaurant/utils/storage.dart';
import 'package:app_restaurant/widgets/button/button_gradient.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:app_restaurant/env/index.dart';
import 'package:app_restaurant/constant/api/index.dart';
import 'package:intl/intl.dart';
import 'package:app_restaurant/config/void_show_dialog.dart';
import 'dart:math' as math;

import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ManagerAddFood extends StatefulWidget {
  final List<DataListStore> listStores;
  const ManagerAddFood({Key? key, required this.listStores}) : super(key: key);

  @override
  State<ManagerAddFood> createState() => _ManagerAddFoodState();
}

class _ManagerAddFoodState extends State<ManagerAddFood> {
  bool isShowListStores = false;
  bool isShowListRoles = false;
  bool passwordVisible = true;
  bool rePasswordVisible = true;
  int? currentFoodKind;
  int? currentStoreId;
  bool light = false;
  String priceFoodString = '';
  List<String> listImageFood = [];
  List<int> listStoreId = [];
  List<dynamic>? listStoreString = [];
  String priceFoodNumber = '0';
  List<File>? imageFileList = [];

  List<String> categories2 = [
    "Combo",
    "Món nướng",
    "Món lẩu",
    "Nước giải khát"
  ];
  final _formField = GlobalKey<FormState>();
  final foodNameController = TextEditingController();
  final priceOfFood = TextEditingController();
  final noteController = TextEditingController();
  final listStoreTextController = TextEditingController();
  final listFoodTypeTextController = TextEditingController();
  final ImagePicker imagePicker = ImagePicker();
  final List<String> nameStoreList = [];
  final List<int> listStoreIdInIt = [];

  final Set<int> selectedStoreIndices = {};

  void updateSelectedStores() {
    mounted
        ? setState(() {
            final selectedStores = selectedStoreIndices
                .map((index) => nameStoreList[index])
                .toList();
            listStoreTextController.text = selectedStores.join(', ');
          })
        : null;
  }

  static const _locale = 'en';
  String _formatNumber(String s) =>
      NumberFormat.decimalPattern(_locale).format(int.parse(s));

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  void dispose() {
    foodNameController.dispose();
    priceOfFood.dispose();
    noteController.dispose();
    listStoreTextController.dispose();
    listFoodTypeTextController.dispose();
    listStoreId.clear();
    selectedStoreIndices.clear();
    super.dispose();
  }

  void init() {
    for (var i = 0; i < widget.listStores.length; i++) {
      nameStoreList.add(widget.listStores[i].storeName ?? '');
      listStoreIdInIt.add(widget.listStores[i].storeId ?? 0);
    }
  }

  void pickImage() async {
    final returndImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returndImage == null) return;
    setState(() {
      var pathImage = File(returndImage.path);
      imageFileList!.add(pathImage);
      Uint8List imagebytes = pathImage.readAsBytesSync(); //convert to bytes
      String base64string = base64Encode(imagebytes);
      listImageFood.add(base64string);
    });
    // openImage();
  }

  void deleteImages(data) {
    imageFileList!.remove(data);
    setState(() {});
  }

  void handleCreateFood({
    required List<int> listStore,
    required String foodName,
    required String desText,
    required int foodKind,
    required String foodPrice,
    required int activeFlag,
    required List<String> images,
  }) async {
    try {
      var token = StorageUtils.instance.getString(key: 'token_manager');

      final respons = await http.post(
        Uri.parse('$baseUrl$createFood'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          'stores': listStore,
          'food_name': foodName,
          'food_kind': foodKind,
          'description': desText,
          'food_price': int.parse(priceFoodNumber),
          'active_flg': activeFlag,
          'is_api': true,
          'images': images
        }),
      );
      final data = jsonDecode(respons.body);

      try {
        if (data['status'] == 200) {
          showCustomDialogModal(
            typeDialog: "succes",
            context: navigatorKey.currentContext,
            textDesc: "Thêm món thành công",
            title: "Thành công",
            colorButton: Colors.green,
            btnText: "OK",
          );
          mounted
              ? setState(() {
                  foodNameController.clear();
                  priceOfFood.clear();
                  noteController.clear();
                  imageFileList?.clear();
                  listStoreId.clear();
                  listStoreString = null;
                  listStoreTextController.clear();
                  listFoodTypeTextController.clear();
                  light = false;
                })
              : null;
        } else {
          log("ERROR handleCreateFood 1");
          showCustomDialogModal(
              context: navigatorKey.currentContext,
              textDesc: "Có lỗi xảy ra",
              title: "Thất bại",
              colorButton: Colors.red,
              btnText: "OK",
              typeDialog: "error");
        }
      } catch (error) {
        log("ERROR handleCreateFood 2 $error");
        showCustomDialogModal(
            context: navigatorKey.currentContext,
            textDesc: "Có lỗi xảy ra",
            title: "Thất bại",
            colorButton: Colors.red,
            btnText: "OK",
            typeDialog: "error");
      }
    } catch (error) {
      log("ERROR handleCreateFood 3 $error");
      showCustomDialogModal(
          context: navigatorKey.currentContext,
          textDesc: "Có lỗi xảy ra",
          title: "Thất bại",
          colorButton: Colors.red,
          btnText: "OK",
          typeDialog: "error");
    }
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
              padding: EdgeInsets.all(0.w),
              child: Column(
                children: [
                  Container(
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
                                // boxShadow: [
                                //   BoxShadow(
                                //     color: Colors.grey.withOpacity(0.5),
                                //     spreadRadius: 5,
                                //     blurRadius: 7,
                                //     offset: const Offset(
                                //         0, 3), // changes position of shadow
                                //   ),
                                // ],
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(20.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextApp(
                                      text: foodInfor,
                                      color:
                                          const Color.fromRGBO(52, 71, 103, 1),
                                      fontFamily: "OpenSans",
                                      fontWeight: FontWeight.bold,
                                      fontsize: 20.sp,
                                    ),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextApp(
                                          text: foodName,
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
                                          controller: foodNameController,
                                          style: TextStyle(
                                              fontSize: 14.sp,
                                              color: Colors.black),
                                          cursorColor: grey,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return canNotNull;
                                            } else if (value.length > 32) {
                                              return "Độ dài tối đa 32 kí tự";
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
                                              hintText: foodName,
                                              hintStyle: TextStyle(
                                                  fontSize: 14.sp, color: grey),
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
                                          text: " $type",
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
                                                  topRight:
                                                      Radius.circular(15.r),
                                                  topLeft:
                                                      Radius.circular(15.r),
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
                                                        text: "Chọn loại",
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
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 10.w),
                                                        itemCount:
                                                            categories2.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return Column(
                                                            children: [
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left: 20
                                                                            .w),
                                                                child: InkWell(
                                                                  onTap:
                                                                      () async {
                                                                    Navigator.pop(
                                                                        context);

                                                                    currentFoodKind =
                                                                        index;
                                                                    listFoodTypeTextController
                                                                            .text =
                                                                        categories2[
                                                                            index];
                                                                  },
                                                                  child: Row(
                                                                    children: [
                                                                      TextApp(
                                                                        text: categories2[
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
                                          controller:
                                              listFoodTypeTextController,
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
                                              hintText: chooseType,
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
                                        )
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
                                          text: " Giá món ăn",
                                          fontsize: 14.sp,
                                          fontWeight: FontWeight.bold,
                                          color: blueText,
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        TextFormField(
                                          keyboardType: TextInputType.number,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter.allow(
                                                RegExp("[0-9]")),
                                          ], // Only numbers can be entered,
                                          onTapOutside: (event) {
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                          },
                                          controller: priceOfFood,
                                          onChanged: (string) {
                                            priceFoodString = string;
                                            if (string.isNotEmpty) {
                                              string = _formatNumber(
                                                  string.replaceAll(',', ''));
                                              priceFoodNumber =
                                                  priceOfFood.text;
                                              priceOfFood.value =
                                                  TextEditingValue(
                                                text: string,
                                                selection:
                                                    TextSelection.collapsed(
                                                        offset: string.length),
                                              );
                                            }
                                          },
                                          style: TextStyle(
                                              fontSize: 14.sp,
                                              color: Colors.black),
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
                                              hintText: 'Giá món ăn',
                                              hintStyle: TextStyle(
                                                  fontSize: 14.sp, color: grey),
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
                                          text: " Cửa hàng",
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
                                                  topRight:
                                                      Radius.circular(15.r),
                                                  topLeft:
                                                      Radius.circular(15.r),
                                                ),
                                              ),
                                              clipBehavior:
                                                  Clip.antiAliasWithSaveLayer,
                                              context: context,
                                              builder: (context) =>
                                                  StatefulBuilder(builder:
                                                      (BuildContext context,
                                                          StateSetter
                                                              setModalState) {
                                                return SizedBox(
                                                  height: 1.sh / 2,
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        width: 1.sw,
                                                        padding: EdgeInsets.all(
                                                            20.w),
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary,
                                                        child: TextApp(
                                                          text: "Chọn cửa hàng",
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
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 10.w),
                                                          itemCount:
                                                              nameStoreList
                                                                  .length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            final isSelected =
                                                                selectedStoreIndices
                                                                    .contains(
                                                                        index);
                                                            return Column(
                                                              children: [
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              20.w),
                                                                  child:
                                                                      InkWell(
                                                                    onTap: () {
                                                                      setModalState(
                                                                          () {
                                                                        if (isSelected) {
                                                                          selectedStoreIndices
                                                                              .remove(index);
                                                                          listStoreId
                                                                              .remove(index);
                                                                        } else {
                                                                          selectedStoreIndices
                                                                              .add(index);
                                                                          listStoreId
                                                                              .add(index);
                                                                        }
                                                                      });
                                                                      updateSelectedStores();
                                                                    },
                                                                    child: Row(
                                                                      children: [
                                                                        Icon(
                                                                          isSelected
                                                                              ? Icons.check_box
                                                                              : Icons.check_box_outline_blank,
                                                                          size:
                                                                              35.sp,
                                                                        ),
                                                                        SizedBox(
                                                                            width:
                                                                                10.w),
                                                                        TextApp(
                                                                          text:
                                                                              nameStoreList[index],
                                                                          color:
                                                                              Colors.black,
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
                                                );
                                              }),
                                            );
                                          },
                                          validator: (value) {
                                            if (listStoreId.isEmpty) {
                                              return canNotNull;
                                            }
                                            return null;
                                          },
                                          controller: listStoreTextController,
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
                                              hintText: "Chọn cửa hàng",
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
                                        SizedBox(
                                          height: 20.h,
                                        ),
                                        TextApp(
                                          text: "Chế độ hiển thị",
                                          fontsize: 14.sp,
                                          fontWeight: FontWeight.bold,
                                          color: blueText,
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        SizedBox(
                                          width: 1.sw,
                                          child: TextApp(
                                            isOverFlow: false,
                                            softWrap: true,
                                            text: allowFoodReady,
                                            fontsize: 14.sp,
                                            fontWeight: FontWeight.normal,
                                            color: blueText,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
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
                                                mounted
                                                    ? setState(() {
                                                        light = value;
                                                      })
                                                    : null;
                                              },
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20.h,
                                        ),
                                        TextApp(
                                          text: createFoodInEachYourStore,
                                          fontsize: 14.sp,
                                          fontWeight: FontWeight.normal,
                                          color: blueText,
                                        ),
                                        SizedBox(
                                          height: 10.h,
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
                                          text: " Mô tả",
                                          fontsize: 14.sp,
                                          fontWeight: FontWeight.bold,
                                          color: blueText,
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        TextFormField(
                                          style: TextStyle(
                                              fontSize: 14.sp,
                                              color: Colors.black),
                                          onTapOutside: (event) {
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                          },
                                          validator: (value) {
                                            if (value!.length < 255) {
                                              return "Độ dài tối đa 255 kí tự";
                                            } else {
                                              return null;
                                            }
                                          },
                                          controller: noteController,
                                          keyboardType: TextInputType.multiline,
                                          minLines: 1,
                                          maxLines: 3,
                                          cursorColor: const Color.fromRGBO(
                                              73, 80, 87, 1),
                                          decoration: InputDecoration(
                                              fillColor: const Color.fromARGB(
                                                  255, 226, 104, 159),
                                              focusedBorder:
                                                  const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color.fromRGBO(
                                                        214, 51, 123, 0.6),
                                                    width: 2.0),
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                              ),
                                              hintText: '',
                                              hintStyle: TextStyle(
                                                  fontSize: 14.sp, color: grey),
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
                                          text: " $foodImage",
                                          color: blueText,
                                          fontFamily: "OpenSans",
                                          fontWeight: FontWeight.bold,
                                          fontsize: 14.sp,
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15.r),
                                              ),
                                              backgroundColor: Colors.white,
                                              side: const BorderSide(
                                                  color: Colors.grey,
                                                  width: 1), //
                                            ),
                                            onPressed: () {
                                              pickImage();
                                            },
                                            child: imageFileList!.isEmpty
                                                ? SizedBox(
                                                    width: double.infinity,
                                                    height: 200.h,
                                                    // color: Colors.red,
                                                    child: Center(
                                                      child: TextApp(
                                                        text: addPictureHere,
                                                        fontsize: 14.sp,
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  )
                                                : SizedBox(
                                                    width: double.infinity,
                                                    child: GridView.builder(
                                                        physics:
                                                            const NeverScrollableScrollPhysics(),
                                                        shrinkWrap: true,
                                                        itemCount:
                                                            imageFileList!
                                                                .length,
                                                        gridDelegate:
                                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                                                crossAxisCount:
                                                                    2),
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          return Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              SizedBox(
                                                                  width: 100.w,
                                                                  height: 100.w,
                                                                  child:
                                                                      ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            15.w),
                                                                    child: Image
                                                                        .file(
                                                                      File(imageFileList![
                                                                              index]
                                                                          .path),
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  )),
                                                              SizedBox(
                                                                height: 10.h,
                                                              ),
                                                              InkWell(
                                                                onTap: () {
                                                                  deleteImages(
                                                                      imageFileList![
                                                                          index]);
                                                                },
                                                                child: TextApp(
                                                                  text:
                                                                      deleteImage,
                                                                  color: Colors
                                                                      .blue,
                                                                ),
                                                              )
                                                            ],
                                                          );
                                                        }),
                                                  )),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SizedBox(
                                          width: 100.w,
                                          child: ButtonGradient(
                                            color1: color1DarkButton,
                                            color2: color2DarkButton,
                                            event: () {
                                              if (_formField.currentState!
                                                  .validate()) {
                                                if (imageFileList != null &&
                                                    imageFileList!.isNotEmpty) {
                                                  handleCreateFood(
                                                      listStore: listStoreId,
                                                      foodName:
                                                          foodNameController
                                                              .text,
                                                      foodKind:
                                                          currentFoodKind!,
                                                      foodPrice:
                                                          priceFoodNumber,
                                                      desText:
                                                          noteController.text,
                                                      activeFlag:
                                                          light == true ? 1 : 0,
                                                      images: listImageFood);
                                                } else {
                                                  showCustomDialogModal(
                                                      context: navigatorKey
                                                          .currentContext,
                                                      textDesc:
                                                          "Bạn cần ít nhất một ảnh cho món ăn",
                                                      title: "Thất bại",
                                                      colorButton: Colors.red,
                                                      btnText: "OK",
                                                      typeDialog: "error");
                                                }
                                              }
                                            },
                                            text: next,
                                            fontSize: 14.sp,
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
                  )
                ],
              ),
            )),
          ),
        ],
      ),
    );
  }
}
