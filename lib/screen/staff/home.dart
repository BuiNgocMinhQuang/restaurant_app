import 'dart:async';
import 'package:app_restaurant/bloc/bill/bill_bloc.dart';
import 'package:app_restaurant/bloc/manager/room/list_room_bloc.dart';
import 'package:app_restaurant/bloc/manager/tables/table_bloc.dart';
import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/config/space.dart';
import 'package:app_restaurant/utils/share_getString.dart';
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
  void saveMoveTableModal() {}

  void savePayBillModal() {}

  void getDataTabIndex({String? roomId, required String role}) async {
    await Future.delayed(const Duration(seconds: 0));

    BlocProvider.of<ListRoomBloc>(context).add(
      GetListRoom(
          client: role,
          shopId: getStaffShopID,
          isApi: true,
          roomId: roomId ?? ''),
    );
  }

  void getTableInfor(
      {String? roomId, required String tableId, required String role}) async {
    BlocProvider.of<TableBloc>(context).add(GetTableInfor(
        client: role,
        shopId: getStaffShopID,
        roomId: roomId ?? '',
        tableId: tableId));
  }

  void getSwitchTableData(
      {String? roomId,
      required String tableId,
      required String role,
      required String orderID}) async {
    BlocProvider.of<TableBloc>(context).add(GetTableSwitchInfor(
        client: role,
        shopId: getStaffShopID,
        roomId: roomId ?? '',
        tableId: tableId,
        orderId: orderID));
  }

  void getBillData(
      {String? roomId,
      required String tableId,
      required String role,
      required String orderID}) async {
    BlocProvider.of<BillInforBloc>(context).add(GetBillInfor(
        client: role,
        shopId: getStaffShopID,
        roomId: roomId ?? '',
        tableId: tableId,
        orderId: orderID));
  }

  void getFoodTableData(String roomId, String tableId, String role) async {
    BlocProvider.of<TableBloc>(context).add(GetTableFoods(
        client: role,
        shopId: getStaffShopID,
        roomId: roomId,
        tableId: tableId,
        limit: 1.toString(),
        page: 1.toString()));
  }

  @override
  void initState() {
    getDataTabIndex(roomId: "", role: "staff");
    super.initState();
  }

  var indexRoomID = 1;

  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(
      length: 2,
      vsync: this,
    );

    return BlocBuilder<ListRoomBloc, ListRoomState>(builder: (context, state) {
      return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
              child: SizedBox(
            width: double.maxFinite,
            child: state.listRoomStatus == ListRoomStatus.succes
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 1.sw,
                        child: SizedBox(
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  height: 40.h,
                                  color: Colors.white,
                                  child: TabBar(
                                    onTap: (index) {
                                      indexRoomID = index;
                                      getDataTabIndex(
                                          roomId: state.listRoomModel!
                                              .rooms![index].storeRoomId
                                              .toString(),
                                          role: "staff");
                                    },
                                    labelPadding: const EdgeInsets.only(
                                        left: 20, right: 20),
                                    labelColor: Colors.blue,
                                    labelStyle: TextStyle(
                                        fontSize: 14.sp,
                                        fontFamily: 'OpenSans',
                                        fontWeight: FontWeight.bold),
                                    unselectedLabelColor:
                                        Colors.black.withOpacity(0.5),
                                    controller: _tabController,
                                    isScrollable: true,
                                    indicatorSize: TabBarIndicatorSize.label,
                                    tabs: state.listRoomModel!.rooms!
                                        .map((data) =>
                                            Tab(text: data.storeRoomName))
                                        .toList(),
                                  ),
                                ))),
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
                                  color: grey,
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
                                  color: lightBlue,
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
                                  padding:
                                      EdgeInsets.only(left: 30.w, right: 30.w),
                                  child: SizedBox(
                                    width: 1.sw,
                                    height: 500,
                                    child: TabBarView(
                                      controller: _tabController,
                                      children: state.listRoomModel!.rooms!
                                          .map((data) => data.tables!.isNotEmpty
                                              ? RefreshIndicator(
                                                  color: Colors.blue,
                                                  onRefresh: () async {
                                                    getDataTabIndex(
                                                        roomId: state
                                                            .listRoomModel!
                                                            .rooms![indexRoomID]
                                                            .storeRoomId
                                                            .toString(),
                                                        role:
                                                            "staff"); //get data table of firts room
                                                  },
                                                  child: GridView.builder(
                                                      gridDelegate:
                                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                                              crossAxisCount:
                                                                  3),
                                                      itemCount:
                                                          data.tables?.length ??
                                                              1,
                                                      itemBuilder:
                                                          (context, index) {
                                                        var roomName =
                                                            data.storeRoomName ??
                                                                '';

                                                        var listRoomName = state
                                                            .listRoomModel!
                                                            .rooms!
                                                            .map((data) => data
                                                                .storeRoomName)
                                                            .toList();
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
                                                                  color: data.tables?[index]
                                                                              .bookingStatus ==
                                                                          true
                                                                      ? lightBlue
                                                                      : grey,
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
                                                                                    textAlign: TextAlign.center,
                                                                                    text: data.tables?[index].tableName ?? '',
                                                                                    color: Colors.white,
                                                                                    fontWeight: FontWeight.bold,
                                                                                  ),
                                                                                )),
                                                                            if (data.tables?[index].bookingStatus ==
                                                                                false)
                                                                              TextApp(text: data.tables?[index].clientCanPay.toString() ?? '', color: Colors.white),
                                                                            TextApp(
                                                                                text: data.tables?[index].orderCreatedAt.toString() ?? '',
                                                                                color: Colors.white)
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Positioned(
                                                                        top: 0,
                                                                        right:
                                                                            0,
                                                                        child: data.tables?[index].bookingStatus ==
                                                                                false
                                                                            ? PopUpMenuUsingTable(eventButton1:
                                                                                () {
                                                                                // getDataTabIndex(roomId: state.listRoomModel!.rooms![indexRoomID].storeRoomId.toString(), role: "staff");
                                                                                getTableInfor(
                                                                                  roomId: data.storeRoomId.toString(),
                                                                                  tableId: data.tables![index].roomTableId.toString(),
                                                                                  role: "staff",
                                                                                );
                                                                                getFoodTableData(data.storeRoomId.toString(), data.tables![index].roomTableId.toString(), "staff");
                                                                                showDialog(
                                                                                  context: context,
                                                                                  builder: (BuildContext context) {
                                                                                    return BookingTableDialog(
                                                                                      eventSaveButton: () {
                                                                                        getDataTabIndex(roomId: state.listRoomModel!.rooms![indexRoomID].storeRoomId.toString(), role: "staff");
                                                                                      },
                                                                                      idRoom: data.storeRoomId,
                                                                                      listTableOfRoom: data.tables,
                                                                                      currentTable: data.tables![index],
                                                                                    );
                                                                                  },
                                                                                );
                                                                              }, eventButton2:
                                                                                () {
                                                                                // getDataTabIndex(roomId: state.listRoomModel!.rooms![indexRoomID].storeRoomId.toString(), role: "staff");
                                                                                // getTableInfor(
                                                                                //   roomId: data.storeRoomId.toString(),
                                                                                //   tableId: data.tables![index].roomTableId.toString(),
                                                                                //   role: "staff",
                                                                                // );
                                                                                getSwitchTableData(roomId: data.storeRoomId.toString(), tableId: data.tables![index].roomTableId.toString(), role: "staff", orderID: data.tables![index].orderId.toString());
                                                                                showDialog(
                                                                                    context: context,
                                                                                    builder: (BuildContext context) {
                                                                                      return MoveTableDialog(
                                                                                        orderID: data.tables![index].orderId.toString(),
                                                                                        // listRoom: state.listRoomModel!.rooms![index],
                                                                                        // listNameRoom: listRoomName,
                                                                                        currentTable: data.tables![index],
                                                                                        nameRoom: roomName,
                                                                                        idRoom: listRoomID,
                                                                                        eventSaveButton: saveMoveTableModal,
                                                                                      );
                                                                                    });
                                                                              }, eventButton3:
                                                                                () {
                                                                                getBillData(roomId: data.storeRoomId.toString(), tableId: data.tables![index].roomTableId.toString(), role: "staff", orderID: data.tables![index].orderId.toString());
                                                                                showDialog(
                                                                                    context: context,
                                                                                    builder: (BuildContext context) {
                                                                                      return SeeBillDialog(
                                                                                        currentTable: data.tables![index],
                                                                                        nameRoom: roomName,
                                                                                      );
                                                                                    });
                                                                              }, eventButton4:
                                                                                () {
                                                                                showDialog(
                                                                                    context: context,
                                                                                    builder: (BuildContext context) {
                                                                                      return PayBillDialog(
                                                                                        eventSaveButton: savePayBillModal,
                                                                                      );
                                                                                    });
                                                                              })
                                                                            : PopUpMenuUnUseTable(eventButton1:
                                                                                () {
                                                                                // getDataTabIndex(roomId: state.listRoomModel!.rooms![indexRoomID].storeRoomId.toString(), role: "staff");
                                                                                getTableInfor(
                                                                                  roomId: data.storeRoomId.toString(),
                                                                                  tableId: data.tables![index].roomTableId.toString(),
                                                                                  role: "staff",
                                                                                );
                                                                                getFoodTableData(data.storeRoomId.toString(), data.tables![index].roomTableId.toString(), "staff");

                                                                                showDialog(
                                                                                    context: context,
                                                                                    builder: (BuildContext context) {
                                                                                      return BookingTableDialog(
                                                                                        eventSaveButton: () {
                                                                                          getDataTabIndex(roomId: state.listRoomModel!.rooms![indexRoomID].storeRoomId.toString(), role: "staff");
                                                                                        },
                                                                                        idRoom: data.storeRoomId,
                                                                                        listTableOfRoom: data.tables,
                                                                                        currentTable: data.tables![index],
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
                                                            .rooms![indexRoomID]
                                                            .storeRoomId
                                                            .toString(),
                                                        role: "staff");
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
                                                ))
                                          .toList(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                      SizedBox(
                        height: 15.h,
                      ),
                    ],
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
                                          .rooms![indexRoomID].storeRoomId
                                          .toString(),
                                      role: "staff");
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
