import 'dart:convert';
import 'dart:developer';
import 'package:app_restaurant/bloc/manager/manager_login/manager_login_bloc.dart';
import 'package:app_restaurant/config/colors.dart';
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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:app_restaurant/env/index.dart';
import 'package:app_restaurant/constant/api/index.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:money_formatter/money_formatter.dart';
import 'dart:math' as math;

class ManagerHome extends StatefulWidget {
  const ManagerHome({super.key});

  @override
  State<ManagerHome> createState() => _ManagerHomeState();
}

class _ManagerHomeState extends State<ManagerHome> {
  final scrollListStrore = ScrollController();

  HomeDataModel? dataHome;
  DetailsStoreModel? dataDetailsStoreModel;
  final TextEditingController _dateStartController = TextEditingController();
  final TextEditingController _dateEndController = TextEditingController();
  final TextEditingController dataTypeTextController = TextEditingController();

  String currentDataType = "%m-%Y";
  ChartDataHomeModel? chartDataModel;
  bool isLoading = true;
  bool isError = false;
  bool hasMore = false;
  List<String> loaiList = [
    "Ngày",
    "Tháng",
    "Năm",
  ];
  void hanldeLogOut() async {
    BlocProvider.of<ManagerLoginBloc>(context).add(const ManagerLogout());
  }

  void handleGetDataHome() async {
    mounted
        ? setState(() {
            isLoading = true;
            isError = false;
          })
        : null;
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
      try {
        if (data['status'] == 200) {
          mounted
              ? setState(() {
                  dataHome = HomeDataModel.fromJson(data);
                  handleGetChartDataHome(
                      startDate: _dateStartController.text,
                      endDate: _dateEndController.text,
                      dataType: currentDataType);
                })
              : null;
          Future.delayed(const Duration(milliseconds: 1000), () {
            mounted
                ? setState(() {
                    isLoading = false;
                  })
                : null;
          });
        } else if (data['status'] == 401) {
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
          // hanldeLogOut();
          navigatorKey.currentContext?.go('/');
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
              handleGetChartDataHome(
                  startDate: _dateStartController.text,
                  endDate: _dateEndController.text,
                  dataType: currentDataType);
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
              handleGetChartDataHome(
                  startDate: _dateStartController.text,
                  endDate: _dateEndController.text,
                  dataType: currentDataType);
            })
          : null;
    }
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
      try {
        if (data['status'] == 200) {
          mounted
              ? setState(() {
                  dataDetailsStoreModel = DetailsStoreModel.fromJson(data);
                })
              : null;
          Navigator.push(
            navigatorKey.currentContext!,
            MaterialPageRoute(
                builder: (context) => DetailsStore(
                      detailsStoreModel: dataDetailsStoreModel,
                    )),
          );
        } else {
          log("ERROR getDetailsStore 1");
        }
      } catch (error) {
        log("ERROR getDetailsStore 2 $error");
      }
    } catch (error) {
      log("ERROR getDetailsStore 3 $error");
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
      try {
        if (data['status'] == 200) {
          mounted
              ? setState(() {
                  chartDataModel = ChartDataHomeModel.fromJson(data);
                })
              : null;
        } else {
          log("ERROR handleGetChartDataHome 1");
        }
      } catch (error) {
        log("ERROR handleGetChartDataHome 2 $error");
      }
    } catch (error) {
      log("ERROR handleGetChartDataHome 3 $error");
    }
  }

  @override
  void initState() {
    handleGetDataHome();
    super.initState();
  }

  @override
  void dispose() {
    _dateStartController.dispose();
    _dateEndController.dispose();
    dataTypeTextController.dispose();
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
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: Lottie.asset('assets/lottie/error.json'),
                        ),
                        SizedBox(height: 30.h),
                        TextApp(
                          text: "Có lỗi xảy ra, vui lòng thử lại sau",
                          fontsize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(height: 30.h),
                        SizedBox(
                          width: 200,
                          child: ButtonGradient(
                            color1: color1BlueButton,
                            color2: color2BlueButton,
                            event: () {
                              handleGetDataHome();
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
                      handleGetDataHome();
                    },
                    child: Container(
                      width: 1.sw,
                      color: Colors.white,
                      child: SlidableAutoCloseBehavior(
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            // Close any open slidable when tapping outside
                            Slidable.of(context)?.close();
                          },
                          child: SingleChildScrollView(
                            child: Padding(
                                padding: EdgeInsets.only(
                                    top: 20.w,
                                    left: 20.w,
                                    right: 20.w,
                                    bottom: 20.w),
                                child: Column(
                                  children: [
                                    TextApp(
                                      text: "Thống kê chung",
                                      fontsize: 22.sp,
                                      color: menuGrey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    SizedBox(
                                      height: 35.h,
                                    ),
                                    Container(
                                        width: 1.sw,
                                        // height: 100.h,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15.r),
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
                                        ),
                                        child: Padding(
                                            padding: EdgeInsets.all(20.w),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    TextApp(
                                                      text:
                                                          "Tổng tiền thu được",
                                                      fontsize: 14.sp,
                                                      color: menuGrey,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                                    TextApp(
                                                      text:
                                                          "${MoneyFormatter(amount: (dataHome?.orderTotal ?? 0).toDouble()).output.withoutFractionDigits.toString()} đ",
                                                      fontsize: 20.sp,
                                                      color: blueText2,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    )
                                                  ],
                                                ),
                                                InkWell(
                                                  onTap: () {},
                                                  child: SizedBox(
                                                      width: 50,
                                                      height: 50,
                                                      // color: Colors.amber,
                                                      child: SvgPicture.asset(
                                                        'assets/svg/incomes.svg',
                                                        fit: BoxFit.contain,
                                                      )),
                                                )
                                              ],
                                            ))),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    Container(
                                        width: 1.sw,
                                        // height: 100.h,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15.r),
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
                                        ),
                                        child: Padding(
                                            padding: EdgeInsets.all(20.w),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    TextApp(
                                                      text: "Tổng số nhân viên",
                                                      fontsize: 14.sp,
                                                      color: menuGrey,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                                    TextApp(
                                                      text: dataHome?.staffTotal
                                                              .toString() ??
                                                          '0',
                                                      fontsize: 20.sp,
                                                      color: blueText2,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                    width: 50,
                                                    height: 50,
                                                    child: SvgPicture.asset(
                                                      'assets/svg/staff_gr.svg',
                                                      fit: BoxFit.contain,
                                                    ))
                                              ],
                                            ))),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    Container(
                                        width: 1.sw,
                                        // height: 100.h,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15.r),
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
                                        ),
                                        child: Padding(
                                            padding: EdgeInsets.all(20.w),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    TextApp(
                                                      text: "Số đơn thành công",
                                                      fontsize: 14.sp,
                                                      color: menuGrey,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                                    TextApp(
                                                      text: dataHome
                                                              ?.orderTotalSuccess
                                                              .toString() ??
                                                          '0',
                                                      fontsize: 20.sp,
                                                      color: blueText2,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: 50,
                                                  height: 50,
                                                  child: SvgPicture.asset(
                                                    'assets/svg/comeplete_receipt.svg',
                                                    fit: BoxFit.contain,
                                                  ),
                                                )
                                              ],
                                            ))),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    Container(
                                        width: 1.sw,
                                        // height: 100.h,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15.r),
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
                                        ),
                                        child: Padding(
                                            padding: EdgeInsets.all(20.w),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    TextApp(
                                                      text: "Số đơn bị huỷ",
                                                      fontsize: 14.sp,
                                                      color: menuGrey,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                                    TextApp(
                                                      text: dataHome
                                                              ?.orderTotalClose
                                                              .toString() ??
                                                          '0',
                                                      fontsize: 20.sp,
                                                      color: blueText2,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                    width: 50,
                                                    height: 50,
                                                    child: SvgPicture.asset(
                                                      'assets/svg/cancle_receipt.svg',
                                                      fit: BoxFit.contain,
                                                    ))
                                              ],
                                            ))),
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
                                          height: 20.h,
                                        ),
                                        TextApp(
                                          text: "Các cửa hàng của bạn",
                                          fontsize: 16.sp,
                                          color: blueText2,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        SizedBox(
                                          height: 20.h,
                                        ),
                                        SizedBox(
                                          width: 1.sw,
                                          child: ListView.builder(
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount:
                                                  (dataHome?.stores.length ??
                                                          0) +
                                                      1,
                                              itemBuilder: (context, index) {
                                                var dataLenght =
                                                    dataHome?.stores.length ??
                                                        0;
                                                if (index < dataLenght) {
                                                  DetailsStoreHome storeData =
                                                      dataHome!.stores[index];
                                                  var logoImageStore =
                                                      storeData.storeLogo;

                                                  return Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      const Divider(
                                                        height: 1,
                                                      ),
                                                      SizedBox(
                                                        height: 5.h,
                                                      ),
                                                      Slidable(
                                                        // Specify a key if the Slidable is dismissible.
                                                        key: ValueKey(dataHome!
                                                            .stores[index]),

                                                        // The start action pane is the one at the left or the top side.
                                                        endActionPane:
                                                            ActionPane(
                                                          extentRatio: 0.3,
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
                                                                getDetailsStore(
                                                                    shopID: storeData
                                                                        .shopId);
                                                              },
                                                              backgroundColor:
                                                                  Colors.black,
                                                              foregroundColor:
                                                                  Colors.white,
                                                              icon: Icons
                                                                  .more_horiz_outlined,
                                                              label: 'Chi tiết',
                                                            ),
                                                          ],
                                                        ),

                                                        // The end action pane is the one at the right or the bottom side.

                                                        // The child of the Slidable is what the user sees when the
                                                        // component is not dragged.
                                                        child: ListTile(
                                                            contentPadding:
                                                                EdgeInsets.zero,
                                                            minVerticalPadding:
                                                                0,
                                                            horizontalTitleGap:
                                                                0,
                                                            title: Container(
                                                              width: 1.sw,
                                                              color:
                                                                  Colors.white,
                                                              child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  SizedBox(
                                                                    width:
                                                                        140.w,
                                                                    height:
                                                                        100.w,
                                                                    child: logoImageStore ==
                                                                            null
                                                                        ? ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(8.r),
                                                                            child: SvgPicture.asset(
                                                                              'assets/svg/store_icon.svg',
                                                                              fit: BoxFit.contain,
                                                                            ))
                                                                        : ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(8.r),
                                                                            child:
                                                                                CachedNetworkImage(
                                                                              fit: BoxFit.fill,
                                                                              imageUrl: httpImage + logoImageStore,
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
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Row(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        children: [
                                                                          TextApp(
                                                                            isOverFlow:
                                                                                false,
                                                                            softWrap:
                                                                                true,
                                                                            text:
                                                                                "Địa chỉ: ",
                                                                            fontsize:
                                                                                14.sp,
                                                                            textAlign:
                                                                                TextAlign.start,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                5.w,
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                150.w,
                                                                            child:
                                                                                TextApp(
                                                                              isOverFlow: false,
                                                                              softWrap: true,
                                                                              text: storeData.storeAddress ?? '',
                                                                              fontsize: 14.sp,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Row(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        children: [
                                                                          TextApp(
                                                                            isOverFlow:
                                                                                false,
                                                                            softWrap:
                                                                                true,
                                                                            text:
                                                                                "Nhân viên: ",
                                                                            fontsize:
                                                                                14.sp,
                                                                            textAlign:
                                                                                TextAlign.start,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                5.w,
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                150.w,
                                                                            child:
                                                                                TextApp(
                                                                              isOverFlow: false,
                                                                              softWrap: true,
                                                                              text: storeData.staffsCount.toString(),
                                                                              fontsize: 14.sp,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Row(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        children: [
                                                                          TextApp(
                                                                            isOverFlow:
                                                                                false,
                                                                            softWrap:
                                                                                true,
                                                                            text:
                                                                                "Tổng tiền: ",
                                                                            fontsize:
                                                                                14.sp,
                                                                            textAlign:
                                                                                TextAlign.start,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                5.w,
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                150.w,
                                                                            child:
                                                                                TextApp(
                                                                              isOverFlow: false,
                                                                              softWrap: true,
                                                                              text: "${MoneyFormatter(amount: (storeData.ordersSumOrderTotal ?? 0).toDouble()).output.withoutFractionDigits.toString()} đ",
                                                                              fontsize: 14.sp,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
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
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 10.h,
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
                                    ),
                                    SizedBox(height: 30.h),
                                    Container(
                                      width: 1.sw,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(15.r),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 2,
                                            blurRadius: 4,
                                            offset: const Offset(0,
                                                3), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          SizedBox(height: 20.h),
                                          TextApp(
                                            text: "Biểu đồ thu nhập",
                                            fontsize: 16.sp,
                                            color: blueText2,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          SizedBox(height: 20.h),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: 10.w,
                                              ),
                                              Flexible(
                                                fit: FlexFit.tight,
                                                child: Column(
                                                  children: [
                                                    TextApp(
                                                      text: "Loại",
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
                                                          builder: (context) =>
                                                              SizedBox(
                                                            height: 1.sh / 2,
                                                            child: Column(
                                                              children: [
                                                                Container(
                                                                  width: 1.sw,
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(20
                                                                              .w),
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .primary,
                                                                  child:
                                                                      TextApp(
                                                                    text:
                                                                        "Chọn loại",
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
                                                                        loaiList
                                                                            .length,
                                                                    itemBuilder:
                                                                        (context,
                                                                            index) {
                                                                      return Column(
                                                                        children: [
                                                                          Padding(
                                                                            padding:
                                                                                EdgeInsets.only(left: 20.w),
                                                                            child:
                                                                                InkWell(
                                                                              onTap: () async {
                                                                                Navigator.pop(context);

                                                                                if (index == 0) {
                                                                                  mounted
                                                                                      ? setState(() {
                                                                                          currentDataType = "%d-%m-%Y";
                                                                                        })
                                                                                      : null;
                                                                                  handleGetChartDataHome(startDate: _dateStartController.text, endDate: _dateEndController.text, dataType: currentDataType);
                                                                                } else if (index == 2) {
                                                                                  mounted
                                                                                      ? setState(() {
                                                                                          currentDataType = "%Y";
                                                                                        })
                                                                                      : null;
                                                                                  handleGetChartDataHome(startDate: _dateStartController.text, endDate: _dateEndController.text, dataType: currentDataType);
                                                                                } else {
                                                                                  mounted
                                                                                      ? setState(() {
                                                                                          currentDataType = "%m-%Y";
                                                                                        })
                                                                                      : null;
                                                                                  handleGetChartDataHome(startDate: _dateStartController.text, endDate: _dateEndController.text, dataType: currentDataType);
                                                                                }
                                                                                mounted
                                                                                    ? setState(() {
                                                                                        dataTypeTextController.text = loaiList[index];
                                                                                      })
                                                                                    : null;
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
                                                                            height:
                                                                                25.h,
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
                                                          dataTypeTextController,
                                                      style: TextStyle(
                                                          fontSize: 14.sp,
                                                          color: Colors.black),
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
                                                              hintText: 'Tháng',
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
                                                              hintStyle:
                                                                  TextStyle(
                                                                      fontSize:
                                                                          14.sp,
                                                                      color:
                                                                          grey),
                                                              contentPadding:
                                                                  EdgeInsets
                                                                      .all(10
                                                                          .w)),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10.w,
                                              ),
                                              Flexible(
                                                fit: FlexFit.tight,
                                                child: Column(
                                                  children: [
                                                    TextApp(
                                                      text: " Từ ngày",
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
                                                              // suffixIcon:
                                                              //     const Icon(Icons
                                                              //         .calendar_month),
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
                                                              // hintText:
                                                              //     'dd/mm/yy',
                                                              isDense: true,
                                                              contentPadding:
                                                                  EdgeInsets
                                                                      .all(18
                                                                          .w)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10.w,
                                              ),
                                              Flexible(
                                                fit: FlexFit.tight,
                                                child: Column(
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
                                                              // suffixIcon:
                                                              //     const Icon(Icons
                                                              //         .calendar_month),
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
                                                              // hintText:
                                                              //     'dd/mm/yy',
                                                              isDense: true,
                                                              contentPadding:
                                                                  EdgeInsets
                                                                      .all(18
                                                                          .w)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10.w,
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 20.h),
                                          chartDataModel != null
                                              ? SizedBox(
                                                  width: 1.sw,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 0.w, right: 00.w),
                                                    child: ChartHomeAllStore(
                                                        chartDataModel:
                                                            chartDataModel!),
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
