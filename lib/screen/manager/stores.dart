import 'dart:io';

import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/widgets/button_app.dart';
import 'package:app_restaurant/widgets/button_gradient.dart';
import 'package:app_restaurant/widgets/copy_right_text.dart';
import 'package:app_restaurant/widgets/custom_dialog.dart';
import 'package:app_restaurant/widgets/text_app.dart';
import 'package:avatar_stack/avatar_stack.dart';
import 'package:avatar_stack/positions.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Stores extends StatefulWidget {
  const Stores({super.key});

  @override
  State<Stores> createState() => _StoresState();
}

final List<String> bannerList = [
  "assets/images/banner1.png",
  "assets/images/banner2.png",
  "assets/images/banner3.png",
];

final List<String> staffList = [
  "assets/images/banner1.png",
  "assets/images/banner2.png",
  "assets/images/banner3.png",
  "assets/images/banner1.png",
  "assets/images/banner1.png",
  "assets/images/banner2.png",
];

List<XFile>? imageFileList = [];

class _StoresState extends State<Stores> {
  int activeIndex = 0;
  bool showModal = false;
  bool light = false;
  File? selectedImage;
  final ImagePicker imagePicker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 246, 246, 246).withOpacity(1),
        body: Stack(
          children: [
            SafeArea(
                child: Padding(
              padding: EdgeInsets.only(left: 15.w, right: 15.w),
              child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //Carousel
                      CarouselSlider.builder(
                          itemCount: bannerList.length,
                          itemBuilder: (context, index, realIndex) {
                            final currentBanner = bannerList[index];
                            return buildImage(currentBanner, index);
                          },
                          options: CarouselOptions(
                              height: 300,
                              autoPlay: true,
                              reverse: false,
                              autoPlayInterval: Duration(seconds: 2),
                              onPageChanged: (index, reason) {
                                setState(() {
                                  activeIndex = index;
                                });
                              },
                              viewportFraction: 1)),
                      SizedBox(
                        height: 25.h,
                      ),
                      buildIndicator(),
                      SizedBox(
                        height: 25.h,
                      ),
                      //List Stores
                      Container(
                          width: 1.sw,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15.r)),
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: 10.w, left: 15.w, right: 15.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                contentStores(),
                                ListView.builder(
                                    shrinkWrap: true,
                                    physics: const ClampingScrollPhysics(),
                                    itemCount: 2,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Container(
                                        margin: EdgeInsetsDirectional.symmetric(
                                            horizontal: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(15.r),
                                                child: Container(
                                                  width: 1.sw,
                                                  height: 150.h,
                                                  child: Image.asset(
                                                    "assets/images/banner1.png",
                                                    fit: BoxFit.fill,
                                                  ),
                                                )),
                                            SizedBox(
                                              height: 15.h,
                                            ),
                                            TextApp(
                                              text: "Tên cửa hàng",
                                              fontsize: 14.sp,
                                            ),
                                            SizedBox(
                                              height: 15.h,
                                            ),
                                            TextApp(
                                              text: "Mã cửa hàng",
                                              color: blueText,
                                              fontsize: 16.sp,
                                            ),
                                            SizedBox(
                                              height: 15.h,
                                            ),
                                            TextApp(
                                              text: "Mô tả cửa hàng",
                                              fontsize: 14.sp,
                                            ),
                                            SizedBox(
                                              height: 30.h,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                ButtonApp(
                                                  event: () {},
                                                  text: "Quản lý cửa hàng",
                                                  colorText: Color.fromRGBO(
                                                      23, 193, 232, 1),
                                                  backgroundColor: Colors.white,
                                                  outlineColor: Color.fromRGBO(
                                                      23, 193, 232, 1),
                                                ),
                                                Container(
                                                  width: 120.w,
                                                  // color: Colors.amber,
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 1,
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: 8.r),
                                                          child: const Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Example2MaxAmount(),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 30.h,
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                                OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.r),
                                    ),
                                    backgroundColor: Colors.white,
                                    side: BorderSide(
                                        color: Colors.grey,
                                        width: 1), //<-- SEE HERE
                                  ),
                                  onPressed: () {
                                    // showDialog();
                                    setState(() {
                                      showModal = true;
                                    });
                                  },
                                  child: Container(
                                    width: 1.sw,
                                    height: 150.h,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        TextApp(
                                          text: "Tạo cửa hàng",
                                          fontWeight: FontWeight.bold,
                                          fontsize: 16.sp,
                                          color: Colors.grey,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 30.h,
                                ),
                              ],
                            ),
                          )),
                      SizedBox(
                        height: 30.h,
                      ),
                      const CopyRightText()
                    ]),
              ),
            )),
            Visibility(
                visible: showModal,
                child: Container(
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
                                        top: BorderSide(
                                            width: 0, color: Colors.grey),
                                        bottom: BorderSide(
                                            width: 1, color: Colors.grey),
                                        left: BorderSide(
                                            width: 0, color: Colors.grey),
                                        right: BorderSide(
                                            width: 0, color: Colors.grey)),
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
                                            padding:
                                                EdgeInsets.only(left: 20.w),
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
                                      cursorColor:
                                          const Color.fromRGBO(73, 80, 87, 1),
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
                                          hintText: 'Mã cửa hàng',
                                          isDense: true,
                                          contentPadding: EdgeInsets.all(
                                              1.sw > 600 ? 20.w : 10.w)),
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
                                      cursorColor:
                                          const Color.fromRGBO(73, 80, 87, 1),
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
                                          hintText: 'Tên cửa hàng',
                                          isDense: true,
                                          contentPadding: EdgeInsets.all(
                                              1.sw > 600 ? 20.w : 10.w)),
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
                                      cursorColor:
                                          const Color.fromRGBO(73, 80, 87, 1),
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
                                          hintText: 'Địa chỉ cửa hàng',
                                          isDense: true,
                                          contentPadding: EdgeInsets.all(
                                              1.sw > 600 ? 20.w : 10.w)),
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
                                          borderRadius:
                                              BorderRadius.circular(15.r),
                                        ),
                                        backgroundColor: Colors.white,
                                        side: BorderSide(
                                            color: Colors.grey, width: 1), //
                                      ),
                                      onPressed: () {
                                        // pickImage();
                                        // takeImage();
                                        selectImages();
                                      },
                                      child: Container(
                                        width: 1.sw,
                                        height: 300.h,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 200,
                                              height: 100,
                                              color: Colors.blue,
                                              child: GridView.builder(
                                                  itemCount:
                                                      imageFileList!.length,
                                                  gridDelegate:
                                                      SliverGridDelegateWithFixedCrossAxisCount(
                                                          crossAxisCount: 3),
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return Image.file(
                                                      File(imageFileList![index]
                                                          .path),
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
                                              color1: const Color.fromRGBO(
                                                  33, 82, 255, 1),
                                              color2: const Color.fromRGBO(
                                                  33, 212, 253, 1),
                                              event: () {},
                                              text: "Chọn ảnh từ thiết bị",
                                              fontSize: 12.sp,
                                              radius: 8.r,
                                              textColor: Colors.white,
                                            ),
                                            SizedBox(
                                              height: 20.h,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: 100,
                                                  height: 1, // Thickness
                                                  color: Color.fromRGBO(
                                                      103, 116, 142, 1),
                                                ),
                                                SizedBox(
                                                  width: 12.w,
                                                ),
                                                Text(
                                                  "hoặc",
                                                  style: TextStyle(
                                                    fontSize: 12.sp,
                                                    color: Color.fromRGBO(
                                                        103, 116, 142, 1),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 12.w,
                                                ),
                                                Container(
                                                  width: 100,
                                                  height: 1, // Thickness
                                                  color: Color.fromRGBO(
                                                      103, 116, 142, 1),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 20.h,
                                            ),
                                            ButtonGradient(
                                              color1: const Color.fromRGBO(
                                                  33, 82, 255, 1),
                                              color2: const Color.fromRGBO(
                                                  33, 212, 253, 1),
                                              event: () {},
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
                                      top: BorderSide(
                                          width: 1, color: Colors.grey),
                                      bottom: BorderSide(
                                          width: 0, color: Colors.grey),
                                      left: BorderSide(
                                          width: 0, color: Colors.grey),
                                      right: BorderSide(
                                          width: 0, color: Colors.grey)),
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
                                        setState(() {
                                          showModal = false;
                                        });
                                      },
                                      text: "Đóng",
                                      colorText: Colors.white,
                                      backgroundColor:
                                          Color.fromRGBO(131, 146, 171, 1),
                                      outlineColor:
                                          Color.fromRGBO(131, 146, 171, 1),
                                    ),
                                    SizedBox(
                                      width: 20.w,
                                    ),
                                    ButtonApp(
                                      event: () {},
                                      text: "Lưu",
                                      colorText: Colors.white,
                                      backgroundColor:
                                          Color.fromRGBO(23, 193, 232, 1),
                                      outlineColor:
                                          Color.fromRGBO(23, 193, 232, 1),
                                    ),
                                    SizedBox(
                                      width: 20.w,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )),
                    ))))
          ],
        ));
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
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages!.isNotEmpty) {
      imageFileList!.addAll(selectedImages);
    }
    setState(() {});
  } //selecte multiple images

  Widget contentStores() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 25.h,
          ),
          TextApp(
            text: "Tất cả cửa hàng",
            color: blueText,
            fontsize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(
            height: 10.h,
          ),
          TextApp(
            text: "Bắt đầu quản lý các cửa hàng của bạn.",
            color: grey,
            fontsize: 12.sp,
          ),
          SizedBox(
            height: 20.h,
          ),
        ],
      );

  Widget buildImage(String currentBanner, int index) => Container(
        color: Colors.grey,
        child: Image.asset(
          currentBanner,
          fit: BoxFit.cover,
        ),
      );
  Widget buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: bannerList.length,
      );

  Widget showDialog() => Dialog(
        child: SizedBox(
          height: 300,
          child: Column(
            children: [
              Container(
                width: 100,
                height: 100,
                color: Colors.amber,
              ),
              Container(
                width: 100,
                height: 100,
                color: Colors.red,
              )
            ],
          ),
        ),
      );
}

class Example2MaxAmount extends StatelessWidget {
  const Example2MaxAmount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settings = RestrictedAmountPositions(
      maxAmountItems: 4,
      maxCoverage: 0.3,
      minCoverage: 0.1,
    );
    return AvatarStack(
      settings: settings,
      height: 50,
      avatars: [
        for (int i = 0; i < staffList.length; i++) AssetImage(staffList[i])
      ],
    );
  }
}
