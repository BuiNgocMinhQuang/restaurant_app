import 'dart:io';

import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/widgets/button_app.dart';
import 'package:app_restaurant/widgets/copy_right_text.dart';
import 'package:app_restaurant/widgets/create_store_modal.dart';
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
                      // CarouselSlider.builder(
                      //     itemCount: bannerList.length,
                      //     itemBuilder: (context, index, realIndex) {
                      //       final currentBanner = bannerList[index];
                      //       return buildImage(currentBanner, index);
                      //     },
                      //     options: CarouselOptions(
                      //         height: 300,
                      //         autoPlay: true,
                      //         reverse: false,
                      //         autoPlayInterval: Duration(seconds: 2),
                      //         onPageChanged: (index, reason) {
                      //           setState(() {
                      //             activeIndex = index;
                      //           });
                      //         },
                      //         viewportFraction: 1)),
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
                child: CreateStoreModal(
                  imageFileList: imageFileList,
                  eventCloseButton: () {
                    setState(() {
                      showModal = false;
                    });
                  },
                  eventSaveButton: () {},
                ))
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
