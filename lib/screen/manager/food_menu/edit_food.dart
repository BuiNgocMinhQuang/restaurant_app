import 'dart:convert';
import 'dart:io';
import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/config/fake_data.dart';
import 'package:app_restaurant/config/space.dart';
import 'package:app_restaurant/config/text.dart';
import 'package:app_restaurant/config/void_show_dialog.dart';
import 'package:app_restaurant/routers/app_router_config.dart';
import 'package:app_restaurant/utils/storage.dart';
import 'package:app_restaurant/widgets/button/button_gradient.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:app_restaurant/model/manager/manager_list_store_model.dart';
import 'package:http/http.dart' as http;
import 'package:app_restaurant/env/index.dart';
import 'package:app_restaurant/constant/api/index.dart';
import 'package:intl/intl.dart';
import 'package:app_restaurant/model/manager/food/details_food_model.dart';
import 'package:quill_html_editor/quill_html_editor.dart';

class EditFood extends StatefulWidget {
  final List<DataListStore> listStores;
  final DetailsFoodModel? detailsDataFood;
  const EditFood({
    Key? key,
    required this.listStores,
    required this.detailsDataFood,
  }) : super(key: key);

  @override
  State<EditFood> createState() => _EditFoodState();
}

class _EditFoodState extends State<EditFood> {
  bool light = false;

  final _formField = GlobalKey<FormState>();
  final priceOfFood = TextEditingController();
  final foodNameController = TextEditingController();
  final desTextController = TextEditingController();
  final _popupCustomValidationKey1 = GlobalKey<DropdownSearchState<int>>();
  final _popupCustomValidationKey2 =
      GlobalKey<DropdownSearchState<List<String>>>();
  final ImagePicker imagePicker = ImagePicker();
  String priceFoodNumber = '0';
  List<String> listImageFood = [];
  List<String> listStoreName = [];
  List<String> listFoodKind = [];
  List<FoodImage> listDataImage = [];
  List<dynamic> listDynamicImage = [];
  int? currentFoodKind;
  int? currentStoreID;
  String? currentStoreText;
  String? currentFoodKindText;
  String priceFoodString = '';
  static const _locale = 'en';
  String _formatNumber(String s) =>
      NumberFormat.decimalPattern(_locale).format(int.parse(s));

  @override
  void dispose() {
    super.dispose();
    listStoreName.clear();
  }

  void init() async {
    mounted
        ? priceOfFood.text =
            '${_formatNumber((widget.detailsDataFood?.food.foodPrice.toString() ?? '').replaceAll(',', ''))}'
        : null;
    mounted
        ? foodNameController.text = widget.detailsDataFood?.food.foodName ?? ''
        : null;
    mounted
        ? desTextController.text =
            widget.detailsDataFood?.food.foodDescription ?? ''
        : null;
    mounted
        ? widget.detailsDataFood?.food.activeFlg == 1
            ? light = true
            : light = false
        : null;
    mounted
        ? currentStoreText = widget.detailsDataFood?.food.storeName ?? ''
        : null;
    var foodKindMap = widget.detailsDataFood?.foodKinds.asMap();
    var myFoodKind = foodKindMap?[widget.detailsDataFood?.food.foodKind];
    mounted ? currentFoodKindText = myFoodKind ?? '' : null;
    mounted
        ? listDataImage = widget.detailsDataFood?.food.foodImages ?? []
        : null;

    mounted ? currentStoreID = widget.detailsDataFood?.food.storeId : null;
    mounted ? currentFoodKind = widget.detailsDataFood?.food.foodKind : null;
    mounted
        ? priceFoodNumber =
            widget.detailsDataFood?.food.foodPrice.toString() ?? ''
        : null;

    mounted
        ? widget.detailsDataFood?.food.foodImages.where((element) {
              var heheh = element.path;
              listDynamicImage.add(heheh ?? '');
              return true;
            }).toList() ??
            []
        : null;
    listDataImage.where((element) {
      if (element.name != null) {
        listImageFood.add(element.normal!);
      } else {
        return false;
      }
      return true;
    }).toList();
  }

  void pickImage() async {
    final returndImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returndImage == null) return;
    setState(() {
      var pathImage = File(returndImage.path);

      listDynamicImage.add(pathImage);

      if (pathImage != null) {
        Uint8List imagebytes = pathImage.readAsBytesSync(); //convert to bytes
        String base64string = base64Encode(imagebytes);
        listImageFood.add(base64string);
      }
    });
  }

  void deleteImages(data) {
    listDynamicImage.remove(data);
    listImageFood.remove(data);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  void handleEditFood({
    required String foodID,
    required int listStore,
    required String foodName,
    required String foodPrice,
    required int activeFlag,
    required List<String> images,
    required String desText,
    required int foodKind,
  }) async {
    try {
      var token = StorageUtils.instance.getString(key: 'token_manager');

      final respons = await http.post(
        Uri.parse('$baseUrl$editFood'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          'store': currentStoreID,
          'food_id': foodID,
          'images': images,
          'food_name': foodName,
          'food_kind': foodKind,
          'description': desText,
          'food_price': int.parse(priceFoodNumber),
          'active_flg': activeFlag,
          'is_api': true,
        }),
      );
      final data = jsonDecode(respons.body);
      print("GET DATA LIST FOOD ${data}");
      try {
        if (data['status'] == 200) {
          // Navigator.of(navigatorKey.currentContext!).pop();
          Navigator.pop(navigatorKey.currentContext!);
          Future.delayed(Duration(milliseconds: 300), () {
            showCustomDialogModal(
              typeDialog: "succes",
              context: navigatorKey.currentContext,
              textDesc: "Cập nhật món thành công",
              title: "Thành công",
              colorButton: Colors.green,
              btnText: "OK",
            );
          });
        } else {
          print("ERROR LIST FOOOD RECEIPT PAGE 1");
          showCustomDialogModal(
              context: navigatorKey.currentContext,
              textDesc: "Có lỗi xảy ra",
              title: "Thất bại",
              colorButton: Colors.red,
              btnText: "OK",
              typeDialog: "error");
        }
      } catch (error) {
        print("ERROR BROUGHT RECEIPT PAGE 2 $error");
        showCustomDialogModal(
            context: navigatorKey.currentContext,
            textDesc: "Có lỗi xảy ra",
            title: "Thất bại",
            colorButton: Colors.red,
            btnText: "OK",
            typeDialog: "error");
      }
    } catch (error) {
      print("ERROR BROUGHT RECEIPT PAGE 3 $error");
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
    widget.listStores.where((element) {
      setState(() {
        listStoreName.add(element.storeName ?? '');
      });
      return true;
    }).toList();
    // log("NEW LISSTTTTt");

    // log(listDynamicImage.toString());

    return Scaffold(
      appBar: AppBar(
        title: Text("Chỉnh sửa món ăn"),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
              child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextApp(
              text: "Thực hiện các thay đổi bên dưới",
              fontsize: 20.sp,
              color: blueText,
              fontWeight: FontWeight.bold,
            ),
            space10H,
            TextApp(
              text: "Khi bạn nhấn lưu thì không thể trở lại!",
              fontsize: 16.sp,
              color: Colors.grey,
            ),
            space30H,
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
                              TextApp(
                                text: "Giá tiền",
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
                                    text: " Giá món ăn",
                                    fontsize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                    color: blueText,
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  TextFormField(
                                    controller: priceOfFood,
                                    keyboardType: TextInputType.number,
                                    onChanged: (string) {
                                      priceFoodString = string;
                                      if (string.isNotEmpty) {
                                        string =
                                            '${_formatNumber(string.replaceAll(',', ''))}';
                                        priceFoodNumber = priceOfFood.text;
                                        priceOfFood.value = TextEditingValue(
                                          text: string,
                                          selection: TextSelection.collapsed(
                                              offset: string.length),
                                        );
                                      }
                                    },
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.allow(
                                          RegExp("[0-9]")),
                                    ], // Only numbers can be entered,
                                    onTapOutside: (event) {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                    },
                                    style:
                                        TextStyle(fontSize: 14.sp, color: grey),
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
                                        isDense: true,
                                        contentPadding: EdgeInsets.all(15.w)),
                                  ),
                                ],
                              ),
                              space20H,
                              SizedBox(
                                width: 1.sw,
                                child: TextApp(
                                  isOverFlow: false,
                                  softWrap: true,
                                  text: notChangeFoodtoStore,
                                  fontsize: 12.sp,
                                  fontWeight: FontWeight.normal,
                                  color: blueText,
                                ),
                              ),
                              space10H,
                              TextApp(
                                text: " Cửa hàng",
                                fontsize: 12.sp,
                                fontWeight: FontWeight.bold,
                                color: blueText,
                              ),
                              space10H,
                              SizedBox(
                                width: 1.sw,
                                // height: 100.h,
                                child: DropdownSearch(
                                  validator: (value) {
                                    if (currentStoreText == null) {
                                      return canNotNull;
                                    }
                                    return null;
                                  },
                                  selectedItem: currentStoreText,
                                  key: _popupCustomValidationKey1,
                                  // itemAsString: (item) => item.storeName,
                                  items: listStoreName,
                                  onChanged: (listSelectedStore) {
                                    var getIndexStore = listStoreName
                                        .indexOf(listSelectedStore.toString());

                                    currentStoreID = widget
                                        .listStores[getIndexStore].storeId;
                                    // log(currentStoreID.toString());
                                  },
                                  dropdownDecoratorProps:
                                      DropDownDecoratorProps(
                                    dropdownSearchDecoration: InputDecoration(
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
                                      contentPadding: EdgeInsets.all(15.w),
                                    ),
                                  ),
                                ),
                              ),
                              space20H,
                              TextApp(
                                text: " Loại",
                                fontsize: 12.sp,
                                fontWeight: FontWeight.bold,
                                color: blueText,
                              ),
                              space10H,
                              SizedBox(
                                width: 1.sw,
                                child: DropdownSearch<String>(
                                  validator: (value) {
                                    if (value == chooseType) {
                                      return canNotNull;
                                    }
                                    return null;
                                  },
                                  key: _popupCustomValidationKey2,
                                  items: categories,
                                  selectedItem: currentFoodKindText,
                                  onChanged: (foodKindIndex) {
                                    currentFoodKind = categories
                                        .indexOf(foodKindIndex.toString());
                                    // log("CURRENT FOOD");
                                    // log(currentFoodKind.toString());
                                  },
                                  dropdownDecoratorProps:
                                      DropDownDecoratorProps(
                                    dropdownSearchDecoration: InputDecoration(
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
                                      contentPadding: EdgeInsets.all(15.w),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                    space50H,
                    Container(
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
                                    TextApp(
                                      text: foodInfor,
                                      color:
                                          const Color.fromRGBO(52, 71, 103, 1),
                                      fontFamily: "OpenSans",
                                      fontWeight: FontWeight.bold,
                                      fontsize: 20.sp,
                                    ),
                                    space20H,
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextApp(
                                          text: foodName,
                                          fontsize: 12.sp,
                                          fontWeight: FontWeight.bold,
                                          color: blueText,
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        TextFormField(
                                          controller: foodNameController,
                                          onTapOutside: (event) {
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                          },
                                          style: TextStyle(
                                              fontSize: 14.sp, color: grey),
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
                                              hintText: foodName,
                                              isDense: true,
                                              contentPadding:
                                                  EdgeInsets.all(15.w)),
                                        ),
                                      ],
                                    ),
                                    space20H,
                                    TextApp(
                                      text: "Chế độ hiển thị",
                                      fontsize: 12.sp,
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
                                        fontsize: 12.sp,
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
                                            setState(() {
                                              light = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    space20H,
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextApp(
                                          text: " Mô tả",
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
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                          },
                                          controller: desTextController,
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
                                              isDense: true,
                                              contentPadding: EdgeInsets.only(
                                                  bottom:
                                                      1.sw > 600 ? 50.w : 40.w,
                                                  top: 0,
                                                  left:
                                                      1.sw > 600 ? 20.w : 15.w,
                                                  right: 1.sw > 600
                                                      ? 20.w
                                                      : 15.w)),
                                        ),
                                      ],
                                    ),
                                    space20H,
                                  ],
                                ),
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            space50H,

            Container(
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
                            TextApp(
                              text: image,
                              color: const Color.fromRGBO(52, 71, 103, 1),
                              fontFamily: "OpenSans",
                              fontWeight: FontWeight.bold,
                              fontsize: 20.sp,
                            ),
                            space10H,
                            space20H,
                            TextApp(
                              text: foodImage,
                              color: blueText,
                              fontFamily: "OpenSans",
                              fontWeight: FontWeight.bold,
                              fontsize: 14.sp,
                            ),
                            space10H,
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.r),
                                ),
                                backgroundColor: Colors.white,
                                side: const BorderSide(
                                    color: Colors.grey, width: 1), //
                              ),
                              onPressed: () {
                                // selectImages();
                                listDynamicImage.length >= 3
                                    ? showCustomDialogModal(
                                        context: navigatorKey.currentContext,
                                        textDesc: "Số ảnh tối đa là 3",
                                        title: "Thất bại",
                                        colorButton: Colors.red,
                                        btnText: "OK",
                                        typeDialog: "error")
                                    : pickImage();
                              },
                              child: listDataImage.isEmpty
                                  ? SizedBox(
                                      width: double.infinity,
                                      height: 200.h,
                                      // color: Colors.red,
                                      child: Center(
                                        child: TextApp(
                                          text: addPictureHere,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    )
                                  : SizedBox(
                                      width: double.infinity,
                                      child: GridView.builder(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: listDynamicImage.length,
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 2),
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            if (listDynamicImage[index]
                                                    .toString()
                                                    .length >
                                                150) {
                                              return Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    width: 100.w,
                                                    height: 100.w,
                                                    child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15.w),
                                                        child: Image.file(
                                                          listDynamicImage[
                                                              index],
                                                          fit: BoxFit.cover,
                                                        )),
                                                  ),
                                                  space10H,
                                                  InkWell(
                                                    onTap: () {
                                                      deleteImages(
                                                          listDynamicImage[
                                                              index]);
                                                      deleteImages(
                                                          listImageFood[index]);
                                                    },
                                                    child: TextApp(
                                                      text: deleteImage,
                                                      color: Colors.blue,
                                                    ),
                                                  )
                                                ],
                                              );
                                            } else {
                                              return Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    width: 100.w,
                                                    height: 100.w,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.w),
                                                      child: CachedNetworkImage(
                                                        fit: BoxFit.fill,
                                                        imageUrl:
                                                            listDynamicImage[
                                                                    index] ??
                                                                '',
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
                                                  ),
                                                  space10H,
                                                  InkWell(
                                                    onTap: () {
                                                      deleteImages(
                                                          listDynamicImage[
                                                              index]);
                                                      deleteImages(
                                                          listImageFood[index]);
                                                    },
                                                    child: TextApp(
                                                      text: deleteImage,
                                                      color: Colors.blue,
                                                    ),
                                                  )
                                                ],
                                              );
                                            }
                                          }),
                                    ),
                            ),
                            space20H,
                          ],
                        ),
                      )),
                ],
              ),
            ),

            //FORM 4
            space15H,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 100.w,
                  child: ButtonGradient(
                    radius: 8.r,
                    color1: pupple,
                    color2: red,
                    event: () {
                      if (_formField.currentState!.validate()) {
                        if (listImageFood.isNotEmpty) {
                          handleEditFood(
                              foodID: widget.detailsDataFood?.food.foodId
                                      .toString() ??
                                  '',
                              listStore: currentStoreID!,
                              foodName: foodNameController.text,
                              foodPrice: priceFoodNumber,
                              activeFlag: light == true ? 1 : 0,
                              images: listImageFood,
                              desText: desTextController.text,
                              foodKind: currentFoodKind!);
                        } else {
                          showCustomDialogModal(
                              context: navigatorKey.currentContext,
                              textDesc: "Bạn cần ít nhất một ảnh cho món ăn",
                              title: "Thất bại",
                              colorButton: Colors.red,
                              btnText: "OK",
                              typeDialog: "error");
                        }
                      }
                    },
                    text: save,
                    textColor: Colors.white,
                    fontSize: 14.sp,
                  ),
                )
              ],
            ),
          ],
        ),
      ))),
    );
  }
}
