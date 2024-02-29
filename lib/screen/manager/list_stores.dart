import 'dart:io';

import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/config/space.dart';
import 'package:app_restaurant/config/text.dart';
import 'package:app_restaurant/widgets/button/button_app.dart';
import 'package:app_restaurant/widgets/button/button_gradient.dart';
import 'package:app_restaurant/widgets/text/copy_right_text.dart';
import 'package:app_restaurant/widgets/modal/create_store_modal.dart';
import 'package:app_restaurant/widgets/item_drawer.dart';
import 'package:app_restaurant/widgets/sub_item_drawer.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:avatar_stack/avatar_stack.dart';
import 'package:avatar_stack/positions.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ListStores extends StatefulWidget {
  const ListStores({super.key});

  @override
  State<ListStores> createState() => _ListStoresState();
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

class _ListStoresState extends State<ListStores> {
  int activeIndex = 0;
  bool showModal = false;
  bool light = false;
  File? selectedImage;
  final ImagePicker imagePicker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Danh sách cửa hàng"),
      ),
      body: Stack(
        children: [
          SafeArea(
              child: Padding(
            padding: EdgeInsets.only(left: 15.w, right: 15.w),
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ////Carousel
                    CarouselSlider.builder(
                        itemCount: bannerList.length,
                        itemBuilder: (context, index, realIndex) {
                          final currentBanner = bannerList[index];
                          return buildImage(currentBanner, index);
                        },
                        options: CarouselOptions(
                            height: 300.h,
                            autoPlay: true,
                            reverse: false,
                            autoPlayInterval: Duration(seconds: 2),
                            onPageChanged: (index, reason) {
                              setState(() {
                                activeIndex = index;
                              });
                            },
                            viewportFraction: 1)),
                    space25H,

                    buildIndicator(),
                    space25H,

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
                                          horizontal: 10.w),
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
                                          space15H,
                                          TextApp(
                                            text: "Tên cửa hàng",
                                            fontsize: 14.sp,
                                          ),
                                          space15H,
                                          TextApp(
                                            text: "Mã cửa hàng",
                                            color: blueText,
                                            fontsize: 16.sp,
                                          ),
                                          space15H,
                                          TextApp(
                                            text: "Mô tả cửa hàng",
                                            fontsize: 14.sp,
                                          ),
                                          space30H,
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              ButtonApp(
                                                event: () {
                                                  context.go('/manage_store');
                                                },
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
                                          space30H,
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
                                  setState(() {
                                    showModal = true;
                                  });
                                },
                                child: Container(
                                  width: 1.sw,
                                  height: 150.h,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add,
                                        color: Colors.grey,
                                      ),
                                      space10H,
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
                              space30H,
                            ],
                          ),
                        )),
                    space30H,

                    const CopyRightText(),
                    space35H
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
      ),
      backgroundColor: Color.fromARGB(255, 246, 246, 246).withOpacity(1),
      drawer: Drawer(
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 100.w,
                  height: 100.w,
                  child: Image.asset(
                    "assets/images/logo-thv.png",
                    fit: BoxFit.contain,
                  ),
                ),
                const Divider(
                  color: Colors.black45,
                ),
                space10H,
                TextApp(
                  text: 'Tất cả cửa hàng',
                  color: grey,
                  fontsize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
                space25H,
                ItemDrawer(
                    // item: DrawerItem.stores,
                    text: 'Cửa hàng 1',
                    subItem: [
                      SubItemDrawer(
                          text: bookingTable,
                          event: () {
                            Navigator.pop(context);
                            context.go('/manager_booking_table');
                          }),
                      SizedBox(
                        height: 10.h,
                      ),
                      SubItemDrawer(
                          text: invoiceList,
                          event: () {
                            Navigator.pop(context);
                          }),
                      SizedBox(
                        height: 10.h,
                      ),
                      SubItemDrawer(
                          text: takeHomeReceipt,
                          event: () {
                            Navigator.pop(context);
                          })
                    ],
                    icon: Icons.store),
                space25H,
                ItemDrawer(
                    // item: DrawerItem.stores,
                    text: 'Cửa hàng 2',
                    subItem: [
                      SubItemDrawer(
                          text: bookingTable,
                          event: () {
                            Navigator.pop(context);
                          }),
                      SizedBox(
                        height: 10.h,
                      ),
                      SubItemDrawer(
                          text: invoiceList,
                          event: () {
                            Navigator.pop(context);
                          }),
                      SizedBox(
                        height: 10.h,
                      ),
                      SubItemDrawer(
                          text: takeHomeReceipt,
                          event: () {
                            Navigator.pop(context);
                          })
                    ],
                    icon: Icons.store),
              ],
            ),
            space20H,
            Padding(
                padding: EdgeInsets.all(15.w),
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 180.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          image: const DecorationImage(
                            image: AssetImage("assets/images/curved9.jpg"),
                            fit: BoxFit.fill,
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.all(15.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 50.w,
                            height: 50.w,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white),
                            child: Icon(Icons.power_settings_new_outlined),
                          ),
                          space15H,
                          Center(
                            child: TextApp(
                              text: "Ten Chu Cua Hang",
                              textAlign: TextAlign.center,
                              color: Colors.white,
                            ),
                          ),
                          Center(
                            child: TextApp(
                                text: "chucuahang@gmail.com",
                                textAlign: TextAlign.center,
                                color: Colors.white),
                          ),
                          space10H,
                          ButtonGradient(
                            color1: Colors.white,
                            color2: Colors.white,
                            event: () {
                              context.go("/");
                            },
                            text: "Đăng xuất",
                            textColor: Colors.black,
                            radius: 8.r,
                          )
                        ],
                      ),
                    )
                  ],
                ))
          ],
        ),
      ),
    );
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
          space25H,
          TextApp(
            text: "Tất cả cửa hàng",
            color: blueText,
            fontsize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
          space10H,
          TextApp(
            text: "Bắt đầu quản lý các cửa hàng của bạn.",
            color: grey,
            fontsize: 12.sp,
          ),
          space20H,
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
      height: 50.h,
      avatars: [
        for (int i = 0; i < staffList.length; i++) AssetImage(staffList[i])
      ],
    );
  }
}
