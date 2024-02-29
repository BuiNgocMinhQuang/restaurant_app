import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/widgets/button/button_app.dart';
import 'package:app_restaurant/widgets/custom_tab.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

List<String> listtable = ["bàn 1", "bàn 2", "bàn 3"];

class BookingTableModal extends StatefulWidget {
  Function eventCloseButton;
  Function eventSaveButton;
  bool isUsingTable;
  BookingTableModal({
    Key? key,
    required this.eventCloseButton,
    required this.eventSaveButton,
    this.isUsingTable = false,
  }) : super(key: key);

  @override
  State<BookingTableModal> createState() => _BookingTableModalState();
}

class _BookingTableModalState extends State<BookingTableModal>
    with TickerProviderStateMixin {
  final _popupCustomValidationKey = GlobalKey<DropdownSearchState<int>>();
  TextEditingController _dateStartController = TextEditingController();

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
    final hours = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return Container(
        width: 1.sw,
        height: 1.sh,
        color: Colors.black.withOpacity(0.3),
        child: Center(
            child: Padding(
          padding: EdgeInsets.only(
              top: 100.h, bottom: 100.h, left: 35.w, right: 35.w),
          child: Container(
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
                              labelStyle: TextStyle(color: Colors.red),
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
                        Container(
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

                                  Container(
                                    height: 50,
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: DropdownSearch.multiSelection(
                                            key: _popupCustomValidationKey,
                                            items: listtable,
                                            popupProps: PopupPropsMultiSelection.dialog(
                                                // validationWidgetBuilder:
                                                //     (context, item) {
                                                //   return Container(
                                                //     color: Colors.blue[200],
                                                //     height: 50.h,
                                                //     child: Align(
                                                //       alignment:
                                                //           Alignment.center,
                                                //       child: MaterialButton(
                                                //         child: Text('ĐÓNG'),
                                                //         onPressed: () {
                                                //           print("odakd");
                                                //           _popupCustomValidationKey
                                                //               .currentState
                                                //               ?.popupOnValidate();
                                                //         },
                                                //       ),
                                                //     ),
                                                //   );
                                                // },
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
                            widget.eventCloseButton();
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
                          text: "Lưu",
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
        )));
  }
}
