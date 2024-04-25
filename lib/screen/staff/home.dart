import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:app_restaurant/bloc/bill_table/bill_table_bloc.dart';
import 'package:app_restaurant/bloc/manager/room/list_room_bloc.dart';
import 'package:app_restaurant/bloc/manager/tables/table_bloc.dart';
import 'package:app_restaurant/bloc/payment/payment_bloc.dart';
import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/config/date_time_format.dart';
import 'package:app_restaurant/config/space.dart';
import 'package:app_restaurant/config/void_show_dialog.dart';
import 'package:app_restaurant/model/staff/list_food_order_model.dart';
import 'package:app_restaurant/model/staff/staff_infor_model.dart';
import 'package:app_restaurant/routers/app_router_config.dart';
import 'package:app_restaurant/utils/share_getString.dart';
import 'package:app_restaurant/utils/storage.dart';
import 'package:app_restaurant/widgets/button/button_gradient.dart';
import 'package:app_restaurant/widgets/card/card_receipt_container.dart';
import 'package:app_restaurant/widgets/dialog/list_custom_dialog.dart';
import 'package:app_restaurant/widgets/tabs&drawer/item_drawer_and_tab.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:http/http.dart' as http;
import 'package:app_restaurant/env/index.dart';
import 'package:app_restaurant/constant/api/index.dart';

class StaffBookingTable extends StatefulWidget {
  const StaffBookingTable({
    Key? key,
  }) : super(key: key);

  @override
  State<StaffBookingTable> createState() => _StaffBookingTableState();
}

class _StaffBookingTableState extends State<StaffBookingTable>
    with TickerProviderStateMixin {
  final String currentRole = "staff";
  final String currentShopId = getStaffShopID;
  var tokenStaff = StorageUtils.instance.getString(key: 'token_staff') ?? '';
  int currentRoomIndex = 0;
  DataStaffInfor? staffInforData;

  void getDataTabIndex({String? roomId}) async {
    BlocProvider.of<ListRoomBloc>(context).add(
      GetListRoom(
          token: tokenStaff,
          client: currentRole,
          shopId: getStaffShopID,
          isApi: true,
          roomId: roomId ?? ''),
    );
  }

  void getTableInfor({
    String? roomId,
    required String tableId,
    required String? orderID,
  }) async {
    BlocProvider.of<TableBloc>(context).add(GetTableInfor(
        token: tokenStaff,
        client: currentRole,
        shopId: getStaffShopID,
        roomId: roomId ?? '',
        tableId: tableId,
        orderID: orderID));
  }

  void getSwitchTableData(
      {String? roomId,
      required String tableId,
      required String orderID}) async {
    BlocProvider.of<TableBloc>(context).add(GetTableSwitchInfor(
        token: tokenStaff,
        client: currentRole,
        shopId: getStaffShopID,
        roomId: roomId ?? '',
        tableId: tableId,
        orderId: orderID));
  }

  void getBillData(
      {String? roomId,
      required String tableId,
      required String orderID}) async {
    BlocProvider.of<BillInforBloc>(context).add(GetBillInfor(
        token: tokenStaff,
        client: currentRole,
        shopId: getStaffShopID,
        roomId: roomId ?? '',
        tableId: tableId,
        orderId: orderID));
  }

  void getPaymentData(
      {String? roomId,
      required String tableId,
      required String orderID}) async {
    BlocProvider.of<PaymentInforBloc>(context).add(GetPaymentInfor(
        token: tokenStaff,
        client: currentRole,
        shopId: getStaffShopID,
        roomId: roomId ?? '',
        tableId: tableId,
        orderId: orderID));
  }

  @override
  void initState() {
    super.initState();
    getDataTabIndex(roomId: '');
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   WidgetsBinding.instance.addPostFrameCallback((_) => getInfor());
    // });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListRoomBloc, ListRoomState>(builder: (context, state) {
      return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
              child: SizedBox(
            width: double.maxFinite,
            child: state.listRoomStatus == ListRoomStatus.succes
                ? SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 1.sw,
                          child: SizedBox(
                            child: Align(
                              alignment: Alignment.center,
                              child: Container(
                                // width: 1.sw,
                                height: 40.h,
                                color: newGreyApp,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount:
                                      state.listRoomModel?.rooms?.length ?? 1,
                                  itemBuilder: (context, index) {
                                    return Center(
                                        child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 15.w, right: 15.w),
                                      child: InkWell(
                                          onTap: () {
                                            getDataTabIndex(
                                              roomId: state.listRoomModel!
                                                  .rooms![index].storeRoomId
                                                  .toString(),
                                            );
                                            setState(() {
                                              currentRoomIndex = index;
                                            });
                                          },
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              space5H,
                                              TextApp(
                                                text: state
                                                        .listRoomModel
                                                        ?.rooms?[index]
                                                        .storeRoomName ??
                                                    '',
                                                color: currentRoomIndex == index
                                                    ? Colors.blue
                                                    : Colors.black,
                                                fontWeight:
                                                    currentRoomIndex == index
                                                        ? FontWeight.bold
                                                        : FontWeight.normal,
                                                fontsize: 14.sp,
                                              ),
                                              currentRoomIndex == index
                                                  ? Container(
                                                      width: 70.w,
                                                      color: newBlueText,
                                                      height: 4,
                                                    )
                                                  : Container()
                                            ],
                                          )),
                                    ));
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        space25H,
                        SizedBox(
                          width: 1.sw,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 40.w,
                                    height: 20.h,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(2.r),
                                        color: newGreyApp),
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  TextApp(
                                    text: "Đang phục vụ",
                                    color: color1DarkGreyButton,
                                    fontWeight: FontWeight.bold,
                                  )
                                ],
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(2.r),
                                      border: Border.all(
                                          width: 1, color: newBlueText),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  TextApp(
                                    text: "Bàn trống",
                                    color: color1DarkGreyButton,
                                    fontWeight: FontWeight.bold,
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        space15H,
                        state.listRoomModel!.rooms!.isEmpty
                            ? Container(
                                width: 1.sw,
                                height: 50,
                                color: Colors.blue,
                                child: Center(
                                  child: TextApp(
                                    text: "Shop này không có Phòng",
                                    color: Colors.white,
                                    fontsize: 14.sp,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )
                            : Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 30.w, right: 30.w),
                                    child: Container(
                                      width: 1.sw,
                                      height: 600.h,
                                      // color: Colors.amber,
                                      child:
                                          state
                                                  .listRoomModel!
                                                  .rooms![currentRoomIndex]
                                                  .tables!
                                                  .isNotEmpty
                                              ? RefreshIndicator(
                                                  color: Colors.blue,
                                                  onRefresh: () async {
                                                    log(currentRoomIndex
                                                        .toString());
                                                    getDataTabIndex(
                                                      roomId: state
                                                          .listRoomModel!
                                                          .rooms![
                                                              currentRoomIndex]
                                                          .storeRoomId
                                                          .toString(),
                                                    ); //get data table of firts room
                                                  },
                                                  child: GridView.builder(
                                                      gridDelegate:
                                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                                              crossAxisCount:
                                                                  3),
                                                      itemCount: state
                                                              .listRoomModel!
                                                              .rooms![
                                                                  currentRoomIndex]
                                                              .tables
                                                              ?.length ??
                                                          1,
                                                      itemBuilder:
                                                          (context, index) {
                                                        var roomName = state
                                                                .listRoomModel!
                                                                .rooms![
                                                                    currentRoomIndex]
                                                                .storeRoomName ??
                                                            '';

                                                        var listRoomID = state
                                                            .listRoomModel!
                                                            .rooms!
                                                            .map((data) => data
                                                                .storeRoomId)
                                                            .toList();

                                                        return Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  10.w),
                                                          child: state
                                                                      .listRoomModel!
                                                                      .rooms![
                                                                          currentRoomIndex]
                                                                      .tables?[
                                                                          index]
                                                                      .bookingStatus ==
                                                                  true
                                                              ? InkWell(
                                                                  onTap: () {
                                                                    getTableInfor(
                                                                        roomId: state
                                                                            .listRoomModel!
                                                                            .rooms![
                                                                                currentRoomIndex]
                                                                            .storeRoomId
                                                                            .toString(),
                                                                        tableId: state
                                                                            .listRoomModel!
                                                                            .rooms![
                                                                                currentRoomIndex]
                                                                            .tables![
                                                                                index]
                                                                            .roomTableId
                                                                            .toString(),
                                                                        orderID: state
                                                                            .listRoomModel!
                                                                            .rooms![currentRoomIndex]
                                                                            .tables![index]
                                                                            .orderId
                                                                            .toString());

                                                                    showDialog(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (BuildContext
                                                                                context) {
                                                                          return BookingTableDialog(
                                                                            token:
                                                                                tokenStaff,
                                                                            role:
                                                                                currentRole,
                                                                            shopID:
                                                                                currentShopId,
                                                                            idRoom:
                                                                                state.listRoomModel!.rooms![currentRoomIndex].storeRoomId,
                                                                            orderID:
                                                                                null,
                                                                            eventSaveButton:
                                                                                () {
                                                                              getDataTabIndex(
                                                                                roomId: state.listRoomModel!.rooms![currentRoomIndex].storeRoomId.toString(),
                                                                              );
                                                                            },
                                                                            listTableOfRoom:
                                                                                state.listRoomModel!.rooms![currentRoomIndex].tables,
                                                                            currentTable:
                                                                                state.listRoomModel!.rooms![currentRoomIndex].tables![index],
                                                                          );
                                                                        });
                                                                  },
                                                                  child: Stack(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    children: [
                                                                      Image
                                                                          .asset(
                                                                        "assets/images/table_image_emty.png",
                                                                        fit: BoxFit
                                                                            .contain,
                                                                      ),
                                                                      Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        children: [
                                                                          TextApp(
                                                                            isOverFlow:
                                                                                false,
                                                                            softWrap:
                                                                                true,
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            text:
                                                                                state.listRoomModel!.rooms![currentRoomIndex].tables?[index].tableName ?? '',
                                                                            color:
                                                                                newBlueText,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                          Icon(
                                                                            Icons.add,
                                                                            color:
                                                                                newBlueText,
                                                                            size:
                                                                                15.sp,
                                                                          )
                                                                        ],
                                                                      )
                                                                    ],
                                                                  ),
                                                                )
                                                              : InkWell(
                                                                  onTap: () {
                                                                    showMaterialModalBottomSheet(
                                                                        shape:
                                                                            RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.only(
                                                                            topRight:
                                                                                Radius.circular(25.r),
                                                                            topLeft:
                                                                                Radius.circular(25.r),
                                                                          ),
                                                                        ),
                                                                        clipBehavior:
                                                                            Clip
                                                                                .antiAliasWithSaveLayer,
                                                                        context:
                                                                            context,
                                                                        builder: (context) =>
                                                                            Container(
                                                                              height: 1.sh / 3,
                                                                              padding: EdgeInsets.all(20.w),
                                                                              child: Column(
                                                                                children: [
                                                                                  InkWell(
                                                                                    onTap: () {
                                                                                      Navigator.pop(context);

                                                                                      getTableInfor(roomId: state.listRoomModel!.rooms![currentRoomIndex].storeRoomId.toString(), tableId: state.listRoomModel!.rooms![currentRoomIndex].tables![index].roomTableId.toString(), orderID: state.listRoomModel!.rooms![currentRoomIndex].tables![index].orderId.toString());
                                                                                      showDialog(
                                                                                        context: context,
                                                                                        builder: (BuildContext context) {
                                                                                          return BookingTableDialog(
                                                                                            eventSaveButton: () {
                                                                                              getDataTabIndex(
                                                                                                roomId: state.listRoomModel!.rooms![currentRoomIndex].storeRoomId.toString(),
                                                                                              );
                                                                                            },
                                                                                            orderID: state.listRoomModel!.rooms![currentRoomIndex].tables![index].orderId.toString(),
                                                                                            token: tokenStaff,
                                                                                            role: currentRole,
                                                                                            shopID: currentShopId,
                                                                                            idRoom: state.listRoomModel!.rooms![currentRoomIndex].storeRoomId,
                                                                                            listTableOfRoom: state.listRoomModel!.rooms![currentRoomIndex].tables,
                                                                                            currentTable: state.listRoomModel!.rooms![currentRoomIndex].tables![index],
                                                                                          );
                                                                                        },
                                                                                      );
                                                                                    },
                                                                                    child: Row(
                                                                                      children: [
                                                                                        Icon(
                                                                                          Icons.receipt,
                                                                                          size: 35.sp,
                                                                                        ),
                                                                                        space10W,
                                                                                        TextApp(
                                                                                          text: "Quản lý hoá đơn",
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

                                                                                      getSwitchTableData(
                                                                                        roomId: state.listRoomModel!.rooms![currentRoomIndex].storeRoomId.toString(),
                                                                                        tableId: state.listRoomModel!.rooms![currentRoomIndex].tables![index].roomTableId.toString(),
                                                                                        orderID: state.listRoomModel!.rooms![currentRoomIndex].tables![index].orderId.toString(),
                                                                                      );
                                                                                      showDialog(
                                                                                          context: context,
                                                                                          builder: (BuildContext context) {
                                                                                            return MoveTableDialog(
                                                                                              token: tokenStaff,
                                                                                              role: currentRole,
                                                                                              shopID: currentShopId,
                                                                                              orderID: state.listRoomModel!.rooms![currentRoomIndex].tables![index].orderId.toString(),
                                                                                              currentTable: state.listRoomModel!.rooms![currentRoomIndex].tables![index],
                                                                                              nameRoom: roomName,
                                                                                              roomID: state.listRoomModel!.rooms![currentRoomIndex].storeRoomId.toString(),
                                                                                              listIdRoom: listRoomID,
                                                                                              eventSaveButton: () {
                                                                                                getDataTabIndex(
                                                                                                  roomId: state.listRoomModel!.rooms![currentRoomIndex].storeRoomId.toString(),
                                                                                                );
                                                                                              },
                                                                                            );
                                                                                          });
                                                                                    },
                                                                                    child: Row(
                                                                                      children: [
                                                                                        Icon(
                                                                                          Icons.table_bar,
                                                                                          size: 35.sp,
                                                                                        ),
                                                                                        space10W,
                                                                                        TextApp(
                                                                                          text: "Ghép bàn",
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

                                                                                      getBillData(
                                                                                        roomId: state.listRoomModel!.rooms![currentRoomIndex].storeRoomId.toString(),
                                                                                        tableId: state.listRoomModel!.rooms![currentRoomIndex].tables![index].roomTableId.toString(),
                                                                                        orderID: state.listRoomModel!.rooms![currentRoomIndex].tables![index].orderId.toString(),
                                                                                      );
                                                                                      showDialog(
                                                                                          useRootNavigator: false,
                                                                                          context: context,
                                                                                          builder: (BuildContext context) {
                                                                                            return SeeBillDialog(
                                                                                              token: tokenStaff,
                                                                                              role: currentRole,
                                                                                              shopID: currentShopId,
                                                                                              orderID: state.listRoomModel!.rooms![currentRoomIndex].tables?[index].orderId,
                                                                                              roomID: state.listRoomModel!.rooms![currentRoomIndex].storeRoomId.toString(),
                                                                                              currentTable: state.listRoomModel!.rooms![currentRoomIndex].tables![index],
                                                                                              nameRoom: roomName,
                                                                                            );
                                                                                          });
                                                                                    },
                                                                                    child: Row(
                                                                                      children: [
                                                                                        Icon(
                                                                                          Icons.print,
                                                                                          size: 35.sp,
                                                                                        ),
                                                                                        space10W,
                                                                                        TextApp(
                                                                                          text: "In hoá đơn",
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

                                                                                      getPaymentData(
                                                                                        tableId: state.listRoomModel!.rooms![currentRoomIndex].tables![index].roomTableId.toString(),
                                                                                        orderID: state.listRoomModel!.rooms![currentRoomIndex].tables![index].orderId.toString(),
                                                                                      );
                                                                                      showDialog(
                                                                                          context: context,
                                                                                          builder: (BuildContext context) {
                                                                                            return PayBillDialog(
                                                                                              token: tokenStaff,
                                                                                              role: currentRole,
                                                                                              shopID: currentShopId,
                                                                                              orderID: state.listRoomModel!.rooms![currentRoomIndex].tables?[index].orderId.toString(),
                                                                                              roomID: state.listRoomModel!.rooms![currentRoomIndex].storeRoomId.toString(),
                                                                                              currentTable: state.listRoomModel!.rooms![currentRoomIndex].tables![index],
                                                                                              nameRoom: roomName,
                                                                                              eventSaveButton: () {
                                                                                                getDataTabIndex(
                                                                                                  roomId: state.listRoomModel!.rooms![currentRoomIndex].storeRoomId.toString(),
                                                                                                );
                                                                                              },
                                                                                            );
                                                                                          });
                                                                                    },
                                                                                    child: Row(
                                                                                      children: [
                                                                                        Icon(
                                                                                          Icons.cancel,
                                                                                          size: 35.sp,
                                                                                        ),
                                                                                        space10W,
                                                                                        TextApp(
                                                                                          text: "Huỷ hoá đơn",
                                                                                          color: Colors.black,
                                                                                          fontsize: 18.sp,
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ));
                                                                  },
                                                                  child: Stack(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    children: [
                                                                      Image
                                                                          .asset(
                                                                        "assets/images/table_image.png",
                                                                        fit: BoxFit
                                                                            .contain,
                                                                      ),
                                                                      Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        children: [
                                                                          TextApp(
                                                                            isOverFlow:
                                                                                false,
                                                                            softWrap:
                                                                                true,
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            text:
                                                                                state.listRoomModel!.rooms![currentRoomIndex].tables?[index].tableName ?? '',
                                                                            color:
                                                                                Colors.black,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                          TextApp(
                                                                            text:
                                                                                state.listRoomModel!.rooms![currentRoomIndex].tables?[index].orderCreatedAt.toString() ?? '',
                                                                            color:
                                                                                orangeColorApp,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                        );
                                                      }),
                                                )
                                              : RefreshIndicator(
                                                  color: Colors.blue,
                                                  onRefresh: () async {
                                                    getDataTabIndex(
                                                      roomId: state
                                                          .listRoomModel!
                                                          .rooms![
                                                              currentRoomIndex]
                                                          .storeRoomId
                                                          .toString(),
                                                    );
                                                  },
                                                  child: ListView.builder(
                                                      itemCount: 1,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 30.w,
                                                                  right: 30.w),
                                                          child: Container(
                                                            width: 1.sw,
                                                            height: 50,
                                                            color: Colors.blue,
                                                            child: Center(
                                                              child: TextApp(
                                                                text:
                                                                    "Phòng này không có bàn",
                                                                color: Colors
                                                                    .white,
                                                                fontsize: 14.sp,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      }),
                                                ),
                                    ),
                                  )
                                ],
                              ),
                        SizedBox(
                          height: 15.h,
                        ),
                      ],
                    ),
                  )
                : state.listRoomStatus == ListRoomStatus.loading
                    ? Center(
                        child: SizedBox(
                          width: 200.w,
                          height: 200.w,
                          child: Lottie.asset(
                              'assets/lottie/loading_7_color.json'),
                        ),
                      )
                    : Center(
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
                              text: state.errorText.toString(),
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
                                  getDataTabIndex(
                                    roomId: state
                                            .listRoomModel
                                            ?.rooms![currentRoomIndex]
                                            .storeRoomId
                                            .toString() ??
                                        '',
                                  );
                                },
                                text: 'Thử lại',
                                fontSize: 12.sp,
                                radius: 8.r,
                                textColor: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
          )));
    });
  }
}

//// Phần của đầu bếp
class ChefHomeScreen extends StatefulWidget {
  const ChefHomeScreen({super.key});

  @override
  State<ChefHomeScreen> createState() => _ChefHomeScreenState();
}

class _ChefHomeScreenState extends State<ChefHomeScreen> {
  List<String> stateBill = [
    "TẤT CẢ",
    "CHỜ XÁC NHẬN",
    "ĐANG CHUẨN BỊ",
    "ĐÃ XONG"
  ];
  List<String> updateStatusList = ["Chờ xác nhận", "Đang chuẩn bị", "Đã xong"];

  String selectedCategories = 'TẤT CẢ';
  int? selectedCategoriesIndex;
  DataListFoodOrderModel? dataListFoodOrderModel;
  List currentListOrderBill = [];
  List<bool> checkedList = [];
  bool isChecked = false;
  bool isSelectedAll = false;
  List<int> listIdOrder = [];
  int? currentStatus;
  int currentPage = 1;
  final scrollListOrderController = ScrollController();
  bool hasMore = true;

  Timer? timer;
  void getListOrderOfChef({
    required int page,
    required int? foodInOrderStatus,
  }) async {
    log({
      'shop_id': getStaffShopID,
      'client': "staff",
      'is_api': true,
      'filters': {'food_in_order_status': foodInOrderStatus},
      'limit': 15,
      'page': page
    }.toString());
    try {
      var token = StorageUtils.instance.getString(key: 'token_staff');

      final respons = await http.post(
        Uri.parse('$baseUrl$chefListFoodOrder'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          'shop_id': getStaffShopID,
          'client': "staff",
          'is_api': true,
          'filters': {'food_in_order_status': foodInOrderStatus},
          'limit': 15,
          'page': page
        }),
      );
      final data = jsonDecode(respons.body);
      print(data);
      try {
        if (data['status'] == 200) {
          mounted
              ? setState(() {
                  // currentListOrderBill.clear();
                  dataListFoodOrderModel =
                      DataListFoodOrderModel.fromJson(data);
                  currentListOrderBill
                      .addAll(dataListFoodOrderModel?.data.data ?? []);
                  // currentPage++;
                  if (dataListFoodOrderModel!.data.data.isEmpty ||
                      dataListFoodOrderModel!.data.data.length <= 15) {
                    hasMore = false;
                  }
                  checkedList =
                      List<bool>.filled(currentListOrderBill.length, false);
                  isSelectedAll = false;
                  listIdOrder = [];
                })
              : null;
        } else {
          print("ERROR BROUGHT RECEIPT PAGE 1");
        }
      } catch (error) {
        print("ERROR BROUGHT RECEIPT PAGE 2 $error");
      }
    } catch (error) {
      print("ERROR BROUGHT RECEIPT PAGE 3 $error");
    }
  }

  void refeshListOrderOfChef({
    required int page,
    required int? foodInOrderStatus,
  }) async {
    log({
      'shop_id': getStaffShopID,
      'client': "staff",
      'is_api': true,
      'filters': {'food_in_order_status': foodInOrderStatus},
      'limit': 15,
      'page': page
    }.toString());
    try {
      var token = StorageUtils.instance.getString(key: 'token_staff');

      final respons = await http.post(
        Uri.parse('$baseUrl$chefListFoodOrder'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          'shop_id': getStaffShopID,
          'client': "staff",
          'is_api': true,
          'filters': {'food_in_order_status': foodInOrderStatus},
          'limit': 15,
          'page': page
        }),
      );
      final data = jsonDecode(respons.body);
      print(data);
      try {
        if (data['status'] == 200) {
          mounted
              ? setState(() {
                  currentListOrderBill.clear();
                  dataListFoodOrderModel =
                      DataListFoodOrderModel.fromJson(data);
                  currentListOrderBill
                      .addAll(dataListFoodOrderModel?.data.data ?? []);
                  // currentPage++;
                  // if (dataListFoodOrderModel!.data.data.isEmpty ||
                  //     dataListFoodOrderModel!.data.data.length <= 15) {
                  //   hasMore = false;
                  // }
                  // checkedList =
                  //     List<bool>.filled(currentListOrderBill.length, false);
                  // isSelectedAll = false;
                  // listIdOrder = [];
                })
              : null;
        } else {
          print("ERROR BROUGHT RECEIPT PAGE 1");
        }
      } catch (error) {
        print("ERROR BROUGHT RECEIPT PAGE 2 $error");
      }
    } catch (error) {
      print("ERROR BROUGHT RECEIPT PAGE 3 $error");
    }
  }

  void hanldeUpdateStatusOrderFood({
    required List<int> idList,
    required int? status,
  }) async {
    try {
      var token = StorageUtils.instance.getString(key: 'token_staff');

      final respons = await http.post(
        Uri.parse('$baseUrl$updateStatusFoodOrder'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          'ids': idList,
          'status': status,
          'client': 'staff',
          'shop_id': getStaffShopID,
          'is_api': true,
        }),
      );
      final data = jsonDecode(respons.body);
      print(data);
      try {
        if (data['status'] == 200) {
          mounted
              ? setState(() {
                  selectedCategories = 'TẤT CẢ';
                  selectedCategoriesIndex = 0;
                  currentListOrderBill.clear();
                  currentPage = 1;
                  getListOrderOfChef(
                      page: currentPage, foodInOrderStatus: null);
                })
              : null;
        } else {
          print("ERROR BROUGHT RECEIPT PAGE 1");
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

    getListOrderOfChef(foodInOrderStatus: null, page: 1);
    scrollListOrderController.addListener(() {
      if (scrollListOrderController.position.maxScrollExtent ==
          scrollListOrderController.offset) {
        log("selectedCategoriesIndex");

        log(selectedCategoriesIndex.toString());
        getListOrderOfChef(
            foodInOrderStatus: selectedCategoriesIndex == 0
                ? null
                : selectedCategoriesIndex == 1
                    ? 0
                    : selectedCategoriesIndex == 2
                        ? 1
                        : selectedCategoriesIndex == 3
                            ? 2
                            : null,
            page: currentPage);
      }
    });
    // timer = Timer.periodic(Duration(seconds: 2), (Timer t) {
    //   currentPage = 1;
    //   currentListOrderBill.clear();

    //   getListOrderOfChef(
    //       foodInOrderStatus: selectedCategoriesIndex == 0
    //           ? null
    //           : selectedCategoriesIndex == 1
    //               ? 0
    //               : selectedCategoriesIndex == 2
    //                   ? 1
    //                   : selectedCategoriesIndex == 3
    //                       ? 2
    //                       : null,
    //       page: 1);
    // });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List filterOrderBill = currentListOrderBill.where((order) {
      // final foodTitle = product.foodName.toLowerCase();
      // final input = query.toLowerCase();
      return (selectedCategoriesIndex == null ||
          selectedCategoriesIndex == stateBill.indexOf(selectedCategories));
    }).toList();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding:
              EdgeInsets.only(top: 10.h, left: 25.w, right: 25.w, bottom: 10.h),
          child: Column(
            children: [
              Container(
                  height: 50,
                  child: Row(
                    children: [
                      Expanded(
                        child: ListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          children: stateBill.map((lableFood) {
                            return Padding(
                              padding: EdgeInsets.only(right: 5.w, left: 5.w),
                              child: FilterChip(
                                labelPadding: EdgeInsets.only(
                                    left: 15.w,
                                    right: 15.w,
                                    top: 8.w,
                                    bottom: 8.w),
                                disabledColor: Colors.blue,
                                selectedColor: Colors.blue,
                                backgroundColor: Colors.white,
                                shadowColor: Colors.black,
                                selectedShadowColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.w),
                                  side: BorderSide(
                                    color:
                                        selectedCategories.contains(lableFood)
                                            ? Colors.grey.withOpacity(0.5)
                                            : Colors.blue,
                                    width: 1.0,
                                  ),
                                ),
                                labelStyle: TextStyle(
                                    color:
                                        selectedCategories.contains(lableFood)
                                            ? Colors.white
                                            : Colors.blue),
                                showCheckmark: false,
                                label: Text(lableFood.toUpperCase()),
                                selected:
                                    selectedCategories.contains(lableFood),
                                onSelected: (bool selected) {
                                  mounted
                                      ? setState(() {
                                          if (selected) {
                                            selectedCategories = lableFood;
                                            int index =
                                                stateBill.indexOf(lableFood);
                                            selectedCategoriesIndex = index;
                                            currentPage = 1;
                                            // log("INDEX");
                                            // log(index.toString());
                                            // log("selectedCategoriesIndex");

                                            // log(selectedCategoriesIndex
                                            //     .toString());
                                            currentListOrderBill.clear();
                                            getListOrderOfChef(
                                                foodInOrderStatus:
                                                    selectedCategoriesIndex == 0
                                                        ? null
                                                        : selectedCategoriesIndex ==
                                                                1
                                                            ? 0
                                                            : selectedCategoriesIndex ==
                                                                    2
                                                                ? 1
                                                                : selectedCategoriesIndex ==
                                                                        3
                                                                    ? 2
                                                                    : null,
                                                page: 1);
                                          } else {
                                            selectedCategories = 'TẤT CẢ';
                                            selectedCategoriesIndex = null;
                                            currentPage = 1;

                                            currentListOrderBill.clear();

                                            getListOrderOfChef(
                                                foodInOrderStatus: null,
                                                page: currentPage);
                                          }
                                        })
                                      : null;
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  )),
              space25H,
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: SizedBox(
                      // height: 35.h,
                      child: ButtonGradient(
                        radius: 5.r,
                        color1: color1BlueButton,
                        color2: color2BlueButton,
                        event: () {
                          mounted
                              ? setState(() {
                                  isSelectedAll = !isSelectedAll;
                                  for (var i = 0;
                                      i < filterOrderBill.length;
                                      i++) {
                                    checkedList[i] = isSelectedAll;
                                    if (checkedList[i] == true) {
                                      listIdOrder.add(
                                          filterOrderBill[i].foodInOrderId);
                                    } else if (checkedList[i] == false) {
                                      listIdOrder.remove(
                                          filterOrderBill[i].foodInOrderId);
                                    }
                                  }
                                })
                              : null;
                        },
                        text: "CHỌN TẤT CẢ",
                        textColor: Colors.white,
                      ),
                    )),
                    space15W,
                    Expanded(
                      child: DropdownSearch(
                        selectedItem: "Chọn trạng thái",
                        items: updateStatusList,
                        onChanged: (state) {
                          // currentListOrderBill.clear();
                          mounted
                              ? setState(() {
                                  if (state == "Chờ xác nhận") {
                                    currentStatus = 0;
                                  } else if (state == "Đang chuẩn bị") {
                                    currentStatus = 1;
                                  } else if (state == "Đã xong") {
                                    currentStatus = 2;
                                  }
                                })
                              : null;
                          if (listIdOrder.isNotEmpty) {
                            showConfirmDialog(context, () {
                              hanldeUpdateStatusOrderFood(
                                  idList: listIdOrder, status: currentStatus);
                            });
                          }
                        },
                        dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            // isCollapsed: true,

                            hintMaxLines: 1,
                            fillColor: const Color.fromARGB(255, 226, 104, 159),
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
                            hintStyle: TextStyle(fontSize: 14.sp),
                            hintText: "Chọn trạng thái",
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              space25H,
              Expanded(
                child: RefreshIndicator(
                  color: Colors.blue,
                  onRefresh: () async {
                    refeshListOrderOfChef(
                      page: 1,
                      foodInOrderStatus: selectedCategoriesIndex == 0
                          ? null
                          : selectedCategoriesIndex == 1
                              ? 0
                              : selectedCategoriesIndex == 2
                                  ? 1
                                  : selectedCategoriesIndex == 3
                                      ? 2
                                      : null,
                    );
                  },
                  child: Container(
                    width: 1.sw,
                    color: Colors.white,
                    child: ListView.builder(
                      controller: scrollListOrderController,
                      shrinkWrap: true,
                      itemCount: filterOrderBill.length + 1,
                      itemBuilder: (context, index) {
                        var dataLength = filterOrderBill.length;
                        if (index < dataLength) {
                          var statusText = filterOrderBill[index]
                                      .foodInOrderStatus ==
                                  0
                              ? 'CHỜ XÁC NHẬN'
                              : filterOrderBill[index].foodInOrderStatus == 1
                                  ? 'ĐANG CHUẨN BỊ'
                                  : 'ĐÃ XONG';
                          Color color1 = filterOrderBill[index]
                                      .foodInOrderStatus ==
                                  0
                              ? color1BlueButton
                              : filterOrderBill[index].foodInOrderStatus == 1
                                  ? color1OrganeButton
                                  : color2GreenButton;
                          Color color2 = filterOrderBill[index]
                                      .foodInOrderStatus ==
                                  0
                              ? color2BlueButton
                              : filterOrderBill[index].foodInOrderStatus == 1
                                  ? color2OrangeButton
                                  : color1GreenButton;
                          return Column(
                            children: [
                              space10H,
                              Container(
                                  width: 1.sw,
                                  // height: 100.h,
                                  margin:
                                      EdgeInsets.only(left: 10.w, right: 10.w),
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
                                    padding: EdgeInsets.all(10.w),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width: 20.w,
                                              height: 20.w,
                                              child: InkWell(
                                                onTap: () {
                                                  showMaterialModalBottomSheet(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topRight:
                                                            Radius.circular(
                                                                25.r),
                                                        topLeft:
                                                            Radius.circular(
                                                                25.r),
                                                      ),
                                                    ),
                                                    clipBehavior: Clip
                                                        .antiAliasWithSaveLayer,
                                                    context: context,
                                                    builder: (context) =>
                                                        Container(
                                                      height: 1.sh / 3,
                                                      padding:
                                                          EdgeInsets.all(20.w),
                                                      child: Column(
                                                        children: [
                                                          InkWell(
                                                            onTap: () async {
                                                              Navigator.pop(
                                                                  context);

                                                              mounted
                                                                  ? setState(
                                                                      () {
                                                                      listIdOrder
                                                                          .clear();
                                                                      listIdOrder.add(
                                                                          filterOrderBill[index]
                                                                              .foodInOrderId);
                                                                      hanldeUpdateStatusOrderFood(
                                                                          idList:
                                                                              listIdOrder,
                                                                          status:
                                                                              0);
                                                                    })
                                                                  : null;
                                                            },
                                                            child: Row(
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .timer_outlined,
                                                                  size: 35.sp,
                                                                ),
                                                                space10W,
                                                                TextApp(
                                                                  text:
                                                                      "Chờ xác nhận",
                                                                  color: Colors
                                                                      .black,
                                                                  fontsize:
                                                                      18.sp,
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          space10H,
                                                          Divider(),
                                                          InkWell(
                                                            onTap: () async {
                                                              Navigator.pop(
                                                                  context);

                                                              mounted
                                                                  ? setState(
                                                                      () {
                                                                      listIdOrder
                                                                          .clear();
                                                                      listIdOrder.add(
                                                                          filterOrderBill[index]
                                                                              .foodInOrderId);
                                                                      hanldeUpdateStatusOrderFood(
                                                                          idList:
                                                                              listIdOrder,
                                                                          status:
                                                                              1);
                                                                    })
                                                                  : null;
                                                            },
                                                            child: Row(
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .food_bank_outlined,
                                                                  size: 35.sp,
                                                                ),
                                                                space10W,
                                                                TextApp(
                                                                  text:
                                                                      "Đang chuẩn bị",
                                                                  color: Colors
                                                                      .black,
                                                                  fontsize:
                                                                      18.sp,
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          Divider(),
                                                          space10H,
                                                          InkWell(
                                                            onTap: () async {
                                                              Navigator.pop(
                                                                  context);
                                                              mounted
                                                                  ? setState(
                                                                      () {
                                                                      listIdOrder
                                                                          .clear();
                                                                      listIdOrder.add(
                                                                          filterOrderBill[index]
                                                                              .foodInOrderId);
                                                                      hanldeUpdateStatusOrderFood(
                                                                          idList:
                                                                              listIdOrder,
                                                                          status:
                                                                              2);
                                                                    })
                                                                  : null;
                                                            },
                                                            child: Row(
                                                              children: [
                                                                Icon(
                                                                  Icons.done,
                                                                  size: 35.sp,
                                                                ),
                                                                space10W,
                                                                TextApp(
                                                                  text:
                                                                      "Đã xong",
                                                                  color: Colors
                                                                      .black,
                                                                  fontsize:
                                                                      18.sp,
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Icon(
                                                  Icons.more_horiz_outlined,
                                                  size: 25.sp,
                                                ),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                TextApp(
                                                  text: filterOrderBill[index]
                                                      .foodName,
                                                  color: orangeColorApp,
                                                  fontWeight: FontWeight.bold,
                                                  fontsize: 12.sp,
                                                ),
                                                TextApp(text: " | "),
                                                TextApp(
                                                  text: filterOrderBill[index]
                                                      .tableName,
                                                  fontsize: 12.sp,
                                                  color: menuGrey,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                TextApp(text: " | "),
                                                TextApp(
                                                  text: filterOrderBill[index]
                                                      .storeRoomName,
                                                  fontsize: 12.sp,
                                                  color: menuGrey,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ],
                                            ),
                                            Checkbox(
                                                value: checkedList[index],
                                                onChanged: (bool? value) {
                                                  mounted
                                                      ? setState(() {
                                                          checkedList[index] =
                                                              value!;
                                                          if (checkedList[
                                                                  index] ==
                                                              true) {
                                                            listIdOrder.add(
                                                                filterOrderBill[
                                                                        index]
                                                                    .foodInOrderId);
                                                          } else if (checkedList[
                                                                  index] ==
                                                              false) {
                                                            listIdOrder.remove(
                                                                filterOrderBill[
                                                                        index]
                                                                    .foodInOrderId);
                                                          }
                                                          log("listIdOrder");
                                                          log(listIdOrder
                                                              .toString());
                                                        })
                                                      : null;

                                                  // log(checkedList.toString());
                                                }),
                                            // typePopMenu
                                          ],
                                        ),
                                        space10H,
                                        Row(
                                          children: [
                                            TextApp(text: 'Người tạo: '),
                                            TextApp(
                                                text: filterOrderBill[index]
                                                    .staffFullName),
                                          ],
                                        ),
                                        // SizedBox(
                                        //   height: 10.h,
                                        // ),
                                        space10H,

                                        Row(
                                          children: [
                                            TextApp(text: 'Thời gian: '),
                                            TextApp(
                                                text: formatDateTime(
                                                    filterOrderBill[index]
                                                        .createdAt))
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                TextApp(
                                                  text: 'Giá tiền: ',
                                                  fontsize: 16.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                TextApp(
                                                  text:
                                                      "${MoneyFormatter(amount: (filterOrderBill[index].foodPrice ?? 0).toDouble()).output.withoutFractionDigits.toString()} đ",
                                                  fontsize: 16.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              width: 150.w,
                                              height: 35.h,
                                              child: ButtonGradient(
                                                radius: 5.r,
                                                color1: color1,
                                                color2: color2,
                                                event: () {},
                                                text: statusText,
                                                textColor: Colors.white,
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  )),
                              space10H
                            ],
                          );
                        } else {
                          return Center(
                            child: hasMore
                                ? CircularProgressIndicator()
                                : Container(),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
