import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:app_restaurant/bloc/manager/stores/list_stores_bloc.dart';
import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/config/space.dart';
import 'package:app_restaurant/env/index.dart';
import 'package:app_restaurant/model/manager/store/details_stores_model.dart';
import 'package:app_restaurant/model/manager_infor_model.dart';
import 'package:app_restaurant/screen/manager/store/details_store.dart';
import 'package:app_restaurant/utils/storage.dart';
import 'package:app_restaurant/widgets/button/button_app.dart';
import 'package:app_restaurant/widgets/dialog/list_custom_dialog.dart';
import 'package:app_restaurant/widgets/text/copy_right_text.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'package:app_restaurant/constant/api/index.dart';

class ListStores extends StatefulWidget {
  final List<String> bannerList;
  final DataManagerInfor? managerInforData;
  const ListStores({
    Key? key,
    required this.bannerList,
    required this.managerInforData,
  }) : super(key: key);

  @override
  State<ListStores> createState() => _ListStoresState();
}

List<XFile>? imageFileList = [];

class _ListStoresState extends State<ListStores> {
  int activeIndex = 0;
  bool light = false;
  File? selectedImage;
  String avatarUser = '';
  List<String>? avatarStaff;
  DetailsStoreModel? detailsStoreModel;
  final ImagePicker imagePicker = ImagePicker();
  @override
  void initState() {
    super.initState();
    getListStore();
  }

  void getListStore() async {
    BlocProvider.of<ListStoresBloc>(context).add(GetListStores(
      token: StorageUtils.instance.getString(key: 'token_manager') ?? '',
    ));
  }

  void getDetailsStore({required shopID}) async {
    try {
      var token = StorageUtils.instance.getString(key: 'token_manager');

      final respons = await http.post(
        Uri.parse('$baseUrl$detailStore'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          'shop_id': shopID,
          'is_api': true,
        }),
      );
      final data = jsonDecode(respons.body);
      log(" DATA CREATE FOOD ${data}");
      try {
        if (data['status'] == 200) {
          setState(() {
            detailsStoreModel = DetailsStoreModel.fromJson(data);
          });
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailsStore(
                      detailsStoreModel: detailsStoreModel,
                    )),
          );
        } else {
          log("ERROR CREATE FOOOD");
        }
      } catch (error) {
        log("ERROR CREATE $error");
      }
    } catch (error) {
      log("ERROR CREATE $error");
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListStoresBloc, ListStoresState>(
      builder: (context, state) {
        return Scaffold(
          body: Stack(
            children: [
              SafeArea(
                  child: Container(
                width: 1.sw,
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.only(left: 15.w, right: 15.w),
                  child: state.listStoresStatus == ListStoresStatus.succes
                      ? RefreshIndicator(
                          color: Colors.blue,
                          onRefresh: () async {
                            getListStore();
                          },
                          child: SingleChildScrollView(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  space25H,
                                  Stack(
                                    children: [
                                      // Carousel
                                      widget.bannerList.isNotEmpty
                                          ? CarouselSlider.builder(
                                              itemCount:
                                                  widget.bannerList.length,
                                              itemBuilder:
                                                  (context, index, realIndex) {
                                                final currentBanner =
                                                    widget.bannerList[index];
                                                return buildImage(
                                                    currentBanner, index);
                                              },
                                              options: CarouselOptions(
                                                  height: 300.h,
                                                  autoPlay: true,
                                                  reverse: false,
                                                  autoPlayInterval:
                                                      const Duration(
                                                          seconds: 4),
                                                  onPageChanged:
                                                      (index, reason) {
                                                    setState(() {
                                                      activeIndex = index;
                                                    });
                                                  },
                                                  viewportFraction: 1))
                                          : Container(),

                                      // buildIndicator(),

                                      widget.managerInforData != null
                                          ? Padding(
                                              padding: EdgeInsets.only(
                                                  left: 20.w,
                                                  right: 20.w,
                                                  top: 150.h),
                                              child: Container(
                                                width: 1.sw,
                                                // height: 120.h,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.r)),
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 10.w,
                                                      left: 15.w,
                                                      right: 15.w,
                                                      bottom: 10.w),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      widget.managerInforData!
                                                                      .userAvatar !=
                                                                  null &&
                                                              widget
                                                                  .managerInforData!
                                                                  .userAvatar!
                                                                  .isNotEmpty
                                                          ? ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.r),
                                                              child: SizedBox(
                                                                width: 50.w,
                                                                height: 50.h,
                                                                child:
                                                                    CachedNetworkImage(
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  imageUrl: httpImage +
                                                                      (widget.managerInforData
                                                                              ?.userAvatar ??
                                                                          ''),
                                                                  placeholder:
                                                                      (context,
                                                                              url) =>
                                                                          SizedBox(
                                                                    height:
                                                                        15.w,
                                                                    width: 15.w,
                                                                    child: const Center(
                                                                        child:
                                                                            CircularProgressIndicator()),
                                                                  ),
                                                                  errorWidget: (context,
                                                                          url,
                                                                          error) =>
                                                                      const Icon(
                                                                          Icons
                                                                              .error),
                                                                ),
                                                              ))
                                                          : Container(),
                                                      space10H,
                                                      TextApp(
                                                        text: widget
                                                                .managerInforData
                                                                ?.userFullName ??
                                                            '',
                                                        fontsize: 16.sp,
                                                        color: blueText,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      space10H,
                                                      TextApp(
                                                        text: widget
                                                                .managerInforData
                                                                ?.userPhone ??
                                                            '',
                                                        fontsize: 14.sp,
                                                        color: grey,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Container()
                                    ],
                                  ),

                                  //List Stores
                                  space25H,
                                  Container(
                                      width: 1.sw,
                                      margin: EdgeInsets.only(
                                          left: 10.w, right: 10.w),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              spreadRadius: 2,
                                              blurRadius: 4,
                                              offset: const Offset(0,
                                                  3), // changes position of shadow
                                            ),
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(15.r)),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            top: 10.w, left: 15.w, right: 15.w),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            contentStores(),
                                            ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    const ClampingScrollPhysics(),
                                                itemCount: state.listStoreModel
                                                    ?.data.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  var imagePath1 = (state
                                                      .listStoreModel
                                                      ?.data[index]
                                                      .storeImages);
                                                  var listImagePath =
                                                      jsonDecode(
                                                          imagePath1 ?? '[]');
                                                  var desStore = state
                                                          .listStoreModel
                                                          ?.data[index]
                                                          .storeDescription ??
                                                      '';

                                                  return Container(
                                                    margin:
                                                        EdgeInsetsDirectional
                                                            .symmetric(
                                                                horizontal:
                                                                    10.w),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15.r),
                                                            child: SizedBox(
                                                              width: 1.sw,
                                                              height: 150.h,
                                                              child: imagePath1 ==
                                                                      null
                                                                  ? Image.asset(
                                                                      'assets/images/store.png',
                                                                      fit: BoxFit
                                                                          .contain,
                                                                    )
                                                                  : CachedNetworkImage(
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      imageUrl:
                                                                          httpImage +
                                                                              listImagePath[0],
                                                                      placeholder:
                                                                          (context, url) =>
                                                                              SizedBox(
                                                                        height:
                                                                            30.w,
                                                                        width:
                                                                            30.w,
                                                                        child: const Center(
                                                                            child:
                                                                                CircularProgressIndicator()),
                                                                      ),
                                                                      errorWidget: (context,
                                                                              url,
                                                                              error) =>
                                                                          const Icon(
                                                                              Icons.error),
                                                                    ),
                                                            )),
                                                        space15H,
                                                        TextApp(
                                                          text: state
                                                                  .listStoreModel
                                                                  ?.data[index]
                                                                  .storeName ??
                                                              '',
                                                          fontsize: 14.sp,
                                                        ),
                                                        space15H,
                                                        TextApp(
                                                          text: state
                                                                  .listStoreModel
                                                                  ?.data[index]
                                                                  .shopId ??
                                                              '',
                                                          color: blueText,
                                                          fontsize: 16.sp,
                                                        ),
                                                        space15H,
                                                        HtmlWidget(
                                                          '''
                                                           $desStore
                                                          ''',
                                                        ),
                                                        space30H,
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            ButtonApp(
                                                              event: () {
                                                                getDetailsStore(
                                                                    shopID: state
                                                                        .listStoreModel
                                                                        ?.data[
                                                                            index]
                                                                        .shopId);
                                                                // context.go(
                                                                //     '/manager_manage_stores');
                                                              },
                                                              text:
                                                                  "Quản lý cửa hàng",
                                                              colorText:
                                                                  const Color
                                                                      .fromRGBO(
                                                                      23,
                                                                      193,
                                                                      232,
                                                                      1),
                                                              backgroundColor:
                                                                  Colors.white,
                                                              outlineColor:
                                                                  const Color
                                                                      .fromRGBO(
                                                                      23,
                                                                      193,
                                                                      232,
                                                                      1),
                                                            ),
                                                            space25W,
                                                            SizedBox(
                                                                // width: 120.w,
                                                                height: 50.h,
                                                                // color: Colors.amber,
                                                                child: ListView
                                                                    .builder(
                                                                        scrollDirection:
                                                                            Axis
                                                                                .horizontal,
                                                                        itemCount: state
                                                                            .listStoreModel
                                                                            ?.data[
                                                                                index]
                                                                            .staffs
                                                                            .length,
                                                                        shrinkWrap:
                                                                            true,
                                                                        itemBuilder:
                                                                            (context,
                                                                                indexStaff) {
                                                                          var staffInfor = state
                                                                              .listStoreModel
                                                                              ?.data[index]
                                                                              .staffs;

                                                                          return CircleAvatar(
                                                                            radius:
                                                                                15.0,
                                                                            backgroundImage:
                                                                                NetworkImage("${httpImage + (staffInfor?[indexStaff].staffAvatar ?? '')}"),
                                                                            backgroundColor:
                                                                                Colors.red,
                                                                          );
                                                                        }))
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
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.r),
                                                ),
                                                backgroundColor: Colors.white,
                                                side: const BorderSide(
                                                    color: Colors.grey,
                                                    width: 1), //<-- SEE HERE
                                              ),
                                              onPressed: () {
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return CreateStoreDialog(
                                                          eventSaveButton:
                                                              () {});
                                                    });
                                              },
                                              child: SizedBox(
                                                width: 1.sw,
                                                height: 150.h,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const Icon(
                                                      Icons.add,
                                                      color: Colors.grey,
                                                    ),
                                                    space10H,
                                                    TextApp(
                                                      text: "Tạo cửa hàng",
                                                      fontWeight:
                                                          FontWeight.bold,
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
                        )
                      : state.listStoresStatus == ListStoresStatus.loading
                          ? Center(
                              child: SizedBox(
                                width: 200.w,
                                height: 200.w,
                                child: Lottie.asset(
                                    'assets/lottie/loading_7_color.json'),
                              ),
                            )
                          : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 100,
                                    height: 100,
                                    child: Lottie.asset(
                                        'assets/lottie/error.json'),
                                  ),
                                  space30H,
                                  TextApp(
                                    text: state.errorText.toString(),
                                    fontsize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ],
                              ),
                            ),
                ),
              )),
            ],
          ),
          backgroundColor:
              const Color.fromARGB(255, 246, 246, 246).withOpacity(1),
        );
      },
    );
  }

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

  Widget buildImage(String currentBanner, int index) => ClipRRect(
        borderRadius: BorderRadius.circular(15.r),
        child: Container(
          color: Colors.grey,
          child: CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl: httpImage + currentBanner,
            placeholder: (context, url) => SizedBox(
              height: 30.w,
              width: 30.w,
              child: const Center(child: CircularProgressIndicator()),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
      );
}
