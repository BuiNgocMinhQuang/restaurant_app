import 'dart:convert';
import 'dart:developer';

import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/config/date_time_format.dart';
import 'package:app_restaurant/config/void_show_dialog.dart';
import 'package:app_restaurant/model/manager/staff/list_staff_model.dart';
import 'package:app_restaurant/routers/app_router_config.dart';
import 'package:app_restaurant/screen/manager/staff/edit_staff_infor.dart';
import 'package:app_restaurant/utils/storage.dart';
import 'package:app_restaurant/widgets/box/status_box.dart';
import 'package:app_restaurant/widgets/button/button_gradient.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;
import 'package:app_restaurant/env/index.dart';
import 'package:app_restaurant/constant/api/index.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'dart:math' as math;

List<String> listState = ["Tất cả", "Đang hoạt động", "Đã chặn"];

class ListStaff extends StatefulWidget {
  const ListStaff({super.key});

  @override
  State<ListStaff> createState() => _ListStaffState();
}

class _ListStaffState extends State<ListStaff> {
  final TextEditingController _dateStartController = TextEditingController();
  final TextEditingController _dateEndController = TextEditingController();
  final stateFilterTextController = TextEditingController();

  ListStaffDataModel? listStaffDataModel;
  List currentStaffList = [];
  int? currentActiveFlag;
  bool hasMore = true;
  bool isRefesh = false;
  int currentPage = 1;
  String query = '';
  bool isLoading = true;
  bool isError = false;
  String? selectedFlitterFlag = 'Tất cả';

  final scrollListStaffController = ScrollController();
  void searchStaff(String query) {
    mounted
        ? setState(() {
            this.query = query;
            currentPage = 1;
          })
        : null;
    currentStaffList.clear();
    handleGetListStaff(
      page: currentPage,
      keywords: query,
      activeFlg: currentActiveFlag,
      dateStart: _dateStartController.text,
      dateEnd: _dateEndController.text,
    );
  }

  void selectDayStart() async {
    DateTime? picked = await showDatePicker(
        // helpText: 'Chọn ngày bắt đầu', // Can be used as title
        // cancelText: 'Huỷ',
        // confirmText: 'Xác nhận',
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2025));

    if (picked != null) {
      mounted
          ? setState(() {
              _dateStartController.text = picked.toString().split(" ")[0];
              currentPage = 1;
              currentStaffList.clear();

              handleGetListStaff(
                page: currentPage,
                keywords: query,
                activeFlg: currentActiveFlag,
                dateStart: _dateStartController.text,
                dateEnd: _dateEndController.text,
              );
            })
          : null;
    }
  }

  void selectDayEnd() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2025));
    if (picked != null) {
      mounted
          ? setState(() {
              _dateEndController.text = picked.toString().split(" ")[0];
              currentPage = 1;
              currentStaffList.clear();
              handleGetListStaff(
                page: currentPage,
                keywords: query,
                activeFlg: currentActiveFlag,
                dateStart: _dateStartController.text,
                dateEnd: _dateEndController.text,
              );
            })
          : null;
    }
  }

  void handleGetListStaff({
    required int page,
    String? keywords,
    int? activeFlg,
    String? dateStart,
    String? dateEnd,
  }) async {
    try {
      var token = StorageUtils.instance.getString(key: 'token_manager');

      final respons = await http.post(
        Uri.parse('$baseUrl$getListStaffApi'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          'is_api': true,
          'limit': 15,
          'page': page,
          'filters': {
            "keywords": keywords,
            "active_flg": activeFlg,
            "date_range": {"start_date": dateStart, "end_date": dateEnd}
          },
        }),
      );
      final data = jsonDecode(respons.body);
      try {
        if (data['status'] == 200) {
          mounted
              ? setState(() {
                  listStaffDataModel = ListStaffDataModel.fromJson(data);
                  currentStaffList.addAll(listStaffDataModel!.staffs.data);
                  currentPage++;
                  if (listStaffDataModel!.staffs.data.isEmpty ||
                      listStaffDataModel!.staffs.data.length <= 15) {
                    hasMore = false;
                  }
                })
              : null;
          Future.delayed(const Duration(milliseconds: 1000), () {
            mounted
                ? setState(() {
                    isLoading = false;
                  })
                : null;
          });
        } else {
          log("ERROR handleGetListStaff 1");
          Future.delayed(const Duration(milliseconds: 1000), () {
            mounted
                ? setState(() {
                    isLoading = false;
                  })
                : null;
          });
          mounted
              ? setState(() {
                  isError = true;
                })
              : null;
        }
      } catch (error) {
        log("ERROR handleGetListStaff 2 $error");

        Future.delayed(const Duration(milliseconds: 1000), () {
          mounted
              ? setState(() {
                  isLoading = false;
                })
              : null;
        });
        mounted
            ? setState(() {
                isError = true;
              })
            : null;
      }
    } catch (error) {
      log("ERROR handleGetListStaff 3 $error");

      Future.delayed(const Duration(milliseconds: 1000), () {
        mounted
            ? setState(() {
                isLoading = false;
              })
            : null;
      });
      mounted
          ? setState(() {
              isError = true;
            })
          : null;
    }
  }

  void handleChangeStatusStaff({
    required String staffNo,
  }) async {
    try {
      var token = StorageUtils.instance.getString(key: 'token_manager');

      final respons = await http.post(
        Uri.parse('$baseUrl$updateStatusStaff'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({'is_api': true, 'staff_no': staffNo}),
      );
      final data = jsonDecode(respons.body);
      try {
        if (data['status'] == 200) {
          currentStaffList.clear();
          handleGetListStaff(
            page: 1,
            keywords: query,
            activeFlg: currentActiveFlag,
            dateStart: _dateStartController.text,
            dateEnd: _dateEndController.text,
          );
        } else {
          log("ERROR handleChangeStatusStaff 1");
        }
      } catch (error) {
        log("ERROR handleChangeStatusStaff 2 $error");
      }
    } catch (error) {
      log("ERROR handleChangeStatusStaff 3 $error");
    }
  }

  @override
  void initState() {
    handleGetListStaff(page: 1);
    scrollListStaffController.addListener(() {
      if (scrollListStaffController.position.maxScrollExtent ==
              scrollListStaffController.offset &&
          isRefesh == false) {
        handleGetListStaff(
          page: currentPage,
          keywords: query,
          activeFlg: currentActiveFlag,
          dateStart: _dateStartController.text,
          dateEnd: _dateEndController.text,
        );
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _dateStartController.dispose();
    _dateEndController.dispose();
    scrollListStaffController.dispose();
    stateFilterTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: !isLoading
            ? isError
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: Lottie.asset('assets/lottie/error.json'),
                        ),
                        SizedBox(
                          height: 30.h,
                        ),
                        TextApp(
                          text: "Có lỗi xảy ra, vui lòng thử lại sau",
                          fontsize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(
                          height: 30.h,
                        ),
                        SizedBox(
                          width: 200,
                          child: ButtonGradient(
                            color1: color1BlueButton,
                            color2: color2BlueButton,
                            event: () {
                              currentStaffList.clear();
                              handleGetListStaff(page: 1);
                            },
                            text: 'Thử lại',
                            fontSize: 12.sp,
                            radius: 8.r,
                            textColor: Colors.white,
                          ),
                        )
                      ],
                    ),
                  )
                : RefreshIndicator(
                    color: Theme.of(context).colorScheme.primary,
                    onRefresh: () async {
                      currentStaffList.clear();
                      handleGetListStaff(page: 1);
                      // Implement logic to refresh data for Tab 1
                    },
                    child: SlidableAutoCloseBehavior(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          // Close any open slidable when tapping outside
                          Slidable.of(context)?.close();
                        },
                        child: SingleChildScrollView(
                          controller: scrollListStaffController,
                          child: Padding(
                            padding: EdgeInsets.zero,
                            child: Container(
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
                                        borderRadius:
                                            BorderRadius.circular(15.r),
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Flexible(
                                                  fit: FlexFit.tight,
                                                  flex: 1,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      TextApp(
                                                        text: " Từ ngày",
                                                        fontsize: 12.sp,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: blueText,
                                                      ),
                                                      SizedBox(
                                                        height: 10.h,
                                                      ),
                                                      TextField(
                                                        onTapOutside: (event) {
                                                          FocusManager.instance
                                                              .primaryFocus
                                                              ?.unfocus();
                                                        },
                                                        readOnly: true,
                                                        controller:
                                                            _dateStartController,
                                                        onTap: selectDayStart,
                                                        style: TextStyle(
                                                            fontSize: 14.sp,
                                                            color: grey),
                                                        cursorColor: grey,
                                                        decoration:
                                                            InputDecoration(
                                                                suffixIcon:
                                                                    const Icon(Icons
                                                                        .calendar_month),
                                                                fillColor:
                                                                    const Color
                                                                        .fromARGB(
                                                                        255,
                                                                        226,
                                                                        104,
                                                                        159),
                                                                focusedBorder:
                                                                    OutlineInputBorder(
                                                                  borderSide: const BorderSide(
                                                                      color: Color.fromRGBO(
                                                                          214,
                                                                          51,
                                                                          123,
                                                                          0.6),
                                                                      width:
                                                                          2.0),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.r),
                                                                ),
                                                                border:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.r),
                                                                ),
                                                                hintText:
                                                                    'dd/mm/yy',
                                                                isDense: true,
                                                                contentPadding:
                                                                    EdgeInsets
                                                                        .all(15
                                                                            .w)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 20.w,
                                                ),
                                                Flexible(
                                                  fit: FlexFit.tight,
                                                  flex: 1,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      TextApp(
                                                        text: " Đến ngày",
                                                        fontsize: 12.sp,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: blueText,
                                                      ),
                                                      SizedBox(
                                                        height: 10.h,
                                                      ),
                                                      TextField(
                                                        onTapOutside: (event) {
                                                          FocusManager.instance
                                                              .primaryFocus
                                                              ?.unfocus();
                                                        },
                                                        readOnly: true,
                                                        controller:
                                                            _dateEndController,
                                                        onTap: selectDayEnd,
                                                        style: TextStyle(
                                                            fontSize: 14.sp,
                                                            color: grey),
                                                        cursorColor: grey,
                                                        decoration:
                                                            InputDecoration(
                                                                suffixIcon:
                                                                    const Icon(Icons
                                                                        .calendar_month),
                                                                fillColor:
                                                                    const Color
                                                                        .fromARGB(
                                                                        255,
                                                                        226,
                                                                        104,
                                                                        159),
                                                                focusedBorder:
                                                                    OutlineInputBorder(
                                                                  borderSide: const BorderSide(
                                                                      color: Color.fromRGBO(
                                                                          214,
                                                                          51,
                                                                          123,
                                                                          0.6),
                                                                      width:
                                                                          2.0),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.r),
                                                                ),
                                                                border:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.r),
                                                                ),
                                                                hintText:
                                                                    'dd/mm/yy',
                                                                isDense: true,
                                                                contentPadding:
                                                                    EdgeInsets
                                                                        .all(15
                                                                            .w)),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 20.h,
                                            ),
                                            Row(
                                              children: [
                                                Flexible(
                                                  fit: FlexFit.tight,
                                                  flex: 1,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      TextApp(
                                                        text: " Trạng thái",
                                                        fontsize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: blueText,
                                                      ),
                                                      SizedBox(
                                                        height: 10.h,
                                                      ),
                                                      TextFormField(
                                                        readOnly: true,
                                                        onTapOutside: (event) {
                                                          FocusManager.instance
                                                              .primaryFocus
                                                              ?.unfocus();
                                                        },
                                                        onTap: () {
                                                          showMaterialModalBottomSheet(
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .only(
                                                                topRight: Radius
                                                                    .circular(
                                                                        15.r),
                                                                topLeft: Radius
                                                                    .circular(
                                                                        15.r),
                                                              ),
                                                            ),
                                                            clipBehavior: Clip
                                                                .antiAliasWithSaveLayer,
                                                            context: context,
                                                            builder:
                                                                (context) =>
                                                                    SizedBox(
                                                              height: 1.sh / 2,
                                                              child: Column(
                                                                children: [
                                                                  Container(
                                                                    width: 1.sw,
                                                                    padding: EdgeInsets
                                                                        .all(20
                                                                            .w),
                                                                    color: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .primary,
                                                                    child:
                                                                        TextApp(
                                                                      text:
                                                                          "Chọn trạng thái",
                                                                      color: Colors
                                                                          .white,
                                                                      fontsize:
                                                                          20.sp,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child: ListView
                                                                        .builder(
                                                                      padding: EdgeInsets.only(
                                                                          top: 10
                                                                              .w),
                                                                      itemCount:
                                                                          listState
                                                                              .length,
                                                                      itemBuilder:
                                                                          (context,
                                                                              index) {
                                                                        return Column(
                                                                          children: [
                                                                            Padding(
                                                                              padding: EdgeInsets.only(left: 20.w),
                                                                              child: InkWell(
                                                                                onTap: () async {
                                                                                  Navigator.pop(context);
                                                                                  mounted
                                                                                      ? setState(() {
                                                                                          stateFilterTextController.text = listState[index];
                                                                                        })
                                                                                      : null;
                                                                                  var kkk = index;
                                                                                  if (kkk == 0) {
                                                                                    mounted
                                                                                        ? setState(() {
                                                                                            currentStaffList.clear();

                                                                                            currentPage = 1;
                                                                                            currentActiveFlag = null;
                                                                                          })
                                                                                        : null;
                                                                                  } else if (kkk == 1) {
                                                                                    mounted
                                                                                        ? setState(() {
                                                                                            currentStaffList.clear();

                                                                                            currentPage = 1;
                                                                                            currentActiveFlag = 1;
                                                                                          })
                                                                                        : null;
                                                                                  } else {
                                                                                    mounted
                                                                                        ? setState(() {
                                                                                            currentStaffList.clear();

                                                                                            currentPage = 1;
                                                                                            currentActiveFlag = 0;
                                                                                          })
                                                                                        : null;
                                                                                  }
                                                                                  handleGetListStaff(
                                                                                    page: currentPage,
                                                                                    keywords: query,
                                                                                    activeFlg: currentActiveFlag,
                                                                                    dateStart: _dateStartController.text,
                                                                                    dateEnd: _dateEndController.text,
                                                                                  );
                                                                                },
                                                                                child: Row(
                                                                                  children: [
                                                                                    TextApp(
                                                                                      text: listState[index],
                                                                                      color: Colors.black,
                                                                                      fontsize: 20.sp,
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
                                                            stateFilterTextController,
                                                        style: TextStyle(
                                                            fontSize: 14.sp,
                                                            color:
                                                                Colors.black),
                                                        cursorColor: grey,
                                                        validator: (value) {
                                                          return null;
                                                        },
                                                        decoration:
                                                            InputDecoration(
                                                                fillColor: const Color
                                                                    .fromARGB(
                                                                    255,
                                                                    226,
                                                                    104,
                                                                    159),
                                                                focusedBorder:
                                                                    OutlineInputBorder(
                                                                  borderSide: const BorderSide(
                                                                      color: Color.fromRGBO(
                                                                          214,
                                                                          51,
                                                                          123,
                                                                          0.6),
                                                                      width:
                                                                          2.0),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.r),
                                                                ),
                                                                border:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.r),
                                                                ),
                                                                hintText:
                                                                    selectedFlitterFlag,
                                                                suffixIcon:
                                                                    Transform
                                                                        .rotate(
                                                                  angle: 90 *
                                                                      math.pi /
                                                                      180,
                                                                  child: Icon(
                                                                    Icons
                                                                        .chevron_right,
                                                                    size: 28.sp,
                                                                    color: Colors
                                                                        .black
                                                                        .withOpacity(
                                                                            0.5),
                                                                  ),
                                                                ),
                                                                isDense: true,
                                                                hintStyle: TextStyle(
                                                                    fontSize:
                                                                        14.sp,
                                                                    color:
                                                                        grey),
                                                                contentPadding:
                                                                    EdgeInsets
                                                                        .all(15
                                                                            .w)),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 20.w,
                                                ),
                                                Flexible(
                                                  fit: FlexFit.tight,
                                                  flex: 1,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      TextApp(
                                                        text: " Tìm kiếm",
                                                        fontsize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: blueText,
                                                      ),
                                                      SizedBox(
                                                        height: 10.h,
                                                      ),
                                                      TextField(
                                                        onTapOutside: (event) {
                                                          FocusManager.instance
                                                              .primaryFocus
                                                              ?.unfocus();
                                                        },
                                                        onChanged: searchStaff,
                                                        style: TextStyle(
                                                            fontSize: 14.sp,
                                                            color: grey),
                                                        cursorColor: grey,
                                                        decoration:
                                                            InputDecoration(
                                                                fillColor:
                                                                    const Color
                                                                        .fromARGB(
                                                                        255,
                                                                        226,
                                                                        104,
                                                                        159),
                                                                focusedBorder:
                                                                    OutlineInputBorder(
                                                                  borderSide: const BorderSide(
                                                                      color: Color.fromRGBO(
                                                                          214,
                                                                          51,
                                                                          123,
                                                                          0.6),
                                                                      width:
                                                                          2.0),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.r),
                                                                ),
                                                                border:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.r),
                                                                ),
                                                                isDense: true,
                                                                contentPadding:
                                                                    EdgeInsets
                                                                        .all(18
                                                                            .w)),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 20.h,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: 1.sw,
                                                  child: ListView.builder(
                                                      physics:
                                                          const NeverScrollableScrollPhysics(),
                                                      shrinkWrap: true,
                                                      itemCount:
                                                          currentStaffList
                                                                  .length +
                                                              1,
                                                      itemBuilder:
                                                          (context, index) {
                                                        if (index <
                                                            currentStaffList
                                                                .length) {
                                                          DataListStaff
                                                              staffData =
                                                              currentStaffList[
                                                                  index];
                                                          var avatarStaff =
                                                              staffData
                                                                      .staffAvatar ??
                                                                  '';
                                                          var intPosition =
                                                              staffData
                                                                  .staffPosition;
                                                          var staffPos = intPosition ==
                                                                  1
                                                              ? "Nhân viên phục vụ"
                                                              : intPosition == 2
                                                                  ? "Trưởng nhóm"
                                                                  : intPosition ==
                                                                          3
                                                                      ? "Quản lý"
                                                                      : intPosition ==
                                                                              4
                                                                          ? "Kế toán"
                                                                          : "Đầu bếp";
                                                          return Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              const Divider(
                                                                height: 1,
                                                              ),
                                                              SizedBox(
                                                                height: 5.h,
                                                              ),
                                                              Slidable(
                                                                // Specify a key if the Slidable is dismissible.
                                                                key: ValueKey(
                                                                    currentStaffList[
                                                                        index]),

                                                                // The start action pane is the one at the left or the top side.
                                                                endActionPane:
                                                                    ActionPane(
                                                                  extentRatio:
                                                                      0.6,
                                                                  // dismissible: SlidableDismissal.disabled,
                                                                  dragDismissible:
                                                                      false,
                                                                  // A motion is a widget used to control how the pane animates.
                                                                  motion:
                                                                      const ScrollMotion(),

                                                                  // A pane can dismiss the Slidable.
                                                                  dismissible:
                                                                      DismissiblePane(
                                                                          onDismissed:
                                                                              () {}),

                                                                  // All actions are defined in the children parameter.
                                                                  children: [
                                                                    // A SlidableAction can have an icon and/or a label.
                                                                    // SlidableAction(
                                                                    //   onPressed:
                                                                    //       (dd) {},
                                                                    //   backgroundColor: Theme.of(
                                                                    //           context)
                                                                    //       .colorScheme
                                                                    //       .primary,
                                                                    //   foregroundColor:
                                                                    //       Colors
                                                                    //           .white,
                                                                    //   icon: Icons
                                                                    //       .info,
                                                                    //   label:
                                                                    //       'Thêm',
                                                                    // ),
                                                                    SlidableAction(
                                                                      onPressed:
                                                                          (context) {
                                                                        // handleGetDetailsFood(
                                                                        //     foodID:
                                                                        //         product.foodId ?? 0);
                                                                        Navigator
                                                                            .push(
                                                                          navigatorKey
                                                                              .currentContext!,
                                                                          MaterialPageRoute(
                                                                              builder: (context) => EditStaffInformation(
                                                                                    staffNo: staffData.staffNo.toString(),
                                                                                  )),
                                                                        );
                                                                      },
                                                                      backgroundColor:
                                                                          Colors
                                                                              .black,
                                                                      foregroundColor:
                                                                          Colors
                                                                              .white,
                                                                      icon: Icons
                                                                          .edit,
                                                                      label:
                                                                          'Sửa',
                                                                    ),
                                                                    SizedBox(
                                                                      width:
                                                                          2.w,
                                                                    ),
                                                                    SlidableAction(
                                                                      onPressed:
                                                                          (context) {
                                                                        showConfirmDialog(
                                                                            navigatorKey.currentContext,
                                                                            () {
                                                                          handleChangeStatusStaff(
                                                                              staffNo: staffData.staffNo.toString());
                                                                        });
                                                                        // showConfirmDialog(
                                                                        //     navigatorKey
                                                                        //         .currentContext,
                                                                        //     () {
                                                                        //   handleDeleteFood(
                                                                        //       foodID:
                                                                        //           product.foodId.toString());
                                                                        // });
                                                                      },
                                                                      backgroundColor:
                                                                          Colors
                                                                              .black,
                                                                      foregroundColor:
                                                                          Colors
                                                                              .white,
                                                                      icon: Icons
                                                                          .lock,
                                                                      label:
                                                                          'Khoá',
                                                                    ),
                                                                  ],
                                                                ),

                                                                // The end action pane is the one at the right or the bottom side.

                                                                // The child of the Slidable is what the user sees when the
                                                                // component is not dragged.
                                                                child: ListTile(
                                                                    contentPadding:
                                                                        EdgeInsets
                                                                            .zero,
                                                                    minVerticalPadding:
                                                                        0,
                                                                    horizontalTitleGap:
                                                                        0,
                                                                    title:
                                                                        Container(
                                                                      width:
                                                                          1.sw,
                                                                      color: Colors
                                                                          .white,
                                                                      child:
                                                                          Row(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        children: [
                                                                          SizedBox(
                                                                            width:
                                                                                120.w,
                                                                            height:
                                                                                120.w,
                                                                            child:
                                                                                ClipRRect(
                                                                              borderRadius: BorderRadius.circular(8.r),
                                                                              child: CachedNetworkImage(
                                                                                fit: BoxFit.fill,
                                                                                imageUrl: httpImage + avatarStaff,
                                                                                placeholder: (context, url) => SizedBox(
                                                                                  height: 10.w,
                                                                                  width: 10.w,
                                                                                  child: const Center(child: CircularProgressIndicator()),
                                                                                ),
                                                                                errorWidget: (context, url, error) => const Icon(Icons.error),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                10.w,
                                                                          ),
                                                                          SizedBox(
                                                                            child:
                                                                                Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              children: [
                                                                                Row(
                                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  children: [
                                                                                    SizedBox(
                                                                                      // color: Colors.white,
                                                                                      width: 140.w,
                                                                                      child: TextApp(
                                                                                        isOverFlow: false,
                                                                                        softWrap: true,
                                                                                        text: staffData.staffFullName ?? '',
                                                                                        fontsize: 14.sp,
                                                                                        color: blueText,
                                                                                        fontWeight: FontWeight.bold,
                                                                                      ),
                                                                                    ),
                                                                                    staffData.activeFlg == 1 ? const StatusBoxIsActive() : const StatusBoxIsLock()
                                                                                  ],
                                                                                ),
                                                                                // SizedBox(
                                                                                //   height: 10.h,
                                                                                // ),
                                                                                Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                                  children: [
                                                                                    TextApp(
                                                                                      isOverFlow: false,
                                                                                      softWrap: true,
                                                                                      text: "Chức vụ: ",
                                                                                      fontsize: 14.sp,
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 160.w,
                                                                                      child: TextApp(
                                                                                        isOverFlow: false,
                                                                                        softWrap: true,
                                                                                        text: staffPos,
                                                                                        fontsize: 14.sp,
                                                                                        fontWeight: FontWeight.bold,
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                // SizedBox(
                                                                                //   width: 150.w,
                                                                                //   child: Center(child: staffData.activeFlg == 1 ? const StatusBoxIsActive() : const StatusBoxIsLock()),
                                                                                // ),
                                                                                // SizedBox(
                                                                                //   height: 10.h,
                                                                                // ),
                                                                                Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                                  children: [
                                                                                    TextApp(
                                                                                      isOverFlow: false,
                                                                                      softWrap: true,
                                                                                      text: "Làm việc tại: ",
                                                                                      fontsize: 14.sp,
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 160.w,
                                                                                      child: TextApp(
                                                                                        isOverFlow: false,
                                                                                        softWrap: true,
                                                                                        text: staffData.storeName,
                                                                                        fontsize: 14.sp,
                                                                                        fontWeight: FontWeight.bold,
                                                                                        textAlign: TextAlign.start,
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                Row(
                                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  children: [
                                                                                    TextApp(
                                                                                      isOverFlow: false,
                                                                                      softWrap: true,
                                                                                      text: "Email: ",
                                                                                      fontsize: 14.sp,
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 160.w,
                                                                                      child: TextApp(
                                                                                        isOverFlow: false,
                                                                                        softWrap: true,
                                                                                        text: staffData.staffEmail ?? '',
                                                                                        fontsize: 14.sp,
                                                                                        textAlign: TextAlign.start,
                                                                                        fontWeight: FontWeight.bold,
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                Row(
                                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  children: [
                                                                                    TextApp(
                                                                                      isOverFlow: false,
                                                                                      softWrap: true,
                                                                                      text: "Điện thoại: ",
                                                                                      fontsize: 14.sp,
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 150.w,
                                                                                      child: TextApp(
                                                                                        isOverFlow: false,
                                                                                        softWrap: true,
                                                                                        text: staffData.staffPhone.toString(),
                                                                                        fontsize: 14.sp,
                                                                                        fontWeight: FontWeight.bold,
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                Row(
                                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  children: [
                                                                                    TextApp(
                                                                                      isOverFlow: false,
                                                                                      softWrap: true,
                                                                                      text: "Ngày tạo: ",
                                                                                      fontsize: 14.sp,
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 160.w,
                                                                                      child: TextApp(
                                                                                        isOverFlow: false,
                                                                                        softWrap: true,
                                                                                        text: formatDateTime(staffData.createdAt ?? ''),
                                                                                        fontsize: 14.sp,
                                                                                        textAlign: TextAlign.start,
                                                                                        fontWeight: FontWeight.bold,
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    )),
                                                              ),
                                                              SizedBox(
                                                                height: 5.h,
                                                              ),
                                                            ],
                                                          );
                                                        } else {
                                                          return Center(
                                                            child: hasMore
                                                                ? Padding(
                                                                    padding: EdgeInsets.only(
                                                                        top: 10
                                                                            .h,
                                                                        bottom:
                                                                            10.h),
                                                                    child:
                                                                        const CircularProgressIndicator(),
                                                                  )
                                                                : Container(),
                                                          );
                                                        }
                                                      }),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      )),
                                  SizedBox(
                                    height: 30.h,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
            : Center(
                child: SizedBox(
                  width: 200.w,
                  height: 200.w,
                  child: Lottie.asset('assets/lottie/loading_7_color.json'),
                ),
              ),
      ),
    );
  }
}
