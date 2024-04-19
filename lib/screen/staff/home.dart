import 'dart:developer';
import 'package:app_restaurant/bloc/bill_table/bill_table_bloc.dart';
import 'package:app_restaurant/bloc/manager/room/list_room_bloc.dart';
import 'package:app_restaurant/bloc/manager/tables/table_bloc.dart';
import 'package:app_restaurant/bloc/payment/payment_bloc.dart';
import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/config/space.dart';
import 'package:app_restaurant/utils/share_getString.dart';
import 'package:app_restaurant/utils/storage.dart';
import 'package:app_restaurant/widgets/button/button_gradient.dart';
import 'package:app_restaurant/widgets/list_custom_dialog.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

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
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     init();
    //     getDataTabIndex(roomId: '');
    //   });
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
                                                                                          Icons.monetization_on,
                                                                                          size: 35.sp,
                                                                                        ),
                                                                                        space10W,
                                                                                        TextApp(
                                                                                          text: "Thanh toán hoá đơn",
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
                                    roomId: state.listRoomModel!
                                        .rooms![currentRoomIndex].storeRoomId
                                        .toString(),
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
