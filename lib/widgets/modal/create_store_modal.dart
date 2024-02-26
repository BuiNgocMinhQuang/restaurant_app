import 'dart:io';

import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/config/text.dart';
import 'package:app_restaurant/widgets/button/button_app.dart';
import 'package:app_restaurant/widgets/button/button_gradient.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_quill/flutter_quill.dart';

class CreateStoreModal extends StatefulWidget {
  List<XFile>? imageFileList;
  Function eventCloseButton;
  Function eventSaveButton;
  CreateStoreModal({
    Key? key,
    required this.imageFileList,
    required this.eventCloseButton,
    required this.eventSaveButton,
  }) : super(key: key);

  @override
  State<CreateStoreModal> createState() => _CreateStoreModalState();
}

// List<XFile>? imageFileList = [];

class _CreateStoreModalState extends State<CreateStoreModal> {
  bool light = false;
  File? selectedImage;
  final _formField = GlobalKey<FormState>();
  final idStoreController = TextEditingController();
  final nameStoreController = TextEditingController();
  final addressStoreController = TextEditingController();
  final ImagePicker imagePicker = ImagePicker();
  QuillController _controllerQuill = QuillController.basic();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controllerQuill;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 1.sw,
        height: 1.sh,
        color: Colors.black.withOpacity(0.3),
        child: Center(
            child: Padding(
          padding: EdgeInsets.only(
              top: 100.h, bottom: 100.h, left: 35.w, right: 35.w),
          child: Container(
              width: 1.sw,
              height: 1.sh,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      width: 1.sw,
                      height: 50,
                      decoration: BoxDecoration(
                        border: const Border(
                            top: BorderSide(width: 0, color: Colors.grey),
                            bottom: BorderSide(width: 1, color: Colors.grey),
                            left: BorderSide(width: 0, color: Colors.grey),
                            right: BorderSide(width: 0, color: Colors.grey)),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15.w),
                            topRight: Radius.circular(15.w)),
                        // color: Colors.amber,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 20.w),
                                child: TextApp(
                                  text: "Cửa hàng",
                                  fontsize: 18.sp,
                                  color: blueText,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ],
                      )),
                  Expanded(
                      child: SingleChildScrollView(
                          child: Padding(
                    padding: EdgeInsets.all(20.w),
                    child: Form(
                      key: _formField,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextApp(
                            text: storeId,
                            fontsize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: blueText,
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          TextFormField(
                            controller: idStoreController,
                            cursorColor: const Color.fromRGBO(73, 80, 87, 1),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return canNotNull;
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
                                hintText: storeId,
                                isDense: true,
                                contentPadding:
                                    EdgeInsets.all(1.sw > 600 ? 20.w : 15.w)),
                          ),
                          ////////
                          SizedBox(
                            height: 30.h,
                          ),
                          //////
                          TextApp(
                            text: storeName,
                            fontsize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: blueText,
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          TextFormField(
                            controller: nameStoreController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return canNotNull;
                              } else {
                                return null;
                              }
                            },
                            cursorColor: const Color.fromRGBO(73, 80, 87, 1),
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
                                hintText: storeName,
                                isDense: true,
                                contentPadding:
                                    EdgeInsets.all(1.sw > 600 ? 20.w : 15.w)),
                          ),
                          /////
                          SizedBox(
                            height: 30.h,
                          ),
                          ////
                          TextApp(
                            text: storeAddress,
                            fontsize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: blueText,
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          TextFormField(
                            controller: addressStoreController,
                            cursorColor: const Color.fromRGBO(73, 80, 87, 1),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return canNotNull;
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
                                hintText: storeAddress,
                                isDense: true,
                                contentPadding:
                                    EdgeInsets.all(1.sw > 600 ? 20.w : 15.w)),
                          ),
                          /////
                          SizedBox(
                            height: 30.h,
                          ),
                          ////
                          TextApp(
                            text: displayMode,
                            fontsize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: blueText,
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          TextApp(
                            text: allowOpenStore,
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

                          SizedBox(
                            height: 30.h,
                          ),
                          ////
                          TextApp(
                            text: desStore,
                            fontsize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: blueText,
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          TextApp(
                            text: describeDetailSotre,
                            fontsize: 12.sp,
                            fontWeight: FontWeight.normal,
                            color: blueText,
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Container(
                              width: 1.sw,
                              height: 250.h,
                              color: Colors.amber,
                              child: Column(
                                children: [
                                  QuillProvider(
                                      configurations: QuillConfigurations(
                                          controller: _controllerQuill),
                                      child: Column(
                                        children: [
                                          QuillToolbar(
                                            configurations:
                                                QuillToolbarConfigurations(
                                              toolbarIconAlignment:
                                                  WrapAlignment.start,
                                              showColorButton: false,
                                              showCodeBlock: false,
                                              showHeaderStyle: false,
                                              showSearchButton: false,
                                              showFontFamily: false,
                                              showLeftAlignment: false,
                                              showRightAlignment: false,
                                              showCenterAlignment: false,
                                              showQuote: false,
                                              showUndo: false,
                                              showRedo: false,
                                              showDirection: false,
                                            ),
                                          ),
                                          Container(
                                            color: Colors.red,
                                            height: 100.h,
                                            child: QuillEditor.basic(
                                              configurations:
                                                  QuillEditorConfigurations(
                                                readOnly: false,
                                              ),
                                            ),
                                          )
                                        ],
                                      )),
                                ],
                              )),
                          SizedBox(
                            height: 30.h,
                          ),
                          TextApp(
                            text: storeImage,
                            fontsize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: blueText,
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.r),
                              ),
                              backgroundColor: Colors.white,
                              side: BorderSide(color: Colors.grey, width: 1), //
                            ),
                            onPressed: () {
                              selectImages();
                            },
                            child: Container(
                              width: 1.sw,
                              height: 300.h,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 200,
                                    height: 100,
                                    color: Colors.blue,
                                    child: GridView.builder(
                                        itemCount: widget.imageFileList!.length,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 3),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Image.file(
                                            File(widget
                                                .imageFileList![index].path),
                                            fit: BoxFit.cover,
                                          );
                                        }),
                                    // child: selectedImage != null
                                    //     ? Image.file(selectedImage!)
                                    //     : null,
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  // ButtonGradient(
                                  //   color1:
                                  //       const Color.fromRGBO(33, 82, 255, 1),
                                  //   color2:
                                  //       const Color.fromRGBO(33, 212, 253, 1),
                                  //   event: () {
                                  //     selectImages();
                                  //   },
                                  //   text: "Chọn ảnh từ thiết bị",
                                  //   fontSize: 12.sp,
                                  //   radius: 8.r,
                                  //   textColor: Colors.white,
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ))),
                  Container(
                    width: 1.sw,
                    height: 80,
                    decoration: BoxDecoration(
                      border: const Border(
                          top: BorderSide(width: 1, color: Colors.grey),
                          bottom: BorderSide(width: 0, color: Colors.grey),
                          left: BorderSide(width: 0, color: Colors.grey),
                          right: BorderSide(width: 0, color: Colors.grey)),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15.w),
                          bottomRight: Radius.circular(15.w)),
                      // color: Colors.green,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ButtonApp(
                          event: () {
                            widget.eventCloseButton();
                          },
                          text: "Đóng",
                          colorText: Colors.white,
                          backgroundColor: Color.fromRGBO(131, 146, 171, 1),
                          outlineColor: Color.fromRGBO(131, 146, 171, 1),
                        ),
                        SizedBox(
                          width: 20.w,
                        ),
                        ButtonApp(
                          event: () {
                            if (_formField.currentState!.validate()) {
                              widget.eventSaveButton();
                              idStoreController.clear();
                              nameStoreController.clear();
                              addressStoreController.clear();
                            }
                          },
                          text: "Lưu",
                          colorText: Colors.white,
                          backgroundColor: Color.fromRGBO(23, 193, 232, 1),
                          outlineColor: Color.fromRGBO(23, 193, 232, 1),
                        ),
                        SizedBox(
                          width: 20.w,
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        )));
  }

  void pickImage() async {
    final returndImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returndImage == null) return;
    setState(() {
      selectedImage = File(returndImage.path);
    });
  } //selecte one picture

  void takeImage() async {
    final returndImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (returndImage == null) return;
    setState(() {
      selectedImage = File(returndImage.path);
    });
  }

  void selectImages() async {
    final List<XFile> selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages.isNotEmpty) {
      widget.imageFileList!.addAll(selectedImages);
    }
    setState(() {});
  } //sele
}
