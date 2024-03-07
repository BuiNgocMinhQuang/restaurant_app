import 'dart:io';

import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/config/fake_data.dart';
import 'package:app_restaurant/config/space.dart';
import 'package:app_restaurant/config/text.dart';
import 'package:app_restaurant/widgets/button/button_app.dart';
import 'package:app_restaurant/widgets/custom_tab.dart';
import 'package:app_restaurant/widgets/dots_line.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

///Modal quản lí bàn
class BookingTableDialog extends StatefulWidget {
  final Function eventSaveButton;
  final bool isUsingTable;
  const BookingTableDialog({
    Key? key,
    required this.eventSaveButton,
    this.isUsingTable = false,
  }) : super(key: key);

  @override
  State<BookingTableDialog> createState() => _BookingTableDialogState();
}

class _BookingTableDialogState extends State<BookingTableDialog>
    with TickerProviderStateMixin {
  final _popupCustomValidationKey = GlobalKey<DropdownSearchState<int>>();
  final TextEditingController _dateStartController = TextEditingController();

  DateTime dateTime = DateTime(2022, 12, 24, 5, 30);

  Future<DateTime?> pickDate() => showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2025));

  Future<TimeOfDay?> pickTime() => showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: dateTime.hour, minute: dateTime.minute),
      );

  Future pickDateAndTime() async {
    DateTime? date = await pickDate();
    if (date == null) return;
    TimeOfDay? time = await pickTime();
    if (time == null) return;

    final newDateTime =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);
    setState(() {
      dateTime = newDateTime;
      _dateStartController.text = newDateTime.toString();
    });
  }

  void selectDayStart() async {
    DateTime? picked = await showDatePicker(
        // helpText: 'Chọn ngày bắt đầu', // Can be used as title
        // cancelText: 'Huỷ',
        // confirmText: 'Xác nhận',
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2025));

    if (picked != null) {
      setState(() {
        _dateStartController.text = picked.toString().split(" ")[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 3, vsync: this);
    TabController _tabSubController = TabController(length: 4, vsync: this);
    // final hours = dateTime.hour.toString().padLeft(2, '0');
    // final minute = dateTime.minute.toString().padLeft(2, '0');
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return AlertDialog(
          // title: Text('Title'),
          content: Container(
              width: 1.sw,
              height: 1.sh,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      width: 1.sw,
                      height: 50,
                      decoration: BoxDecoration(
                        border: const Border(
                            top: BorderSide(width: 0, color: Colors.grey),
                            bottom: BorderSide(width: 1, color: Colors.grey),
                            left: BorderSide(width: 0, color: Colors.grey),
                            right: BorderSide(width: 0, color: Colors.grey)),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15.w),
                            topRight: Radius.circular(15.w)),
                        // color: Colors.amber,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 20.w),
                                child: TextApp(
                                  text: "Quản lý bàn đặt: Table 1",
                                  fontsize: 18.sp,
                                  color: blueText,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ],
                      )),
                  Expanded(
                      child: SingleChildScrollView(
                          child: Padding(
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 50,
                          // color: Colors.green,
                          child: TabBar(
                              labelPadding:
                                  EdgeInsets.only(left: 20.w, right: 20.w),
                              labelColor: Colors.black,
                              unselectedLabelColor:
                                  Colors.black.withOpacity(0.5),
                              labelStyle: const TextStyle(color: Colors.red),
                              controller: _tabController,
                              isScrollable: true,
                              indicatorSize: TabBarIndicatorSize.label,
                              indicator: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  8.r,
                                ),
                                color: Colors.blue,
                                border: Border.all(color: Colors.blue),
                              ),
                              tabs: [
                                CustomTab(
                                    text: "Đặt bàn",
                                    icon: Icons.group_add_outlined),
                                CustomTab(
                                    text: "Đặt món",
                                    icon: Icons.dinner_dining_outlined),
                                Visibility(
                                  visible: widget.isUsingTable,
                                  child: CustomTab(
                                      text: "Huỷ bàn",
                                      icon: Icons.group_add_outlined),
                                )
                              ]),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        SizedBox(
                          width: 1.sw,
                          height: 600.h,
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextApp(
                                    text: " Thời gian kết thúc",
                                    fontsize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                    color: blueText,
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  TextField(
                                    readOnly: true,
                                    controller: _dateStartController,
                                    onTap: pickDateAndTime,
                                    cursorColor:
                                        const Color.fromRGBO(73, 80, 87, 1),
                                    decoration: InputDecoration(
                                        fillColor: const Color.fromARGB(
                                            255, 226, 104, 159),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Color.fromRGBO(
                                                  214, 51, 123, 0.6),
                                              width: 2.0),
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                        ),
                                        isDense: true,
                                        contentPadding: EdgeInsets.all(
                                            1.sw > 600 ? 20.w : 15.w)),
                                  ),
                                  ////////
                                  SizedBox(
                                    height: 30.h,
                                  ),
                                  //////
                                  TextApp(
                                    text: " Tên khách hàng",
                                    fontsize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                    color: blueText,
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  TextField(
                                    cursorColor:
                                        const Color.fromRGBO(73, 80, 87, 1),
                                    decoration: InputDecoration(
                                        fillColor: const Color.fromARGB(
                                            255, 226, 104, 159),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Color.fromRGBO(
                                                  214, 51, 123, 0.6),
                                              width: 2.0),
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                        ),
                                        hintText: 'Tên khách hàng',
                                        isDense: true,
                                        contentPadding: EdgeInsets.all(
                                            1.sw > 600 ? 20.w : 15.w)),
                                  ),
                                  /////
                                  SizedBox(
                                    height: 30.h,
                                  ),
                                  ////
                                  TextApp(
                                    text: " Số điện thoại",
                                    fontsize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                    color: blueText,
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  TextField(
                                    cursorColor:
                                        const Color.fromRGBO(73, 80, 87, 1),
                                    decoration: InputDecoration(
                                        fillColor: const Color.fromARGB(
                                            255, 226, 104, 159),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Color.fromRGBO(
                                                  214, 51, 123, 0.6),
                                              width: 2.0),
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                        ),
                                        hintText: 'Số điện thoại',
                                        isDense: true,
                                        contentPadding: EdgeInsets.all(
                                            1.sw > 600 ? 20.w : 15.w)),
                                  ),
                                  /////
                                  SizedBox(
                                    height: 30.h,
                                  ),
                                  ////

                                  TextApp(
                                    text: "Các bàn đang còn trống của phòng",
                                    fontsize: 12.sp,
                                    fontWeight: FontWeight.normal,
                                    color: blueText,
                                  ),

                                  ////
                                  TextApp(
                                    text: "Ghép bàn",
                                    fontsize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                    color: blueText,
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),

                                  SizedBox(
                                    height: 50,
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: DropdownSearch.multiSelection(
                                            key: _popupCustomValidationKey,
                                            items: listTable,
                                            popupProps:
                                                PopupPropsMultiSelection.dialog(
                                                    title: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 15.w, top: 10.h),
                                              child: TextApp(
                                                text: "Chọn bàn để ghép",
                                                fontsize: 16.sp,
                                                fontWeight: FontWeight.bold,
                                                color: blueText,
                                              ),
                                            )),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(
                                    height: 30.h,
                                  ),
                                  TextApp(
                                    text: "Ghi chú",
                                    fontsize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                    color: blueText,
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  TextField(
                                    keyboardType: TextInputType.multiline,
                                    minLines: 1,
                                    maxLines: 3,
                                    cursorColor:
                                        const Color.fromRGBO(73, 80, 87, 1),
                                    decoration: InputDecoration(
                                        fillColor: const Color.fromARGB(
                                            255, 226, 104, 159),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Color.fromRGBO(
                                                  214, 51, 123, 0.6),
                                              width: 2.0),
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                        ),
                                        hintText: '',
                                        isDense: true,
                                        contentPadding: EdgeInsets.only(
                                            bottom: 1.sw > 600 ? 50.w : 40.w,
                                            top: 0,
                                            left: 1.sw > 600 ? 20.w : 15.w,
                                            right: 1.sw > 600 ? 20.w : 15.w)),
                                  ),

                                  SizedBox(
                                    height: 15.h,
                                  ),
                                ],
                              ),

                              ////Tab2
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                            height: 40.h,
                                            color: Colors.white,
                                            child: TabBar(
                                                labelPadding: EdgeInsets.only(
                                                    left: 20, right: 20),
                                                labelColor: Colors.black,
                                                unselectedLabelColor: Colors
                                                    .black
                                                    .withOpacity(0.5),
                                                labelStyle: TextStyle(
                                                    color: Colors.red),
                                                controller: _tabSubController,
                                                isScrollable: true,
                                                indicatorSize:
                                                    TabBarIndicatorSize.label,
                                                indicator: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    8.r,
                                                  ),
                                                  color: Colors.blue,
                                                  border: Border.all(
                                                      color: Colors.blue),
                                                ),
                                                tabs: [
                                                  CustomTab(
                                                      text: "Tất cả",
                                                      icon: Icons.list_alt),
                                                  CustomTab(
                                                    text: "Đã thanh toán",
                                                    icon: Icons.credit_score,
                                                  ),
                                                  CustomTab(
                                                      text: "Chưa thanh toán",
                                                      icon: Icons.credit_card),
                                                  CustomTab(
                                                      text: "Hóa đơn đã hủy",
                                                      icon: Icons.cancel_sharp),

                                                  // Tab(text: "Đã thanh toán"),
                                                  // Tab(text: "Chưa thanh toán"),
                                                  // Tab(text: "Hóa đơn đã hủy"),
                                                ]),
                                          ))),
                                ],
                              ),

                              ///Tab3
                              Visibility(
                                  visible: widget.isUsingTable,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextApp(
                                        text: "Lý do hủy bàn",
                                        fontsize: 12.sp,
                                        fontWeight: FontWeight.bold,
                                        color: blueText,
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      TextField(
                                        keyboardType: TextInputType.multiline,
                                        minLines: 1,
                                        maxLines: 5,
                                        cursorColor:
                                            const Color.fromRGBO(73, 80, 87, 1),
                                        decoration: InputDecoration(
                                            fillColor: const Color.fromARGB(
                                                255, 226, 104, 159),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Color.fromRGBO(
                                                      214, 51, 123, 0.6),
                                                  width: 2.0),
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                            ),
                                            hintText: '',
                                            isDense: true,
                                            contentPadding: EdgeInsets.only(
                                                bottom:
                                                    1.sw > 600 ? 50.w : 40.w,
                                                top: 0,
                                                left: 1.sw > 600 ? 20.w : 15.w,
                                                right:
                                                    1.sw > 600 ? 20.w : 15.w)),
                                      ),
                                    ],
                                  ))
                            ],
                          ),
                        )
                      ],
                    ),
                  ))),
                  Container(
                    width: 1.sw,
                    height: 80,
                    decoration: BoxDecoration(
                      border: const Border(
                          top: BorderSide(width: 1, color: Colors.grey),
                          bottom: BorderSide(width: 0, color: Colors.grey),
                          left: BorderSide(width: 0, color: Colors.grey),
                          right: BorderSide(width: 0, color: Colors.grey)),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15.w),
                          bottomRight: Radius.circular(15.w)),
                      // color: Colors.green,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ButtonApp(
                          event: () {
                            Navigator.of(context).pop();
                          },
                          text: "Đóng",
                          colorText: Colors.white,
                          backgroundColor: Color.fromRGBO(131, 146, 171, 1),
                          outlineColor: Color.fromRGBO(131, 146, 171, 1),
                        ),
                        SizedBox(
                          width: 20.w,
                        ),
                        ButtonApp(
                          event: () {
                            widget.eventSaveButton();
                          },
                          text: save,
                          colorText: Colors.white,
                          backgroundColor: Color.fromRGBO(23, 193, 232, 1),
                          outlineColor: Color.fromRGBO(23, 193, 232, 1),
                        ),
                        SizedBox(
                          width: 20.w,
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        );
      },
    );
  }
}

///Modal chuyển bàn
class MoveTableDialog extends StatelessWidget {
  final Function eventSaveButton;

  const MoveTableDialog({Key? key, required this.eventSaveButton})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        content: SizedBox(
      width: double.maxFinite,
      child: ListView(
        shrinkWrap: true,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  width: 1.sw,
                  height: 50,
                  decoration: BoxDecoration(
                    border: const Border(
                        top: BorderSide(width: 0, color: Colors.grey),
                        bottom: BorderSide(width: 1, color: Colors.grey),
                        left: BorderSide(width: 0, color: Colors.grey),
                        right: BorderSide(width: 0, color: Colors.grey)),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15.w),
                        topRight: Radius.circular(15.w)),
                    // color: Colors.amber,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 20.w),
                            child: TextApp(
                              text: "Table 1",
                              fontsize: 18.sp,
                              color: blueText,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 20.w),
                            child: TextApp(
                              text: "Room 1",
                              fontsize: 14.sp,
                              color: blueText,
                              fontWeight: FontWeight.normal,
                            ),
                          )
                        ],
                      )
                    ],
                  )),
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextApp(
                        text: "Bàn hiện tại",
                        fontsize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: blueText,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      ButtonApp(
                        event: () {},
                        text: "Table 1",
                        colorText: Colors.blue,
                        backgroundColor: Colors.white,
                        outlineColor: Colors.blue,
                        radius: 8.r,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextApp(
                            text: "Bàn có thể đổi:",
                            fontsize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: blueText,
                          ),
                          SizedBox(
                            width: 20.w,
                          ),
                          Flexible(
                            fit: FlexFit.tight,
                            child: DropdownSearch(
                              validator: (value) {
                                if (value == "Chọn phòng") {
                                  return canNotNull;
                                }
                                return null;
                              },
                              items: listTable,
                              dropdownDecoratorProps: DropDownDecoratorProps(
                                dropdownSearchDecoration: InputDecoration(
                                  fillColor:
                                      const Color.fromARGB(255, 226, 104, 159),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color:
                                            Color.fromRGBO(214, 51, 123, 0.6),
                                        width: 2.0),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(15.w),
                                ),
                              ),
                              onChanged: print,
                              selectedItem: "Chọn phòng",
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors
                                          .blue, //                   <--- border color
                                      width: 1.w,
                                    ),
                                    color: Colors.white),
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
                                color: Colors.blue,
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              TextApp(text: "Bàn trống")
                            ],
                          )
                        ],
                      ),
                      space15H,
                      GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: listTable.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                          ),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.all(10.w),
                              child: ButtonApp(
                                event: () {},
                                text: listTable[index],
                                colorText: Colors.white,
                                backgroundColor: Colors.blue,
                                outlineColor: Color.fromRGBO(131, 146, 171, 1),
                              ),
                            );
                          }),
                      GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: listTable.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                          ),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.all(10.w),
                              child: ButtonApp(
                                event: () {},
                                text: listTable[index],
                                colorText: Colors.white,
                                backgroundColor: Colors.blue,
                                outlineColor: Color.fromRGBO(131, 146, 171, 1),
                              ),
                            );
                          }),
                    ],
                  ),
                ),
              ),
              Container(
                width: 1.sw,
                height: 80,
                decoration: BoxDecoration(
                  border: const Border(
                      top: BorderSide(width: 1, color: Colors.grey),
                      bottom: BorderSide(width: 0, color: Colors.grey),
                      left: BorderSide(width: 0, color: Colors.grey),
                      right: BorderSide(width: 0, color: Colors.grey)),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15.w),
                      bottomRight: Radius.circular(15.w)),
                  // color: Colors.green,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ButtonApp(
                      event: () {
                        Navigator.of(context).pop();
                      },
                      text: "Đóng",
                      colorText: Colors.white,
                      backgroundColor: const Color.fromRGBO(131, 146, 171, 1),
                      outlineColor: const Color.fromRGBO(131, 146, 171, 1),
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    ButtonApp(
                      event: () {
                        eventSaveButton();
                      },
                      text: save,
                      colorText: Colors.white,
                      backgroundColor: const Color.fromRGBO(23, 193, 232, 1),
                      outlineColor: const Color.fromRGBO(23, 193, 232, 1),
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    ));
  }
}

//Modal xem hoá đơn
class SeeBillDialog extends StatelessWidget {
  const SeeBillDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
          width: 1.sw,
          height: 1.sh,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  width: 1.sw,
                  height: 50,
                  decoration: BoxDecoration(
                    border: const Border(
                        top: BorderSide(width: 0, color: Colors.grey),
                        bottom: BorderSide(width: 1, color: Colors.grey),
                        left: BorderSide(width: 0, color: Colors.grey),
                        right: BorderSide(width: 0, color: Colors.grey)),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15.w),
                        topRight: Radius.circular(15.w)),
                    // color: Colors.amber,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 20.w),
                            child: TextApp(
                              text: "Table 1",
                              fontsize: 18.sp,
                              color: blueText,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 20.w),
                            child: TextApp(
                              text: "Room 1",
                              fontsize: 14.sp,
                              color: blueText,
                              fontWeight: FontWeight.normal,
                            ),
                          )
                        ],
                      )
                    ],
                  )),
              Flexible(
                fit: FlexFit.tight,
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    children: [
                      Flexible(
                        fit: FlexFit.tight,
                        child: Column(
                          children: [
                            Container(
                                width: 1.sw,
                                // height: 100.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.r),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 4,
                                      offset: const Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 1.sw,
                                      // height: 30.h,
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          begin: Alignment.topRight,
                                          end: Alignment.bottomLeft,
                                          colors: [
                                            Color.fromRGBO(33, 82, 255, 1),
                                            Color.fromRGBO(33, 212, 253, 1),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10.r),
                                            topRight: Radius.circular(10.r)),
                                        color: Colors.blue,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            top: 10.h,
                                            left: 10.w,
                                            bottom: 10.h),
                                        child: TextApp(
                                          text: "Tổng quan",
                                          fontsize: 18.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 1.sw,
                                      // height: 30.h,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(15.r),
                                        color: Colors.white,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(20.w),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                TextApp(
                                                    text: "22-02-2024 13:44:51",
                                                    fontsize: 14.sp),
                                                SizedBox(
                                                  width: 5.w,
                                                ),
                                                Icon(
                                                  Icons.access_time_filled,
                                                  size: 14.sp,
                                                  color: Colors.grey,
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 15.h,
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                TextApp(
                                                  text: "Tổng tiền",
                                                  fontsize: 14.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                TextApp(
                                                    text: "200,000 đ",
                                                    fontsize: 14.sp),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                )),
                            SizedBox(
                              height: 20.h,
                            ),
                            Flexible(
                              fit: FlexFit.tight,
                              child: Container(
                                  width: 1.sw,
                                  // height: 100.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.r),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 4,
                                        offset: const Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 1.sw,
                                        // height: 30.h,
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            begin: Alignment.topRight,
                                            end: Alignment.bottomLeft,
                                            colors: [
                                              Color.fromRGBO(33, 82, 255, 1),
                                              Color.fromRGBO(33, 212, 253, 1),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10.r),
                                              topRight: Radius.circular(10.r)),
                                          color: Colors.blue,
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: 10.h,
                                              left: 10.w,
                                              right: 10.w,
                                              bottom: 10.h),
                                          child: TextApp(
                                            text: "Danh sách món ăn",
                                            fontsize: 18.sp,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                          child: Container(
                                        width: 1.sw,
                                        // height: 100.h,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(10.r),
                                              bottomRight:
                                                  Radius.circular(10.r)),
                                          color: Colors.white,
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 20.w, right: 20.w),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              // SizedBox(
                                              //   height: 200.h,
                                              //   child:
                                              // ),
                                              Flexible(
                                                child: ListView.builder(
                                                    itemCount: 10,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Column(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    bottom:
                                                                        10.h),
                                                            child: SizedBox(
                                                                width: 1.sw,
                                                                child: Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(20
                                                                              .w),
                                                                  child: Column(
                                                                    children: [
                                                                      Row(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        children: [
                                                                          SizedBox(
                                                                            width:
                                                                                50.w,
                                                                            height:
                                                                                50.w,
                                                                            child:
                                                                                Image.asset(
                                                                              "assets/images/banner1.png",
                                                                              fit: BoxFit.cover,
                                                                            ),
                                                                          ),
                                                                          space50W,
                                                                          Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.center,
                                                                            children: [
                                                                              TextApp(text: "Ten mon an"),
                                                                              TextApp(text: "Gia mon an")
                                                                            ],
                                                                          )
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            15.h,
                                                                      ),
                                                                      Container(
                                                                          width: 1
                                                                              .sw,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.all(Radius.circular(8.r)),

                                                                            // color:
                                                                            //     Colors.pink,
                                                                          ),
                                                                          child:
                                                                              IntrinsicHeight(
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              crossAxisAlignment: CrossAxisAlignment.stretch,
                                                                              children: [
                                                                                InkWell(
                                                                                  onTap: () {},
                                                                                  child: Container(
                                                                                    width: 50.w,
                                                                                    height: 25.w,
                                                                                    decoration: BoxDecoration(
                                                                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(8.r), bottomLeft: Radius.circular(8.r)),
                                                                                        gradient: const LinearGradient(
                                                                                          begin: Alignment.topRight,
                                                                                          end: Alignment.bottomLeft,
                                                                                          colors: [
                                                                                            Color.fromRGBO(33, 82, 255, 1),
                                                                                            Color.fromRGBO(33, 212, 253, 1)
                                                                                          ],
                                                                                        )),
                                                                                    child: Center(
                                                                                      child: TextApp(text: "-", textAlign: TextAlign.center, color: Colors.white, fontsize: 14.sp),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Expanded(
                                                                                    child: Container(
                                                                                  decoration: BoxDecoration(
                                                                                    border: Border.all(width: 0.4, color: Colors.grey),
                                                                                  ),
                                                                                  child: Center(
                                                                                    child: TextApp(
                                                                                      text: "1",
                                                                                      textAlign: TextAlign.center,
                                                                                    ),
                                                                                  ),
                                                                                )),
                                                                                InkWell(
                                                                                  onTap: () {},
                                                                                  child: Container(
                                                                                    width: 50.w,
                                                                                    height: 25.w,
                                                                                    decoration: BoxDecoration(
                                                                                        borderRadius: BorderRadius.only(topRight: Radius.circular(8.r), bottomRight: Radius.circular(8.r)),
                                                                                        gradient: const LinearGradient(
                                                                                          begin: Alignment.topRight,
                                                                                          end: Alignment.bottomLeft,
                                                                                          colors: [
                                                                                            Color.fromRGBO(33, 82, 255, 1),
                                                                                            Color.fromRGBO(33, 212, 253, 1)
                                                                                          ],
                                                                                        )),
                                                                                    child: Center(
                                                                                      child: TextApp(
                                                                                        text: "+",
                                                                                        textAlign: TextAlign.center,
                                                                                        color: Colors.white,
                                                                                        fontsize: 14.sp,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          )),
                                                                    ],
                                                                  ),
                                                                )),
                                                          ),
                                                          const Divider(
                                                            height: 1,
                                                            color: Colors.grey,
                                                          )
                                                        ],
                                                      );
                                                    }),
                                              )
                                            ],
                                          ),
                                        ),
                                      ))
                                    ],
                                  )),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                width: 1.sw,
                height: 80,
                decoration: BoxDecoration(
                  border: const Border(
                      top: BorderSide(width: 1, color: Colors.grey),
                      bottom: BorderSide(width: 0, color: Colors.grey),
                      left: BorderSide(width: 0, color: Colors.grey),
                      right: BorderSide(width: 0, color: Colors.grey)),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15.w),
                      bottomRight: Radius.circular(15.w)),
                  // color: Colors.green,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ButtonApp(
                      event: () {
                        Navigator.of(context).pop();
                      },
                      text: "Đóng",
                      colorText: Colors.white,
                      backgroundColor: const Color.fromRGBO(131, 146, 171, 1),
                      outlineColor: const Color.fromRGBO(131, 146, 171, 1),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}

//Modal thanh toán hoá đơn
class PayBillDialog extends StatefulWidget {
  final Function eventSaveButton;
  const PayBillDialog({Key? key, required this.eventSaveButton})
      : super(key: key);

  @override
  State<PayBillDialog> createState() => _PayBillDialogState();
}

class _PayBillDialogState extends State<PayBillDialog> {
  final moneySaleController = TextEditingController();

  String currentOptions = optionsPayment[0];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
          width: 1.sw,
          // height: 1.sh,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  width: 1.sw,
                  height: 50,
                  decoration: BoxDecoration(
                    border: const Border(
                        top: BorderSide(width: 0, color: Colors.grey),
                        bottom: BorderSide(width: 1, color: Colors.grey),
                        left: BorderSide(width: 0, color: Colors.grey),
                        right: BorderSide(width: 0, color: Colors.grey)),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15.w),
                        topRight: Radius.circular(15.w)),
                    // color: Colors.amber,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 20.w),
                            child: TextApp(
                              text: "Table 1",
                              fontsize: 18.sp,
                              color: blueText,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 20.w),
                            child: TextApp(
                              text: "Room 1",
                              fontsize: 14.sp,
                              color: blueText,
                              fontWeight: FontWeight.normal,
                            ),
                          )
                        ],
                      )
                    ],
                  )),
              Flexible(
                  fit: FlexFit.tight,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10.w),
                          child: Container(
                            width: 1.sw,
                            // height: 100.h,
                            // color: Colors.green,
                            child: Column(
                              children: [
                                Container(
                                    width: 1.sw,
                                    height: 40.h,
                                    color: Colors.grey,
                                    child: Padding(
                                        padding: EdgeInsets.only(left: 5.h),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            TextApp(
                                              text: "Hóa đơn",
                                              color: Colors.white,
                                              fontsize: 14.sp,
                                            ),
                                          ],
                                        ))),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        TextApp(
                                          text: "Tên món ăn",
                                          color: Colors.black,
                                          fontsize: 14.sp,
                                        ),
                                        TextApp(
                                          text: "thit heo nuong",
                                          color: Colors.black,
                                          fontsize: 14.sp,
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        TextApp(
                                          text: "Số lượng",
                                          color: Colors.black,
                                          fontsize: 14.sp,
                                        ),
                                        TextApp(
                                          text: "3",
                                          color: Colors.black,
                                          fontsize: 14.sp,
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        TextApp(
                                          text: "Giá",
                                          color: Colors.black,
                                          fontsize: 14.sp,
                                        ),
                                        TextApp(
                                          text: "200,000",
                                          color: Colors.black,
                                          fontsize: 14.sp,
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        TextApp(
                                          text: "Tổng",
                                          color: Colors.black,
                                          fontsize: 14.sp,
                                        ),
                                        TextApp(
                                          text: "600,000",
                                          color: Colors.black,
                                          fontsize: 14.sp,
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        Divider(
                          height: 1,
                          color: Colors.grey,
                        ),
                        Padding(
                          padding: EdgeInsets.all(10.w),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextApp(
                                    text: "Tổng",
                                    color: Colors.black,
                                    fontsize: 14.sp,
                                  ),
                                  TextApp(
                                    text: "600,000",
                                    color: Colors.black,
                                    fontsize: 14.sp,
                                  ),
                                ],
                              ),
                              space20H,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextApp(
                                      text: "22-02-2024 13:44:51",
                                      fontsize: 14.sp),
                                  space5W,
                                  Icon(
                                    Icons.access_time_filled,
                                    size: 14.sp,
                                    color: Colors.grey,
                                  )
                                ],
                              ),
                              space20H,
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextApp(
                                    text: "Tổng tiền món",
                                    color: Colors.black,
                                    fontsize: 14.sp,
                                  ),
                                  TextApp(
                                    text: '600000',
                                    color: Colors.black,
                                    fontsize: 14.sp,
                                  ),
                                ],
                              ),
                              space20H,
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextApp(
                                    text: "Giảm giá",
                                    color: Colors.black,
                                    fontsize: 14.sp,
                                  ),
                                  // space35W,
                                  Container(
                                    width: 120.w,
                                    child: TextField(
                                      style: TextStyle(
                                          fontSize: 12.sp, color: grey),
                                      controller: moneySaleController,
                                      onEditingComplete: () {},
                                      cursorColor: grey,
                                      decoration: InputDecoration(
                                          fillColor: const Color.fromARGB(
                                              255, 226, 104, 159),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Color.fromRGBO(
                                                    214, 51, 123, 0.6),
                                                width: 2.0),
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                          ),
                                          hintText: '',
                                          isDense: true,
                                          contentPadding: EdgeInsets.all(15.w)),
                                    ),
                                  )
                                ],
                              ),
                              space20H,
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextApp(
                                    text: "Khách cần trả",
                                    color: Colors.black,
                                    fontsize: 14.sp,
                                  ),
                                  TextApp(
                                    text: '600000',
                                    color: Colors.black,
                                    fontsize: 14.sp,
                                  ),
                                ],
                              ),
                              space20H,
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextApp(
                                    text: "Khách thanh toán",
                                    color: Colors.black,
                                    fontsize: 14.sp,
                                  ),
                                  // space15W,
                                  Container(
                                    width: 120.w,
                                    child: TextField(
                                      style: TextStyle(
                                          fontSize: 12.sp, color: grey),
                                      cursorColor: grey,
                                      decoration: InputDecoration(
                                          fillColor: const Color.fromARGB(
                                              255, 226, 104, 159),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Color.fromRGBO(
                                                    214, 51, 123, 0.6),
                                                width: 2.0),
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                          ),
                                          hintText: '',
                                          isDense: true,
                                          contentPadding: EdgeInsets.all(15.w)),
                                    ),
                                  )
                                ],
                              ),
                              space20H,
                              Wrap(
                                children: [
                                  Row(
                                    children: [
                                      Radio(
                                        activeColor: Colors.black,
                                        value: optionsPayment[0],
                                        groupValue: currentOptions,
                                        onChanged: (value) {
                                          setState(() {
                                            currentOptions = value.toString();
                                          });
                                        },
                                      ),
                                      TextApp(
                                        text: optionsPayment[0],
                                        color: Colors.black,
                                        fontsize: 14.sp,
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Radio(
                                        activeColor: Colors.black,
                                        value: optionsPayment[1],
                                        groupValue: currentOptions,
                                        onChanged: (value) {
                                          setState(() {
                                            currentOptions = value.toString();
                                          });
                                        },
                                      ),
                                      TextApp(
                                        text: optionsPayment[1],
                                        color: Colors.black,
                                        fontsize: 14.sp,
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Radio(
                                        activeColor: Colors.black,
                                        value: optionsPayment[2],
                                        groupValue: currentOptions,
                                        onChanged: (value) {
                                          setState(() {
                                            currentOptions = value.toString();
                                          });
                                        },
                                      ),
                                      TextApp(
                                        text: optionsPayment[2],
                                        color: Colors.black,
                                        fontsize: 14.sp,
                                      )
                                    ],
                                  )
                                ],
                              ),
                              space20H,
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextApp(
                                    text: "Tiền thừa trả khách",
                                    color: Colors.black,
                                    fontsize: 14.sp,
                                  ),
                                  TextApp(
                                    text: "600,000",
                                    color: Colors.black,
                                    fontsize: 14.sp,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
              Container(
                width: 1.sw,
                height: 80,
                decoration: BoxDecoration(
                  border: const Border(
                      top: BorderSide(width: 1, color: Colors.grey),
                      bottom: BorderSide(width: 0, color: Colors.grey),
                      left: BorderSide(width: 0, color: Colors.grey),
                      right: BorderSide(width: 0, color: Colors.grey)),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15.w),
                      bottomRight: Radius.circular(15.w)),
                  // color: Colors.green,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ButtonApp(
                      event: () {
                        Navigator.of(context).pop();
                      },
                      text: "Đóng",
                      colorText: Colors.white,
                      backgroundColor: Color.fromRGBO(131, 146, 171, 1),
                      outlineColor: Color.fromRGBO(131, 146, 171, 1),
                    ),
                    ButtonApp(
                      event: () {
                        widget.eventSaveButton();
                      },
                      text: "Thanh toán",
                      colorText: Colors.white,
                      backgroundColor: Color.fromRGBO(23, 173, 55, 1),
                      outlineColor: Color.fromRGBO(152, 236, 45, 1),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}

//Modal quản lí hoá đơn mang về
class ManageBroughtReceiptDialog extends StatefulWidget {
  const ManageBroughtReceiptDialog({super.key});

  @override
  State<ManageBroughtReceiptDialog> createState() =>
      _ManageBroughtReceiptDialogState();
}

class _ManageBroughtReceiptDialogState
    extends State<ManageBroughtReceiptDialog> {
  final searchController = TextEditingController();

  List<String> selectedCategories = [];
  List<ItemFood> currentFoodList = [];
  String query = '';
  void searchProduct(String query) {
    setState(() {
      this.query = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filterProducts = listFood.where((product) {
      final foodTitle = product.name.toLowerCase();
      final input = query.toLowerCase();

      return (selectedCategories.isEmpty ||
              selectedCategories.contains(product.category)) &&
          foodTitle.contains(input);
    }).toList();
    return AlertDialog(
      content: InkWell(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Container(
          width: 1.sw,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextApp(
                    text: "Hóa đơn mang về",
                    fontWeight: FontWeight.bold,
                    fontsize: 18.sp,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.close),
                  )
                ],
              ),
              space20H,
              const Divider(
                height: 1,
                color: Colors.black,
              ),
              space10H,
              Card(
                  elevation: 8.w,
                  margin: EdgeInsets.all(8.w),
                  child: Container(
                      width: 1.sw,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.w)),
                      child: Padding(
                        padding: EdgeInsets.all(10.w),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                TextApp(
                                  text: "Tên khách hàng: ",
                                  fontWeight: FontWeight.bold,
                                  fontsize: 14.sp,
                                ),
                                TextApp(
                                  text: "Khách lẻ",
                                  fontsize: 14.sp,
                                ),
                              ],
                            ),
                            space10H,
                            Row(
                              children: [
                                TextApp(
                                  text: "Tổng tiền món ăn: ",
                                  fontWeight: FontWeight.bold,
                                  fontsize: 14.sp,
                                ),
                                TextApp(
                                  text: "28,000 đ",
                                  fontsize: 14.sp,
                                ),
                              ],
                            )
                          ],
                        ),
                      ))),
              space30H,
              SizedBox(
                  height: 50,
                  // color: Colors.red,
                  child: Row(
                    children: [
                      Expanded(
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: categories.map((exercise) {
                            return Padding(
                              padding: EdgeInsets.only(right: 5.w, left: 5.w),
                              child: FilterChip(
                                labelPadding: EdgeInsets.only(
                                    left: 15.w,
                                    right: 15.w,
                                    top: 8.w,
                                    bottom: 8.w),
                                disabledColor: Colors.grey,
                                selectedColor: Colors.blue,
                                backgroundColor: Colors.white,
                                shadowColor: Colors.black,
                                selectedShadowColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.w),
                                  side: BorderSide(
                                    color: Colors.grey.withOpacity(0.5),
                                    width: 1.0,
                                  ),
                                ),
                                labelStyle: TextStyle(
                                    color: selectedCategories.contains(exercise)
                                        ? Colors.white
                                        : Colors.black),
                                showCheckmark: false,
                                label: TextApp(
                                  text: exercise.toUpperCase(),
                                  fontsize: 14.sp,
                                  color: blueText,
                                  fontWeight: FontWeight.bold,
                                  textAlign: TextAlign.center,
                                ),
                                selected: selectedCategories.contains(exercise),
                                onSelected: (bool selected) {
                                  setState(() {
                                    if (selected) {
                                      selectedCategories.add(exercise);
                                    } else {
                                      selectedCategories.remove(exercise);
                                    }
                                  });
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  )),
              space30H,
              IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        onChanged: searchProduct,
                        controller: searchController,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color.fromRGBO(214, 51, 123, 0.6),
                                  width: 2.0),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            isDense: true,
                            hintText: "Nhập nội dung bạn muốn tìm kiếm",
                            contentPadding: const EdgeInsets.all(15)),
                      ),
                    ),
                    space20W,
                    Container(
                        width: 80.w,
                        height: 45.w,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            gradient: const LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [
                                Color.fromRGBO(33, 82, 255, 1),
                                Color.fromRGBO(33, 212, 253, 1)
                              ],
                            )),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextApp(
                              text: "1",
                              color: Colors.white,
                              fontsize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                            space5W,
                            const Icon(
                              Icons.shopping_cart,
                              color: Colors.white,
                            )
                          ],
                        ))
                  ],
                ),
              ),
              const SizedBox(height: 5.0),
              const SizedBox(height: 10.0),
              Expanded(
                  child: ListView.builder(
                      itemCount: filterProducts.length,
                      itemBuilder: (context, index) {
                        final product = filterProducts[index];
                        return Card(
                          elevation: 8.0,
                          margin: const EdgeInsets.all(8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          child: Container(
                              width: 1.sw,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15.r)),
                              child: Column(
                                children: [
                                  // space15H,
                                  SizedBox(
                                      height: 160.w,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(15.r),
                                            topRight: Radius.circular(15.r)),
                                        child: Image.asset(
                                          product.image,
                                          fit: BoxFit.cover,
                                        ),
                                      )),
                                  space10H,
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextApp(text: product.name),
                                      TextApp(
                                        text: product.price,
                                        fontsize: 20.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ],
                                  ),
                                  const Divider(),
                                  Padding(
                                    padding: EdgeInsets.all(20.w),
                                    child: Container(
                                        width: 1.sw,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8.r)),
                                        ),
                                        child: IntrinsicHeight(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              InkWell(
                                                onTap: () {},
                                                child: Container(
                                                  width: 70.w,
                                                  height: 35.w,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(
                                                                      8.r),
                                                              bottomLeft: Radius
                                                                  .circular(
                                                                      8.r)),
                                                      gradient:
                                                          const LinearGradient(
                                                        begin:
                                                            Alignment.topRight,
                                                        end: Alignment
                                                            .bottomLeft,
                                                        colors: [
                                                          Color.fromRGBO(
                                                              33, 82, 255, 1),
                                                          Color.fromRGBO(
                                                              33, 212, 253, 1)
                                                        ],
                                                      )),
                                                  child: Center(
                                                    child: TextApp(
                                                      text: "-",
                                                      textAlign:
                                                          TextAlign.center,
                                                      color: Colors.white,
                                                      fontsize: 18.sp,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                  child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 0.4,
                                                      color: Colors.grey),
                                                ),
                                                child: Center(
                                                  child: TextApp(
                                                    text: "1",
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              )),
                                              InkWell(
                                                onTap: () {},
                                                child: Container(
                                                  width: 70.w,
                                                  height: 35.w,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topRight: Radius
                                                                  .circular(
                                                                      8.r),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          8.r)),
                                                      gradient:
                                                          const LinearGradient(
                                                        begin:
                                                            Alignment.topRight,
                                                        end: Alignment
                                                            .bottomLeft,
                                                        colors: [
                                                          Color.fromRGBO(
                                                              33, 82, 255, 1),
                                                          Color.fromRGBO(
                                                              33, 212, 253, 1)
                                                        ],
                                                      )),
                                                  child: Center(
                                                    child: TextApp(
                                                      text: "+",
                                                      textAlign:
                                                          TextAlign.center,
                                                      color: Colors.white,
                                                      fontsize: 18.sp,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        )),
                                  )
                                ],
                              )),
                        );
                      })),
            ],
          ),
        ),
      ),
    );
  }
}

//Modal in hoá đơn

class PrintBillDialog extends StatelessWidget {
  const PrintBillDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // scrollable: true,
      content: SizedBox(
        width: double.maxFinite,
        child: ListView(
          shrinkWrap: true,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextApp(
                          text: "Phòng 1",
                          fontsize: 18.sp,
                          color: blueText,
                          fontWeight: FontWeight.bold,
                        ),
                        TextApp(
                          text: "Bàn 1",
                          fontsize: 16.sp,
                          color: blueText,
                        ),
                      ],
                    ),
                  ],
                ),
                space10H,
                const Divider(
                  height: 1,
                  color: Colors.black,
                ),
                space10H,
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextApp(
                      text: "Shop 1",
                      fontsize: 18.sp,
                      color: blueText,
                      fontWeight: FontWeight.bold,
                    ),
                    space5W,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextApp(
                          text: "Địa chỉ: ",
                          fontsize: 16.sp,
                          color: blueText,
                        ),
                        space10W,
                        TextApp(
                          text: "123 duong abc",
                          fontsize: 16.sp,
                          color: blueText,
                        ),
                      ],
                    )
                  ],
                ),
                space5H,
                // CustomDotsLine(color: Colors.grey),
                const Divider(
                  height: 1,
                  color: Colors.black,
                ),
                space10H,
                Wrap(
                  children: [
                    Row(
                      children: [
                        TextApp(
                          text: "Giờ vào: ",
                          fontsize: 16.sp,
                          color: blueText,
                          fontWeight: FontWeight.bold,
                        ),
                        TextApp(
                          text: "16:04:57",
                          fontsize: 16.sp,
                          color: blueText,
                        ),
                        space20W,
                        TextApp(
                          text: "27-02-2024",
                          fontsize: 16.sp,
                          color: blueText,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        TextApp(
                          text: "Giờ ra:  ",
                          fontsize: 16.sp,
                          color: blueText,
                          fontWeight: FontWeight.bold,
                        ),
                        TextApp(
                          text: "11:45:19",
                          fontsize: 16.sp,
                          color: blueText,
                        ),
                        space20W,
                        TextApp(
                          text: "29-02-2024",
                          fontsize: 16.sp,
                          color: blueText,
                        ),
                      ],
                    )
                  ],
                ),
                space5H,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        TextApp(
                          text: "Tên khách hàng: ",
                          fontsize: 16.sp,
                          color: blueText,
                          fontWeight: FontWeight.bold,
                        ),
                        TextApp(
                          text: "Nguyen Van A",
                          fontsize: 16.sp,
                          color: blueText,
                        ),
                      ],
                    ),
                  ],
                ),
                space20H,

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextApp(
                      text: "Tên hàng",
                      fontsize: 16.sp,
                      color: blueText,
                    ),
                    TextApp(
                      text: "SL",
                      fontsize: 16.sp,
                      color: blueText,
                    ),
                    TextApp(
                      text: "Đ.giá",
                      fontsize: 16.sp,
                      color: blueText,
                    ),
                    TextApp(
                      text: "TT",
                      fontsize: 16.sp,
                      color: blueText,
                    ),
                  ],
                ),
                space5H,
                const Divider(
                  height: 1,
                  color: Colors.black,
                ),
                space10H,
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextApp(
                                text: "Tên hàng",
                                fontsize: 16.sp,
                                color: blueText,
                              ),
                              TextApp(
                                text: "SL",
                                fontsize: 16.sp,
                                color: blueText,
                              ),
                              TextApp(
                                text: "Đ.giá",
                                fontsize: 16.sp,
                                color: blueText,
                              ),
                              TextApp(
                                text: "TT",
                                fontsize: 16.sp,
                                color: blueText,
                              ),
                            ],
                          ),
                          const Divider(
                            height: 1,
                            color: Colors.black,
                          ),
                          space10H
                        ],
                      );
                    }),
                space35H,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextApp(
                      text: "Tổng tiền món ",
                      fontsize: 16.sp,
                      color: blueText,
                      fontWeight: FontWeight.bold,
                    ),
                    TextApp(
                      text: "45,000",
                      fontsize: 16.sp,
                      color: blueText,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextApp(
                      text: "Giảm giá ",
                      fontsize: 16.sp,
                      color: blueText,
                      fontWeight: FontWeight.bold,
                    ),
                    TextApp(
                      text: "20,000",
                      fontsize: 16.sp,
                      color: blueText,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextApp(
                      text: "Khách cần trả ",
                      fontsize: 16.sp,
                      color: blueText,
                      fontWeight: FontWeight.bold,
                    ),
                    TextApp(
                      text: "45,000",
                      fontsize: 16.sp,
                      color: blueText,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextApp(
                      text: "Khách thanh toán ",
                      fontsize: 16.sp,
                      color: blueText,
                      fontWeight: FontWeight.bold,
                    ),
                    TextApp(
                      text: "45,000",
                      fontsize: 16.sp,
                      color: blueText,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextApp(
                      text: "Loại thanh toán ",
                      fontsize: 16.sp,
                      color: blueText,
                      fontWeight: FontWeight.bold,
                    ),
                    TextApp(
                      text: "Tiền mặt",
                      fontsize: 16.sp,
                      color: blueText,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextApp(
                      text: "Tiền thừa trả khách ",
                      fontsize: 16.sp,
                      color: blueText,
                      fontWeight: FontWeight.bold,
                    ),
                    TextApp(
                      text: "45,000",
                      fontsize: 16.sp,
                      color: blueText,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
                space15H,
                const Divider(
                  height: 1,
                  color: Colors.black,
                ),
                space15H,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ButtonApp(
                      event: () {
                        Navigator.of(context).pop();
                      },
                      text: "Đóng",
                      colorText: Colors.white,
                      backgroundColor: const Color.fromRGBO(131, 146, 171, 1),
                      outlineColor: const Color.fromRGBO(131, 146, 171, 1),
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    ButtonApp(
                      event: () {
                        // widget.eventSaveButton();
                      },
                      text: "In",
                      colorText: Colors.white,
                      backgroundColor: const Color.fromRGBO(23, 193, 232, 1),
                      outlineColor: const Color.fromRGBO(23, 193, 232, 1),
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

// Modal huỷ hoá đơn
class CancleBillDialog extends StatefulWidget {
  const CancleBillDialog({super.key});

  @override
  State<CancleBillDialog> createState() => _CancleBillDialogState();
}

class _CancleBillDialogState extends State<CancleBillDialog> {
  String currentOptions = optionsCancle[0];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      content: Container(
          width: 1.sw,
          // height: 1.sh / 2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            color: Colors.white,
          ),
          child: Padding(
            padding: EdgeInsets.only(
                top: 20.w, bottom: 20.w, left: 10.w, right: 10.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextApp(
                      text: "Hủy đơn",
                      fontsize: 18.sp,
                      color: blueText,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
                space10H,
                const Divider(
                  height: 1,
                  color: Colors.black,
                ),
                space10H,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextApp(
                      text: "Lý do hủy đơn",
                      fontsize: 14.sp,
                      color: blueText,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
                space5H,
                Column(
                  children: [
                    Row(
                      children: [
                        Radio(
                          activeColor: Colors.black,
                          value: optionsCancle[0],
                          groupValue: currentOptions,
                          onChanged: (value) {
                            setState(() {
                              currentOptions = value.toString();
                            });
                          },
                        ),
                        TextApp(
                          text: optionsCancle[0],
                          color: Colors.black,
                          fontsize: 14.sp,
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                          activeColor: Colors.black,
                          value: optionsCancle[1],
                          groupValue: currentOptions,
                          onChanged: (value) {
                            setState(() {
                              currentOptions = value.toString();
                            });
                          },
                        ),
                        TextApp(
                          text: optionsCancle[1],
                          color: Colors.black,
                          fontsize: 14.sp,
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                          activeColor: Colors.black,
                          value: optionsCancle[2],
                          groupValue: currentOptions,
                          onChanged: (value) {
                            setState(() {
                              currentOptions = value.toString();
                            });
                          },
                        ),
                        TextApp(
                          text: optionsCancle[2],
                          color: Colors.black,
                          fontsize: 14.sp,
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                          activeColor: Colors.black,
                          value: optionsCancle[3],
                          groupValue: currentOptions,
                          onChanged: (value) {
                            setState(() {
                              currentOptions = value.toString();
                            });
                          },
                        ),
                        TextApp(
                          text: optionsCancle[3],
                          color: Colors.black,
                          fontsize: 14.sp,
                        )
                      ],
                    )
                  ],
                ),
                space15H,
                const Divider(
                  height: 1,
                  color: Colors.black,
                ),
                space15H,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ButtonApp(
                      event: () {
                        Navigator.of(context).pop();
                      },
                      text: "Đóng".toUpperCase(),
                      colorText: Colors.white,
                      backgroundColor: const Color.fromRGBO(131, 146, 171, 1),
                      outlineColor: const Color.fromRGBO(131, 146, 171, 1),
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    ButtonApp(
                      event: () {
                        // widget.eventSaveButton();
                      },
                      text: "Xác nhận".toUpperCase(),
                      colorText: Colors.white,
                      backgroundColor: const Color.fromRGBO(23, 193, 232, 1),
                      outlineColor: const Color.fromRGBO(23, 193, 232, 1),
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}

//Modal tạo phòng

class CreateRoomDialog extends StatefulWidget {
  final Function eventSaveButton;

  const CreateRoomDialog({
    Key? key,
    required this.eventSaveButton,
  }) : super(key: key);

  @override
  State<CreateRoomDialog> createState() => _CreateRoomDialogState();
}

class _CreateRoomDialogState extends State<CreateRoomDialog> {
  bool light = false;
  final _formField = GlobalKey<FormState>();
  final roomFieldController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              width: 1.sw,
              height: 50,
              decoration: BoxDecoration(
                border: const Border(
                    top: BorderSide(width: 0, color: Colors.grey),
                    bottom: BorderSide(width: 1, color: Colors.grey),
                    left: BorderSide(width: 0, color: Colors.grey),
                    right: BorderSide(width: 0, color: Colors.grey)),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.w),
                    topRight: Radius.circular(15.w)),
                // color: Colors.amber,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 20.w),
                        child: TextApp(
                          text: "Phòng",
                          fontsize: 18.sp,
                          color: blueText,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ],
              )),
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Form(
              key: _formField,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextApp(
                    text: "Tên phòng",
                    fontsize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: blueText,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  TextFormField(
                    controller: roomFieldController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return canNotNull;
                      } else {
                        return null;
                      }
                    },
                    cursorColor: const Color.fromRGBO(73, 80, 87, 1),
                    decoration: InputDecoration(
                        fillColor: const Color.fromARGB(255, 226, 104, 159),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(214, 51, 123, 0.6),
                              width: 2.0),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        hintText: "Tên phòng",
                        isDense: true,
                        contentPadding:
                            EdgeInsets.all(1.sw > 600 ? 20.w : 15.w)),
                  ),
                  space20H,
                  TextApp(
                    text: "Chế độ hiển thị",
                    fontsize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: blueText,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  TextApp(
                    text: allowFoodReady,
                    fontsize: 12.sp,
                    fontWeight: FontWeight.normal,
                    color: blueText,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  SizedBox(
                    width: 50.w,
                    height: 30.w,
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: CupertinoSwitch(
                        value: light,
                        activeColor: const Color.fromRGBO(58, 65, 111, .95),
                        onChanged: (bool value) {
                          setState(() {
                            light = value;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: 1.sw,
            height: 80,
            decoration: BoxDecoration(
              border: const Border(
                  top: BorderSide(width: 1, color: Colors.grey),
                  bottom: BorderSide(width: 0, color: Colors.grey),
                  left: BorderSide(width: 0, color: Colors.grey),
                  right: BorderSide(width: 0, color: Colors.grey)),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15.w),
                  bottomRight: Radius.circular(15.w)),
              // color: Colors.green,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ButtonApp(
                  event: () {
                    Navigator.of(context).pop();
                  },
                  text: "Đóng",
                  colorText: Colors.white,
                  backgroundColor: const Color.fromRGBO(131, 146, 171, 1),
                  outlineColor: const Color.fromRGBO(131, 146, 171, 1),
                ),
                SizedBox(
                  width: 20.w,
                ),
                ButtonApp(
                  event: () {
                    if (_formField.currentState!.validate()) {
                      widget.eventSaveButton();
                      roomFieldController.clear();
                    }
                  },
                  text: save,
                  colorText: Colors.white,
                  backgroundColor: const Color.fromRGBO(23, 193, 232, 1),
                  outlineColor: const Color.fromRGBO(23, 193, 232, 1),
                ),
                SizedBox(
                  width: 20.w,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Modal tạo cửa hàng và chỉnh sửa cửa hàng

class CreateStoreDialog extends StatefulWidget {
  final List<XFile>? imageFileList;
  final Function eventSaveButton;
  const CreateStoreDialog({
    Key? key,
    required this.imageFileList,
    required this.eventSaveButton,
  }) : super(key: key);

  @override
  State<CreateStoreDialog> createState() => _CreateStoreDialogState();
}

class _CreateStoreDialogState extends State<CreateStoreDialog> {
  bool light = false;
  File? selectedImage;
  final _formField = GlobalKey<FormState>();
  final idStoreController = TextEditingController();
  final nameStoreController = TextEditingController();
  final addressStoreController = TextEditingController();
  final ImagePicker imagePicker = ImagePicker();
  QuillController _controllerQuill = QuillController.basic();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controllerQuill;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: double.maxFinite,
        child: ListView(
          shrinkWrap: true,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    width: 1.sw,
                    height: 50,
                    decoration: BoxDecoration(
                      border: const Border(
                          top: BorderSide(width: 0, color: Colors.grey),
                          bottom: BorderSide(width: 1, color: Colors.grey),
                          left: BorderSide(width: 0, color: Colors.grey),
                          right: BorderSide(width: 0, color: Colors.grey)),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15.w),
                          topRight: Radius.circular(15.w)),
                      // color: Colors.amber,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            TextApp(
                              text: "Cửa hàng",
                              fontsize: 18.sp,
                              color: blueText,
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                      ],
                    )),
                space15H,
                SingleChildScrollView(
                    child: Form(
                  key: _formField,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextApp(
                        text: storeId,
                        fontsize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: blueText,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      TextFormField(
                        controller: idStoreController,
                        cursorColor: const Color.fromRGBO(73, 80, 87, 1),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return canNotNull;
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                            fillColor: const Color.fromARGB(255, 226, 104, 159),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color.fromRGBO(214, 51, 123, 0.6),
                                  width: 2.0),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            hintText: storeId,
                            isDense: true,
                            contentPadding:
                                EdgeInsets.all(1.sw > 600 ? 20.w : 15.w)),
                      ),
                      ////////
                      SizedBox(
                        height: 30.h,
                      ),
                      //////
                      TextApp(
                        text: storeName,
                        fontsize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: blueText,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      TextFormField(
                        controller: nameStoreController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return canNotNull;
                          } else {
                            return null;
                          }
                        },
                        cursorColor: const Color.fromRGBO(73, 80, 87, 1),
                        decoration: InputDecoration(
                            fillColor: const Color.fromARGB(255, 226, 104, 159),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color.fromRGBO(214, 51, 123, 0.6),
                                  width: 2.0),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            hintText: storeName,
                            isDense: true,
                            contentPadding:
                                EdgeInsets.all(1.sw > 600 ? 20.w : 15.w)),
                      ),
                      /////
                      SizedBox(
                        height: 30.h,
                      ),
                      ////
                      TextApp(
                        text: storeAddress,
                        fontsize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: blueText,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      TextFormField(
                        controller: addressStoreController,
                        cursorColor: const Color.fromRGBO(73, 80, 87, 1),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return canNotNull;
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                            fillColor: const Color.fromARGB(255, 226, 104, 159),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color.fromRGBO(214, 51, 123, 0.6),
                                  width: 2.0),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            hintText: storeAddress,
                            isDense: true,
                            contentPadding:
                                EdgeInsets.all(1.sw > 600 ? 20.w : 15.w)),
                      ),
                      /////
                      SizedBox(
                        height: 30.h,
                      ),
                      ////
                      TextApp(
                        text: displayMode,
                        fontsize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: blueText,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      TextApp(
                        text: allowOpenStore,
                        fontsize: 12.sp,
                        fontWeight: FontWeight.normal,
                        color: blueText,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      SizedBox(
                        width: 50.w,
                        height: 30.w,
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: CupertinoSwitch(
                            value: light,
                            activeColor: const Color.fromRGBO(58, 65, 111, .95),
                            onChanged: (bool value) {
                              setState(() {
                                light = value;
                              });
                            },
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 30.h,
                      ),
                      ////
                      TextApp(
                        text: desStore,
                        fontsize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: blueText,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      TextApp(
                        text: describeDetailSotre,
                        fontsize: 12.sp,
                        fontWeight: FontWeight.normal,
                        color: blueText,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Container(
                          width: 1.sw,
                          // height: 250.h,

                          decoration: BoxDecoration(
                            border: const Border(
                                top: BorderSide(width: 1, color: Colors.grey),
                                bottom:
                                    BorderSide(width: 1, color: Colors.grey),
                                left: BorderSide(width: 1, color: Colors.grey),
                                right:
                                    BorderSide(width: 1, color: Colors.grey)),
                            borderRadius: BorderRadius.circular(15.w),
                            // color: Colors.amber,
                          ),
                          child: Column(
                            children: [
                              QuillProvider(
                                  configurations: QuillConfigurations(
                                      controller: _controllerQuill),
                                  child: Column(
                                    children: [
                                      Container(
                                          width: 1.sw,
                                          decoration: const BoxDecoration(
                                            border: Border(
                                                top: BorderSide(
                                                    width: 0,
                                                    color: Colors.grey),
                                                bottom: BorderSide(
                                                    width: 1,
                                                    color: Colors.grey),
                                                left: BorderSide(
                                                    width: 0,
                                                    color: Colors.grey),
                                                right: BorderSide(
                                                    width: 0,
                                                    color: Colors.grey)),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(10.w),
                                            child: const QuillToolbar(
                                              configurations:
                                                  QuillToolbarConfigurations(
                                                      toolbarIconAlignment:
                                                          WrapAlignment.center,
                                                      showFontFamily: true,
                                                      showFontSize: false,
                                                      showBoldButton: true,
                                                      showItalicButton: true,
                                                      showSmallButton: false,
                                                      showUnderLineButton: true,
                                                      showStrikeThrough: false,
                                                      showInlineCode: false,
                                                      showColorButton: false,
                                                      showBackgroundColorButton:
                                                          false,
                                                      showClearFormat: false,
                                                      showAlignmentButtons:
                                                          true,
                                                      showLeftAlignment: true,
                                                      showCenterAlignment: true,
                                                      showRightAlignment: true,
                                                      showJustifyAlignment:
                                                          true,
                                                      showHeaderStyle: false,
                                                      showListNumbers: true,
                                                      showListBullets: true,
                                                      showListCheck: false,
                                                      showCodeBlock: false,
                                                      showQuote: false,
                                                      showIndent: false,
                                                      showLink: true,
                                                      showUndo: false,
                                                      showRedo: false,
                                                      showDirection: false,
                                                      showSearchButton: false,
                                                      showSubscript: false,
                                                      showSuperscript: false),
                                            ),
                                          )),
                                      // space20H,
                                      Container(
                                        margin: EdgeInsets.all(5.w),
                                        height: 200.h,
                                        child: QuillEditor.basic(
                                          configurations:
                                              const QuillEditorConfigurations(
                                            readOnly: false,
                                          ),
                                        ),
                                      )
                                    ],
                                  )),
                            ],
                          )),
                      SizedBox(
                        height: 30.h,
                      ),
                      TextApp(
                        text: storeImage,
                        fontsize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: blueText,
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),

                            backgroundColor: Colors.white,
                            side: BorderSide(color: Colors.grey, width: 1), //
                          ),
                          onPressed: () {
                            selectImages();
                          },
                          child: Column(
                            children: [
                              Visibility(
                                  visible: widget.imageFileList!.length == 0,
                                  child: SizedBox(width: 1.sw, height: 150.h)),
                              SizedBox(
                                width: double.infinity,
                                child: GridView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: widget.imageFileList!.length,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                              width: 100.w,
                                              height: 100.w,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(15.w),
                                                child: Image.file(
                                                  File(widget
                                                      .imageFileList![index]
                                                      .path),
                                                  fit: BoxFit.cover,
                                                ),
                                              )),
                                          space10H,
                                          InkWell(
                                            onTap: () {
                                              deleteImages(
                                                  widget.imageFileList![index]);
                                            },
                                            child: TextApp(
                                              text: deleteImage,
                                              color: Colors.blue,
                                            ),
                                          )
                                        ],
                                      );
                                    }),
                              )
                            ],
                          )),
                    ],
                  ),
                )),
                space15H,
                Container(
                  width: 1.sw,
                  height: 80,
                  decoration: BoxDecoration(
                    border: const Border(
                        top: BorderSide(width: 1, color: Colors.grey),
                        bottom: BorderSide(width: 0, color: Colors.grey),
                        left: BorderSide(width: 0, color: Colors.grey),
                        right: BorderSide(width: 0, color: Colors.grey)),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15.w),
                        bottomRight: Radius.circular(15.w)),
                    // color: Colors.green,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ButtonApp(
                        event: () {
                          Navigator.of(context).pop();
                        },
                        text: "Đóng",
                        colorText: Colors.white,
                        backgroundColor: Color.fromRGBO(131, 146, 171, 1),
                        outlineColor: Color.fromRGBO(131, 146, 171, 1),
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                      ButtonApp(
                        event: () {
                          if (_formField.currentState!.validate()) {
                            widget.eventSaveButton();
                            idStoreController.clear();
                            nameStoreController.clear();
                            addressStoreController.clear();
                          }
                        },
                        text: save,
                        colorText: Colors.white,
                        backgroundColor: Color.fromRGBO(23, 193, 232, 1),
                        outlineColor: Color.fromRGBO(23, 193, 232, 1),
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void pickImage() async {
    final returndImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returndImage == null) return;
    setState(() {
      selectedImage = File(returndImage.path);
    });
  } //selecte one picture

  void takeImage() async {
    final returndImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (returndImage == null) return;
    setState(() {
      selectedImage = File(returndImage.path);
    });
  }

  void selectImages() async {
    final List<XFile> selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages.isNotEmpty) {
      widget.imageFileList!.addAll(selectedImages);
    }
    setState(() {});
  } //selecte multi image

  void deleteImages(data) {
    widget.imageFileList!.remove(data);
    setState(() {});
  }
}

//Modal tạo bàn
class CreateTableDialog extends StatefulWidget {
  final Function eventSaveButton;
  const CreateTableDialog({
    Key? key,
    required this.eventSaveButton,
  }) : super(key: key);

  @override
  State<CreateTableDialog> createState() => _CreateTableDialogState();
}

class _CreateTableDialogState extends State<CreateTableDialog> {
  bool light = false;
  File? selectedImage;
  final _formField = GlobalKey<FormState>();
  final nameTableController = TextEditingController();
  final chairsOfTableController = TextEditingController();
  final ImagePicker imagePicker = ImagePicker();
  QuillController _controllerQuill = QuillController.basic();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controllerQuill;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: double.maxFinite,
        child: ListView(
          shrinkWrap: true,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    width: 1.sw,
                    height: 50,
                    decoration: BoxDecoration(
                      border: const Border(
                          top: BorderSide(width: 0, color: Colors.grey),
                          bottom: BorderSide(width: 1, color: Colors.grey),
                          left: BorderSide(width: 0, color: Colors.grey),
                          right: BorderSide(width: 0, color: Colors.grey)),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15.w),
                          topRight: Radius.circular(15.w)),
                      // color: Colors.amber,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            TextApp(
                              text: "Bàn",
                              fontsize: 18.sp,
                              color: blueText,
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                      ],
                    )),
                space15H,
                SingleChildScrollView(
                    child: Form(
                  key: _formField,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ////////
                      SizedBox(
                        height: 30.h,
                      ),
                      //////
                      TextApp(
                        text: "Tên bàn",
                        fontsize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: blueText,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      TextFormField(
                        controller: nameTableController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return canNotNull;
                          } else {
                            return null;
                          }
                        },
                        cursorColor: const Color.fromRGBO(73, 80, 87, 1),
                        decoration: InputDecoration(
                            fillColor: const Color.fromARGB(255, 226, 104, 159),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color.fromRGBO(214, 51, 123, 0.6),
                                  width: 2.0),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            // hintText: storeName,
                            isDense: true,
                            contentPadding:
                                EdgeInsets.all(1.sw > 600 ? 20.w : 15.w)),
                      ),
                      /////
                      SizedBox(
                        height: 30.h,
                      ),
                      ////
                      TextApp(
                        text: "Số ghế trong bàn",
                        fontsize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: blueText,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      TextFormField(
                        controller: chairsOfTableController,
                        cursorColor: const Color.fromRGBO(73, 80, 87, 1),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return canNotNull;
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                            fillColor: const Color.fromARGB(255, 226, 104, 159),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color.fromRGBO(214, 51, 123, 0.6),
                                  width: 2.0),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            // hintText: storeAddress,
                            isDense: true,
                            contentPadding:
                                EdgeInsets.all(1.sw > 600 ? 20.w : 15.w)),
                      ),

                      SizedBox(
                        height: 20.h,
                      ),
                      TextApp(
                        text: "Mô tả",
                        fontsize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: blueText,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Container(
                          width: 1.sw,
                          // height: 250.h,

                          decoration: BoxDecoration(
                            border: const Border(
                                top: BorderSide(width: 1, color: Colors.grey),
                                bottom:
                                    BorderSide(width: 1, color: Colors.grey),
                                left: BorderSide(width: 1, color: Colors.grey),
                                right:
                                    BorderSide(width: 1, color: Colors.grey)),
                            borderRadius: BorderRadius.circular(15.w),
                            // color: Colors.amber,
                          ),
                          child: Column(
                            children: [
                              QuillProvider(
                                  configurations: QuillConfigurations(
                                      controller: _controllerQuill),
                                  child: Column(
                                    children: [
                                      Container(
                                          width: 1.sw,
                                          decoration: const BoxDecoration(
                                            border: Border(
                                                top: BorderSide(
                                                    width: 0,
                                                    color: Colors.grey),
                                                bottom: BorderSide(
                                                    width: 1,
                                                    color: Colors.grey),
                                                left: BorderSide(
                                                    width: 0,
                                                    color: Colors.grey),
                                                right: BorderSide(
                                                    width: 0,
                                                    color: Colors.grey)),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(10.w),
                                            child: const QuillToolbar(
                                              configurations:
                                                  QuillToolbarConfigurations(
                                                      toolbarIconAlignment:
                                                          WrapAlignment.center,
                                                      showFontFamily: true,
                                                      showFontSize: false,
                                                      showBoldButton: true,
                                                      showItalicButton: true,
                                                      showSmallButton: false,
                                                      showUnderLineButton: true,
                                                      showStrikeThrough: false,
                                                      showInlineCode: false,
                                                      showColorButton: false,
                                                      showBackgroundColorButton:
                                                          false,
                                                      showClearFormat: false,
                                                      showAlignmentButtons:
                                                          true,
                                                      showLeftAlignment: true,
                                                      showCenterAlignment: true,
                                                      showRightAlignment: true,
                                                      showJustifyAlignment:
                                                          true,
                                                      showHeaderStyle: false,
                                                      showListNumbers: true,
                                                      showListBullets: true,
                                                      showListCheck: false,
                                                      showCodeBlock: false,
                                                      showQuote: false,
                                                      showIndent: false,
                                                      showLink: true,
                                                      showUndo: false,
                                                      showRedo: false,
                                                      showDirection: false,
                                                      showSearchButton: false,
                                                      showSubscript: false,
                                                      showSuperscript: false),
                                            ),
                                          )),
                                      // space20H,
                                      Container(
                                        margin: EdgeInsets.all(5.w),
                                        height: 100.h,
                                        child: QuillEditor.basic(
                                          configurations:
                                              const QuillEditorConfigurations(
                                            readOnly: false,
                                          ),
                                        ),
                                      )
                                    ],
                                  )),
                            ],
                          )),

                      SizedBox(
                        height: 30.h,
                      ),
                      ////
                      TextApp(
                        text: displayMode,
                        fontsize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: blueText,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      TextApp(
                        text: allowOpenTable,
                        fontsize: 12.sp,
                        fontWeight: FontWeight.normal,
                        color: blueText,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      SizedBox(
                        width: 50.w,
                        height: 30.w,
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: CupertinoSwitch(
                            value: light,
                            activeColor: const Color.fromRGBO(58, 65, 111, .95),
                            onChanged: (bool value) {
                              setState(() {
                                light = value;
                              });
                            },
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 30.h,
                      ),
                    ],
                  ),
                )),
                space15H,
                Container(
                  width: 1.sw,
                  height: 80,
                  decoration: BoxDecoration(
                    border: const Border(
                        top: BorderSide(width: 1, color: Colors.grey),
                        bottom: BorderSide(width: 0, color: Colors.grey),
                        left: BorderSide(width: 0, color: Colors.grey),
                        right: BorderSide(width: 0, color: Colors.grey)),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15.w),
                        bottomRight: Radius.circular(15.w)),
                    // color: Colors.green,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ButtonApp(
                        event: () {
                          Navigator.of(context).pop();
                        },
                        text: "Đóng",
                        colorText: Colors.white,
                        backgroundColor: Color.fromRGBO(131, 146, 171, 1),
                        outlineColor: Color.fromRGBO(131, 146, 171, 1),
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                      ButtonApp(
                        event: () {
                          if (_formField.currentState!.validate()) {
                            widget.eventSaveButton();
                            nameTableController.clear();
                            chairsOfTableController.clear();
                          }
                        },
                        text: save,
                        colorText: Colors.white,
                        backgroundColor: Color.fromRGBO(23, 193, 232, 1),
                        outlineColor: Color.fromRGBO(23, 193, 232, 1),
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CreateItemDialog extends StatefulWidget {
  final Function eventSaveButton;
  const CreateItemDialog({
    Key? key,
    required this.eventSaveButton,
  }) : super(key: key);

  @override
  State<CreateItemDialog> createState() => _CreateItemDialogState();
}

class _CreateItemDialogState extends State<CreateItemDialog>
    with TickerProviderStateMixin {
  File? selectedImage;
  final _formField = GlobalKey<FormState>();
  final _formField2 = GlobalKey<FormState>();
  final nameItemController = TextEditingController();
  final initalQuantityController = TextEditingController();
  final minQuantityController = TextEditingController();
  final ImagePicker imagePicker = ImagePicker();
  QuillController _controllerQuill = QuillController.basic();
  bool isHaveddddd = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controllerQuill;
  }

  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(
      length: 2,
      vsync: this,
    );
    return AlertDialog(
      content: SizedBox(
        width: double.maxFinite,
        child: ListView(
          shrinkWrap: true,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    width: 1.sw,
                    height: 50,
                    decoration: BoxDecoration(
                      border: const Border(
                          top: BorderSide(width: 0, color: Colors.grey),
                          bottom: BorderSide(width: 1, color: Colors.grey),
                          left: BorderSide(width: 0, color: Colors.grey),
                          right: BorderSide(width: 0, color: Colors.grey)),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15.w),
                          topRight: Radius.circular(15.w)),
                      // color: Colors.amber,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            TextApp(
                              text: "Quản lý mặt hàng",
                              fontsize: 18.sp,
                              color: blueText,
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                      ],
                    )),
                space15H,
                TabBar(
                    labelPadding: const EdgeInsets.only(left: 20, right: 20),
                    labelColor: Colors.blue,
                    unselectedLabelColor: Colors.black.withOpacity(0.5),
                    labelStyle: const TextStyle(color: Colors.red),
                    controller: _tabController,
                    isScrollable: true,
                    indicatorSize: TabBarIndicatorSize.label,
                    tabs: [
                      Tab(text: "Thông tin chung"),
                      Tab(
                        text: "Quy đổi đơn vị",
                      ),
                    ]),
                Container(
                  width: 1.sw,
                  height: 400.h,
                  child: TabBarView(controller: _tabController, children: [
                    ListView(
                      shrinkWrap: true,
                      children: [
                        Form(
                          key: _formField,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ////////
                              SizedBox(
                                height: 30.h,
                              ),
                              //////
                              TextApp(
                                text: "Tên mặt hàng",
                                fontsize: 12.sp,
                                fontWeight: FontWeight.bold,
                                color: blueText,
                              ),
                              SizedBox(
                                height: 10.h,
                              ),

                              TextFormField(
                                controller: nameItemController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return canNotNull;
                                  } else {
                                    return null;
                                  }
                                },
                                cursorColor:
                                    const Color.fromRGBO(73, 80, 87, 1),
                                decoration: InputDecoration(
                                    fillColor: const Color.fromARGB(
                                        255, 226, 104, 159),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color:
                                              Color.fromRGBO(214, 51, 123, 0.6),
                                          width: 2.0),
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    // hintText: storeName,
                                    isDense: true,
                                    contentPadding: EdgeInsets.all(
                                        1.sw > 600 ? 20.w : 15.w)),
                              ),
                              /////
                              SizedBox(
                                height: 20.h,
                              ),
                              TextApp(
                                text: "Đơn vị",
                                fontsize: 12.sp,
                                fontWeight: FontWeight.bold,
                                color: blueText,
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              DropdownSearch(
                                validator: (value) {
                                  if (value == "Nhập đơn vị") {
                                    // setState(() {
                                    //   isHaveddddd = false;
                                    // });
                                    return canNotNull;
                                  } else {
                                    return null;
                                  }
                                },
                                items: listMeasure,
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                    fillColor: const Color.fromARGB(
                                        255, 226, 104, 159),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color:
                                              Color.fromRGBO(214, 51, 123, 0.6),
                                          width: 2.0),
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    isDense: true,
                                    contentPadding: EdgeInsets.all(15.w),
                                    hintText: "Nhập đơn vị",
                                  ),
                                ),
                                onChanged: print,
                                selectedItem: "Nhập đơn vị",
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              ////
                              TextApp(
                                text: "Số lượng ban đầu",
                                fontsize: 12.sp,
                                fontWeight: FontWeight.bold,
                                color: blueText,
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              TextFormField(
                                controller: initalQuantityController,
                                cursorColor:
                                    const Color.fromRGBO(73, 80, 87, 1),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return canNotNull;
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                    fillColor: const Color.fromARGB(
                                        255, 226, 104, 159),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color:
                                              Color.fromRGBO(214, 51, 123, 0.6),
                                          width: 2.0),
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    // hintText: storeAddress,
                                    isDense: true,
                                    contentPadding: EdgeInsets.all(
                                        1.sw > 600 ? 20.w : 15.w)),
                              ),

                              SizedBox(
                                height: 30.h,
                              ),
                              ////
                              TextApp(
                                text: "Số lượng tối thiểu",
                                fontsize: 12.sp,
                                fontWeight: FontWeight.bold,
                                color: blueText,
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              TextFormField(
                                controller: minQuantityController,
                                cursorColor:
                                    const Color.fromRGBO(73, 80, 87, 1),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return canNotNull;
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                    fillColor: const Color.fromARGB(
                                        255, 226, 104, 159),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color:
                                              Color.fromRGBO(214, 51, 123, 0.6),
                                          width: 2.0),
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    // hintText: storeAddress,
                                    isDense: true,
                                    contentPadding: EdgeInsets.all(
                                        1.sw > 600 ? 20.w : 15.w)),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),

                              SizedBox(
                                height: 30.h,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // Tab2

                    ListView(
                      shrinkWrap: true,
                      children: [
                        Form(
                          key: _formField2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ////////
                              SizedBox(
                                height: 30.h,
                              ),
                              //////
                              isHaveddddd
                                  ? TextApp(
                                      text:
                                          "* Lưu ý: Chỉ số nhập vào bé nhất là 1 và đơn vị quy đổi không được trùng lặp",
                                      fontsize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    )
                                  : Container(
                                      width: 1.sw,
                                      height: 50.h,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.w),
                                          color: Colors.red),
                                      child: Center(
                                        child: TextApp(
                                          text: "Chưa chọn đơn vị quy đổi",
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontsize: 14.sp,
                                        ),
                                      ),
                                    ),

                              SizedBox(
                                width: 20.w,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ]),
                ),
                space15H,
                Container(
                  width: 1.sw,
                  height: 80,
                  decoration: BoxDecoration(
                    border: const Border(
                        top: BorderSide(width: 1, color: Colors.grey),
                        bottom: BorderSide(width: 0, color: Colors.grey),
                        left: BorderSide(width: 0, color: Colors.grey),
                        right: BorderSide(width: 0, color: Colors.grey)),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15.w),
                        bottomRight: Radius.circular(15.w)),
                    // color: Colors.green,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ButtonApp(
                        event: () {
                          Navigator.of(context).pop();
                        },
                        text: "Đóng",
                        colorText: Colors.white,
                        backgroundColor: Color.fromRGBO(131, 146, 171, 1),
                        outlineColor: Color.fromRGBO(131, 146, 171, 1),
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                      ButtonApp(
                        event: () {
                          if (_formField.currentState!.validate() &&
                              _formField2.currentState!.validate()) {
                            widget.eventSaveButton();
                            nameItemController.clear();
                            initalQuantityController.clear();
                            minQuantityController.clear();
                          }
                        },
                        text: "Lưu mặt hàng",
                        colorText: Colors.white,
                        backgroundColor: Color.fromRGBO(23, 193, 232, 1),
                        outlineColor: Color.fromRGBO(23, 193, 232, 1),
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


                        // Navigator.of(context).pop();
