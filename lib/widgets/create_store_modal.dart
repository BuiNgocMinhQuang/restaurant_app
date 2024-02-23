import 'dart:io';

import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/widgets/button_app.dart';
import 'package:app_restaurant/widgets/button_gradient.dart';
import 'package:app_restaurant/widgets/text_app.dart';
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                        TextField(
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
                              hintText: 'Mã cửa hàng',
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
                          text: " Tên cửa hàng",
                          fontsize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: blueText,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        TextField(
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
                              hintText: 'Tên cửa hàng',
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
                          text: " Địa chỉ cửa hàng",
                          fontsize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: blueText,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        TextField(
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
                              hintText: 'Địa chỉ cửa hàng',
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
                          text: "Chế độ hiển thị",
                          fontsize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: blueText,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        TextApp(
                          text:
                              "Nếu bạn sẵn sàng cho cửa hàng đi vào hoạt động, bạn phải cho phép nó hiển thị với những người khác.",
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
                          text: "Mô tả cửa hàng",
                          fontsize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: blueText,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        TextApp(
                          text:
                              "Đây là cách những người khác sẽ tìm hiểu về về nhà hàng, vì vậy hãy làm cho nó thật tốt!",
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
                          text: "Hình ảnh về cửa hàng",
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
                            // pickImage();
                            // takeImage();
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
                                ButtonGradient(
                                  color1: const Color.fromRGBO(33, 82, 255, 1),
                                  color2: const Color.fromRGBO(33, 212, 253, 1),
                                  event: () {
                                    selectImages();
                                  },
                                  text: "Chọn ảnh từ thiết bị",
                                  fontSize: 12.sp,
                                  radius: 8.r,
                                  textColor: Colors.white,
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 1, // Thickness
                                      color: Color.fromRGBO(103, 116, 142, 1),
                                    ),
                                    SizedBox(
                                      width: 12.w,
                                    ),
                                    Text(
                                      "hoặc",
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Color.fromRGBO(103, 116, 142, 1),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 12.w,
                                    ),
                                    Container(
                                      width: 100,
                                      height: 1, // Thickness
                                      color: Color.fromRGBO(103, 116, 142, 1),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                ButtonGradient(
                                  color1: const Color.fromRGBO(33, 82, 255, 1),
                                  color2: const Color.fromRGBO(33, 212, 253, 1),
                                  event: () {
                                    pickImage();
                                  },
                                  text: "Chụp ảnh",
                                  fontSize: 12.sp,
                                  radius: 8.r,
                                  textColor: Colors.white,
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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
                            widget.eventSaveButton();
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
