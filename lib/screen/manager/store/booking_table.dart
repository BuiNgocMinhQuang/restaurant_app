import 'package:app_restaurant/bloc/manager/room/list_room_bloc.dart';
import 'package:app_restaurant/bloc/manager/tables/table_bloc.dart';
import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/config/space.dart';
import 'package:app_restaurant/model/list_room_model.dart';
import 'package:app_restaurant/utils/storage.dart';
import 'package:app_restaurant/widgets/list_custom_dialog.dart';
import 'package:app_restaurant/widgets/list_pop_menu.dart';
import 'package:app_restaurant/widgets/shimmer/shimmer_list.dart';
import 'package:app_restaurant/widgets/text/copy_right_text.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ManagerBookingTable extends StatefulWidget {
  const ManagerBookingTable({super.key});

  @override
  State<ManagerBookingTable> createState() => _ManagerBookingTableState();
}

class _ManagerBookingTableState extends State<ManagerBookingTable>
    with TickerProviderStateMixin {
  void saveBookingModal() {}

  void saveMoveTableModal() {}

  void savePayBillModal() {}

  @override
  void initState() {
    _getDataNe();
    super.initState();
  }

  void _getDataNe() async {
    await Future.delayed(const Duration(seconds: 0));
    BlocProvider.of<ListRoomBloc>(context).add(
      const GetListRoom(
          client: "user", shopId: "123456", isApi: true, roomId: ""),
    );
  }

  void getDataTabIndex(String roomId) async {
    await Future.delayed(const Duration(seconds: 0));
    BlocProvider.of<ListRoomBloc>(context).add(
      GetListRoom(
          client: "user", shopId: "123456", isApi: true, roomId: roomId),
    );
  }

  void getTableInfor(String roomId, String tableId) {
    BlocProvider.of<TableBloc>(context).add(GetTableInfor(
        client: "user", shopId: "123456", roomId: roomId, tableId: tableId));
  }

  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(
      length: 2,
      vsync: this,
    );

    return BlocConsumer<ListRoomBloc, ListRoomState>(
      listener: (context, state) {
        // do stuff here based on BlocA's state
      },
      builder: (context, state) {
        if (state.listRoomStatus == ListRoomStatus.succes) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
                child: Padding(
              padding: EdgeInsets.only(
                  top: 10.h, left: 25.w, right: 25.w, bottom: 10.h),
              child: Column(
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
                                  getDataTabIndex(state
                                      .listRoomModel!.rooms![index].storeRoomId
                                      .toString());
                                },
                                labelPadding:
                                    const EdgeInsets.only(left: 20, right: 20),
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
                                    .map(
                                        (data) => Tab(text: data.storeRoomName))
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
                              text: "Phòng này không có bàn",
                              color: Colors.white,
                              fontsize: 14.sp,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : Expanded(
                          child: Container(
                          // width: 1.sw,
                          color: Colors.white,
                          child: TabBarView(
                            controller: _tabController,
                            children: state.listRoomModel!.rooms!
                                .map((data) => GridView.builder(
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3),
                                    itemCount: data.tables?.length ?? 0,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
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
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          TextApp(
                                                            text: data
                                                                    .tables?[
                                                                        index]
                                                                    .tableName ??
                                                                '',
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                          if (data
                                                                  .tables?[
                                                                      index]
                                                                  .bookingStatus ==
                                                              false)
                                                            TextApp(
                                                                text: data
                                                                        .tables?[
                                                                            index]
                                                                        .clientCanPay
                                                                        .toString() ??
                                                                    '',
                                                                color: Colors
                                                                    .white),
                                                          TextApp(
                                                              text: data
                                                                      .tables?[
                                                                          index]
                                                                      .orderCreatedAt
                                                                      .toString() ??
                                                                  '',
                                                              color:
                                                                  Colors.white)
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Positioned(
                                                      top: 0,
                                                      right: 0,
                                                      child: data.tables?[index]
                                                                  .bookingStatus ==
                                                              false
                                                          ? PopUpMenuUsingTable(
                                                              eventButton1: () {
                                                              getTableInfor(
                                                                  data.storeRoomId
                                                                      .toString(),
                                                                  data.tables?[index]
                                                                          .roomTableId
                                                                          .toString() ??
                                                                      '');
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return BookingTableDialog(
                                                                      eventSaveButton:
                                                                          () {},
                                                                      // nameTable:
                                                                      //     'hehe',
                                                                      // eventSaveButton:
                                                                      //     saveBookingModal,
                                                                      // isUsingTable:
                                                                      //     true,
                                                                    );
                                                                  });
                                                            }, eventButton2:
                                                                  () {
                                                              // showDialog(
                                                              //     context:
                                                              //         context,
                                                              //     builder:
                                                              //         (BuildContext
                                                              //             context) {
                                                              //       return MoveTableDialog(
                                                              //         listTable: [],
                                                              //         listRoom: [],
                                                              //         currentTable:Tables[]
                                                              //             ,
                                                              //         nameRoom:
                                                              //             'roomName',
                                                              //         eventSaveButton:
                                                              //             saveMoveTableModal,
                                                              //       );
                                                              //     });
                                                            }, eventButton3:
                                                                  () {
                                                              // showDialog(
                                                              //     context:
                                                              //         context,
                                                              //     builder:
                                                              //         (BuildContext
                                                              //             context) {
                                                              //       return const SeeBillDialog();
                                                              //     });
                                                            }, eventButton4:
                                                                  () {
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return PayBillDialog(
                                                                      eventSaveButton:
                                                                          savePayBillModal,
                                                                    );
                                                                  });
                                                            })
                                                          : PopUpMenuUnUseTable(
                                                              eventButton1: () {
                                                              getTableInfor(
                                                                  data.storeRoomId
                                                                      .toString(),
                                                                  data.tables?[index]
                                                                          .roomTableId
                                                                          .toString() ??
                                                                      '');
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return BookingTableDialog(
                                                                      eventSaveButton:
                                                                          () {},
                                                                      // nameTable:
                                                                      //     'hehe',
                                                                      // eventSaveButton:
                                                                      //     () {},
                                                                      // isUsingTable:
                                                                      //     true,
                                                                    );
                                                                  });
                                                            })),
                                                ],
                                              )));
                                    }))
                                .toList(),
                          ),
                        )),
                  SizedBox(
                    height: 15.h,
                  ),
                  const CopyRightText(),
                  SizedBox(
                    height: 35.h,
                  ),
                ],
              ),
            )),
          );
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
