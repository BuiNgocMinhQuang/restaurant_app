import 'dart:async';
import 'dart:convert';

import 'package:app_restaurant/bloc/login/login_bloc.dart';
import 'package:app_restaurant/bloc/manager/room/list_room_bloc.dart';
import 'package:app_restaurant/bloc/manager/tables/table_bloc.dart';
import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/config/fake_data.dart';
import 'package:app_restaurant/config/space.dart';
import 'package:app_restaurant/config/void_show_dialog.dart';
import 'package:app_restaurant/utils/share_getString.dart';
import 'package:app_restaurant/utils/storage.dart';
import 'package:app_restaurant/widgets/button/button_gradient.dart';
import 'package:app_restaurant/widgets/list_custom_dialog.dart';
import 'package:app_restaurant/widgets/list_pop_menu.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
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
  void saveBookingModal() {}

  void saveMoveTableModal() {}

  void savePayBillModal() {}

  void getDataTabIndex(String roomId) async {
    await Future.delayed(const Duration(seconds: 0));

    BlocProvider.of<ListRoomBloc>(context).add(
      GetListRoom(
          client: "user", shopId: getStaffShopID, isApi: true, roomId: roomId),
    );
  }

  void getTableInfor(String roomId, String tableId) {
    BlocProvider.of<TableBloc>(context).add(GetTableInfor(
        client: "user",
        shopId: getStaffShopID,
        roomId: roomId,
        tableId: tableId));
  }

  @override
  void initState() {
    getDataTabIndex("");
    super.initState();
  }

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
                                      getDataTabIndex(state.listRoomModel!
                                          .rooms![index].storeRoomId
                                          .toString());
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
                                                        ""); //get data table of firts room
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
                                                        var tableName = data
                                                                .tables?[index]
                                                                .tableName
                                                                .toString() ??
                                                            ''; //truyền tên bàn
                                                        var listTableJoined =
                                                            data.tables!
                                                                .map((data) =>
                                                                    data)
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
                                                                            TextApp(
                                                                              text: data.tables?[index].tableName ?? '',
                                                                              color: Colors.white,
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
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
                                                                                // getTableInfor(data.storeRoomId.toString(), data.tables?[index].roomTableId.toString() ?? '');

                                                                                print("DATA TU DAY NE $listTableJoined");
                                                                                showDialog(
                                                                                    context: context,
                                                                                    builder: (BuildContext context) {
                                                                                      return BookingTableDialog(eventSaveButton: saveBookingModal, isUsingTable: true, nameTable: tableName, listNameTableJoined: listTableJoined, roomID: data.storeRoomId.toString(), tableID: data.tables?[index].roomTableId.toString());
                                                                                    });
                                                                              }, eventButton2:
                                                                                () {
                                                                                showDialog(
                                                                                    context: context,
                                                                                    builder: (BuildContext context) {
                                                                                      return MoveTableDialog(
                                                                                        eventSaveButton: saveMoveTableModal,
                                                                                      );
                                                                                    });
                                                                              }, eventButton3:
                                                                                () {
                                                                                showDialog(
                                                                                    context: context,
                                                                                    builder: (BuildContext context) {
                                                                                      return const SeeBillDialog();
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
                                                                                // getTableInfor(data.storeRoomId.toString(), data.tables?[index].roomTableId.toString() ?? '');
                                                                                var tableName = data.tables?[index].tableName.toString() ?? '';

                                                                                showDialog(
                                                                                    context: context,
                                                                                    builder: (BuildContext context) {
                                                                                      return BookingTableDialog(eventSaveButton: saveBookingModal, isUsingTable: true, nameTable: tableName, listNameTableJoined: listTableJoined, roomID: data.storeRoomId.toString(), tableID: data.tables?[index].roomTableId.toString());
                                                                                    });
                                                                              })),
                                                                  ],
                                                                )));
                                                      }),
                                                )
                                              : RefreshIndicator(
                                                  color: Colors.blue,
                                                  onRefresh: () async {
                                                    getDataTabIndex("");
                                                    // Implement logic to refresh data for Tab 1
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
                                  getDataTabIndex("");
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
