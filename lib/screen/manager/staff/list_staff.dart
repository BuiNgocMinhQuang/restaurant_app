import 'dart:convert';
import 'dart:developer';

import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/config/date_time_format.dart';
import 'package:app_restaurant/config/space.dart';
import 'package:app_restaurant/config/void_show_dialog.dart';
import 'package:app_restaurant/model/manager/staff/list_staff_model.dart';
import 'package:app_restaurant/routers/app_router_config.dart';
import 'package:app_restaurant/screen/manager/staff/edit_staff_infor.dart';
import 'package:app_restaurant/utils/storage.dart';
import 'package:app_restaurant/widgets/box/status_box.dart';
import 'package:app_restaurant/widgets/button/button_gradient.dart';
import 'package:app_restaurant/widgets/button/button_icon.dart';
import 'package:app_restaurant/widgets/text/copy_right_text.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:app_restaurant/env/index.dart';
import 'package:app_restaurant/constant/api/index.dart';
import 'package:lottie/lottie.dart';

List<String> listState = ["Tất cả", "Đang hoạt động", "Đã chặn"];

class ListStaff extends StatefulWidget {
  const ListStaff({super.key});

  @override
  State<ListStaff> createState() => _ListStaffState();
}

class _ListStaffState extends State<ListStaff> {
  TextEditingController _dateStartController = TextEditingController();
  TextEditingController _dateEndController = TextEditingController();
  ListStaffDataModel? listStaffDataModel;
  List currentStaffList = [];
  int? currentActiveFlag;
  bool hasMore = true;
  bool isRefesh = false;
  int currentPage = 1;
  String query = '';
  bool isLoading = true;
  bool isError = false;
  final scrollListStaffController = ScrollController();
  void searchStaff(String query) {
    setState(() {
      this.query = query;
      currentPage = 1;
    });
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
      setState(() {
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
      });
    }
  }

  void selectDayEnd() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2025));
    if (picked != null) {
      setState(() {
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
      });
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
      print(" DATA CREATE FOOD ${data}");
      try {
        if (data['status'] == 200) {
          setState(() {
            listStaffDataModel = ListStaffDataModel.fromJson(data);
            currentStaffList.addAll(listStaffDataModel!.staffs.data);
            currentPage++;
            log(currentStaffList.toString());
            if (listStaffDataModel!.staffs.data.isEmpty ||
                listStaffDataModel!.staffs.data.length <= 15) {
              hasMore = false;
            }
          });
          Future.delayed(const Duration(milliseconds: 1000), () {
            setState(() {
              isLoading = false;
            });
          });
        } else {
          Future.delayed(const Duration(milliseconds: 1000), () {
            setState(() {
              isLoading = false;
            });
          });
          setState(() {
            isError = true;
          });
        }
      } catch (error) {
        Future.delayed(const Duration(milliseconds: 1000), () {
          setState(() {
            isLoading = false;
          });
        });
        setState(() {
          isError = true;
        });
      }
    } catch (error) {
      Future.delayed(const Duration(milliseconds: 1000), () {
        setState(() {
          isLoading = false;
        });
      });
      setState(() {
        isError = true;
      });
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
      print(" DATA CREATE FOOD ${data}");
      try {
        if (data['status'] == 200) {
          // var hahah = DetailsStoreModel.fromJson(data);
          currentStaffList.clear();
          handleGetListStaff(
            page: 1,
            keywords: query,
            activeFlg: currentActiveFlag,
            dateStart: _dateStartController.text,
            dateEnd: _dateEndController.text,
          );
        } else {
          print("ERROR CREATE FOOOD");
        }
      } catch (error) {
        print("ERROR CREATE $error");
      }
    } catch (error) {
      print("ERROR CREATE $error");
    }
  }

  @override
  void initState() {
    super.initState();
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
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: !isLoading
            ? isError
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          child: Lottie.asset('assets/lottie/error.json'),
                        ),
                        space30H,
                        TextApp(
                          text: "Có lỗi xảy ra, vui lòng thử lại sau",
                          fontsize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        space30H,
                        Container(
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
                    color: Colors.blue,
                    onRefresh: () async {
                      currentStaffList.clear();
                      handleGetListStaff(page: 1);
                      // Implement logic to refresh data for Tab 1
                    },
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.all(20.w),
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
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  TextApp(
                                                    text: " Từ ngày",
                                                    fontsize: 12.sp,
                                                    fontWeight: FontWeight.bold,
                                                    color: blueText,
                                                  ),
                                                  SizedBox(
                                                    height: 10.h,
                                                  ),
                                                  TextField(
                                                    readOnly: true,
                                                    controller:
                                                        _dateStartController,
                                                    onTap: selectDayStart,
                                                    style: TextStyle(
                                                        fontSize: 14.sp,
                                                        color: grey),
                                                    cursorColor: grey,
                                                    decoration: InputDecoration(
                                                        suffixIcon: Icon(Icons
                                                            .calendar_month),
                                                        fillColor: const Color
                                                            .fromARGB(
                                                            255, 226, 104, 159),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          214,
                                                                          51,
                                                                          123,
                                                                          0.6),
                                                                  width: 2.0),
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
                                                        hintText: 'dd/mm/yy',
                                                        isDense: true,
                                                        contentPadding:
                                                            EdgeInsets.all(
                                                                15.w)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            space20W,
                                            Flexible(
                                              fit: FlexFit.tight,
                                              flex: 1,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  TextApp(
                                                    text: " Đến ngày",
                                                    fontsize: 12.sp,
                                                    fontWeight: FontWeight.bold,
                                                    color: blueText,
                                                  ),
                                                  SizedBox(
                                                    height: 10.h,
                                                  ),
                                                  TextField(
                                                    readOnly: true,
                                                    controller:
                                                        _dateEndController,
                                                    onTap: selectDayEnd,
                                                    style: TextStyle(
                                                        fontSize: 14.sp,
                                                        color: grey),
                                                    cursorColor: grey,
                                                    decoration: InputDecoration(
                                                        suffixIcon: Icon(Icons
                                                            .calendar_month),
                                                        fillColor: const Color
                                                            .fromARGB(
                                                            255, 226, 104, 159),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          214,
                                                                          51,
                                                                          123,
                                                                          0.6),
                                                                  width: 2.0),
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
                                                        hintText: 'dd/mm/yy',
                                                        isDense: true,
                                                        contentPadding:
                                                            EdgeInsets.all(
                                                                15.w)),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        space20H,
                                        Row(
                                          children: [
                                            Flexible(
                                              fit: FlexFit.tight,
                                              flex: 1,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  TextApp(
                                                    text: " Trạng thái",
                                                    fontsize: 12.sp,
                                                    fontWeight: FontWeight.bold,
                                                    color: blueText,
                                                  ),
                                                  SizedBox(
                                                    height: 10.h,
                                                  ),
                                                  DropdownSearch(
                                                    onChanged: (status) {
                                                      var kkk =
                                                          listState.indexOf(
                                                              status ?? '');
                                                      if (kkk == 0) {
                                                        setState(() {
                                                          currentStaffList
                                                              .clear();

                                                          currentPage = 1;
                                                          currentActiveFlag =
                                                              null;
                                                        });
                                                      } else if (kkk == 1) {
                                                        setState(() {
                                                          currentStaffList
                                                              .clear();

                                                          currentPage = 1;
                                                          currentActiveFlag = 1;
                                                        });
                                                      } else {
                                                        setState(() {
                                                          currentStaffList
                                                              .clear();

                                                          currentPage = 1;
                                                          currentActiveFlag = 0;
                                                        });
                                                      }
                                                      handleGetListStaff(
                                                        page: currentPage,
                                                        keywords: query,
                                                        activeFlg:
                                                            currentActiveFlag,
                                                        dateStart:
                                                            _dateStartController
                                                                .text,
                                                        dateEnd:
                                                            _dateEndController
                                                                .text,
                                                      );
                                                    },
                                                    items: listState,
                                                    dropdownDecoratorProps:
                                                        DropDownDecoratorProps(
                                                      dropdownSearchDecoration:
                                                          InputDecoration(
                                                        fillColor: const Color
                                                            .fromARGB(
                                                            255, 226, 104, 159),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          214,
                                                                          51,
                                                                          123,
                                                                          0.6),
                                                                  width: 2.0),
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
                                                            EdgeInsets.all(
                                                                15.w),
                                                        hintText: "Tất cả",
                                                      ),
                                                    ),
                                                    selectedItem: "Tất cả",
                                                  ),
                                                ],
                                              ),
                                            ),
                                            space20W,
                                            Flexible(
                                              fit: FlexFit.tight,
                                              flex: 1,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  TextApp(
                                                    text: " Tìm kiếm",
                                                    fontsize: 12.sp,
                                                    fontWeight: FontWeight.bold,
                                                    color: blueText,
                                                  ),
                                                  SizedBox(
                                                    height: 10.h,
                                                  ),
                                                  TextField(
                                                    onTapOutside: (event) {
                                                      FocusManager
                                                          .instance.primaryFocus
                                                          ?.unfocus();
                                                    },
                                                    onChanged: searchStaff,
                                                    style: TextStyle(
                                                        fontSize: 14.sp,
                                                        color: grey),
                                                    cursorColor: grey,
                                                    decoration: InputDecoration(
                                                        fillColor: const Color
                                                            .fromARGB(
                                                            255, 226, 104, 159),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          214,
                                                                          51,
                                                                          123,
                                                                          0.6),
                                                                  width: 2.0),
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
                                                            EdgeInsets.all(
                                                                15.w)),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        space20H,
                                        SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                          width: 1.sw * 4.1,
                                                          height: 50.h,
                                                          child: Row(
                                                            children: [
                                                              SizedBox(
                                                                width: 200.w,
                                                                child: TextApp(
                                                                  text:
                                                                      'TÊN NHÂN VIÊN',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontsize:
                                                                      14.sp,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  color:
                                                                      greyText,
                                                                ),
                                                              ),
                                                              // space50W,
                                                              space35W,
                                                              SizedBox(
                                                                width: 150.w,
                                                                // color: Colors.pink,
                                                                child: TextApp(
                                                                  text:
                                                                      'CHỨC VỤ',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontsize:
                                                                      14.sp,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  color:
                                                                      greyText,
                                                                ),
                                                              ),
                                                              space35W,
                                                              SizedBox(
                                                                width: 250.w,
                                                                // color: Colors.purple,
                                                                child: TextApp(
                                                                  text:
                                                                      'LÀM VIỆC TẠI CỬA HÀNG',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontsize:
                                                                      14.sp,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  color:
                                                                      greyText,
                                                                ),
                                                              ),
                                                              space35W,
                                                              SizedBox(
                                                                width: 150.w,
                                                                // color: Colors.orange,
                                                                child: TextApp(
                                                                  text:
                                                                      'TRẠNG THÁI',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontsize:
                                                                      14.sp,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  color:
                                                                      greyText,
                                                                ),
                                                              ),
                                                              space35W,
                                                              SizedBox(
                                                                width: 150.w,
                                                                // color: Colors.lime,
                                                                child: TextApp(
                                                                  text:
                                                                      'SỐ ĐIỆN THOẠI',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontsize:
                                                                      14.sp,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  color:
                                                                      greyText,
                                                                ),
                                                              ),
                                                              space35W,
                                                              SizedBox(
                                                                width: 250.w,
                                                                // color: Colors.blueGrey,
                                                                child: TextApp(
                                                                  text: 'EMAIL',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontsize:
                                                                      14.sp,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  color:
                                                                      greyText,
                                                                ),
                                                              ),
                                                              space35W,
                                                              SizedBox(
                                                                width: 200.w,
                                                                // color: Colors.deepOrange,
                                                                child: TextApp(
                                                                  text:
                                                                      'NGÀY TẠO',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontsize:
                                                                      14.sp,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  color:
                                                                      greyText,
                                                                ),
                                                              ),
                                                              space35W,
                                                              SizedBox(
                                                                width: 150.w,
                                                                // color: Colors.green,
                                                                child: TextApp(
                                                                  text: '',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  fontsize:
                                                                      14.sp,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  color:
                                                                      greyText,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width: 1.sw * 4.1,
                                                      height: 400.h,
                                                      child: ListView.builder(
                                                          shrinkWrap: true,
                                                          controller:
                                                              scrollListStaffController,
                                                          physics:
                                                              const ClampingScrollPhysics(),
                                                          itemCount:
                                                              currentStaffList
                                                                      .length +
                                                                  1,
                                                          itemBuilder:
                                                              (context, index) {
                                                            var dataLength =
                                                                currentStaffList
                                                                    .length;
                                                            if (index <
                                                                dataLength) {
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
                                                                  : intPosition ==
                                                                          2
                                                                      ? "Trưởng nhóm"
                                                                      : intPosition ==
                                                                              3
                                                                          ? "Quản lý"
                                                                          : intPosition == 4
                                                                              ? "Kế toán"
                                                                              : "Đầu bếp";
                                                              return Theme(
                                                                  data: Theme.of(
                                                                          context)
                                                                      .copyWith(
                                                                          dividerColor:
                                                                              Colors.transparent),
                                                                  child: Column(
                                                                    children: [
                                                                      space10H,
                                                                      Row(
                                                                          crossAxisAlignment: CrossAxisAlignment
                                                                              .center,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: [
                                                                            IntrinsicHeight(
                                                                              child: Container(
                                                                                width: 200.w,
                                                                                child: Row(
                                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  children: [
                                                                                    Container(
                                                                                      width: 80.w,
                                                                                      height: 80.w,
                                                                                      // color: Colors.amber,
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
                                                                                    // space5W,
                                                                                    SizedBox(
                                                                                      width: 100.w,
                                                                                      child: TextApp(
                                                                                        isOverFlow: false,
                                                                                        softWrap: true,
                                                                                        text: staffData.staffFullName ?? '',
                                                                                        fontsize: 14.sp,
                                                                                        color: blueText,
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            space35W,
                                                                            Container(
                                                                              width: 150.w,
                                                                              // color:
                                                                              //     Colors.red,
                                                                              child: TextApp(
                                                                                textAlign: TextAlign.center,
                                                                                isOverFlow: false,
                                                                                softWrap: true,
                                                                                text: staffPos,
                                                                                fontsize: 14.sp,
                                                                              ),
                                                                            ),
                                                                            space35W,
                                                                            SizedBox(
                                                                              width: 250.w,
                                                                              child: TextApp(
                                                                                textAlign: TextAlign.center,
                                                                                isOverFlow: false,
                                                                                softWrap: true,
                                                                                text: staffData.storeName,
                                                                                fontsize: 14.sp,
                                                                              ),
                                                                            ),
                                                                            space35W,
                                                                            SizedBox(
                                                                              width: 150.w,
                                                                              child: Center(child: staffData.activeFlg == 1 ? StatusBoxIsActive() : StatusBoxIsLock()),
                                                                            ),
                                                                            space35W,
                                                                            SizedBox(
                                                                              width: 150.w,
                                                                              child: TextApp(
                                                                                textAlign: TextAlign.center,
                                                                                isOverFlow: false,
                                                                                softWrap: true,
                                                                                text: staffData.staffPhone.toString(),
                                                                                fontsize: 14.sp,
                                                                              ),
                                                                            ),
                                                                            space35W,
                                                                            Center(
                                                                              child: SizedBox(
                                                                                width: 250.w,
                                                                                child: TextApp(
                                                                                  textAlign: TextAlign.center,
                                                                                  isOverFlow: false,
                                                                                  softWrap: true,
                                                                                  text: staffData.staffEmail ?? '',
                                                                                  fontsize: 14.sp,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            space35W,
                                                                            Center(
                                                                              child: SizedBox(
                                                                                width: 200.w,
                                                                                child: TextApp(
                                                                                  textAlign: TextAlign.center,
                                                                                  isOverFlow: false,
                                                                                  softWrap: true,
                                                                                  text: formatDateTime(staffData.createdAt ?? ''),
                                                                                  fontsize: 14.sp,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            space35W,
                                                                            Center(
                                                                              child: SizedBox(
                                                                                width: 150.w,
                                                                                child: Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [
                                                                                  SizedBox(
                                                                                    // width: 100.w,
                                                                                    height: 30.h,
                                                                                    child: ButtonIcon(
                                                                                        isIconCircle: false,
                                                                                        color1: color2BlueButton,
                                                                                        color2: color1BlueButton,
                                                                                        event: () {
                                                                                          Navigator.push(
                                                                                            navigatorKey.currentContext!,
                                                                                            MaterialPageRoute(
                                                                                                builder: (context) => EditStaffInformation(
                                                                                                      staffNo: staffData.staffNo.toString(),
                                                                                                    )),
                                                                                          );
                                                                                          // handleGetDetailsFood(foodID: product.foodId ?? 0);
                                                                                        },
                                                                                        icon: Icons.edit),
                                                                                  ),
                                                                                  space15W,
                                                                                  SizedBox(
                                                                                    // width: 100.w,
                                                                                    height: 30.h,
                                                                                    child: ButtonIcon(
                                                                                        isIconCircle: false,
                                                                                        color1: color2OrangeButton,
                                                                                        color2: color1OrganeButton,
                                                                                        event: () {
                                                                                          showConfirmDialog(context, () {
                                                                                            handleChangeStatusStaff(staffNo: staffData.staffNo.toString());
                                                                                          });
                                                                                          // handleGetDetailsFood(foodID: product.foodId ?? 0);
                                                                                        },
                                                                                        icon: Icons.lock),
                                                                                  ),
                                                                                ]),
                                                                              ),
                                                                            ),
                                                                          ]),
                                                                      space10H,
                                                                      Divider(),
                                                                    ],
                                                                  ));
                                                            } else {
                                                              return Center(
                                                                child: hasMore
                                                                    ? CircularProgressIndicator()
                                                                    : Container(),
                                                              );
                                                            }
                                                          }),
                                                    )
                                                  ],
                                                )
                                              ],
                                            )),
                                      ],
                                    ),
                                  )),
                              space30H,
                              CopyRightText()
                            ],
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
