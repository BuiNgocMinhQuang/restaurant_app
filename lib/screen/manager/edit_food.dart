import 'dart:io';

import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/config/fake_data.dart';
import 'package:app_restaurant/config/space.dart';
import 'package:app_restaurant/config/text.dart';
import 'package:app_restaurant/widgets/button/button_gradient.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class EditFood extends StatefulWidget {
  const EditFood({super.key});

  @override
  State<EditFood> createState() => _EditFoodState();
}

class _EditFoodState extends State<EditFood> {
  bool light = false;

  final _formField1 = GlobalKey<FormState>();
  final _formField2 = GlobalKey<FormState>();
  final priceOfFood = TextEditingController();
  final foodNameController = TextEditingController();

  final _popupCustomValidationKey1 = GlobalKey<DropdownSearchState<int>>();
  final _popupCustomValidationKey2 = GlobalKey<DropdownSearchState<int>>();
  final ImagePicker imagePicker = ImagePicker();

  final QuillController _controllerQuill = QuillController.basic();
  List<XFile>? imageFileList = [];
  @override
  void dispose() {
    super.dispose();
    _controllerQuill;
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

  @override
  Widget build(BuildContext context) {
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
                key: _formField1,
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
                              TextApp(
                                text: notChangeFoodtoStore,
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
                              SizedBox(
                                width: 1.sw,
                                // height: 100.h,
                                child: DropdownSearch.multiSelection(
                                  key: _popupCustomValidationKey1,
                                  items: listStore,
                                  popupProps: PopupPropsMultiSelection.dialog(
                                      title: Padding(
                                    padding:
                                        EdgeInsets.only(left: 15.w, top: 10.h),
                                    child: TextApp(
                                      text: "Chọn cửa hàng",
                                      fontsize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                      color: blueText,
                                    ),
                                  )),
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
                                child: DropdownSearch.multiSelection(
                                  key: _popupCustomValidationKey2,
                                  items: categories,
                                  popupProps: PopupPropsMultiSelection.dialog(
                                      title: Padding(
                                    padding:
                                        EdgeInsets.only(left: 15.w, top: 10.h),
                                    child: TextApp(
                                      text: "Chọn loại thức ăn",
                                      fontsize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                      color: blueText,
                                    ),
                                  )),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ),

            ///FORM 1
            space50H,
            Container(
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
                                        hintText: foodName,
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
                                                  decoration:
                                                      const BoxDecoration(
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
                                                            color:
                                                                Colors.grey)),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.all(10.w),
                                                    child: const QuillToolbar(
                                                      configurations: QuillToolbarConfigurations(
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
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ),
            space50H,

            ///FORM 2
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
                                            itemBuilder: (BuildContext context,
                                                int index) {
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
                                                          File(imageFileList![
                                                                  index]
                                                              .path),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      )),
                                                  space10H,
                                                  InkWell(
                                                    onTap: () {
                                                      deleteImages(
                                                          imageFileList![
                                                              index]);
                                                    },
                                                    child: TextApp(
                                                      text: 'Xóa hình ảnh',
                                                      color: Colors.blue,
                                                    ),
                                                  )
                                                ],
                                              );
                                            }),
                                      )),
                            space20H,
                          ],
                        ),
                      )),
                ],
              ),
            ),

            //FORM 3
            space50H,

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
                        text: "Giao diện",
                        color: const Color.fromRGBO(52, 71, 103, 1),
                        fontFamily: "OpenSans",
                        fontWeight: FontWeight.bold,
                        fontsize: 20.sp,
                      ),
                      space20H,
                      TextApp(
                        text: "Nội dung",
                        fontsize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: blueText,
                      ),
                      space10H,
                      Container(
                          width: 1.sw,
                          decoration: BoxDecoration(
                            border: const Border(
                                top: BorderSide(width: 1, color: Colors.grey),
                                bottom:
                                    BorderSide(width: 1, color: Colors.grey),
                                left: BorderSide(width: 1, color: Colors.grey),
                                right:
                                    BorderSide(width: 1, color: Colors.grey)),
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
                                                      showAlignmentButtons:
                                                          true,
                                                      showLeftAlignment: true,
                                                      showCenterAlignment: true,
                                                      showRightAlignment: true,
                                                      showJustifyAlignment:
                                                          true,
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
                    ],
                  ),
                )),
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
                    event: () {},
                    text: "Lưu",
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
