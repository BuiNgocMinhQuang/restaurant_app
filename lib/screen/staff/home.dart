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
import 'package:app_restaurant/widgets/list_pop_menu.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

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
  }) async {
    BlocProvider.of<TableBloc>(context).add(GetTableInfor(
        token: tokenStaff,
        client: currentRole,
        shopId: getStaffShopID,
        roomId: roomId ?? '',
        tableId: tableId));
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
                                height: 40.h,
                                color: Colors.white,
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
                                          child: TextApp(
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
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(2.r),
                                      gradient: const LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: <Color>[
                                          color1DarkGreyButton,
                                          color2DarkGreyButton
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  TextApp(text: "Đang phục vụ")
                                ],
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(2.r),
                                      gradient: const LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: <Color>[
                                            color2BlueButton,
                                            color1BlueButton
                                          ]),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  TextApp(text: "Bàn trống")
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
                                      height: 500,
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
                                                                .rooms![index]
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
                                                                const EdgeInsets
                                                                    .all(10),
                                                            child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.r),
                                                                  gradient:
                                                                      LinearGradient(
                                                                    begin: Alignment
                                                                        .topLeft,
                                                                    end: Alignment
                                                                        .bottomRight,
                                                                    colors: state.listRoomModel!.rooms![currentRoomIndex].tables?[index].bookingStatus ==
                                                                            true
                                                                        ? <Color>[
                                                                            color2BlueButton,
                                                                            color1BlueButton
                                                                          ]
                                                                        : <Color>[
                                                                            color1DarkGreyButton,
                                                                            color2DarkGreyButton
                                                                          ],
                                                                  ),
                                                                ),
                                                                width: 50,
                                                                height: 50,
                                                                child: Stack(
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          children: [
                                                                            SizedBox(
                                                                                width: 100.w,
                                                                                child: Center(
                                                                                  child: TextApp(
                                                                                    isOverFlow: false,
                                                                                    softWrap: true,
                                                                                    textAlign: TextAlign.center,
                                                                                    text: state.listRoomModel!.rooms![currentRoomIndex].tables?[index].tableName ?? '',
                                                                                    color: Colors.white,
                                                                                    fontWeight: FontWeight.bold,
                                                                                  ),
                                                                                )),
                                                                            if (state.listRoomModel!.rooms![currentRoomIndex].tables?[index].bookingStatus ==
                                                                                false)
                                                                              TextApp(text: state.listRoomModel!.rooms![currentRoomIndex].tables?[index].clientCanPay.toString() ?? '', color: Colors.white),
                                                                            TextApp(
                                                                                text: state.listRoomModel!.rooms![currentRoomIndex].tables?[index].orderCreatedAt.toString() ?? '',
                                                                                color: Colors.white)
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Positioned(
                                                                        top: 0,
                                                                        right:
                                                                            0,
                                                                        child: state.listRoomModel!.rooms![currentRoomIndex].tables?[index].bookingStatus ==
                                                                                false
                                                                            ? PopUpMenuUsingTable(eventButton1:
                                                                                () {
                                                                                getTableInfor(
                                                                                  roomId: state.listRoomModel!.rooms![currentRoomIndex].storeRoomId.toString(),
                                                                                  tableId: state.listRoomModel!.rooms![currentRoomIndex].tables![index].roomTableId.toString(),
                                                                                );
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
                                                                              }, eventButton2:
                                                                                () {
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
                                                                              }, eventButton3:
                                                                                () {
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
                                                                              }, eventButton4:
                                                                                () {
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
                                                                              })
                                                                            : PopUpMenuUnUseTable(eventButton1:
                                                                                () {
                                                                                getTableInfor(
                                                                                  roomId: state.listRoomModel!.rooms![currentRoomIndex].storeRoomId.toString(),
                                                                                  tableId: state.listRoomModel!.rooms![currentRoomIndex].tables![index].roomTableId.toString(),
                                                                                );

                                                                                showDialog(
                                                                                    context: context,
                                                                                    builder: (BuildContext context) {
                                                                                      return BookingTableDialog(
                                                                                        token: tokenStaff,
                                                                                        role: currentRole,
                                                                                        shopID: currentShopId,
                                                                                        idRoom: state.listRoomModel!.rooms![currentRoomIndex].storeRoomId,
                                                                                        eventSaveButton: () {
                                                                                          getDataTabIndex(
                                                                                            roomId: state.listRoomModel!.rooms![currentRoomIndex].storeRoomId.toString(),
                                                                                          );
                                                                                        },
                                                                                        listTableOfRoom: state.listRoomModel!.rooms![currentRoomIndex].tables,
                                                                                        currentTable: state.listRoomModel!.rooms![currentRoomIndex].tables![index],
                                                                                      );
                                                                                    });
                                                                              })),
                                                                  ],
                                                                )));
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
