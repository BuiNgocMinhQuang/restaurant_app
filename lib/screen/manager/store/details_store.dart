import 'dart:convert';

import 'package:app_restaurant/bloc/manager/stores/list_stores_bloc.dart';
import 'package:app_restaurant/config/date_time_format.dart';
import 'package:app_restaurant/config/void_show_dialog.dart';
import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/config/space.dart';
import 'package:app_restaurant/env/index.dart';
import 'package:app_restaurant/model/manager/store/edit_details_store_model.dart';
import 'package:app_restaurant/routers/app_router_config.dart';
import 'package:app_restaurant/screen/manager/store/manage_room.dart';
import 'package:app_restaurant/utils/storage.dart';
import 'package:app_restaurant/widgets/button/button_gradient.dart';
import 'package:app_restaurant/widgets/button/button_icon.dart';
import 'package:app_restaurant/widgets/chart/chart_dialog.dart';
import 'package:app_restaurant/widgets/dialog/list_custom_dialog.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:app_restaurant/model/manager/store/details_stores_model.dart';
import 'package:app_restaurant/model/manager/store/rooms/list_room_of_store_model.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:http/http.dart' as http;
import 'package:app_restaurant/constant/api/index.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:money_formatter/money_formatter.dart';

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
      print(" DATA CREATE FOOD ${data}");
      try {
        if (data['status'] == 200) {
          setState(() {
            widget.detailsStoreModel = DetailsStoreModel.fromJson(data);
          });
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
          setState(() {
            editDetailsStoreModel = EditDetailsStoreModel.fromJson(data);
          });
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return EditDetailStoreDialog(
                  eventSaveButton: () {},
                  editDetailsStoreModel: editDetailsStoreModel,
                );
              });
        } else {
          print("ERROR CREATE FOOOD");
        }
      } catch (error) {
        print("ERROR CREATE 112212 $error");
      }
    } catch (error) {
      print("ERROR CREATE 44444 $error");
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
          setState(() {
            listRoomOfStoreModel = ListRoomOfStoreModel.fromJson(data);
          });
        } else {
          print("ERROR CREATE FOOOD");
        }
      } catch (error) {
        print("ERROR CREATE 112212 $error");
      }
    } catch (error) {
      print("ERROR CREATE 44444 $error");
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
          setState(() {
            handleGetListRoom(shopID: widget.detailsStoreModel?.shopId ?? '');
          });
        } else {
          print("ERROR CREATE FOOOD");
        }
      } catch (error) {
        print("ERROR CREATE 112212 $error");
      }
    } catch (error) {
      print("ERROR CREATE 44444 $error");
    }
  }

  @override
  void initState() {
    super.initState();
    handleGetListRoom(shopID: widget.detailsStoreModel?.shopId ?? '');
  }

  @override
  Widget build(BuildContext context) {
    var imageStorePath = widget.detailsStoreModel?.store.storeImages;
    var imageStore = jsonDecode(imageStorePath ?? '[]');
    return Scaffold(
        appBar: AppBar(
          title: Text("Quản lí cửa hàng"),
        ),
        body: Stack(
          children: [
            SafeArea(
              child: RefreshIndicator(
                color: Colors.blue,
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
                              space15H,
                              TextApp(
                                  text:
                                      "${MoneyFormatter(amount: (widget.detailsStoreModel?.totalIncome ?? 0).toDouble()).output.withoutFractionDigits.toString()} đ",
                                  fontsize: 20.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                              space20H,
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
                        space20H,
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
                                  space20W,
                                  Container(
                                    width: 50,
                                    height: 50,
                                    // color: Colors.amber,
                                    child: Image.asset(
                                      'assets/images/incomes.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  space20W,
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
                        space15H,
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
                                  space20W,
                                  Container(
                                    width: 50,
                                    height: 50,
                                    child: Image.asset(
                                      'assets/images/staff.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  space20W,
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
                        space25H,
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
                                                      ? Image.asset(
                                                          'assets/images/store.png',
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
                                            space20W,
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
                                        SizedBox(
                                          width: 30,
                                          height: 30,
                                          child: ButtonIcon(
                                              isIconCircle: false,
                                              color1: const Color.fromRGBO(
                                                  20, 23, 39, 1),
                                              color2: const Color.fromRGBO(
                                                  58, 65, 111, 1),
                                              event: () {
                                                hanldeGetEditDetailsStore(
                                                    shopID: widget
                                                            .detailsStoreModel
                                                            ?.shopId ??
                                                        1);
                                              },
                                              icon: Icons.edit),
                                        )
                                      ],
                                    ),
                                    space10H,
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
                                    space10H,
                                    HtmlWidget(
                                      '''
                                                         ${widget.detailsStoreModel?.store.storeDescription ?? ''}
                                                        ''',
                                    ),
                                    space30H,
                                    Container(
                                      width: 1.sw,
                                      height: 50,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.w),
                                          color: Colors.grey.withOpacity(0.2)),
                                      child: Row(
                                        children: [
                                          space20W,
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
                        space25H,
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
                                  space10H,
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
                                  space10H,
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
                                            space10H,
                                            Container(
                                              width: 1.sw,
                                              padding: EdgeInsets.all(10.w),
                                              decoration: const BoxDecoration(
                                                border: Border(
                                                    top: BorderSide(
                                                        width: 0,
                                                        color: Colors.white),
                                                    bottom: BorderSide(
                                                        width: 0,
                                                        color: Colors.white),
                                                    left: BorderSide(
                                                        width: 3,
                                                        color: Colors.blue),
                                                    right: BorderSide(
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
                                                      // Icon(Icons.more),
                                                      SizedBox(
                                                        width: 20.w,
                                                        height: 20.w,
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
                                                                                    Icon(
                                                                                      Icons.edit,
                                                                                      size: 35.sp,
                                                                                    ),
                                                                                    space10W,
                                                                                    TextApp(
                                                                                      text: "Chỉnh sửa phòng",
                                                                                      color: Colors.black,
                                                                                      fontsize: 18.sp,
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              space10H,
                                                                              Divider(),
                                                                              space10H,
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
                                                                                    Icon(
                                                                                      Icons.settings,
                                                                                      size: 35.sp,
                                                                                    ),
                                                                                    space10W,
                                                                                    TextApp(
                                                                                      text: "Quản lí bàn",
                                                                                      color: Colors.black,
                                                                                      fontsize: 18.sp,
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              space10H,
                                                                              Divider(),
                                                                              space10H,
                                                                              InkWell(
                                                                                onTap: () {
                                                                                  Navigator.pop(context);

                                                                                  showConfirmDialog(navigatorKey.currentContext, () {
                                                                                    handleDeleteRoom(roomID: listRoomOfStoreModel?.rooms[index].storeRoomId.toString() ?? '');
                                                                                  });
                                                                                },
                                                                                child: Row(
                                                                                  children: [
                                                                                    Icon(
                                                                                      Icons.delete,
                                                                                      size: 35.sp,
                                                                                    ),
                                                                                    space10W,
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
                                                          space10H,
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
                                                          space10H,
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
                                                          space10H,
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
