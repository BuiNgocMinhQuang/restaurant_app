import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/config/space.dart';
import 'package:app_restaurant/widgets/text/copy_right_text.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

List<String> listState = ["Tất cả", "Đang hoạt động", "Đã chặn"];

class ListStaff extends StatefulWidget {
  const ListStaff({super.key});

  @override
  State<ListStaff> createState() => _ListStaffState();
}

class _ListStaffState extends State<ListStaff> {
  TextEditingController _dateStartController = TextEditingController();
  TextEditingController _dateEndController = TextEditingController();
  void selectDayStart() async {
    DateTime? picked = await showDatePicker(
        locale: Locale("vi"),
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

  void selectDayEnd() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2025));
    if (picked != null) {
      setState(() {
        _dateEndController.text = picked.toString().split(" ")[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Container(
            width: 1.sw,
            // height: 1.sh,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Column(
              children: [
                Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.r),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                fit: FlexFit.tight,
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextApp(
                                      text: " Từ ngày",
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
                                      onTap: selectDayStart,
                                      style: TextStyle(
                                          fontSize: 14.sp, color: grey),
                                      cursorColor: grey,
                                      decoration: InputDecoration(
                                          suffixIcon:
                                              Icon(Icons.calendar_month),
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
                                          hintText: 'dd/mm/yy',
                                          isDense: true,
                                          contentPadding: EdgeInsets.all(15.w)),
                                    ),
                                  ],
                                ),
                              ),
                              space20W,
                              Flexible(
                                fit: FlexFit.tight,
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextApp(
                                      text: " Đến ngày",
                                      fontsize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                      color: blueText,
                                    ),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    TextField(
                                      readOnly: true,
                                      controller: _dateEndController,
                                      onTap: selectDayEnd,
                                      style: TextStyle(
                                          fontSize: 14.sp, color: grey),
                                      cursorColor: grey,
                                      decoration: InputDecoration(
                                          suffixIcon:
                                              Icon(Icons.calendar_month),
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
                                          hintText: 'dd/mm/yy',
                                          isDense: true,
                                          contentPadding: EdgeInsets.all(15.w)),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          space20H,
                          Row(
                            children: [
                              Flexible(
                                fit: FlexFit.tight,
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextApp(
                                      text: " Trạng thái",
                                      fontsize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                      color: blueText,
                                    ),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    DropdownSearch(
                                      // popupProps: PopupProps.menu(
                                      //   showSelectedItems: true,
                                      //   disabledItemFn: (String s) => s.startsWith(''),
                                      // ),
                                      items: listState,

                                      dropdownDecoratorProps:
                                          DropDownDecoratorProps(
                                        dropdownSearchDecoration:
                                            InputDecoration(
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
                                          contentPadding: EdgeInsets.all(15.w),
                                          hintText: "Tất cả",
                                        ),
                                      ),
                                      onChanged: print,
                                      selectedItem: "Tất cả",
                                    ),
                                  ],
                                ),
                              ),
                              space20W,
                              Flexible(
                                fit: FlexFit.tight,
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextApp(
                                      text: " Tìm kiếm",
                                      fontsize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                      color: blueText,
                                    ),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    TextField(
                                      style: TextStyle(
                                          fontSize: 14.sp, color: grey),
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
                                          // hintText: 'Instagram',
                                          isDense: true,
                                          contentPadding: EdgeInsets.all(15.w)),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          space20H,
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextApp(
                                        text: "Tên nhân viên".toUpperCase()),
                                    SizedBox(
                                      height: 300.h,
                                      child: ListView.builder(
                                        physics: ClampingScrollPhysics(),
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: 1,
                                        itemBuilder:
                                            (BuildContext context, int index) =>
                                                Card(
                                          child: Center(
                                              child: Text('Dummy Card Text')),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextApp(text: "Chức vụ".toUpperCase()),
                                    SizedBox(
                                      height: 300.h,
                                      child: ListView.builder(
                                        physics: ClampingScrollPhysics(),
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: 1,
                                        itemBuilder:
                                            (BuildContext context, int index) =>
                                                Card(
                                          child: Center(
                                              child: Text('Dummy Card Text')),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextApp(
                                        text: "Làm việc tại cửa hàng"
                                            .toUpperCase()),
                                    SizedBox(
                                      height: 300.h,
                                      child: ListView.builder(
                                        physics: ClampingScrollPhysics(),
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: 1,
                                        itemBuilder:
                                            (BuildContext context, int index) =>
                                                Card(
                                          child: Center(
                                              child: Text('Dummy Card Text')),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextApp(text: "Trạng thái".toUpperCase()),
                                    SizedBox(
                                      height: 300.h,
                                      child: ListView.builder(
                                        physics: ClampingScrollPhysics(),
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: 1,
                                        itemBuilder:
                                            (BuildContext context, int index) =>
                                                Card(
                                          child: Center(
                                              child: Text('Dummy Card Text')),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextApp(text: "Email".toUpperCase()),
                                    SizedBox(
                                      height: 300.h,
                                      child: ListView.builder(
                                        physics: ClampingScrollPhysics(),
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: 1,
                                        itemBuilder:
                                            (BuildContext context, int index) =>
                                                Card(
                                          child: Center(
                                              child: Text(
                                                  'Dummy Card Tex cai text nay dai vai lozzzt')),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextApp(text: "Ngày tạo".toUpperCase()),
                                    SizedBox(
                                      height: 300.h,
                                      child: ListView.builder(
                                        physics: ClampingScrollPhysics(),
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: 1,
                                        itemBuilder:
                                            (BuildContext context, int index) =>
                                                Card(
                                          child: Center(
                                              child: Text('Dummy Card Text')),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )),
                space30H,
                CopyRightText()
              ],
            ),
          ),
        ),
      )),
    );
  }
}
