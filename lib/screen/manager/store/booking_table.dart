import 'package:app_restaurant/bloc/bill_table/bill_table_bloc.dart';
import 'package:app_restaurant/bloc/manager/room/list_room_bloc.dart';
import 'package:app_restaurant/bloc/manager/tables/table_bloc.dart';
import 'package:app_restaurant/bloc/payment/payment_bloc.dart';
import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/config/space.dart';
import 'package:app_restaurant/utils/storage.dart';
import 'package:app_restaurant/widgets/button/button_gradient.dart';
import 'package:app_restaurant/widgets/list_custom_dialog.dart';

import 'package:app_restaurant/widgets/list_pop_menu.dart';
import 'package:app_restaurant/widgets/text/copy_right_text.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class ManagerBookingTable extends StatefulWidget {
  const ManagerBookingTable({super.key});

  @override
  State<ManagerBookingTable> createState() => _ManagerBookingTableState();
}

class _ManagerBookingTableState extends State<ManagerBookingTable>
    with TickerProviderStateMixin {
  var tokenManager =
      StorageUtils.instance.getString(key: 'token_manager') ?? '';

  @override
  void initState() {
    super.initState();
    getDataTabIndex(roomId: "");
  }

  void getBillData(
      {String? roomId,
      required String tableId,
      required String orderID}) async {
    BlocProvider.of<BillInforBloc>(context).add(GetBillInfor(
        token: tokenManager,
        client: "user",
        shopId: "123456",
        roomId: roomId ?? '',
        tableId: tableId,
        orderId: orderID));
  }

  void getSwitchTableData(
      {String? roomId,
      required String tableId,
      required String orderID}) async {
    BlocProvider.of<TableBloc>(context).add(GetTableSwitchInfor(
        token: tokenManager,
        client: "user",
        shopId: "123456",
        roomId: roomId ?? '',
        tableId: tableId,
        orderId: orderID));
  }

  void getDataTabIndex({required String roomId}) async {
    await Future.delayed(const Duration(seconds: 0));
    BlocProvider.of<ListRoomBloc>(context).add(
      GetListRoom(
          token: tokenManager,
          client: "user",
          shopId: "123456",
          isApi: true,
          roomId: roomId),
    );
  }

  void getTableInfor({required String roomId, required String tableId}) {
    BlocProvider.of<TableBloc>(context).add(GetTableInfor(
        token: tokenManager,
        client: "user",
        shopId: "123456",
        roomId: roomId,
        tableId: tableId));
  }

  void getPaymentData(
      {String? roomId,
      required String tableId,
      required String orderID}) async {
    BlocProvider.of<PaymentInforBloc>(context).add(GetPaymentInfor(
        token: tokenManager,
        client: "user",
        shopId: "123456",
        roomId: roomId ?? '',
        tableId: tableId,
        orderId: orderID));
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
              ? SingleChildScrollView(
                  child: Column(
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
                                      getDataTabIndex(
                                          roomId: state.listRoomModel!
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
                                  text: "Phòng này không có bàn",
                                  color: Colors.white,
                                  fontsize: 14.sp,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          : Column(mainAxisSize: MainAxisSize.min, children: [
                              Padding(
                                padding:
                                    EdgeInsets.only(left: 30.w, right: 30.w),
                                child: SizedBox(
                                  width: 1.sw,
                                  height: 500,
                                  child: TabBarView(
                                    controller: _tabController,
                                    children: state.listRoomModel!.rooms!
                                        .map((data) => GridView.builder(
                                            gridDelegate:
                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 3),
                                            itemCount: data.tables?.length ?? 0,
                                            itemBuilder: (context, index) {
                                              var listRoomID = state
                                                  .listRoomModel!.rooms!
                                                  .map((data) =>
                                                      data.storeRoomId)
                                                  .toList();
                                              return Padding(
                                                  padding: EdgeInsets.all(10),
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.r),
                                                        color: data
                                                                    .tables?[
                                                                        index]
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
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  SizedBox(
                                                                      width:
                                                                          100.w,
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            TextApp(
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          text: data.tables?[index].tableName ??
                                                                              '',
                                                                          color:
                                                                              Colors.white,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      )),
                                                                  if (data
                                                                          .tables?[
                                                                              index]
                                                                          .bookingStatus ==
                                                                      false)
                                                                    TextApp(
                                                                        text:
                                                                            "${data.tables?[index].clientCanPay.toString() ?? '0'} đ",
                                                                        color: Colors
                                                                            .white),
                                                                  TextApp(
                                                                      text: data
                                                                              .tables?[
                                                                                  index]
                                                                              .orderCreatedAt
                                                                              .toString() ??
                                                                          '',
                                                                      color: Colors
                                                                          .white)
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          Positioned(
                                                              top: 0,
                                                              right: 0,
                                                              child: data
                                                                          .tables?[
                                                                              index]
                                                                          .bookingStatus ==
                                                                      false
                                                                  ? PopUpMenuUsingTable(
                                                                      eventButton1:
                                                                          () {
                                                                      getTableInfor(
                                                                        roomId: data
                                                                            .storeRoomId
                                                                            .toString(),
                                                                        tableId: data
                                                                            .tables![index]
                                                                            .roomTableId
                                                                            .toString(),
                                                                      );
                                                                      showDialog(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (BuildContext
                                                                                context) {
                                                                          return BookingTableDialog(
                                                                            eventSaveButton:
                                                                                () {
                                                                              getDataTabIndex(
                                                                                roomId: data.storeRoomId.toString(),
                                                                              );
                                                                            },
                                                                            token:
                                                                                tokenManager,
                                                                            role:
                                                                                'user',
                                                                            shopID:
                                                                                '123456',
                                                                            idRoom:
                                                                                data.storeRoomId,
                                                                            listTableOfRoom:
                                                                                data.tables,
                                                                            currentTable:
                                                                                data.tables![index],
                                                                          );
                                                                        },
                                                                      );
                                                                    }, eventButton2:
                                                                          () {
                                                                      getSwitchTableData(
                                                                          roomId: data
                                                                              .storeRoomId
                                                                              .toString(),
                                                                          tableId: data
                                                                              .tables![
                                                                                  index]
                                                                              .roomTableId
                                                                              .toString(),
                                                                          orderID: data
                                                                              .tables![index]
                                                                              .orderId
                                                                              .toString());
                                                                      showDialog(
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (BuildContext context) {
                                                                            return MoveTableDialog(
                                                                              token: tokenManager,
                                                                              role: 'user',
                                                                              shopID: '123456',
                                                                              orderID: data.tables![index].orderId.toString(),
                                                                              currentTable: data.tables![index],
                                                                              nameRoom: data.storeRoomName ?? '',
                                                                              roomID: data.storeRoomId.toString(),
                                                                              listIdRoom: listRoomID,
                                                                              eventSaveButton: () {
                                                                                getDataTabIndex(
                                                                                  roomId: data.storeRoomId.toString(),
                                                                                );
                                                                              },
                                                                            );
                                                                          });
                                                                    }, eventButton3:
                                                                          () {
                                                                      getBillData(
                                                                        roomId: data
                                                                            .storeRoomId
                                                                            .toString(),
                                                                        tableId: data
                                                                            .tables![index]
                                                                            .roomTableId
                                                                            .toString(),
                                                                        orderID: data
                                                                            .tables![index]
                                                                            .orderId
                                                                            .toString(),
                                                                      );
                                                                      showDialog(
                                                                          useRootNavigator:
                                                                              false,
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (BuildContext context) {
                                                                            return SeeBillDialog(
                                                                              token: tokenManager,
                                                                              role: 'user',
                                                                              shopID: '123456',
                                                                              orderID: data.tables?[index].orderId,
                                                                              roomID: data.storeRoomId.toString(),
                                                                              currentTable: data.tables![index],
                                                                              nameRoom: data.storeRoomName ?? '',
                                                                            );
                                                                          });
                                                                    }, eventButton4:
                                                                          () {
                                                                      getPaymentData(
                                                                        tableId: data
                                                                            .tables![index]
                                                                            .roomTableId
                                                                            .toString(),
                                                                        orderID: data
                                                                            .tables![index]
                                                                            .orderId
                                                                            .toString(),
                                                                      );
                                                                      showDialog(
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (BuildContext context) {
                                                                            return PayBillDialog(
                                                                              token: tokenManager,
                                                                              role: 'user',
                                                                              shopID: '123456',
                                                                              orderID: data.tables?[index].orderId.toString(),
                                                                              roomID: data.storeRoomId.toString(),
                                                                              currentTable: data.tables![index],
                                                                              nameRoom: data.storeRoomName ?? '',
                                                                              eventSaveButton: () {
                                                                                getDataTabIndex(
                                                                                  roomId: data.storeRoomId.toString(),
                                                                                );
                                                                              },
                                                                            );
                                                                          });
                                                                    })
                                                                  : PopUpMenuUnUseTable(
                                                                      eventButton1:
                                                                          () {
                                                                      getTableInfor(
                                                                          roomId: data
                                                                              .storeRoomId
                                                                              .toString(),
                                                                          tableId:
                                                                              data.tables?[index].roomTableId.toString() ?? '');
                                                                      showDialog(
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (BuildContext context) {
                                                                            return BookingTableDialog(
                                                                              token: tokenManager,
                                                                              role: 'user',
                                                                              shopID: '123456',
                                                                              idRoom: data.storeRoomId,
                                                                              eventSaveButton: () {
                                                                                getDataTabIndex(
                                                                                  roomId: data.storeRoomId.toString(),
                                                                                );
                                                                              },
                                                                              listTableOfRoom: data.tables,
                                                                              currentTable: data.tables![index],
                                                                            );
                                                                          });
                                                                    })),
                                                        ],
                                                      )));
                                            }))
                                        .toList(),
                                  ),
                                ),
                              )
                            ]),
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
                        child:
                            Lottie.asset('assets/lottie/loading_7_color.json'),
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
                              event: () {},
                              text: 'Thử lại',
                              fontSize: 12.sp,
                              radius: 8.r,
                              textColor: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
        )),
      );
    });
  }
}
