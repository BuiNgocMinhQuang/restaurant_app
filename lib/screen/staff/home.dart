import 'dart:async';

import 'package:app_restaurant/bloc/login/login_bloc.dart';
import 'package:app_restaurant/bloc/manager/room/list_room_bloc.dart';
import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/config/space.dart';
import 'package:app_restaurant/config/void_show_dialog.dart';
import 'package:app_restaurant/utils/storage.dart';
import 'package:app_restaurant/widgets/button/button_gradient.dart';
import 'package:app_restaurant/widgets/list_custom_dialog.dart';
import 'package:app_restaurant/widgets/list_pop_menu.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
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

  void getListRoom() async {
    await Future.delayed(const Duration(seconds: 0));
    BlocProvider.of<ListRoomBloc>(context).add(
      const GetListRoom(
          client: "staff", shopId: "123456", isApi: true, roomId: ""),
    );
  }

  @override
  void initState() {
    getListRoom();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(
      length: 1,
      vsync: this,
    );
    return BlocBuilder<ListRoomBloc, ListRoomState>(builder: (context, state) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: RefreshIndicator(
                color: Colors.blue,
                onRefresh: () async {
                  getListRoom();
                },
                child: state.listRoomStatus == ListRoomStatus.succes
                    ? Padding(
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
                                            labelPadding: EdgeInsets.only(
                                                left: 20.w, right: 20.w),
                                            labelColor: Colors.blue,
                                            labelStyle: TextStyle(
                                                fontSize: 14.sp,
                                                fontFamily: 'OpenSans',
                                                fontWeight: FontWeight.bold),
                                            unselectedLabelColor:
                                                Colors.black.withOpacity(0.5),
                                            controller: _tabController,
                                            isScrollable: true,
                                            indicatorSize:
                                                TabBarIndicatorSize.label,
                                            tabs: const [
                                              Tab(
                                                text: "Phòng số 1",
                                              ),
                                            ]),
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
                                    width: 1.sw,
                                    color: Colors.white,
                                    child: TabBarView(
                                        controller: _tabController,
                                        children: [
                                          //Tab All
                                          GridView.builder(
                                              itemCount: 5,
                                              gridDelegate:
                                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 3,
                                              ),
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                  padding: EdgeInsets.all(10.w),
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.r),
                                                        color: Colors.blue,
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
                                                                    text: "Bàn 1"
                                                                        .toUpperCase(),
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                  TextApp(
                                                                      text:
                                                                          "TC: 200,000",
                                                                      color: Colors
                                                                          .white),
                                                                  TextApp(
                                                                      text:
                                                                          "Giờ vào: 13:44",
                                                                      color: Colors
                                                                          .white)
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          Positioned(
                                                              top: 0,
                                                              right: 0,
                                                              child: PopUpMenuUsingTable(
                                                                  eventButton1:
                                                                      () {
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (BuildContext
                                                                            context) {
                                                                      return BookingTableDialog(
                                                                        eventSaveButton:
                                                                            saveBookingModal,
                                                                        isUsingTable:
                                                                            true,
                                                                      );
                                                                    });
                                                              }, eventButton2:
                                                                      () {
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (BuildContext
                                                                            context) {
                                                                      return MoveTableDialog(
                                                                        eventSaveButton:
                                                                            saveMoveTableModal,
                                                                      );
                                                                    });
                                                              }, eventButton3:
                                                                      () {
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (BuildContext
                                                                            context) {
                                                                      return const SeeBillDialog();
                                                                    });
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
                                                              })),
                                                        ],
                                                      )),
                                                );
                                              }),
                                          //Tab Paid
                                        ]),
                                  )),
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
                                  child:
                                      Lottie.asset('assets/lottie/error.json'),
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
                          ))),
      );
    });
  }
}
