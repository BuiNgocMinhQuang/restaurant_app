import 'dart:convert';
import 'dart:developer';
import 'package:app_restaurant/config/date_time_format.dart';
import 'package:app_restaurant/config/void_show_dialog.dart';
import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/config/space.dart';
import 'package:app_restaurant/config/text.dart';
import 'package:app_restaurant/model/manager/manager_list_food_model.dart';
import 'package:app_restaurant/routers/app_router_config.dart';
import 'package:app_restaurant/screen/manager/food_menu/edit_food.dart';
import 'package:app_restaurant/utils/storage.dart';
import 'package:app_restaurant/widgets/button/button_gradient.dart';
import 'package:app_restaurant/widgets/box/status_box.dart';
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
import 'package:money_formatter/money_formatter.dart';
import 'package:app_restaurant/model/manager/manager_list_store_model.dart';
import 'package:app_restaurant/model/manager/food/details_food_model.dart';
import 'dart:math' as math;

List<String> listState = ["Tất cả", "Đang hoạt động", "Đã chặn"];

class ListFoodManager extends StatefulWidget {
  final List<DataListStore> listStores;

  const ListFoodManager({Key? key, required this.listStores}) : super(key: key);

  @override
  State<ListFoodManager> createState() => _ListFoodManagerState();
}

class _ListFoodManagerState extends State<ListFoodManager> {
  final TextEditingController _dateStartController = TextEditingController();
  final TextEditingController _dateEndController = TextEditingController();
  final searchController = TextEditingController();
  final stateFilterTextController = TextEditingController();
  final scrollListFoodController = ScrollController();
  int currentPage = 1;
  List currentFoodList = [];
  String query = '';
  bool hasMore = true;
  bool isRefesh = false;
  DetailsFoodModel? detailsFoodData;
  int? selectedFlag;
  String? selectedFlitterFlag = 'Tất cả';
  bool isLoading = true;
  bool isError = false;
  void searchProduct(String query) {
    mounted
        ? setState(() {
            this.query = query;
            currentPage = 1;
          })
        : null;
    currentFoodList.clear();
    loadMoreMenuFood(
      page: currentPage,
      keywords: query,
      filtersFlg: selectedFlag,
    );
  }

  void handleGetDetailsFood({required int foodID}) async {
    try {
      var token = StorageUtils.instance.getString(key: 'token_manager');

      final respons = await http.post(
        Uri.parse('$baseUrl$getDetailsFood'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({'is_api': true, 'food_id': foodID}),
      );
      final data = jsonDecode(respons.body);
      try {
        if (data['status'] == 200) {
          mounted
              ? setState(() {
                  detailsFoodData = DetailsFoodModel.fromJson(data);
                })
              : null;
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EditFood(
                      detailsDataFood: detailsFoodData,
                      listStores: widget.listStores,
                    )),
          );
        } else {
          print("ERROR DETAILS  FOOD 1");
          showCustomDialogModal(
              context: navigatorKey.currentContext,
              textDesc: "Có lỗi xảy ra",
              title: "Thất bại",
              colorButton: Colors.red,
              btnText: "OK",
              typeDialog: "error");
        }
      } catch (error) {
        print("ERROR DETAILS  FOOD 2 $error");
        showCustomDialogModal(
            context: navigatorKey.currentContext,
            textDesc: "Có lỗi xảy ra",
            title: "Thất bại",
            colorButton: Colors.red,
            btnText: "OK",
            typeDialog: "error");
      }
    } catch (error) {
      print("ERROR DETAILS  FOOD 3 $error");
      showCustomDialogModal(
          context: navigatorKey.currentContext,
          textDesc: "Có lỗi xảy ra",
          title: "Thất bại",
          colorButton: Colors.red,
          btnText: "OK",
          typeDialog: "error");
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
      mounted
          ? setState(() {
              _dateStartController.text = picked.toString().split(" ")[0];

              refeshListFood(
                  page: 1,
                  dateStart: _dateStartController.text,
                  dateEnd: _dateEndController.text);
            })
          : null;
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
              refeshListFood(
                  page: 1,
                  dateStart: _dateStartController.text,
                  dateEnd: _dateEndController.text);
            })
          : null;
    }
  }

  void handleDeleteFood({required String foodID}) async {
    try {
      var token = StorageUtils.instance.getString(key: 'token_manager');

      final respons = await http.post(
        Uri.parse('$baseUrl$deleteFood'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({'is_api': true, 'key': foodID}),
      );
      final data = jsonDecode(respons.body);
      print("GET DATA LIST FOOD ${data}");
      try {
        if (data['status'] == 200) {
          showCustomDialogModal(
            typeDialog: "succes",
            context: navigatorKey.currentContext,
            textDesc: "Xoá món thành công",
            title: "Thành công",
            colorButton: Colors.green,
            btnText: "OK",
          );
          currentFoodList.clear();
          currentPage = 1;
          loadMoreMenuFood(
              page: currentPage, keywords: query, filtersFlg: selectedFlag);
        } else {
          print("ERROR LIST FOOOD RECEIPT PAGE 1");
          showCustomDialogModal(
              context: navigatorKey.currentContext,
              textDesc: "Có lỗi xảy ra",
              title: "Thất bại",
              colorButton: Colors.red,
              btnText: "OK",
              typeDialog: "error");
        }
      } catch (error) {
        print("ERROR BROUGHT RECEIPT PAGE 2 $error");
        showCustomDialogModal(
            context: navigatorKey.currentContext,
            textDesc: "Có lỗi xảy ra",
            title: "Thất bại",
            colorButton: Colors.red,
            btnText: "OK",
            typeDialog: "error");
      }
    } catch (error) {
      print("ERROR BROUGHT RECEIPT PAGE 3 $error");
      showCustomDialogModal(
          context: navigatorKey.currentContext,
          textDesc: "Có lỗi xảy ra",
          title: "Thất bại",
          colorButton: Colors.red,
          btnText: "OK",
          typeDialog: "error");
    }
  }

  void loadMoreMenuFood({
    required int page,
    String? keywords,
    List<int>? foodKinds,
    int? filtersFlg,
    int? activeFlg,
    String? dateStart,
    String? dateEnd,
  }) async {
    try {
      var token = StorageUtils.instance.getString(key: 'token_manager');

      final respons = await http.post(
        Uri.parse('$baseUrl$managerGetListFood'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          'client': 'user',
          'is_api': true,
          'limit': 15,
          'page': page,
          'filters': {
            "keywords": keywords,
            "food_kinds": foodKinds,
            "pay_flg": filtersFlg,
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
                  var listMenuPageRes = ManagerListFoodModel.fromJson(data);
                  currentFoodList.addAll(listMenuPageRes.data.data);
                  currentPage++;
                  isRefesh = false;

                  if (listMenuPageRes.data.data.isEmpty ||
                      listMenuPageRes.data.data.length <= 15) {
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

  void refeshListFood({
    required int page,
    String? keywords,
    List<int>? foodKinds,
    int? filtersFlg,
    int? activeFlg,
    String? dateStart,
    String? dateEnd,
  }) async {
    try {
      var token = StorageUtils.instance.getString(key: 'token_manager');

      final respons = await http.post(
        Uri.parse('$baseUrl$managerGetListFood'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          'client': 'user',
          'is_api': true,
          'limit': 15,
          'page': page,
          'filters': {
            "keywords": keywords,
            "food_kinds": foodKinds,
            "pay_flg": filtersFlg,
            "active_flg": activeFlg,
            "date_range": {"start_date": dateStart, "end_date": dateEnd}
          },
        }),
      );
      final data = jsonDecode(respons.body);
      print("GET DATA LIST FOOD ${data}");
      try {
        if (data['status'] == 200) {
          mounted
              ? setState(() {
                  currentFoodList.clear();
                  var listMenuPageRes = ManagerListFoodModel.fromJson(data);
                  currentFoodList.addAll(listMenuPageRes.data.data);
                  isRefesh = true;
                })
              : null;
        } else {
          print("ERROR LIST FOOOD RECEIPT PAGE 1");
        }
      } catch (error) {
        print("ERROR BROUGHT RECEIPT PAGE 2 $error");
      }
    } catch (error) {
      print("ERROR BROUGHT RECEIPT PAGE 3 $error");
    }
  }

  @override
  void initState() {
    super.initState();
    loadMoreMenuFood(page: 1, filtersFlg: null);
    scrollListFoodController.addListener(() {
      if (scrollListFoodController.position.maxScrollExtent ==
              scrollListFoodController.offset &&
          isRefesh == false) {
        loadMoreMenuFood(
            page: currentPage, keywords: query, filtersFlg: selectedFlag);
      }
    });
  }

  @override
  void dispose() {
    scrollListFoodController.dispose();
    _dateStartController.dispose();
    _dateEndController.dispose();
    searchController.dispose();
    stateFilterTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List filterProducts = currentFoodList.where((product) {
      final foodTitle = product.foodName.toLowerCase();
      final input = query.toLowerCase();
      return (foodTitle.contains(input));
    }).toList();
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
                              loadMoreMenuFood(page: 1, filtersFlg: null);
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
                      refeshListFood(page: 1, filtersFlg: null);
                    },
                    child: SlidableAutoCloseBehavior(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          // Close any open slidable when tapping outside
                          log("TAP CLOSE");
                          Slidable.of(context)?.close();
                        },
                        child: Container(
                          width: 1.sw,
                          color: Colors.white,
                          child: SingleChildScrollView(
                            controller: scrollListFoodController,
                            child: Padding(
                              padding: EdgeInsets.zero,
                              child: Container(
                                width: 1.sw,
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
                                          //     offset: const Offset(0,
                                          //         3), // changes position of shadow
                                          //   ),
                                          // ],
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(20.w),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  TextApp(
                                                      text: "Tất cả món ăn",
                                                      fontsize: 18.sp,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: blueText),
                                                  space10H,
                                                  SizedBox(
                                                    width: 1.sw,
                                                    child: TextApp(
                                                      isOverFlow: false,
                                                      softWrap: true,
                                                      text: allYourFoodHere,
                                                      fontsize: 14.sp,
                                                      color: blueText
                                                          .withOpacity(0.6),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              space40H,
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
                                                        space10H,
                                                        TextField(
                                                          onTapOutside:
                                                              (event) {
                                                            FocusManager
                                                                .instance
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
                                                                      const Icon(
                                                                          Icons
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
                                                                        BorderRadius.circular(
                                                                            8.r),
                                                                  ),
                                                                  border:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
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
                                                  space20W,
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
                                                        space10H,
                                                        TextField(
                                                          onTapOutside:
                                                              (event) {
                                                            FocusManager
                                                                .instance
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
                                                                      const Icon(
                                                                          Icons
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
                                                                        BorderRadius.circular(
                                                                            8.r),
                                                                  ),
                                                                  border:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
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
                                              space20H,
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
                                                          fontsize: 12.sp,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: blueText,
                                                        ),
                                                        space10H,
                                                        TextFormField(
                                                          readOnly: true,
                                                          onTapOutside:
                                                              (event) {
                                                            FocusManager
                                                                .instance
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
                                                                      Container(
                                                                height:
                                                                    1.sh / 2,
                                                                child: Column(
                                                                  children: [
                                                                    Container(
                                                                      width:
                                                                          1.sw,
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
                                                                            FontWeight.bold,
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      child: ListView
                                                                          .builder(
                                                                        padding:
                                                                            EdgeInsets.only(top: 10.w),
                                                                        itemCount:
                                                                            listState.length,
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
                                                                                            selectedFlitterFlag = listState[index];
                                                                                            currentPage = 1;
                                                                                          })
                                                                                        : null;
                                                                                    var hehe = index;
                                                                                    // var hehe = listState.indexOf(
                                                                                    //             changeFlag ??
                                                                                    //                 '') ==
                                                                                    //         0
                                                                                    //     ? null
                                                                                    //     : listState.indexOf(changeFlag ??
                                                                                    //                 '') ==
                                                                                    //             2
                                                                                    //         ? 0
                                                                                    //         : listState.indexOf(
                                                                                    //             changeFlag ??
                                                                                    //                 '');
                                                                                    currentFoodList.clear();

                                                                                    loadMoreMenuFood(
                                                                                      page: currentPage,
                                                                                      keywords: query,
                                                                                      activeFlg: hehe == 0 ? null : hehe,
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
                                                              fontSize: 12.sp,
                                                              color: grey),
                                                          cursorColor: grey,
                                                          validator: (value) {
                                                            if (value!
                                                                .isEmpty) {
                                                              return fullnameIsRequied;
                                                            } else {
                                                              return null;
                                                            }
                                                          },
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
                                                                        BorderRadius.circular(
                                                                            8.r),
                                                                  ),
                                                                  border:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
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
                                                                      size:
                                                                          28.sp,
                                                                      color: Colors
                                                                          .black
                                                                          .withOpacity(
                                                                              0.5),
                                                                    ),
                                                                  ),
                                                                  isDense: true,
                                                                  contentPadding:
                                                                      EdgeInsets
                                                                          .all(15
                                                                              .w)),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  space20W,
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
                                                          fontsize: 12.sp,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: blueText,
                                                        ),
                                                        space10H,
                                                        TextFormField(
                                                          onTapOutside:
                                                              (event) {
                                                            FocusManager
                                                                .instance
                                                                .primaryFocus
                                                                ?.unfocus();
                                                          },
                                                          onChanged:
                                                              searchProduct,
                                                          controller:
                                                              searchController,
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
                                                                        BorderRadius.circular(
                                                                            8.r),
                                                                  ),
                                                                  border:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.r),
                                                                  ),
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
                                              space20H,
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
                                                            filterProducts
                                                                    .length +
                                                                1,
                                                        itemBuilder:
                                                            (context, index) {
                                                          if (index <
                                                              filterProducts
                                                                  .length) {
                                                            DataFoodAllStore
                                                                product =
                                                                filterProducts[
                                                                    index];
                                                            var imagePath1 =
                                                                filterProducts[
                                                                        index]
                                                                    ?.foodImages;
                                                            var listImagePath =
                                                                jsonDecode(
                                                                    imagePath1);
                                                            return Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                const Divider(
                                                                  height: 1,
                                                                ),
                                                                space5H,
                                                                Slidable(
                                                                  // Specify a key if the Slidable is dismissible.
                                                                  key: ValueKey(
                                                                      filterProducts[
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
                                                                          handleGetDetailsFood(
                                                                              foodID: product.foodId ?? 0);
                                                                        },
                                                                        backgroundColor:
                                                                            Colors.black,
                                                                        foregroundColor:
                                                                            Colors.white,
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
                                                                            handleDeleteFood(foodID: product.foodId.toString());
                                                                          });
                                                                        },
                                                                        backgroundColor:
                                                                            Colors.black,
                                                                        foregroundColor:
                                                                            Colors.white,
                                                                        icon: Icons
                                                                            .delete,
                                                                        label:
                                                                            'Xoá',
                                                                      ),
                                                                    ],
                                                                  ),

                                                                  // The end action pane is the one at the right or the bottom side.

                                                                  // The child of the Slidable is what the user sees when the
                                                                  // component is not dragged.
                                                                  child: ListTile(
                                                                      contentPadding: EdgeInsets.zero,
                                                                      minVerticalPadding: 0,
                                                                      horizontalTitleGap: 0,
                                                                      title: Container(
                                                                        width: 1
                                                                            .sw,
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
                                                                              width: 100.w,
                                                                              height: 100.w,
                                                                              child: listImagePath == null
                                                                                  ? ClipRRect(
                                                                                      borderRadius: BorderRadius.circular(8.r),
                                                                                      child: Image.asset(
                                                                                        'assets/images/dish.png',
                                                                                        fit: BoxFit.contain,
                                                                                      ))
                                                                                  : ClipRRect(
                                                                                      borderRadius: BorderRadius.circular(8.r),
                                                                                      child: CachedNetworkImage(
                                                                                        fit: BoxFit.fill,
                                                                                        imageUrl: httpImage + listImagePath[0],
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
                                                                              width: 10.w,
                                                                            ),
                                                                            Container(
                                                                              child: Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                children: [
                                                                                  Row(
                                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    children: [
                                                                                      Container(
                                                                                        // color: Colors.white,
                                                                                        width: 180.w,
                                                                                        child: TextApp(
                                                                                          isOverFlow: false,
                                                                                          softWrap: true,
                                                                                          text: product.foodName ?? '',
                                                                                          fontsize: 14.sp,
                                                                                          color: blueText,
                                                                                          fontWeight: FontWeight.bold,
                                                                                        ),
                                                                                      ),
                                                                                      product.activeFlg == 1 ? const StatusBoxIsSelling() : const StatusBoxNoMoreSelling()
                                                                                    ],
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: 10.h,
                                                                                  ),
                                                                                  Row(
                                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    children: [
                                                                                      Container(
                                                                                        // color: Colors.green,
                                                                                        width: 120.w,
                                                                                        child: TextApp(
                                                                                          isOverFlow: false,
                                                                                          softWrap: true,
                                                                                          text: product.storeName ?? '',
                                                                                          fontsize: 14.sp,
                                                                                        ),
                                                                                      ),
                                                                                      Container(
                                                                                        // color: Theme.of(context).colorScheme.primary,
                                                                                        width: 120.w,
                                                                                        child: TextApp(
                                                                                          isOverFlow: false,
                                                                                          softWrap: true,
                                                                                          text: "${MoneyFormatter(amount: (product.foodPrice ?? 0).toDouble()).output.withoutFractionDigits.toString()} đ",
                                                                                          fontsize: 14.sp,
                                                                                          textAlign: TextAlign.end,
                                                                                          fontWeight: FontWeight.bold,
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: 10.h,
                                                                                  ),
                                                                                  Row(
                                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    children: [
                                                                                      TextApp(
                                                                                        isOverFlow: false,
                                                                                        softWrap: true,
                                                                                        text: "Ngày tạo: ",
                                                                                        fontsize: 14.sp,
                                                                                        textAlign: TextAlign.start,
                                                                                        fontWeight: FontWeight.bold,
                                                                                      ),
                                                                                      space5W,
                                                                                      SizedBox(
                                                                                        width: 150.w,
                                                                                        child: TextApp(
                                                                                          isOverFlow: false,
                                                                                          softWrap: true,
                                                                                          text: formatDateTime(product.createdAt ?? ''),
                                                                                          fontsize: 14.sp,
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
                                                                space5H,
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
                                  ],
                                ),
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
