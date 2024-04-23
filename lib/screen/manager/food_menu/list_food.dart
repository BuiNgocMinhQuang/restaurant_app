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
import 'package:app_restaurant/widgets/button/button_icon.dart';
import 'package:app_restaurant/widgets/box/status_box.dart';
import 'package:app_restaurant/widgets/text/copy_right_text.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:app_restaurant/env/index.dart';
import 'package:app_restaurant/constant/api/index.dart';
import 'package:lottie/lottie.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:app_restaurant/model/manager/manager_list_store_model.dart';
import 'package:app_restaurant/model/manager/food/details_food_model.dart';

List<String> listState = ["Tất cả", "Đang hoạt động", "Đã chặn"];

class ListFoodManager extends StatefulWidget {
  final List<DataListStore> listStores;

  const ListFoodManager({Key? key, required this.listStores}) : super(key: key);

  @override
  State<ListFoodManager> createState() => _ListFoodManagerState();
}

class _ListFoodManagerState extends State<ListFoodManager> {
  TextEditingController _dateStartController = TextEditingController();
  TextEditingController _dateEndController = TextEditingController();
  final searchController = TextEditingController();
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
    setState(() {
      this.query = query;
      currentPage = 1;
    });
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
      print("GET DETAILS  FOOD ${data}");
      try {
        if (data['status'] == 200) {
          setState(() {
            detailsFoodData = DetailsFoodModel.fromJson(data);
          });
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EditFood(
                      //  foodID: product.foodId,
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
      setState(() {
        _dateStartController.text = picked.toString().split(" ")[0];

        refeshListFood(
            page: 1,
            dateStart: _dateStartController.text,
            dateEnd: _dateEndController.text);
      });
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
        refeshListFood(
            page: 1,
            dateStart: _dateStartController.text,
            dateEnd: _dateEndController.text);
      });
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
    // setState(() {
    //   isLoading = true;
    //   isError = false;
    // });
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
          setState(() {
            var listMenuPageRes = ManagerListFoodModel.fromJson(data);
            currentFoodList.addAll(listMenuPageRes.data.data);
            currentPage++;
            isRefesh = false;

            if (listMenuPageRes.data.data.isEmpty ||
                listMenuPageRes.data.data.length <= 15) {
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
          setState(() {
            currentFoodList.clear();
            var listMenuPageRes = ManagerListFoodModel.fromJson(data);
            currentFoodList.addAll(listMenuPageRes.data.data);
            isRefesh = true;
          });
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
                    color: Colors.blue,
                    onRefresh: () async {
                      refeshListFood(page: 1, filtersFlg: null);
                    },
                    child: Container(
                      width: 1.sw,
                      color: Colors.white,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.all(20.w),
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
                                      borderRadius: BorderRadius.circular(15.r),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: const Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
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
                                                  fontWeight: FontWeight.bold,
                                                  color: blueText),
                                              space10H,
                                              SizedBox(
                                                width: 1.sw,
                                                child: TextApp(
                                                  isOverFlow: false,
                                                  softWrap: true,
                                                  text: allYourFoodHere,
                                                  fontsize: 14.sp,
                                                  color:
                                                      blueText.withOpacity(0.6),
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
                                                      CrossAxisAlignment.start,
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
                                                              suffixIcon: Icon(Icons
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
                                                      CrossAxisAlignment.start,
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
                                                              suffixIcon: Icon(Icons
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
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    TextApp(
                                                      text: " Trạng thái",
                                                      fontsize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: blueText,
                                                    ),
                                                    SizedBox(
                                                      height: 10.h,
                                                    ),
                                                    DropdownSearch(
                                                      items: listState,
                                                      onChanged: (changeFlag) {
                                                        setState(() {
                                                          selectedFlitterFlag =
                                                              changeFlag;
                                                          currentPage = 1;
                                                        });
                                                        var hehe = listState.indexOf(
                                                                    changeFlag ??
                                                                        '') ==
                                                                0
                                                            ? null
                                                            : listState.indexOf(
                                                                        changeFlag ??
                                                                            '') ==
                                                                    2
                                                                ? 0
                                                                : listState.indexOf(
                                                                    changeFlag ??
                                                                        '');
                                                        currentFoodList.clear();

                                                        loadMoreMenuFood(
                                                          page: currentPage,
                                                          keywords: query,
                                                          activeFlg: hehe,
                                                        );
                                                      },
                                                      dropdownDecoratorProps:
                                                          DropDownDecoratorProps(
                                                        dropdownSearchDecoration:
                                                            InputDecoration(
                                                          fillColor: const Color
                                                              .fromARGB(255,
                                                              226, 104, 159),
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
                                                      selectedItem:
                                                          selectedFlitterFlag,
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: blueText,
                                                    ),
                                                    SizedBox(
                                                      height: 10.h,
                                                    ),
                                                    TextFormField(
                                                      onTapOutside: (event) {
                                                        FocusManager.instance
                                                            .primaryFocus
                                                            ?.unfocus();
                                                      },
                                                      onChanged: searchProduct,
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
                                                            width: 1.sw * 2.6,
                                                            height: 50.h,
                                                            child: Row(
                                                              children: [
                                                                SizedBox(
                                                                  width: 200.w,
                                                                  child:
                                                                      TextApp(
                                                                    text:
                                                                        'MÓN ĂN',
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
                                                                  width: 180.w,
                                                                  child:
                                                                      TextApp(
                                                                    text:
                                                                        'CỬA HÀNG',
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
                                                                space25W,
                                                                SizedBox(
                                                                  width: 120.w,
                                                                  child:
                                                                      TextApp(
                                                                    text:
                                                                        'GIÁ TIỀN',
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
                                                                  child:
                                                                      TextApp(
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
                                                                  child:
                                                                      TextApp(
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
                                                                  child:
                                                                      TextApp(
                                                                    text: '',
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
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        width: 1.sw * 2.6,
                                                        height: 400.h,
                                                        child: ListView.builder(
                                                            physics:
                                                                const ClampingScrollPhysics(),
                                                            controller:
                                                                scrollListFoodController,
                                                            shrinkWrap: true,
                                                            itemCount:
                                                                filterProducts
                                                                        .length +
                                                                    1,
                                                            itemBuilder:
                                                                (BuildContext
                                                                        context,
                                                                    int index) {
                                                              var dataLength =
                                                                  filterProducts
                                                                      .length;

                                                              if (index <
                                                                  dataLength) {
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

                                                                return Theme(
                                                                    data: Theme.of(
                                                                            context)
                                                                        .copyWith(
                                                                            dividerColor: Colors
                                                                                .transparent),
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        space10H,
                                                                        Row(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: [
                                                                            IntrinsicHeight(
                                                                              child: SizedBox(
                                                                                width: 250.w,
                                                                                child: Row(
                                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  children: [
                                                                                    SizedBox(
                                                                                      width: 80.w,
                                                                                      height: 80.w,
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
                                                                                    space10W,
                                                                                    SizedBox(
                                                                                      width: 150.w,
                                                                                      child: TextApp(
                                                                                        isOverFlow: false,
                                                                                        softWrap: true,
                                                                                        text: product.foodName ?? '',
                                                                                        fontsize: 14.sp,
                                                                                        color: blueText,
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            space35W,
                                                                            SizedBox(
                                                                              width: 150.w,
                                                                              child: TextApp(
                                                                                isOverFlow: false,
                                                                                softWrap: true,
                                                                                text: product.storeName ?? '',
                                                                                fontsize: 14.sp,
                                                                              ),
                                                                            ),
                                                                            space35W,
                                                                            SizedBox(
                                                                              width: 120.w,
                                                                              child: TextApp(
                                                                                isOverFlow: false,
                                                                                softWrap: true,
                                                                                text: "${MoneyFormatter(amount: (product.foodPrice ?? 0).toDouble()).output.withoutFractionDigits.toString()} đ",
                                                                                fontsize: 14.sp,
                                                                              ),
                                                                            ),
                                                                            Container(
                                                                              width: 150.w,
                                                                              child: Center(child: product.activeFlg == 1 ? StatusBoxIsSelling() : StatusBoxNoMoreSelling()),
                                                                            ),
                                                                            space50W,
                                                                            Center(
                                                                              child: SizedBox(
                                                                                width: 200.w,
                                                                                child: TextApp(
                                                                                  isOverFlow: false,
                                                                                  softWrap: true,
                                                                                  text: formatDateTime(product.createdAt ?? ''),
                                                                                  fontsize: 14.sp,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Row(
                                                                              children: [
                                                                                SizedBox(
                                                                                  height: 30.h,
                                                                                  child: ButtonIcon(
                                                                                      isIconCircle: false,
                                                                                      color1: const Color.fromRGBO(23, 193, 232, 1),
                                                                                      color2: const Color.fromRGBO(23, 193, 232, 1),
                                                                                      event: () {
                                                                                        handleGetDetailsFood(foodID: product.foodId ?? 0);
                                                                                      },
                                                                                      icon: Icons.edit),
                                                                                ),
                                                                                space15W,
                                                                                SizedBox(
                                                                                  height: 30.h,
                                                                                  child: ButtonIcon(
                                                                                      isIconCircle: false,
                                                                                      color1: const Color.fromRGBO(234, 6, 6, 1),
                                                                                      color2: const Color.fromRGBO(234, 6, 6, 1),
                                                                                      event: () {
                                                                                        showConfirmDialog(context, () {
                                                                                          handleDeleteFood(foodID: product.foodId.toString());
                                                                                        });
                                                                                      },
                                                                                      icon: Icons.delete),
                                                                                )
                                                                              ],
                                                                            )
                                                                          ],
                                                                        ),
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
                                                ]),
                                          )
                                        ],
                                      ),
                                    )),
                                space30H,
                                const CopyRightText()
                              ],
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
