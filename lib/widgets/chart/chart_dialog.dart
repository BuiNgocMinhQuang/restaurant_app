import 'dart:convert';
import 'dart:developer';
import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/model/manager/chart/chart_data_each_store_model.dart';
import 'package:app_restaurant/utils/storage.dart';
import 'package:app_restaurant/widgets/button/button_app.dart';
import 'package:app_restaurant/widgets/chart/chart_each_store.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:app_restaurant/env/index.dart';
import 'package:app_restaurant/constant/api/index.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'dart:math' as math;

class OverviewChartDialog extends StatefulWidget {
  final String shopID;

  const OverviewChartDialog({
    Key? key,
    required this.shopID,
  }) : super(key: key);
  @override
  State<OverviewChartDialog> createState() => _OverviewChartDialogState();
}

class _OverviewChartDialogState extends State<OverviewChartDialog> {
  final TextEditingController _dateStartController = TextEditingController();
  final TextEditingController _dateEndController = TextEditingController();
  final billTypeTextController = TextEditingController();
  final timeTypeTextController = TextEditingController();

  int currentChartWith = 0;
  String currentDataType = "%m-%Y";
  ChartDataModel? chartDataModel;
  bool isShowChart = false;
  @override
  void initState() {
    super.initState();

    initEndDay();
    initStartDay();
    handleGetChartData(
        chartWith: 0,
        shopID: widget.shopID,
        startDate: _dateStartController.text,
        endDate: _dateEndController.text,
        dataType: currentDataType);
  }

  @override
  void dispose() {
    _dateStartController.dispose();
    _dateEndController.dispose();
    billTypeTextController.dispose();
    timeTypeTextController.dispose();
    super.dispose();
  }

  void initEndDay() async {
    _dateEndController.text = DateTime.now().toString().split(" ")[0];
  }

  void initStartDay() async {
    DateTime now = DateTime.now();
    DateTime firstDayOfYear = DateTime(now.year, 1, 1);
    _dateStartController.text = firstDayOfYear.toString().split(" ")[0];
  }

  void handleGetChartData({
    required int chartWith,
    required String? startDate,
    required String? endDate,
    required String shopID,
    required String dataType // theo thang nam
    //theo ngay thang nam "%d-%m-%Y"
    //theo nam "%Y",
    ,
  }) async {
    log({
      'chart_with': chartWith,
      'filters': {
        'date_range': {"start_date": startDate, "end_date": endDate}
      },
      'shop_id': shopID,
      'date_type': dataType,
      'is_api': true
    }.toString());
    try {
      var token = StorageUtils.instance.getString(key: 'token_manager');

      final respons = await http.post(
        Uri.parse('$baseUrl$getChartData'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          'chart_with': chartWith,
          'filters': {
            'date_range': {"start_date": startDate, "end_date": endDate}
          },
          'shop_id': shopID,
          'date_type': dataType,
          'is_api': true
        }),
      );
      final data = jsonDecode(respons.body);
      log(" DATA CHART $data");
      try {
        if (data['status'] == 200) {
          mounted
              ? setState(() {
                  chartDataModel = ChartDataModel.fromJson(data);
                  isShowChart = true;
                })
              : null;
        } else {
          log("ERROR DATA CHART");
        }
      } catch (error) {
        log("ERROR DATA CHART $error");
      }
    } catch (error) {
      log("ERROR DATA CHART $error");
    }
  }

  List<String> bieudotheoList = [
    "Tất cả hoá đơn",
    "Hoá đơn tại quán",
    "Hoá đơn mang về",
    "Phòng",
    "Bàn",
  ];
  List<String> loaiList = [
    "Theo ngày",
    "Theo tháng",
    "Theo năm",
  ];
  void selectDayStart() async {
    DateTime? picked = await showDatePicker(
        helpText: 'Chọn ngày bắt đầu',
        cancelText: 'Huỷ',
        confirmText: 'Xác nhận',
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2025),
        builder: (context, child) => Theme(
              data: ThemeData().copyWith(
                  colorScheme: const ColorScheme.dark(
                      primary: Colors.black,
                      onPrimary: Colors.white,
                      onSurface: Colors.black,
                      surface: Colors.white),
                  dialogBackgroundColor: Colors.green),
              child: child ?? Container(),
            ));

    if (picked != null) {
      mounted
          ? setState(() {
              _dateStartController.text = picked.toString().split(" ")[0];
            })
          : null;
      handleGetChartData(
          chartWith: currentChartWith,
          shopID: widget.shopID,
          startDate: _dateStartController.text,
          endDate: _dateEndController.text,
          dataType: currentDataType);
    }
  }

  void selectDayEnd() async {
    DateTime? picked = await showDatePicker(
        helpText: 'Chọn ngày kết thúc',
        cancelText: 'Huỷ',
        confirmText: 'Xác nhận',
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2025),
        builder: (context, child) => Theme(
              data: ThemeData().copyWith(
                  colorScheme: const ColorScheme.dark(
                      primary: Colors.black,
                      onPrimary: Colors.white,
                      onSurface: Colors.black,
                      surface: Colors.white),
                  dialogBackgroundColor: Colors.green),
              child: child ?? Container(),
            ));
    if (picked != null) {
      mounted
          ? setState(() {
              _dateEndController.text = picked.toString().split(" ")[0];
            })
          : null;
      handleGetChartData(
          chartWith: currentChartWith,
          shopID: widget.shopID,
          startDate: _dateStartController.text,
          endDate: _dateEndController.text,
          dataType: currentDataType);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      surfaceTintColor: Colors.white,
      backgroundColor: Colors.white,
      insetPadding:
          EdgeInsets.only(left: 20.w, right: 20.w, top: 30.w, bottom: 10.w),
      content: Padding(
        padding: EdgeInsets.all(10.w),
        child: Container(
            width: 1.sw,
            // height: 1.sh,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              color: Colors.white,
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.w),
                  child: Container(
                      width: 1.sw,
                      height: 50,
                      decoration: BoxDecoration(
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
                                padding: EdgeInsets.only(left: 10.w),
                                child: TextApp(
                                  text: "Biểu đồ tổng quan",
                                  fontsize: 18.sp,
                                  color: blueText,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ],
                      )),
                ),
                const Divider(
                  height: 1,
                  color: Colors.black,
                ),
                SizedBox(
                  height: 15.h,
                ),
                Row(
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextApp(
                            text: " Biểu đồ theo",
                            fontsize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: blueText,
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          TextFormField(
                            readOnly: true,
                            onTapOutside: (event) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            onTap: () {
                              showMaterialModalBottomSheet(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(15.r),
                                    topLeft: Radius.circular(15.r),
                                  ),
                                ),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                context: context,
                                builder: (context) => SizedBox(
                                  height: 1.sh / 2,
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 1.sw,
                                        padding: EdgeInsets.all(20.w),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        child: TextApp(
                                          text: "Chọn loại",
                                          color: Colors.white,
                                          fontsize: 20.sp,
                                          fontWeight: FontWeight.bold,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Expanded(
                                        child: ListView.builder(
                                          padding: EdgeInsets.only(top: 10.w),
                                          itemCount: bieudotheoList.length,
                                          itemBuilder: (context, index) {
                                            return Column(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 20.w),
                                                  child: InkWell(
                                                    onTap: () async {
                                                      Navigator.pop(context);

                                                      var hehe = index;
                                                      mounted
                                                          ? setState(() {
                                                              currentChartWith =
                                                                  hehe;
                                                              billTypeTextController
                                                                      .text =
                                                                  bieudotheoList[
                                                                      index];
                                                            })
                                                          : null;
                                                      // currentFoodKind =
                                                      //     categories.indexOf(foodKindIndex ?? '');
                                                      handleGetChartData(
                                                          chartWith:
                                                              currentChartWith,
                                                          shopID: widget.shopID,
                                                          startDate:
                                                              _dateStartController
                                                                  .text,
                                                          endDate:
                                                              _dateEndController
                                                                  .text,
                                                          dataType:
                                                              currentDataType);
                                                    },
                                                    child: Row(
                                                      children: [
                                                        TextApp(
                                                          text: bieudotheoList[
                                                              index],
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
                            controller: billTypeTextController,
                            style:
                                TextStyle(fontSize: 14.sp, color: Colors.black),
                            cursorColor: grey,
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
                                hintText: bieudotheoList[0],
                                suffixIcon: Transform.rotate(
                                  angle: 90 * math.pi / 180,
                                  child: Icon(
                                    Icons.chevron_right,
                                    size: 28.sp,
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                ),
                                hintStyle:
                                    TextStyle(fontSize: 14.sp, color: grey),
                                isDense: true,
                                contentPadding: EdgeInsets.all(20.w)),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextApp(
                            text: " Loại",
                            fontsize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: blueText,
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          TextFormField(
                            readOnly: true,
                            onTapOutside: (event) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            onTap: () {
                              showMaterialModalBottomSheet(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(15.r),
                                    topLeft: Radius.circular(15.r),
                                  ),
                                ),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                context: context,
                                builder: (context) => SizedBox(
                                  height: 1.sh / 2,
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 1.sw,
                                        padding: EdgeInsets.all(20.w),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        child: TextApp(
                                          text: "Chọn loại",
                                          color: Colors.white,
                                          fontsize: 20.sp,
                                          fontWeight: FontWeight.bold,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Expanded(
                                        child: ListView.builder(
                                          padding: EdgeInsets.only(top: 10.w),
                                          itemCount: loaiList.length,
                                          itemBuilder: (context, index) {
                                            return Column(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 20.w),
                                                  child: InkWell(
                                                    onTap: () async {
                                                      Navigator.pop(context);
                                                      mounted
                                                          ? setState(() {
                                                              timeTypeTextController
                                                                      .text =
                                                                  loaiList[
                                                                      index];
                                                            })
                                                          : null;
                                                      var haha = index;
                                                      if (haha == 0) {
                                                        mounted
                                                            ? setState(() {
                                                                currentDataType =
                                                                    "%d-%m-%Y";
                                                              })
                                                            : null;
                                                      } else if (haha == 2) {
                                                        mounted
                                                            ? setState(() {
                                                                currentDataType =
                                                                    "%Y";
                                                              })
                                                            : null;
                                                      } else {
                                                        mounted
                                                            ? setState(() {
                                                                currentDataType =
                                                                    "%m-%Y";
                                                              })
                                                            : null;
                                                      }
                                                      handleGetChartData(
                                                          chartWith:
                                                              currentChartWith,
                                                          shopID: widget.shopID,
                                                          startDate:
                                                              _dateStartController
                                                                  .text,
                                                          endDate:
                                                              _dateEndController
                                                                  .text,
                                                          dataType:
                                                              currentDataType);
                                                    },
                                                    child: Row(
                                                      children: [
                                                        TextApp(
                                                          text: loaiList[index],
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
                            controller: timeTypeTextController,
                            style:
                                TextStyle(fontSize: 14.sp, color: Colors.black),
                            cursorColor: grey,
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
                                hintText: loaiList[1],
                                suffixIcon: Transform.rotate(
                                  angle: 90 * math.pi / 180,
                                  child: Icon(
                                    Icons.chevron_right,
                                    size: 28.sp,
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                ),
                                isDense: true,
                                hintStyle:
                                    TextStyle(fontSize: 14.sp, color: grey),
                                contentPadding: EdgeInsets.all(20.w)),
                          )
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
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                            onTapOutside: (event) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            readOnly: true,
                            controller: _dateStartController,
                            onTap: selectDayStart,
                            style: TextStyle(fontSize: 14.sp, color: grey),
                            cursorColor: grey,
                            decoration: InputDecoration(
                                suffixIcon: const Icon(Icons.calendar_month),
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
                                hintText: 'dd/mm/yy',
                                isDense: true,
                                contentPadding: EdgeInsets.all(15.w)),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                            onTapOutside: (event) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            readOnly: true,
                            controller: _dateEndController,
                            onTap: selectDayEnd,
                            style: TextStyle(fontSize: 14.sp, color: grey),
                            cursorColor: grey,
                            decoration: InputDecoration(
                                suffixIcon: const Icon(Icons.calendar_month),
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
                                hintText: 'dd/mm/yy',
                                isDense: true,
                                contentPadding: EdgeInsets.all(15.w)),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 30.h,
                ),
                isShowChart
                    ? SizedBox(
                        width: 1.sw,
                        child: Padding(
                          padding: EdgeInsets.only(left: 0.w, right: 00.w),
                          child:
                              BarChartSample4(chartDataModel: chartDataModel!),
                        ),
                      )
                    : Container(),
                Container(
                  width: 1.sw,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15.w),
                        bottomRight: Radius.circular(15.w)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ButtonApp(
                        event: () {
                          Navigator.of(context).pop();
                        },
                        text: "Đóng",
                        colorText: Colors.white,
                        backgroundColor: const Color.fromRGBO(131, 146, 171, 1),
                        outlineColor: const Color.fromRGBO(131, 146, 171, 1),
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
