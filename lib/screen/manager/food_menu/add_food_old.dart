import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/config/fake_data.dart';
import 'package:app_restaurant/config/space.dart';
import 'package:app_restaurant/config/text.dart';
import 'package:app_restaurant/routers/app_router_config.dart';
import 'package:app_restaurant/utils/storage.dart';
import 'package:app_restaurant/widgets/button/button_gradient.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:app_restaurant/env/index.dart';
import 'package:app_restaurant/constant/api/index.dart';
import 'package:app_restaurant/config/void_show_dialog.dart';

class ManagerAddFoodOld extends StatefulWidget {
  const ManagerAddFoodOld({super.key});

  @override
  State<ManagerAddFoodOld> createState() => _ManagerAddFoodState();
}

class _ManagerAddFoodState extends State<ManagerAddFoodOld> {
  bool isShowListStores = false;
  bool isShowListRoles = false;
  bool passwordVisible = true;
  bool rePasswordVisible = true;
  int currentSection = 1;
  int? currentFoodKind;
  bool light = false;
  final _popupCustomValidationKey = GlobalKey<DropdownSearchState<int>>();
  final _formField = GlobalKey<FormState>();
  final _formField2 = GlobalKey<FormState>();
  final foodNameController = TextEditingController();
  final priceOfFood = TextEditingController();
  final ImagePicker imagePicker = ImagePicker();
  final QuillController _controllerQuill = QuillController.basic();
  final QuillController _controllerQuill2 = QuillController.basic();
  List<XFile>? imageFileList = [];
  @override
  void dispose() {
    super.dispose();
    _controllerQuill.clear();
    _controllerQuill2.clear();
  }

  void selectImages() async {
    final List<XFile> selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages.isNotEmpty) {
      imageFileList!.addAll(selectedImages);
    }
    setState(() {});
  } //selecte multi image

  void deleteImages(data) {
    imageFileList!.remove(data);
    setState(() {});
  }

  void handleCreateFood({
    required List<int> listStore,
    required String foodName,
    required int foodKind,
    required String foodPrice,
    required int activeFlag,
  }) async {
    print({
      'stores': listStore,
      'food_name': foodName,
      'food_kind': foodKind,
      'food_price': foodPrice,
      'active_flg': activeFlag,
      'is_api': true
    });
    // try {
    //   var token = StorageUtils.instance.getString(key: 'token_manager');

    //   final respons = await http.post(
    //     Uri.parse('$baseUrl$createFood'),
    //     headers: {
    //       'Content-type': 'application/json',
    //       'Accept': 'application/json',
    //       'Authorization': 'Bearer $token'
    //     },
    //     body: jsonEncode({
    //       'stores': listStore,
    //       'food_name': foodName,
    //       'food_kind': foodKind,
    //       'food_price': foodPrice,
    //       'active_flg': activeFlag,
    //       'is_api': true
    //     }),
    //   );
    //   final data = jsonDecode(respons.body);
    //   print(" DATA CREATE FOOD ${data}");
    //   try {
    //     if (data['status'] == 200) {
    //     } else {
    //       print("ERROR CREATE FOOOD");
    //     }
    //   } catch (error) {
    //     print("ERROR CREATE $error");
    //   }
    // } catch (error) {
    //   print("ERROR CREATE $error");
    // }
  }

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
                            text: foodInfor,
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
                                    hintText: foodName,
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
                                text: type,
                                fontsize: 12.sp,
                                fontWeight: FontWeight.bold,
                                color: blueText,
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              DropdownSearch(
                                validator: (value) {
                                  if (value == chooseType) {
                                    return canNotNull;
                                  }
                                  return null;
                                },
                                onChanged: (foodKindIndex) {
                                  currentFoodKind =
                                      categories.indexOf(foodKindIndex ?? '');
                                  log("CURRENT FOOD");
                                  log(currentFoodKind.toString());
                                },
                                items: categories,
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
                                  ),
                                ),
                                // onChanged: print,
                                selectedItem: chooseType,
                              ),
                            ],
                          ),
                          space20H,
                          TextApp(
                            text: "Mô tả",
                            fontsize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: blueText,
                          ),
                          space10H,
                          Container(
                              width: 1.sw,
                              decoration: BoxDecoration(
                                border: const Border(
                                    top: BorderSide(
                                        width: 1, color: Colors.grey),
                                    bottom: BorderSide(
                                        width: 1, color: Colors.grey),
                                    left: BorderSide(
                                        width: 1, color: Colors.grey),
                                    right: BorderSide(
                                        width: 1, color: Colors.grey)),
                                borderRadius: BorderRadius.circular(15.w),
                                // color: Colors.amber,
                              ),
                              child: Column(
                                children: [
                                  QuillProvider(
                                      configurations: QuillConfigurations(
                                          controller: _controllerQuill),
                                      child: Column(
                                        children: [
                                          Container(
                                              width: 1.sw,
                                              decoration: const BoxDecoration(
                                                border: Border(
                                                    top: BorderSide(
                                                        width: 0,
                                                        color: Colors.grey),
                                                    bottom: BorderSide(
                                                        width: 1,
                                                        color: Colors.grey),
                                                    left: BorderSide(
                                                        width: 0,
                                                        color: Colors.grey),
                                                    right: BorderSide(
                                                        width: 0,
                                                        color: Colors.grey)),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.all(10.w),
                                                child: const QuillToolbar(
                                                  configurations:
                                                      QuillToolbarConfigurations(
                                                          toolbarIconAlignment:
                                                              WrapAlignment
                                                                  .center,
                                                          showFontFamily: true,
                                                          showFontSize: false,
                                                          showBoldButton: true,
                                                          showItalicButton:
                                                              true,
                                                          showSmallButton:
                                                              false,
                                                          showUnderLineButton:
                                                              true,
                                                          showStrikeThrough:
                                                              false,
                                                          showInlineCode: false,
                                                          showColorButton:
                                                              false,
                                                          showBackgroundColorButton:
                                                              false,
                                                          showClearFormat:
                                                              false,
                                                          showAlignmentButtons:
                                                              true,
                                                          showLeftAlignment:
                                                              true,
                                                          showCenterAlignment:
                                                              true,
                                                          showRightAlignment:
                                                              true,
                                                          showJustifyAlignment:
                                                              true,
                                                          showHeaderStyle:
                                                              false,
                                                          showListNumbers: true,
                                                          showListBullets: true,
                                                          showListCheck: false,
                                                          showCodeBlock: false,
                                                          showQuote: false,
                                                          showIndent: false,
                                                          showLink: true,
                                                          showUndo: false,
                                                          showRedo: false,
                                                          showDirection: false,
                                                          showSearchButton:
                                                              false,
                                                          showSubscript: false,
                                                          showSuperscript:
                                                              false),
                                                ),
                                              )),
                                          // space20H,
                                          Container(
                                            margin: EdgeInsets.all(5.w),
                                            height: 200.h,
                                            child: QuillEditor.basic(
                                              configurations:
                                                  const QuillEditorConfigurations(
                                                readOnly: false,
                                              ),
                                            ),
                                          )
                                        ],
                                      )),
                                ],
                              )),
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
                                      } else {
                                        setState(() {
                                          currentSection++;
                                          currentStep += 1;
                                        });
                                      }
                                      foodNameController.clear();
                                    }
                                  },
                                  text: next,
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
                              selectImages();
                            },
                            child: imageFileList!.isEmpty
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
                                        itemCount: imageFileList!.length,
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2),
                                        itemBuilder:
                                            (BuildContext context, int index) {
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
                                                    child: Image.file(
                                                      File(imageFileList![index]
                                                          .path),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  )),
                                              space10H,
                                              InkWell(
                                                onTap: () {
                                                  deleteImages(
                                                      imageFileList![index]);
                                                },
                                                child: TextApp(
                                                  text: deleteImage,
                                                  color: Colors.blue,
                                                ),
                                              )
                                            ],
                                          );
                                        }),
                                  )),
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
                                text: back,
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
                                      currentSection++;
                                    });
                                  }
                                },
                                text: next,
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
      case 3:
        return Container(
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
                    text: content,
                    color: const Color.fromRGBO(52, 71, 103, 1),
                    fontFamily: "OpenSans",
                    fontWeight: FontWeight.bold,
                    fontsize: 20.sp,
                  ),
                  space20H,
                  Container(
                      width: 1.sw,
                      decoration: BoxDecoration(
                        border: const Border(
                            top: BorderSide(width: 1, color: Colors.grey),
                            bottom: BorderSide(width: 1, color: Colors.grey),
                            left: BorderSide(width: 1, color: Colors.grey),
                            right: BorderSide(width: 1, color: Colors.grey)),
                        borderRadius: BorderRadius.circular(15.w),
                        // color: Colors.amber,
                      ),
                      child: Column(
                        children: [
                          QuillProvider(
                              configurations: QuillConfigurations(
                                  controller: _controllerQuill2),
                              child: Column(
                                children: [
                                  Container(
                                      width: 1.sw,
                                      decoration: const BoxDecoration(
                                        border: Border(
                                            top: BorderSide(
                                                width: 0, color: Colors.grey),
                                            bottom: BorderSide(
                                                width: 1, color: Colors.grey),
                                            left: BorderSide(
                                                width: 0, color: Colors.grey),
                                            right: BorderSide(
                                                width: 0, color: Colors.grey)),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(10.w),
                                        child: const QuillToolbar(
                                          configurations:
                                              QuillToolbarConfigurations(
                                                  toolbarIconAlignment:
                                                      WrapAlignment.center,
                                                  showFontFamily: true,
                                                  showFontSize: true,
                                                  showBoldButton: true,
                                                  showItalicButton: true,
                                                  showSmallButton: true,
                                                  showUnderLineButton: true,
                                                  showStrikeThrough: true,
                                                  showInlineCode: true,
                                                  showColorButton: true,
                                                  showBackgroundColorButton:
                                                      true,
                                                  showClearFormat: true,
                                                  showAlignmentButtons: true,
                                                  showLeftAlignment: true,
                                                  showCenterAlignment: true,
                                                  showRightAlignment: true,
                                                  showJustifyAlignment: true,
                                                  showHeaderStyle: true,
                                                  showListNumbers: true,
                                                  showListBullets: true,
                                                  showListCheck: true,
                                                  showCodeBlock: false,
                                                  showQuote: true,
                                                  showIndent: true,
                                                  showLink: true,
                                                  showUndo: true,
                                                  showRedo: true,
                                                  showDirection: false,
                                                  showSearchButton: false,
                                                  showSubscript: true,
                                                  showSuperscript: true),
                                        ),
                                      )),
                                  // space20H,
                                  Container(
                                    margin: EdgeInsets.all(5.w),
                                    height: 200.h,
                                    child: QuillEditor.basic(
                                      configurations:
                                          const QuillEditorConfigurations(
                                        readOnly: false,
                                      ),
                                    ),
                                  )
                                ],
                              )),
                        ],
                      )),
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
                                currentSection++;
                                currentStep += 1;
                              });
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
            ));
      case 4:
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
                                    hintText: 'Giá món ăn',
                                    isDense: true,
                                    contentPadding: EdgeInsets.all(15.w)),
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
                          TextApp(
                            text: allowFoodReady,
                            fontsize: 12.sp,
                            fontWeight: FontWeight.normal,
                            color: blueText,
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
                                activeColor:
                                    const Color.fromRGBO(58, 65, 111, .95),
                                onChanged: (bool value) {
                                  setState(() {
                                    light = value;
                                  });
                                },
                              ),
                            ),
                          ),
                          space30H,
                          TextApp(
                            text: createFoodInEachYourStore,
                            fontsize: 12.sp,
                            fontWeight: FontWeight.normal,
                            color: blueText,
                          ),
                          space10H,
                          TextApp(
                            text: " Cửa hàng",
                            fontsize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: blueText,
                          ),
                          space10H,
                          // SizedBox(
                          //   width: 1.sw,
                          //   height: 100.h,
                          //   child: Expanded(
                          //     child: DropdownSearch.multiSelection(
                          //       key: _popupCustomValidationKey,
                          //       items: listStore,
                          //       popupProps: PopupPropsMultiSelection.dialog(
                          //           title: Padding(
                          //         padding:
                          //             EdgeInsets.only(left: 15.w, top: 10.h),
                          //         child: TextApp(
                          //           text: "Chọn bàn để ghép",
                          //           fontsize: 16.sp,
                          //           fontWeight: FontWeight.bold,
                          //           color: blueText,
                          //         ),
                          //       )),
                          //     ),
                          //   ),
                          // ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DropdownSearch(
                                validator: (value) {
                                  if (value == chooseStore) {
                                    return canNotNull;
                                  }
                                  return null;
                                },
                                onChanged: (foodKindIndex) {
                                  currentFoodKind =
                                      categories.indexOf(foodKindIndex ?? '');

                                  log(currentFoodKind.toString());
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
                                  ),
                                ),
                                // onChanged: print,
                                selectedItem: chooseStore,
                              ),
                            ],
                          ),
                          space30H,
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
                                    _formField.currentState != null
                                        ? {
                                            if (_formField.currentState!
                                                    .validate() &&
                                                _formField2.currentState!
                                                    .validate())
                                              {
                                                handleCreateFood(
                                                    listStore: [1],
                                                    foodName:
                                                        foodNameController.text,
                                                    foodKind: 1,
                                                    foodPrice: priceOfFood.text,
                                                    activeFlag:
                                                        light == true ? 1 : 0)
                                              }
                                            else
                                              {
                                                showCustomDialogModal(
                                                    context: navigatorKey
                                                        .currentContext,
                                                    textDesc:
                                                        "Bạn cần điền đầy đủ thông tin",
                                                    title: "Thất bại",
                                                    colorButton: Colors.red,
                                                    btnText: "OK",
                                                    typeDialog: "error")
                                              }
                                          }
                                        : {
                                            showCustomDialogModal(
                                                context:
                                                    navigatorKey.currentContext,
                                                textDesc:
                                                    "Bạn cần điền đầy đủ thông tin 22222",
                                                title: "Thất bại",
                                                colorButton: Colors.red,
                                                btnText: "OK",
                                                typeDialog: "error")
                                          };
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
          ),
        );
    }
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
            content: Container()),
        Step(
            isActive: currentStep >= 3,
            state: currentStep > 3 ? StepState.complete : StepState.indexed,
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
                        child: Theme(
                          data: ThemeData(canvasColor: Colors.white),
                          child: Stepper(
                            currentStep: currentStep,
                            type: StepperType.horizontal,
                            steps: getStep(),
                            onStepTapped: (step) {
                              log("TAPPED");
                              currentStep = step;
                              currentSection = step + 1;
                              setState(() {
                                currentStep = step;
                                currentSection = step + 1;
                              });
                              // if (_formField.currentState!.validate()) {

                              // }
                            },
                            onStepContinue: () {
                              log("CONTINUE");
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
                              log("CANCLE");

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
      ),
    );
  }
}
