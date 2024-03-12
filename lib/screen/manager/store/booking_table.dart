import 'package:app_restaurant/bloc/manager/room/list_room_bloc.dart';
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
  void saveBookingModal() async {}

  void saveMoveTableModal() {}

  void savePayBillModal() {}

  @override
  void initState() {
    print("INITT NE");

    _getDataNe();
    super.initState();
  }

  // List<String> tabData = ["Tab 1", "Tab 2"];
  List<dynamic> tabData = [
    {
      "status": 200,
      "rooms": [
        {
          "store_room_id": 1,
          "store_room_name": "phong1",
          "tables": [
            {
              "booking_status": true,
              "order_id": null,
              "client_can_pay": 0,
              "order_created_at": "",
              "table_name": "ban 1",
              "room_table_id": 1
            },
            {
              "booking_status": true,
              "order_id": null,
              "client_can_pay": 0,
              "order_created_at": "",
              "table_name": "ban 2",
              "room_table_id": 2
            }
          ]
        },
        {"store_room_id": 2, "store_room_name": "phong 2", "tables": []}
      ]
    }
  ];
  List<String> roomNames = [];

  void _getDataNe() async {
    await Future.delayed(const Duration(seconds: 0));
    BlocProvider.of<ListRoomBloc>(context).add(
      const GetListRoom(
          client: "user", shopId: "123456", isApi: true, roomId: ""),
    );
  }

  @override
  Widget build(BuildContext context) {
    for (var room in tabData[0]['rooms']) {
      roomNames.add(
          room['store_room_name']); // add store_room_name to List roomNames
    }

    TabController _tabController = TabController(
      length: roomNames.length,
      vsync: this,
    );

    return BlocBuilder<ListRoomBloc, ListRoomState>(
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
                  SizedBox(
                    height: 10.h,
                  ),
                  Expanded(
                      child: Container(
                    width: 1.sw,
                    color: Colors.white,
                    child: TabBarView(
                      controller: _tabController,
                      children: state.listRoomModel!.rooms!
                          .map((data) => Text(data.storeRoomName ?? ''))
                          .toList(),

                      // [
                      //   //Tab All
                      //   SizedBox(
                      //     width: 1.sw,
                      //     // color: Colors.pink,
                      //     height: 500.h,
                      //     child: Column(
                      //       children: [
                      //         SizedBox(
                      //           height: 20.h,
                      //         ),
                      //         Row(
                      //           crossAxisAlignment: CrossAxisAlignment.center,
                      //           mainAxisAlignment: MainAxisAlignment.center,
                      //           children: [
                      //             Row(
                      //               children: [
                      //                 Container(
                      //                   width: 20,
                      //                   height: 20,
                      //                   color: Colors.green,
                      //                 ),
                      //                 SizedBox(
                      //                   width: 5.w,
                      //                 ),
                      //                 TextApp(text: "Đang phục vụ")
                      //               ],
                      //             ),
                      //             SizedBox(
                      //               width: 10.w,
                      //             ),
                      //             Row(
                      //               children: [
                      //                 Container(
                      //                   width: 20,
                      //                   height: 20,
                      //                   color: Colors.yellow,
                      //                 ),
                      //                 SizedBox(
                      //                   width: 5.w,
                      //                 ),
                      //                 TextApp(text: "Bàn trống")
                      //               ],
                      //             )
                      //           ],
                      //         ),
                      //         Expanded(
                      //           child: GridView.builder(
                      //               itemCount: state.listRoomModel?.rooms?[0]
                      //                       .tables?.length ??
                      //                   1,
                      //               gridDelegate:
                      //                   const SliverGridDelegateWithFixedCrossAxisCount(
                      //                 crossAxisCount: 3,
                      //               ),
                      //               itemBuilder: (context, index) {
                      //                 return Padding(
                      //                   padding: EdgeInsets.all(10.w),
                      //                   child: Container(
                      //                       decoration: BoxDecoration(
                      //                         borderRadius:
                      //                             BorderRadius.circular(8.r),
                      //                         color: Colors.blue,
                      //                       ),
                      //                       width: 50,
                      //                       height: 50,
                      //                       child: Stack(
                      //                         children: [
                      //                           Row(
                      //                             mainAxisAlignment:
                      //                                 MainAxisAlignment.center,
                      //                             crossAxisAlignment:
                      //                                 CrossAxisAlignment.center,
                      //                             children: [
                      //                               Column(
                      //                                 mainAxisAlignment:
                      //                                     MainAxisAlignment
                      //                                         .center,
                      //                                 crossAxisAlignment:
                      //                                     CrossAxisAlignment
                      //                                         .center,
                      //                                 children: [
                      //                                   TextApp(
                      //                                     text: state
                      //                                             .listRoomModel
                      //                                             ?.rooms?[0]
                      //                                             .tables?[
                      //                                                 index]
                      //                                             .tableName
                      //                                             .toString()
                      //                                             .toUpperCase() ??
                      //                                         '',
                      //                                     color: Colors.white,
                      //                                     fontWeight:
                      //                                         FontWeight.bold,
                      //                                   ),
                      //                                   TextApp(
                      //                                       text: state
                      //                                               .listRoomModel
                      //                                               ?.rooms?[0]
                      //                                               .tables?[
                      //                                                   index]
                      //                                               .clientCanPay
                      //                                               .toString() ??
                      //                                           '',
                      //                                       color:
                      //                                           Colors.white),
                      //                                   TextApp(
                      //                                       text: state
                      //                                               .listRoomModel
                      //                                               ?.rooms?[0]
                      //                                               .tables?[
                      //                                                   index]
                      //                                               .orderCreatedAt
                      //                                               .toString() ??
                      //                                           "Giờ vào: 13:44",
                      //                                       color: Colors.white)
                      //                                 ],
                      //                               ),
                      //                             ],
                      //                           ),
                      //                           Positioned(
                      //                               top: 0,
                      //                               right: 0,
                      //                               child: PopUpMenuUsingTable(
                      //                                   eventButton1: () {
                      //                                 showDialog(
                      //                                     context: context,
                      //                                     builder: (BuildContext
                      //                                         context) {
                      //                                       return BookingTableDialog(
                      //                                         eventSaveButton:
                      //                                             saveBookingModal,
                      //                                         isUsingTable:
                      //                                             true,
                      //                                       );
                      //                                     });
                      //                               }, eventButton2: () {
                      //                                 showDialog(
                      //                                     context: context,
                      //                                     builder: (BuildContext
                      //                                         context) {
                      //                                       return MoveTableDialog(
                      //                                         eventSaveButton:
                      //                                             saveMoveTableModal,
                      //                                       );
                      //                                     });
                      //                               }, eventButton3: () {
                      //                                 showDialog(
                      //                                     context: context,
                      //                                     builder: (BuildContext
                      //                                         context) {
                      //                                       return const SeeBillDialog();
                      //                                     });
                      //                               }, eventButton4: () {
                      //                                 showDialog(
                      //                                     context: context,
                      //                                     builder: (BuildContext
                      //                                         context) {
                      //                                       return PayBillDialog(
                      //                                         eventSaveButton:
                      //                                             savePayBillModal,
                      //                                       );
                      //                                     });
                      //                               })),
                      //                         ],
                      //                       )),
                      //                 );
                      //               }),
                      //         )
                      //       ],
                      //     ),
                      //   ),

                      //   Container(
                      //     width: 500,
                      //     height: 500,
                      //     color: Colors.amber,
                      //   )

                      //   //Tab Paid
                      // ],
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
