import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/config/space.dart';
import 'package:app_restaurant/widgets/button/button_gradient.dart';
import 'package:app_restaurant/widgets/button/button_icon.dart';
import 'package:app_restaurant/widgets/modal/create_room_modal.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ManageStore extends StatefulWidget {
  const ManageStore({super.key});

  @override
  State<ManageStore> createState() => _ManageStoreState();
}

class _ManageStoreState extends State<ManageStore> {
  bool isShowCreateRoomModal = false;
  void closeCreateRoomModal() {
    setState(() {
      isShowCreateRoomModal = false;
    });
  }

  _showUpdateInfoModal(context) {
    AwesomeDialog(
            context: context,
            dialogType: DialogType.question,
            animType: AnimType.rightSlide,
            headerAnimationLoop: true,
            title: 'Bạn có chắc chắn thực hiện tác vụ này!',
            desc: 'Sau khi bạn xác nhận sẽ không thể trở lại.',
            btnOkOnPress: () {},
            btnOkText: "Xác Nhận",
            btnCancelOnPress: () {},
            btnCancelText: "Hủy")
        .show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Quản lí cửa hàng"),
        ),
        body: Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    children: [
                      Container(
                        width: 1.sw,
                        height: 200,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.w),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color.fromRGBO(33, 212, 253, 1),
                                Color.fromRGBO(33, 82, 255, 1)
                              ],
                            )),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextApp(
                              text: "Tổng tiền",
                              fontsize: 16.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            space15H,
                            TextApp(
                                text: "100,000,000",
                                fontsize: 20.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            space20H,
                            Container(
                              width: 220.w,
                              child: ButtonGradient(
                                color1: color1DarkButton,
                                color2: color2DarkButton,
                                event: () {},
                                text: "Tổng thu nhập cửa hàng".toUpperCase(),
                                fontSize: 12.sp,
                                radius: 8.r,
                                textColor: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                      space20H,
                      Card(
                        elevation: 8.0,
                        margin: EdgeInsets.all(8),
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
                                    icon: Icons.attach_money_sharp),
                                space20W,
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextApp(
                                      text: "Thu nhập hôm nay",
                                      fontsize: 16.sp,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    TextApp(
                                      text: "100,000,000đ",
                                      fontsize: 20.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ],
                                )
                              ],
                            )),
                      ),
                      space15H,
                      Card(
                        elevation: 8.0,
                        margin: EdgeInsets.all(8),
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
                                    icon: Icons.person_pin),
                                space20W,
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextApp(
                                      text: "Tổng nhân viên",
                                      fontsize: 16.sp,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    TextApp(
                                      text: "100",
                                      fontsize: 20.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ],
                                )
                              ],
                            )),
                      ),
                      space25H,
                      Card(
                        elevation: 8.0,
                        margin: EdgeInsets.all(8),
                        child: Container(
                            width: 1.sw,
                            // height: 100.h,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.w)),
                            child: Padding(
                              padding: EdgeInsets.all(10.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                              width: 50.w,
                                              height: 50.w,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                child: Image.asset(
                                                  "assets/images/banner1.png",
                                                  fit: BoxFit.cover,
                                                ),
                                              )),
                                          space20W,
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              TextApp(
                                                text: "shop 1",
                                                fontsize: 12.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              TextApp(
                                                text: "26-02-2024",
                                                fontsize: 12.sp,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      Container(
                                        width: 30,
                                        height: 30,
                                        child: ButtonIcon(
                                            isIconCircle: false,
                                            color1: const Color.fromRGBO(
                                                20, 23, 39, 1),
                                            color2: const Color.fromRGBO(
                                                58, 65, 111, 1),
                                            event: () {},
                                            icon: Icons.person_pin),
                                      )
                                    ],
                                  ),
                                  space10H,
                                  Row(
                                    children: [
                                      TextApp(
                                        text: "Địa chỉ: ",
                                        fontsize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      TextApp(
                                        text: "somwhere.",
                                        fontsize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ],
                                  ),
                                  space10H,
                                  TextApp(
                                    text: "Mo ta",
                                    fontsize: 14.sp,
                                  ),
                                  space30H,
                                  Container(
                                    width: 1.sw,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.w),
                                        color: Colors.grey.withOpacity(0.2)),
                                    child: Row(
                                      children: [
                                        space20W,
                                        TextApp(
                                          text: "100,000,000 ",
                                          fontsize: 18.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        TextApp(
                                          text: "đ/tháng",
                                          fontsize: 18.sp,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )),
                      ),
                      space25H,
                      Card(
                        elevation: 8.0,
                        margin: EdgeInsets.all(8),
                        child: Container(
                            width: 1.sw,
                            height: 300,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.w)),
                            child: Padding(
                              padding: EdgeInsets.all(10.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextApp(
                                        text: "Danh sách phòng",
                                        fontsize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ],
                                  ),
                                  space10H,
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        width: 150.w,
                                        child: ButtonGradient(
                                          radius: 8.w,
                                          color1: lightBlue,
                                          color2: lightBlue,
                                          event: () {
                                            setState(() {
                                              isShowCreateRoomModal = true;
                                            });
                                          },
                                          text: "Tạo phòng".toUpperCase(),
                                          height: 30.h,
                                          textColor: Colors.white,
                                        ),
                                      )
                                    ],
                                  ),
                                  space10H,
                                  Expanded(
                                      child: ListView.builder(
                                          // physics: NeverScrollableScrollPhysics(),
                                          itemCount: 3,
                                          itemBuilder: (context, index) {
                                            return Column(
                                              children: [
                                                Divider(),
                                                space10H,
                                                Container(
                                                  width: 1.sw,
                                                  // height: 200,
                                                  padding: EdgeInsets.all(10.w),
                                                  decoration: BoxDecoration(
                                                    border: const Border(
                                                        top: BorderSide(
                                                            width: 0,
                                                            color:
                                                                Colors.white),
                                                        bottom: BorderSide(
                                                            width: 0,
                                                            color:
                                                                Colors.white),
                                                        left: BorderSide(
                                                            width: 3,
                                                            color: Colors.blue),
                                                        right: BorderSide(
                                                            width: 0,
                                                            color:
                                                                Colors.white)),

                                                    // color: Colors.amber,
                                                  ),
                                                  child: Column(
                                                    // crossAxisAlignment: CrossAxisAlignment.center,
                                                    // mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          TextApp(
                                                              text: "Phong 1"),
                                                          // Icon(Icons.more),
                                                          PopupMenuButton(
                                                            onSelected:
                                                                (value) {
                                                              switch (value) {
                                                                case '1':
                                                                  // code for the edit action

                                                                  break;
                                                                case '2':
                                                                  // code for the remove action
                                                                  break;
                                                                // other cases...
                                                              }
                                                            },
                                                            itemBuilder:
                                                                (context) => [
                                                              PopupMenuItem(
                                                                onTap: () {
                                                                  setState(() {
                                                                    isShowCreateRoomModal =
                                                                        true;
                                                                  });
                                                                },
                                                                child: Text(
                                                                    "Chỉnh sửa phòng"),
                                                              ),
                                                              PopupMenuItem(
                                                                onTap: () {
                                                                  print(
                                                                      "PRESS");
                                                                },
                                                                child: Text(
                                                                    "Quản lí phòng"),
                                                              ),
                                                              PopupMenuItem(
                                                                onTap: () {
                                                                  _showUpdateInfoModal(
                                                                      context);
                                                                },
                                                                child: Text(
                                                                    "Xoá phòng"),
                                                              )
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets.all(
                                                            20.w),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Column(
                                                              children: [
                                                                TextApp(
                                                                    text:
                                                                        "Ngày tạo"),
                                                                space10H,
                                                                TextApp(
                                                                  text:
                                                                      "26-02-2024",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ],
                                                            ),
                                                            Column(
                                                              children: [
                                                                TextApp(
                                                                    text:
                                                                        "Số bàn trong phòng"),
                                                                space10H,
                                                                TextApp(
                                                                    text: "1",
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ],
                                                            ),
                                                            Column(
                                                              children: [
                                                                TextApp(
                                                                    text:
                                                                        "Trạng thái"),
                                                                space10H,
                                                                TextApp(
                                                                    text:
                                                                        "Đang hoạt động",
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            );
                                          }))
                                ],
                              ),
                            )),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Visibility(
                visible: isShowCreateRoomModal,
                child: CreateRoomModal(
                    eventCloseButton: () {
                      closeCreateRoomModal();
                    },
                    eventSaveButton: () {})),
          ],
        ));
  }
}
