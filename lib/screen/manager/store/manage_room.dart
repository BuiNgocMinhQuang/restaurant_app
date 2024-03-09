import 'package:app_restaurant/config/void_show_dialog.dart';
import 'package:app_restaurant/config/space.dart';
import 'package:app_restaurant/widgets/button/button_icon.dart';
import 'package:app_restaurant/widgets/list_custom_dialog.dart';
import 'package:app_restaurant/widgets/list_pop_menu.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ManageRoom extends StatefulWidget {
  const ManageRoom({super.key});

  @override
  State<ManageRoom> createState() => _ManageRoomState();
}

class _ManageRoomState extends State<ManageRoom> {
  void createRoom() {}

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
                                      text: "Phong 1",
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
                                          text: "1",
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
                      Card(
                          elevation: 8.0,
                          margin: const EdgeInsets.all(8),
                          child: Stack(
                            children: [
                              space30H,
                              SizedBox(
                                  width: 1.sw,
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
                                              CrossAxisAlignment.center,
                                          children: [
                                            space20W,
                                            Container(
                                              width: 50.w,
                                              height: 50.w,
                                              child: Icon(
                                                Icons.table_bar,
                                                size: 45.w,
                                              ),
                                            ),
                                            space20W,
                                            TextApp(
                                              text: "Ban 1",
                                              fontsize: 16.sp,
                                              fontWeight: FontWeight.normal,
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
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                TextApp(
                                                  text: "Số ghế",
                                                  fontsize: 16.sp,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                TextApp(
                                                  text: "10",
                                                  fontsize: 16.sp,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                TextApp(
                                                  text: "Trạng thái",
                                                  fontsize: 16.sp,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                TextApp(
                                                  text: "Hoạt động",
                                                  fontsize: 16.sp,
                                                  fontWeight: FontWeight.normal,
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
                                  top: 0,
                                  right: 0,
                                  child: PopUpEditTable(
                                    eventButton1: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return CreateTableDialog(
                                                eventSaveButton: () {});
                                          });
                                    },
                                    eventButton2: () {
                                      showConfirmDialog(context, () {
                                        print("ConFIRM");
                                      });
                                    },
                                  )),
                            ],
                          )),
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
                                        eventSaveButton: () {});
                                  });
                            },
                            child: Container(
                              width: 1.sw,
                              height: 150.h,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add,
                                    color: Colors.grey,
                                  ),
                                  space10H,
                                  TextApp(
                                    text: "Tạo cửa hàng",
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
