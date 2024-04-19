import 'dart:convert';

import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/config/space.dart';
import 'package:app_restaurant/model/manager/chart/chart_data_each_store_model.dart';
import 'package:app_restaurant/model/manager/chart/chart_data_home_model.dart';
import 'package:app_restaurant/model/manager/home/home_data_model.dart';
import 'package:app_restaurant/model/manager/store/details_stores_model.dart';
import 'package:app_restaurant/routers/app_router_config.dart';
import 'package:app_restaurant/screen/manager/store/details_store.dart';
import 'package:app_restaurant/utils/storage.dart';
import 'package:app_restaurant/widgets/button/button_gradient.dart';
import 'package:app_restaurant/widgets/chart/chart_home_all_store.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:app_restaurant/env/index.dart';
import 'package:app_restaurant/constant/api/index.dart';
import 'package:money_formatter/money_formatter.dart';

class ManagerHome extends StatefulWidget {
  const ManagerHome({super.key});

  @override
  State<ManagerHome> createState() => _ManagerHomeState();
}

class _ManagerHomeState extends State<ManagerHome> {
  final scrollListStrore = ScrollController();

  HomeDataModel? dataHome;
  DetailsStoreModel? dataDetailsStoreModel;
  final loailistKey = GlobalKey<DropdownSearchState>();
  TextEditingController _dateStartController = TextEditingController();
  TextEditingController _dateEndController = TextEditingController();
  String currentDataType = "%d-%m-%Y";
  ChartDataHomeModel? chartDataModel;

  List<String> loaiList = [
    "Ngày",
    "Tháng",
    "Năm",
  ];
  void handleGetDataHome() async {
    try {
      var token = StorageUtils.instance.getString(key: 'token_manager');
      final respons = await http.post(
        Uri.parse('$baseUrl$mangaerDataHome'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          'is_api': true,
        }),
      );
      final data = jsonDecode(respons.body);
      print(" DATA HOME ${data}");
      try {
        if (data['status'] == 200) {
          setState(() {
            dataHome = HomeDataModel.fromJson(data);
          });
        } else {
          print("ERROR GET DATA HOME");
        }
      } catch (error) {
        print("ERROR GET DATA HOME $error");
      }
    } catch (error) {
      print("ERROR GET DATA HOME $error");
    }
  }

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
      // handleGetChartData(
      //     chartWith: currentChartWith,
      //     shopID: widget.shopID,
      //     startDate: _dateStartController.text,
      //     endDate: _dateEndController.text,
      //     dataType: currentDataType);
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
      // handleGetChartData(
      //     chartWith: currentChartWith,
      //     shopID: widget.shopID,
      //     startDate: _dateStartController.text,
      //     endDate: _dateEndController.text,
      //     dataType: currentDataType);
    }
  }

  void getDetailsStore({required shopID}) async {
    print({
      'shopID': shopID,
    });
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
      print(" DATA CREATE FOOD ${data}");
      try {
        if (data['status'] == 200) {
          // var hahah = DetailsStoreModel.fromJson(data);
          setState(() {
            dataDetailsStoreModel = DetailsStoreModel.fromJson(data);
          });
          Navigator.push(
            navigatorKey.currentContext!,
            MaterialPageRoute(
                builder: (context) => DetailsStore(
                      detailsStoreModel: dataDetailsStoreModel,
                    )),
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

  void handleGetChartDataHome(
      {required String? startDate,
      required String? endDate,
      required String dataType}) async {
    try {
      var token = StorageUtils.instance.getString(key: 'token_manager');

      final respons = await http.post(
        Uri.parse('$baseUrl$managerChartHome'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          'filters': {
            'date_range': {"start_date": startDate, "end_date": endDate}
          },
          'date_type': dataType,
          'is_api': true
        }),
      );
      final data = jsonDecode(respons.body);
      print(" DATA CHART HOME ${data}");
      try {
        if (data['status'] == 200) {
          setState(() {
            chartDataModel = ChartDataHomeModel.fromJson(data);
          });
        } else {
          print("ERROR DATA CHART HOME");
        }
      } catch (error) {
        print("ERROR DATA CHART HOME $error");
      }
    } catch (error) {
      print("ERROR DATA CHART HOME $error");
    }
  }

  void handleGetInitData() async {
    handleGetDataHome();
    handleGetChartDataHome(
        startDate: _dateStartController.text,
        endDate: _dateEndController.text,
        dataType: currentDataType);
  }

  @override
  void initState() {
    super.initState();
    handleGetInitData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: RefreshIndicator(
      color: Colors.blue,
      onRefresh: () async {
        handleGetDataHome();
      },
      child: Container(
        width: 1.sw,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.only(
                  top: 20.w, left: 20.w, right: 20.w, bottom: 20.w),
              child: Column(
                children: [
                  TextApp(
                    text: "Thống kê chung",
                    fontsize: 22.sp,
                    color: menuGrey,
                    fontWeight: FontWeight.bold,
                  ),
                  space35H,
                  Container(
                      width: 1.sw,
                      // height: 100.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.r),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 4,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Padding(
                          padding: EdgeInsets.all(20.w),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextApp(
                                    text: "Tổng tiền thu được",
                                    fontsize: 14.sp,
                                    color: menuGrey,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  TextApp(
                                    text:
                                        "${MoneyFormatter(amount: (dataHome?.orderTotal ?? 0).toDouble()).output.withoutFractionDigits.toString()} đ",
                                    fontsize: 20.sp,
                                    color: blueText2,
                                    fontWeight: FontWeight.bold,
                                  )
                                ],
                              ),
                              InkWell(
                                onTap: () {},
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  color: Colors.amber,
                                ),
                              )
                            ],
                          ))),
                  space20H,
                  Container(
                      width: 1.sw,
                      // height: 100.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.r),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 4,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Padding(
                          padding: EdgeInsets.all(20.w),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextApp(
                                    text: "Tổng số nhân viên",
                                    fontsize: 14.sp,
                                    color: menuGrey,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  TextApp(
                                    text:
                                        dataHome?.staffTotal.toString() ?? '0',
                                    fontsize: 20.sp,
                                    color: blueText2,
                                    fontWeight: FontWeight.bold,
                                  )
                                ],
                              ),
                              Container(
                                width: 50,
                                height: 50,
                                color: Colors.amber,
                              )
                            ],
                          ))),
                  space20H,
                  Container(
                      width: 1.sw,
                      // height: 100.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.r),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 4,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Padding(
                          padding: EdgeInsets.all(20.w),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextApp(
                                    text: "Số đơn thành công",
                                    fontsize: 14.sp,
                                    color: menuGrey,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  TextApp(
                                    text: dataHome?.orderTotalSuccess
                                            .toString() ??
                                        '0',
                                    fontsize: 20.sp,
                                    color: blueText2,
                                    fontWeight: FontWeight.bold,
                                  )
                                ],
                              ),
                              Container(
                                width: 50,
                                height: 50,
                                color: Colors.amber,
                              )
                            ],
                          ))),
                  space20H,
                  Container(
                      width: 1.sw,
                      // height: 100.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.r),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 4,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Padding(
                          padding: EdgeInsets.all(20.w),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextApp(
                                    text: "Số đơn bị huỷ",
                                    fontsize: 14.sp,
                                    color: menuGrey,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  TextApp(
                                    text:
                                        dataHome?.orderTotalClose.toString() ??
                                            '0',
                                    fontsize: 20.sp,
                                    color: blueText2,
                                    fontWeight: FontWeight.bold,
                                  )
                                ],
                              ),
                              Container(
                                width: 50,
                                height: 50,
                                color: Colors.amber,
                              )
                            ],
                          ))),
                  space20H,
                  Container(
                      width: 1.sw,
                      // height: 100.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.r),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 4,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          space20H,
                          TextApp(
                            text: "Các cửa hàng của bạn",
                            fontsize: 16.sp,
                            color: blueText2,
                            fontWeight: FontWeight.bold,
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      width: 1.sw * 1.7,
                                      // height: 300.h,
                                      padding: EdgeInsets.all(20.w),
                                      child: ListView.builder(
                                          controller: scrollListStrore,
                                          physics:
                                              const ClampingScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount:
                                              (dataHome?.stores.length ?? 0) +
                                                  1,
                                          itemBuilder: (context, index) {
                                            var dataLenght =
                                                dataHome?.stores.length ?? 0;
                                            if (index < dataLenght) {
                                              DetailsStoreHome storeData =
                                                  dataHome!.stores[index];
                                              var imagePath1 =
                                                  storeData.storeImages;
                                              var listImagePath =
                                                  jsonDecode(imagePath1);
                                              return Theme(
                                                data: Theme.of(context)
                                                    .copyWith(
                                                        dividerColor:
                                                            Colors.transparent),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: 150.w,
                                                      height: 100.w,
                                                      // color: Colors.amber,
                                                      child: CachedNetworkImage(
                                                        fit: BoxFit.fill,
                                                        imageUrl: httpImage +
                                                            listImagePath[0],
                                                        placeholder:
                                                            (context, url) =>
                                                                SizedBox(
                                                          height: 10.w,
                                                          width: 10.w,
                                                          child: const Center(
                                                              child:
                                                                  CircularProgressIndicator()),
                                                        ),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            const Icon(
                                                                Icons.error),
                                                      ),
                                                    ),
                                                    space15W,
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        TextApp(
                                                          isOverFlow: false,
                                                          softWrap: true,
                                                          text: 'Địa chỉ: ',
                                                          fontsize: 14.sp,
                                                        ),
                                                        Container(
                                                          width: 150.w,
                                                          child: TextApp(
                                                            isOverFlow: false,
                                                            softWrap: true,
                                                            text: storeData
                                                                .storeAddress,
                                                            fontsize: 14.sp,
                                                            color: blueText,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    space15W,
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          width: 100.w,
                                                          child: TextApp(
                                                            isOverFlow: false,
                                                            softWrap: true,
                                                            text: 'Nhân viên',
                                                            fontsize: 14.sp,
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 100.w,
                                                          child: TextApp(
                                                            isOverFlow: false,
                                                            softWrap: true,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            text: storeData
                                                                .staffsCount
                                                                .toString(),
                                                            fontsize: 14.sp,
                                                            color: blueText,
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    space15W,
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          width: 100.w,
                                                          child: TextApp(
                                                            isOverFlow: false,
                                                            softWrap: true,
                                                            text: 'Tổng tiền',
                                                            fontsize: 14.sp,
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 100.w,
                                                          child: TextApp(
                                                            isOverFlow: false,
                                                            softWrap: true,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            text:
                                                                "${MoneyFormatter(amount: (storeData.ordersSumOrderTotal ?? 0).toDouble()).output.withoutFractionDigits.toString()} đ",
                                                            fontsize: 14.sp,
                                                            color: blueText,
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    space15W,
                                                    Container(
                                                      width: 100.w,
                                                      height: 30.w,
                                                      child: ButtonGradient(
                                                        color1:
                                                            color1BlueButton,
                                                        color2:
                                                            color2BlueButton,
                                                        event: () {
                                                          getDetailsStore(
                                                              shopID: storeData
                                                                  .shopId);
                                                        },
                                                        text: "Chi tiết",
                                                        fontSize: 12.sp,
                                                        radius: 8.r,
                                                        textColor: Colors.white,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              );
                                            } else {
                                              return Container();
                                            }
                                          }),
                                    )
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      )),
                  space30H,
                  Container(
                    width: 1.sw,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.r),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        space10H,
                        TextApp(
                          text: "Biểu đồ thu nhập",
                          fontsize: 16.sp,
                          color: blueText2,
                          fontWeight: FontWeight.bold,
                        ),
                        Row(
                          children: [
                            space10W,
                            Flexible(
                              fit: FlexFit.tight,
                              child: Column(
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
                                      var haha =
                                          loaiList.indexOf(loaiListIndex ?? '');
                                      if (haha == 0) {
                                        // setState(() {
                                        //   currentDataType = "%d-%m-%Y";
                                        // });
                                      } else if (haha == 2) {
                                        // setState(() {
                                        //   currentDataType = "%Y";
                                        // });
                                      } else {
                                        // setState(() {
                                        //   currentDataType = "%m-%Y";
                                        // });
                                      }
                                      // handleGetChartData(
                                      //     chartWith: currentChartWith,
                                      //     shopID: widget.shopID,
                                      //     startDate: _dateStartController.text,
                                      //     endDate: _dateEndController.text,
                                      //     dataType: currentDataType);
                                    },
                                    items: loaiList,
                                    dropdownDecoratorProps:
                                        DropDownDecoratorProps(
                                      dropdownSearchDecoration: InputDecoration(
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
                                        isDense: true,
                                        contentPadding: EdgeInsets.all(15.w),
                                      ),
                                    ),
                                    // onChanged: print,
                                    selectedItem: loaiList[1],
                                  ),
                                ],
                              ),
                            ),
                            space20W,
                            Flexible(
                              fit: FlexFit.tight,
                              child: Column(
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
                                    controller: _dateStartController,
                                    onTap: selectDayStart,
                                    style:
                                        TextStyle(fontSize: 14.sp, color: grey),
                                    cursorColor: grey,
                                    decoration: InputDecoration(
                                        suffixIcon: Icon(Icons.calendar_month),
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
                              child: Column(
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
                                    controller: _dateEndController,
                                    onTap: selectDayEnd,
                                    style:
                                        TextStyle(fontSize: 14.sp, color: grey),
                                    cursorColor: grey,
                                    decoration: InputDecoration(
                                        suffixIcon: Icon(Icons.calendar_month),
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
                                        hintText: 'dd/mm/yy',
                                        isDense: true,
                                        contentPadding: EdgeInsets.all(15.w)),
                                  ),
                                ],
                              ),
                            ),
                            space10W,
                          ],
                        ),
                        chartDataModel != null
                            ? Container(
                                width: 1.sw,
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(left: 0.w, right: 00.w),
                                  child: ChartHomeAllStore(
                                      chartDataModel: chartDataModel!),
                                ),
                              )
                            : Container()
                      ],
                    ),
                  )
                ],
              )),
        ),
      ),
    )));
  }
}
