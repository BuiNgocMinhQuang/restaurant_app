import 'dart:convert';
import 'dart:developer';

import 'package:app_restaurant/config/void_show_dialog.dart';
import 'package:app_restaurant/config/space.dart';
import 'package:app_restaurant/model/manager/store/rooms/table/list_table_of_room_model.dart';
import 'package:app_restaurant/routers/app_router_config.dart';
import 'package:app_restaurant/utils/storage.dart';
import 'package:app_restaurant/widgets/button/button_icon.dart';
import 'package:app_restaurant/widgets/dialog/list_custom_dialog.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:http/http.dart' as http;
import 'package:app_restaurant/constant/api/index.dart';
import 'package:app_restaurant/env/index.dart';

class ManageRoom extends StatefulWidget {
  final String roomID;
  final String roomName;
  final String numberTable;
  const ManageRoom(
      {Key? key,
      required this.roomID,
      required this.roomName,
      required this.numberTable})
      : super(key: key);

  @override
  State<ManageRoom> createState() => _ManageRoomState();
}

class _ManageRoomState extends State<ManageRoom> {
  void createRoom() {}
  ListTableOfRoomModel? listTableOfRoomModel;
  void getDataInit() async {
    try {
      var token = StorageUtils.instance.getString(key: 'token_manager');

      final respons = await http.post(
        Uri.parse('$baseUrl$getListTableOfRoomByManager'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          'room_id': widget.roomID,
          'is_api': true,
        }),
      );
      final data = jsonDecode(respons.body);
      try {
        if (data['status'] == 200) {
          setState(() {
            listTableOfRoomModel = ListTableOfRoomModel.fromJson(data);
          });
        } else {
          log("ERROR getDataInit 1");
        }
      } catch (error) {
        log("ERROR getDataInit 2 $error");
      }
    } catch (error) {
      log("ERROR getDataInit 3 $error");
    }
  }

  void handleDeleteTable({required String tableID}) async {
    try {
      var token = StorageUtils.instance.getString(key: 'token_manager');

      final respons = await http.post(
        Uri.parse('$baseUrl$deleteTableByManager'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          'room_table_id': tableID,
          'is_api': true,
        }),
      );
      final data = jsonDecode(respons.body);
      try {
        if (data['status'] == 200) {
          getDataInit();
        } else {
          log("ERROR handleDeleteTable 1");
        }
      } catch (error) {
        log("ERROR handleDeleteTable 2 $error");
      }
    } catch (error) {
      log("ERROR handleDeleteTable 3 $error");
    }
  }

  @override
  void initState() {
    getDataInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Quản lí phòng"),
        ),
        body: Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    children: [
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
                                ButtonIcon(
                                    isIconCircle: false,
                                    color1: const Color.fromRGBO(20, 23, 39, 1),
                                    color2:
                                        const Color.fromRGBO(58, 65, 111, 1),
                                    event: () {},
                                    icon: Icons.meeting_room),
                                space20W,
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextApp(
                                      text: widget.roomName,
                                      fontsize: 20.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    Row(
                                      children: [
                                        TextApp(
                                          text: "Số bàn:",
                                          fontsize: 16.sp,
                                          fontWeight: FontWeight.normal,
                                        ),
                                        TextApp(
                                          text: widget.numberTable,
                                          fontsize: 16.sp,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            )),
                      ),
                      space15H,
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount:
                                  listTableOfRoomModel?.tables.length ?? 0,
                              itemBuilder: (context, index) {
                                return Card(
                                    elevation: 8.0,
                                    margin: const EdgeInsets.all(8),
                                    child: Stack(
                                      children: [
                                        space30H,
                                        Container(
                                            width: 1.sw,
                                            //color: Colors.white,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15.r),
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  spreadRadius: 2,
                                                  blurRadius: 4,
                                                  offset: const Offset(0,
                                                      3), // changes position of shadow
                                                ),
                                              ],
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 15.w, right: 15.w),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  space30H,
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      space20W,
                                                      SizedBox(
                                                        width: 50.w,
                                                        height: 50.w,
                                                        child: Icon(
                                                          Icons.table_bar,
                                                          size: 45.w,
                                                        ),
                                                      ),
                                                      space20W,
                                                      TextApp(
                                                        text:
                                                            listTableOfRoomModel
                                                                    ?.tables[
                                                                        index]
                                                                    .tableName ??
                                                                '',
                                                        fontsize: 16.sp,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                    ],
                                                  ),
                                                  const Divider(
                                                    height: 1,
                                                    color: Colors.black,
                                                  ),
                                                  space30H,
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          TextApp(
                                                            text: "Số ghế",
                                                            fontsize: 16.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                          ),
                                                          TextApp(
                                                            text: listTableOfRoomModel
                                                                    ?.tables[
                                                                        index]
                                                                    .numberOfSeats
                                                                    .toString() ??
                                                                '',
                                                            fontsize: 16.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                          ),
                                                        ],
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          TextApp(
                                                            text: "Trạng thái",
                                                            fontsize: 16.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                          ),
                                                          TextApp(
                                                            text: listTableOfRoomModel
                                                                        ?.tables[
                                                                            index]
                                                                        .activeFlg ==
                                                                    1
                                                                ? "Hoạt động"
                                                                : "Ngưng hoạt động",
                                                            fontsize: 16.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color: Colors.green,
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                  space30H,
                                                ],
                                              ),
                                            )),
                                        Positioned(
                                            top: 15.w,
                                            right: 15.w,
                                            child: SizedBox(
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
                                                      builder:
                                                          (context) =>
                                                              Container(
                                                                height:
                                                                    1.sh / 3,
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(20
                                                                            .w),
                                                                child: Column(
                                                                  children: [
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);

                                                                        showDialog(
                                                                            context:
                                                                                context,
                                                                            builder:
                                                                                (BuildContext context) {
                                                                              return CreateTableDialog(
                                                                                roomTableID: listTableOfRoomModel?.tables[index].roomTableId.toString(),
                                                                                storeRoomID: listTableOfRoomModel?.tables[index].storeRoomId.toString(),
                                                                                eventSaveButton: () {
                                                                                  getDataInit();
                                                                                },
                                                                              );
                                                                            });
                                                                      },
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          SizedBox(
                                                                            width:
                                                                                35.w,
                                                                            height:
                                                                                35.w,
                                                                            child:
                                                                                Image.asset(
                                                                              "assets/images/edit_icon.png",
                                                                              fit: BoxFit.contain,
                                                                            ),
                                                                          ),
                                                                          space10W,
                                                                          TextApp(
                                                                            text:
                                                                                "Cập nhật",
                                                                            color:
                                                                                Colors.black,
                                                                            fontsize:
                                                                                18.sp,
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    space10H,
                                                                    const Divider(),
                                                                    space10H,
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);

                                                                        showConfirmDialog(
                                                                            navigatorKey.currentContext,
                                                                            () {
                                                                          handleDeleteTable(
                                                                              tableID: listTableOfRoomModel?.tables[index].roomTableId.toString() ?? '');
                                                                        });
                                                                      },
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          SizedBox(
                                                                            width:
                                                                                35.w,
                                                                            height:
                                                                                35.w,
                                                                            child:
                                                                                Image.asset(
                                                                              "assets/images/delete_icon.png",
                                                                              fit: BoxFit.contain,
                                                                            ),
                                                                          ),
                                                                          space10W,
                                                                          TextApp(
                                                                            text:
                                                                                "Xoá",
                                                                            color:
                                                                                Colors.black,
                                                                            fontsize:
                                                                                18.sp,
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ));
                                                },
                                                child: Icon(
                                                  Icons.more_vert_outlined,
                                                  size: 25.sp,
                                                ),
                                              ),
                                            ))
                                      ],
                                    ));
                              })
                        ],
                      ),
                      space25H,
                      Card(
                          elevation: 8.0,
                          margin: const EdgeInsets.all(8),
                          child: InkWell(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CreateTableDialog(
                                        roomTableID: null, //check this
                                        storeRoomID: widget.roomID,
                                        eventSaveButton: () {
                                          getDataInit();
                                        });
                                  });
                            },
                            child: Container(
                              width: 1.sw,
                              height: 150.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.r),
                                color: Colors.white,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.add,
                                    color: Colors.grey,
                                  ),
                                  space10H,
                                  TextApp(
                                    text: "Tạo bàn",
                                    fontWeight: FontWeight.bold,
                                    fontsize: 16.sp,
                                    color: Colors.grey,
                                  )
                                ],
                              ),
                            ),
                          ))
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
