import 'dart:convert';
import 'dart:developer';
import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/config/space.dart';
import 'package:app_restaurant/model/manager/chart/chart_data_each_store_model.dart';
import 'package:app_restaurant/utils/storage.dart';
import 'package:app_restaurant/widgets/button/button_app.dart';
import 'package:app_restaurant/widgets/chart/chart_each_store.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:app_restaurant/env/index.dart';
import 'package:app_restaurant/constant/api/index.dart';

class OverviewChartDialog extends StatefulWidget {
  final String shopID;

  OverviewChartDialog({
    Key? key,
    required this.shopID,
  }) : super(key: key);
  @override
  State<OverviewChartDialog> createState() => _OverviewChartDialogState();
}

class _OverviewChartDialogState extends State<OverviewChartDialog> {
  TextEditingController _dateStartController = TextEditingController();
  TextEditingController _dateEndController = TextEditingController();
  final bieudotheolistKey = GlobalKey<DropdownSearchState>();
  final loailistKey = GlobalKey<DropdownSearchState>();
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
      print(" DATA CHART ${data}");
      try {
        if (data['status'] == 200) {
          setState(() {
            chartDataModel = ChartDataModel.fromJson(data);
            isShowChart = true;
          });
        } else {
          print("ERROR DATA CHART");
        }
      } catch (error) {
        print("ERROR DATA CHART $error");
      }
    } catch (error) {
      print("ERROR DATA CHART $error");
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
      setState(() {
        _dateStartController.text = picked.toString().split(" ")[0];
      });
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
      setState(() {
        _dateEndController.text = picked.toString().split(" ")[0];
      });
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
      contentPadding: const EdgeInsets.all(0),
      surfaceTintColor: Colors.white,
      backgroundColor: Colors.white,
      content: Padding(
        padding: EdgeInsets.only(left: 10.w, right: 10.w),
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
                space15H,
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
                            fontsize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: blueText,
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          DropdownSearch(
                            key: bieudotheolistKey,
                            // validator: (value) {
                            //   if (value == chooseStore) {
                            //     return canNotNull;
                            //   }
                            //   return null;
                            // },
                            onChanged: (bieudotheoListIndex) {
                              var hehe = bieudotheoList
                                  .indexOf(bieudotheoListIndex ?? '');
                              setState(() {
                                currentChartWith = hehe;
                              });
                              // currentFoodKind =
                              //     categories.indexOf(foodKindIndex ?? '');
                              handleGetChartData(
                                  chartWith: currentChartWith,
                                  shopID: widget.shopID,
                                  startDate: _dateStartController.text,
                                  endDate: _dateEndController.text,
                                  dataType: currentDataType);
                            },
                            items: bieudotheoList,
                            dropdownDecoratorProps: DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
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
                                isDense: true,
                                contentPadding: EdgeInsets.all(15.w),
                              ),
                            ),
                            // onChanged: print,
                            selectedItem: bieudotheoList[0],
                          ),
                        ],
                      ),
                    ),
                    space20W,
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextApp(
                            text: " Loại",
                            fontsize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: blueText,
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          DropdownSearch(
                            key: loailistKey,
                            onChanged: (loaiListIndex) {
                              var haha = loaiList.indexOf(loaiListIndex ?? '');
                              if (haha == 0) {
                                setState(() {
                                  currentDataType = "%d-%m-%Y";
                                });
                              } else if (haha == 2) {
                                setState(() {
                                  currentDataType = "%Y";
                                });
                              } else {
                                setState(() {
                                  currentDataType = "%m-%Y";
                                });
                              }
                              handleGetChartData(
                                  chartWith: currentChartWith,
                                  shopID: widget.shopID,
                                  startDate: _dateStartController.text,
                                  endDate: _dateEndController.text,
                                  dataType: currentDataType);
                            },
                            items: loaiList,
                            dropdownDecoratorProps: DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
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
                                isDense: true,
                                contentPadding: EdgeInsets.all(15.w),
                              ),
                            ),
                            // onChanged: print,
                            selectedItem: loaiList[1],
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
                                suffixIcon: Icon(Icons.calendar_month),
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
                    space20W,
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
                                suffixIcon: Icon(Icons.calendar_month),
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
                space30H,
                isShowChart
                    ? Container(
                        width: 1.sw,
                        child: Padding(
                          padding: EdgeInsets.only(left: 0.w, right: 00.w),
                          child:
                              BarChartSample4(chartDataModel: chartDataModel!),
                        ),
                      )
                    : Container(),
                space20H,
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
