import 'dart:convert';
import 'dart:developer';

import 'package:app_restaurant/bloc/manager/stores/list_stores_bloc.dart';
import 'package:app_restaurant/config/date_time_format.dart';
import 'package:app_restaurant/config/void_show_dialog.dart';
import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/env/index.dart';
import 'package:app_restaurant/model/manager/store/edit_details_store_model.dart';
import 'package:app_restaurant/routers/app_router_config.dart';
import 'package:app_restaurant/screen/manager/store/manage_room.dart';
import 'package:app_restaurant/utils/storage.dart';
import 'package:app_restaurant/widgets/button/button_gradient.dart';
import 'package:app_restaurant/widgets/chart/chart_dialog.dart';
import 'package:app_restaurant/widgets/dialog/list_custom_dialog.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:app_restaurant/model/manager/store/details_stores_model.dart';
import 'package:app_restaurant/model/manager/store/rooms/list_room_of_store_model.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:http/http.dart' as http;
import 'package:app_restaurant/constant/api/index.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:money_formatter/money_formatter.dart';

// ignore: must_be_immutable
class DetailsStore extends StatefulWidget {
  DetailsStoreModel? detailsStoreModel;
  DetailsStore({Key? key, required this.detailsStoreModel}) : super(key: key);

  @override
  State<DetailsStore> createState() => _DetailsStoreState();
}

class _DetailsStoreState extends State<DetailsStore> {
  EditDetailsStoreModel? editDetailsStoreModel;
  ListRoomOfStoreModel? listRoomOfStoreModel;
  DetailsStoreModel? detailsStoreModel;

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
      try {
        if (data['status'] == 200) {
          mounted
              ? setState(() {
                  widget.detailsStoreModel = DetailsStoreModel.fromJson(data);
                })
              : null;
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

  void hanldeGetEditDetailsStore({required shopID}) async {
    try {
      var token = StorageUtils.instance.getString(key: 'token_manager');

      final respons = await http.post(
        Uri.parse('$baseUrl$detailEditStore'),
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
                  editDetailsStoreModel = EditDetailsStoreModel.fromJson(data);
                })
              : null;
          showDialog(
              // ignore: use_build_context_synchronously
              context: context,
              builder: (BuildContext context) {
                return EditDetailStoreDialog(
                  eventSaveButton: () {},
                  editDetailsStoreModel: editDetailsStoreModel,
                );
              });
        } else {
          log("ERROR hanldeGetEditDetailsStore 1");
        }
      } catch (error) {
        log("ERROR hanldeGetEditDetailsStore 2 $error");
      }
    } catch (error) {
      log("ERROR hanldeGetEditDetailsStore 3 $error");
    }
  }

  void handleGetListRoom({
    required String shopID,
  }) async {
    try {
      var token = StorageUtils.instance.getString(key: 'token_manager');

      final respons = await http.post(
        Uri.parse('$baseUrl$getListRoomByManager'),
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
                  listRoomOfStoreModel = ListRoomOfStoreModel.fromJson(data);
                })
              : null;
        } else {
          log("ERROR handleGetListRoom 1");
        }
      } catch (error) {
        log("ERROR handleGetListRoom 2 $error");
      }
    } catch (error) {
      log("ERROR handleGetListRoom 3 $error");
    }
  }

  void handleDeleteRoom({
    required String roomID,
  }) async {
    try {
      var token = StorageUtils.instance.getString(key: 'token_manager');

      final respons = await http.post(
        Uri.parse('$baseUrl$deleteRoomByManager'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          'room_id': roomID,
          'is_api': true,
        }),
      );
      final data = jsonDecode(respons.body);
      try {
        if (data['status'] == 200) {
          mounted
              ? setState(() {
                  handleGetListRoom(
                      shopID: widget.detailsStoreModel?.shopId ?? '');
                })
              : null;
        } else {
          log("ERROR handleDeleteRoom 1");
        }
      } catch (error) {
        log("ERROR handleDeleteRoom 2 $error");
      }
    } catch (error) {
      log("ERROR handleDeleteRoom 3 $error");
    }
  }

  @override
  void initState() {
    handleGetListRoom(shopID: widget.detailsStoreModel?.shopId ?? '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var imageStorePath = widget.detailsStoreModel?.store.storeImages;
    var imageStore = jsonDecode(imageStorePath ?? '[]');
    return Scaffold(
        appBar: AppBar(
          title: const Text("Quản lí cửa hàng"),
        ),
        body: Stack(
          children: [
            SafeArea(
              child: RefreshIndicator(
                color: Theme.of(context).colorScheme.primary,
                onRefresh: () async {
                  handleGetListRoom(
                      shopID: widget.detailsStoreModel?.shopId ?? '');
                  getDetailsStore(
                      shopID: widget.detailsStoreModel?.shopId ?? '');
                },
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      children: [
                        Container(
                          width: 1.sw,
                          height: 200,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.w),
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color.fromRGBO(33, 212, 253, 1),
                                  Color.fromRGBO(33, 82, 255, 1)
                                ],
                              )),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextApp(
                                text: "Tổng tiền",
                                fontsize: 16.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              SizedBox(height: 15.h),
                              TextApp(
                                  text:
                                      "${MoneyFormatter(amount: (widget.detailsStoreModel?.totalIncome ?? 0).toDouble()).output.withoutFractionDigits.toString()} đ",
                                  fontsize: 20.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                              SizedBox(height: 20.h),
                              SizedBox(
                                width: 220.w,
                                child: ButtonGradient(
                                  color1: color1DarkButton,
                                  color2: color2DarkButton,
                                  event: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return OverviewChartDialog(
                                              shopID: widget.detailsStoreModel
                                                      ?.shopId ??
                                                  '');
                                        });
                                  },
                                  text: "Biểu đồ tổng quan".toUpperCase(),
                                  fontSize: 12.sp,
                                  radius: 8.r,
                                  textColor: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Card(
                          elevation: 8.0,
                          margin: const EdgeInsets.all(8),
                          child: Container(
                              width: 1.sw,
                              height: 100.h,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20.w)),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 20.w,
                                  ),
                                  SizedBox(
                                      width: 50.w,
                                      height: 50.w,
                                      // color: Colors.amber,
                                      child: SvgPicture.asset(
                                        'assets/svg/incomes.svg',
                                        fit: BoxFit.contain,
                                      )),
                                  SizedBox(
                                    width: 20.w,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextApp(
                                        text: "Thu nhập hôm nay",
                                        fontsize: 16.sp,
                                        fontWeight: FontWeight.normal,
                                      ),
                                      TextApp(
                                        text:
                                            "${MoneyFormatter(amount: (widget.detailsStoreModel?.todayIncome ?? 0).toDouble()).output.withoutFractionDigits.toString()} đ",
                                        fontsize: 20.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ],
                                  )
                                ],
                              )),
                        ),
                        SizedBox(height: 15.h),
                        Card(
                          elevation: 8.0,
                          margin: const EdgeInsets.all(8),
                          child: Container(
                              width: 1.sw,
                              height: 100.h,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20.w)),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 20.w,
                                  ),
                                  SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: SvgPicture.asset(
                                      'assets/svg/staff_gr.svg',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20.w,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextApp(
                                        text: "Tổng nhân viên",
                                        fontsize: 16.sp,
                                        fontWeight: FontWeight.normal,
                                      ),
                                      TextApp(
                                        text: widget.detailsStoreModel?.store
                                                .staffsCount
                                                .toString() ??
                                            '',
                                        fontsize: 20.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ],
                                  )
                                ],
                              )),
                        ),
                        SizedBox(height: 25.h),
                        Card(
                          elevation: 8.0,
                          margin: const EdgeInsets.all(8),
                          child: Container(
                              width: 1.sw,
                              // height: 100.h,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20.w)),
                              child: Padding(
                                padding: EdgeInsets.all(10.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                                width: 50.w,
                                                height: 50.w,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  child: imageStorePath == null
                                                      ? SvgPicture.asset(
                                                          'assets/svg/store_icon.svg',
                                                          fit: BoxFit.contain,
                                                        )
                                                      : CachedNetworkImage(
                                                          fit: BoxFit.cover,
                                                          imageUrl: httpImage +
                                                              imageStore[0],
                                                          placeholder:
                                                              (context, url) =>
                                                                  SizedBox(
                                                            height: 15.w,
                                                            width: 15.w,
                                                            child: const Center(
                                                                child:
                                                                    CircularProgressIndicator()),
                                                          ),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              const Icon(
                                                                  Icons.error),
                                                        ),
                                                )),
                                            SizedBox(
                                              width: 20.w,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                TextApp(
                                                  text: widget.detailsStoreModel
                                                          ?.store.storeName ??
                                                      '',
                                                  fontsize: 12.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                TextApp(
                                                  text: formatDateTime(widget
                                                          .detailsStoreModel
                                                          ?.store
                                                          .createdAt ??
                                                      ''),
                                                  fontsize: 12.sp,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        InkWell(
                                          onTap: () {
                                            hanldeGetEditDetailsStore(
                                                shopID: widget.detailsStoreModel
                                                        ?.shopId ??
                                                    1);
                                          },
                                          child: Container(
                                            width: 35.w,
                                            height: 35.w,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5.r),
                                                gradient: const LinearGradient(
                                                  begin: Alignment.topRight,
                                                  end: Alignment.bottomLeft,
                                                  colors: [
                                                    Color.fromRGBO(
                                                        20, 23, 39, 1),
                                                    Color.fromRGBO(
                                                        58, 65, 111, 1),
                                                  ],
                                                )),
                                            child: Container(
                                              width: 30.w,
                                              height: 30.w,
                                              padding: EdgeInsets.all(5.w),
                                              child: SvgPicture.asset(
                                                'assets/svg/edit_icon.svg',
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 10.h),
                                    Row(
                                      children: [
                                        TextApp(
                                          text: "Địa chỉ: ",
                                          fontsize: 14.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        TextApp(
                                          text: widget.detailsStoreModel?.store
                                                  .storeAddress ??
                                              '',
                                          fontsize: 14.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10.h),
                                    HtmlWidget(
                                      '''
                                                         ${widget.detailsStoreModel?.store.storeDescription ?? ''}
                                                        ''',
                                    ),
                                    SizedBox(height: 30.h),
                                    Container(
                                      width: 1.sw,
                                      height: 50,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.w),
                                          color: Colors.grey.withOpacity(0.2)),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 20.w,
                                          ),
                                          TextApp(
                                            text:
                                                "${MoneyFormatter(amount: (widget.detailsStoreModel?.monthTotalOrder ?? 0).toDouble()).output.withoutFractionDigits.toString()} ",
                                            fontsize: 18.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          TextApp(
                                            text: "đ/tháng hiện tại",
                                            fontsize: 18.sp,
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )),
                        ),
                        SizedBox(height: 25.h),
                        Card(
                          elevation: 8.0,
                          margin: const EdgeInsets.all(8),
                          child: Container(
                            width: 1.sw,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.w)),
                            child: Padding(
                              padding: EdgeInsets.all(20.w),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextApp(
                                        text: "Danh sách phòng",
                                        fontsize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      SizedBox(
                                        width: 150.w,
                                        child: ButtonGradient(
                                          radius: 8.w,
                                          color1: lightBlue,
                                          color2: lightBlue,
                                          event: () {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return CreateRoomDialog(
                                                      shopID: widget
                                                              .detailsStoreModel
                                                              ?.shopId ??
                                                          '',
                                                      eventSaveButton: () {
                                                        handleGetListRoom(
                                                            shopID: widget
                                                                    .detailsStoreModel
                                                                    ?.shopId ??
                                                                '');
                                                      });
                                                });
                                          },
                                          text: "Tạo phòng".toUpperCase(),
                                          height: 30.h,
                                          textColor: Colors.white,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 10.h),
                                  ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount:
                                          listRoomOfStoreModel?.rooms.length ??
                                              0,
                                      itemBuilder: (context, index) {
                                        return Column(
                                          children: [
                                            const Divider(),
                                            SizedBox(height: 10.h),
                                            Container(
                                              width: 1.sw,
                                              padding: EdgeInsets.all(10.w),
                                              decoration: BoxDecoration(
                                                border: Border(
                                                    top: const BorderSide(
                                                        width: 0,
                                                        color: Colors.white),
                                                    bottom: const BorderSide(
                                                        width: 0,
                                                        color: Colors.white),
                                                    left: BorderSide(
                                                        width: 3,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary),
                                                    right: const BorderSide(
                                                        width: 0,
                                                        color: Colors.white)),
                                              ),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      TextApp(
                                                          text: listRoomOfStoreModel
                                                                  ?.rooms[index]
                                                                  .storeRoomName ??
                                                              ''),
                                                      SizedBox(
                                                        width: 50.w,
                                                        height: 30.w,
                                                        child: InkWell(
                                                          onTap: () {
                                                            showMaterialModalBottomSheet(
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .only(
                                                                    topRight: Radius
                                                                        .circular(
                                                                            25.r),
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            25.r),
                                                                  ),
                                                                ),
                                                                clipBehavior: Clip
                                                                    .antiAliasWithSaveLayer,
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) =>
                                                                        Container(
                                                                          height:
                                                                              1.sh / 3,
                                                                          padding:
                                                                              EdgeInsets.all(20.w),
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              InkWell(
                                                                                onTap: () {
                                                                                  Navigator.pop(context);

                                                                                  showDialog(
                                                                                      context: context,
                                                                                      builder: (BuildContext context) {
                                                                                        return EditRoomDataDialog(
                                                                                            shopID: widget.detailsStoreModel?.shopId ?? '',
                                                                                            roomID: listRoomOfStoreModel?.rooms[index].storeRoomId.toString() ?? '',
                                                                                            eventSaveButton: () {
                                                                                              handleGetListRoom(shopID: widget.detailsStoreModel?.shopId ?? '');
                                                                                            });
                                                                                      });
                                                                                },
                                                                                child: Row(
                                                                                  children: [
                                                                                    SizedBox(
                                                                                      width: 35.w,
                                                                                      height: 35.w,
                                                                                      child: SvgPicture.asset(
                                                                                        'assets/svg/edit_icon.svg',
                                                                                        fit: BoxFit.contain,
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 10.w,
                                                                                    ),
                                                                                    TextApp(
                                                                                      text: "Chỉnh sửa phòng",
                                                                                      color: Colors.black,
                                                                                      fontsize: 18.sp,
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              SizedBox(height: 10.h),
                                                                              const Divider(),
                                                                              SizedBox(height: 10.h),
                                                                              InkWell(
                                                                                onTap: () {
                                                                                  Navigator.pop(context);

                                                                                  Navigator.push(
                                                                                    context,
                                                                                    MaterialPageRoute(
                                                                                        builder: (context) => ManageRoom(
                                                                                              roomName: listRoomOfStoreModel?.rooms[index].storeRoomName.toString() ?? '',
                                                                                              numberTable: listRoomOfStoreModel?.rooms[index].roomTablesCount.toString() ?? '',
                                                                                              roomID: listRoomOfStoreModel?.rooms[index].storeRoomId.toString() ?? '',
                                                                                            )),
                                                                                  );
                                                                                },
                                                                                child: Row(
                                                                                  children: [
                                                                                    SizedBox(
                                                                                      width: 35.w,
                                                                                      height: 35.w,
                                                                                      child: SvgPicture.asset(
                                                                                        'assets/svg/setting_icon.svg',
                                                                                        fit: BoxFit.contain,
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 10.w,
                                                                                    ),
                                                                                    TextApp(
                                                                                      text: "Quản lí bàn",
                                                                                      color: Colors.black,
                                                                                      fontsize: 18.sp,
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              SizedBox(height: 10.h),
                                                                              const Divider(),
                                                                              SizedBox(height: 10.h),
                                                                              InkWell(
                                                                                onTap: () {
                                                                                  Navigator.pop(context);

                                                                                  showConfirmDialog(navigatorKey.currentContext, () {
                                                                                    handleDeleteRoom(roomID: listRoomOfStoreModel?.rooms[index].storeRoomId.toString() ?? '');
                                                                                  });
                                                                                },
                                                                                child: Row(
                                                                                  children: [
                                                                                    SizedBox(
                                                                                      width: 35.w,
                                                                                      height: 35.w,
                                                                                      child: SvgPicture.asset(
                                                                                        'assets/svg/delete_icon.svg',
                                                                                        fit: BoxFit.contain,
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 10.w,
                                                                                    ),
                                                                                    TextApp(
                                                                                      text: "Xoá phòng",
                                                                                      color: Colors.black,
                                                                                      fontsize: 18.sp,
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ));
                                                          },
                                                          child: Icon(
                                                            Icons
                                                                .more_horiz_outlined,
                                                            size: 25.sp,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Column(
                                                        children: [
                                                          TextApp(
                                                              fontsize: 10.sp,
                                                              text: "Ngày tạo"),
                                                          SizedBox(
                                                              height: 10.h),
                                                          TextApp(
                                                            fontsize: 10.sp,
                                                            text: formatDateTime(
                                                                listRoomOfStoreModel
                                                                        ?.rooms[
                                                                            index]
                                                                        .createdAt ??
                                                                    ''),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ],
                                                      ),
                                                      Column(
                                                        children: [
                                                          TextApp(
                                                              fontsize: 10.sp,
                                                              text:
                                                                  "Số bàn trong phòng"),
                                                          SizedBox(
                                                              height: 10.h),
                                                          TextApp(
                                                              fontsize: 10.sp,
                                                              text: listRoomOfStoreModel
                                                                      ?.rooms[
                                                                          index]
                                                                      .roomTablesCount
                                                                      .toString() ??
                                                                  '0',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ],
                                                      ),
                                                      Column(
                                                        children: [
                                                          TextApp(
                                                              fontsize: 10.sp,
                                                              text:
                                                                  "Trạng thái"),
                                                          SizedBox(
                                                              height: 10.h),
                                                          TextApp(
                                                              fontsize: 10.sp,
                                                              text: listRoomOfStoreModel
                                                                          ?.rooms[
                                                                              index]
                                                                          .activeFlg ==
                                                                      1
                                                                  ? "Đang hoạt động"
                                                                  : "Ngừng hoạt động",
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        );
                                      })
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
