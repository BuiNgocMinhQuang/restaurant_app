import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/config/space.dart';
import 'package:app_restaurant/widgets/button/button_app.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OverviewChartDialog extends StatefulWidget {
  final String shopID;

  OverviewChartDialog({
    Key? key,
    required this.shopID,
  }) : super(key: key);
  @override
  State<OverviewChartDialog> createState() => _OverviewChartDialogState();
}

class _OverviewChartDialogState extends State<OverviewChartDialog> {
  TextEditingController _dateStartController = TextEditingController();
  TextEditingController _dateEndController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  void selectDayStart() async {
    DateTime? picked = await showDatePicker(
        helpText: 'Chọn ngày bắt đầu',
        cancelText: 'Huỷ',
        confirmText: 'Xác nhận',
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2025),
        builder: (context, child) => Theme(
              data: ThemeData().copyWith(
                  colorScheme: const ColorScheme.dark(
                      primary: Colors.black,
                      onPrimary: Colors.white,
                      onSurface: Colors.black,
                      surface: Colors.white),
                  dialogBackgroundColor: Colors.green),
              child: child ?? Container(),
            ));

    if (picked != null) {
      setState(() {
        _dateStartController.text = picked.toString().split(" ")[0];
      });
    }
  }

  void selectDayEnd() async {
    DateTime? picked = await showDatePicker(
        helpText: 'Chọn ngày kết thúc',
        cancelText: 'Huỷ',
        confirmText: 'Xác nhận',
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2025),
        builder: (context, child) => Theme(
              data: ThemeData().copyWith(
                  colorScheme: const ColorScheme.dark(
                      primary: Colors.black,
                      onPrimary: Colors.white,
                      onSurface: Colors.black,
                      surface: Colors.white),
                  dialogBackgroundColor: Colors.green),
              child: child ?? Container(),
            ));
    if (picked != null) {
      setState(() {
        _dateEndController.text = picked.toString().split(" ")[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(0),
      surfaceTintColor: Colors.white,
      backgroundColor: Colors.white,
      content: Padding(
        padding: EdgeInsets.only(left: 10.w, right: 10.w),
        child: Container(
            width: 1.sw,
            // height: 1.sh,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              color: Colors.white,
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.w),
                  child: Container(
                      width: 1.sw,
                      height: 50,
                      decoration: BoxDecoration(
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
                                padding: EdgeInsets.only(left: 10.w),
                                child: TextApp(
                                  text: "Biểu đồ tổng quan",
                                  fontsize: 18.sp,
                                  color: blueText,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                          // Row(
                          //   children: [
                          //     Padding(
                          //       padding: EdgeInsets.only(left: 20.w),
                          //       child: TextApp(
                          //         text: "widget.nameRoom",
                          //         fontsize: 14.sp,
                          //         color: blueText,
                          //         fontWeight: FontWeight.normal,
                          //       ),
                          //     )
                          //   ],
                          // )
                        ],
                      )),
                ),
                const Divider(
                  height: 1,
                  color: Colors.black,
                ),
                space15H,
                Row(
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextApp(
                            text: " Biểu đồ theo",
                            fontsize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: blueText,
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          // DropdownSearch(
                          //   items: listState,
                          //   onChanged: (changeFlag) {
                          //     // getListArea(
                          //     //     city: listState.indexOf(changeCity),
                          //     //     district: null);
                          //     setState(() {
                          //       selectedFlitterFlag = changeFlag;
                          //       currentPage = 1;
                          //     });
                          //     var hehe = listState.indexOf(
                          //                 changeFlag ?? '') ==
                          //             0
                          //         ? null
                          //         : listState.indexOf(
                          //                     changeFlag ?? '') ==
                          //                 2
                          //             ? 0
                          //             : listState.indexOf(
                          //                 changeFlag ?? '');
                          //     log(hehe.toString());
                          //     currentFoodList.clear();

                          //     loadMoreMenuFood(
                          //       page: currentPage,
                          //       keywords: query,
                          //       // filtersFlg: hehe,
                          //       activeFlg: hehe,
                          //     );
                          //   },
                          //   dropdownDecoratorProps:
                          //       DropDownDecoratorProps(
                          //     dropdownSearchDecoration:
                          //         InputDecoration(
                          //       fillColor: const Color.fromARGB(
                          //           255, 226, 104, 159),
                          //       focusedBorder: OutlineInputBorder(
                          //         borderSide: const BorderSide(
                          //             color: Color.fromRGBO(
                          //                 214, 51, 123, 0.6),
                          //             width: 2.0),
                          //         borderRadius:
                          //             BorderRadius.circular(8.r),
                          //       ),
                          //       border: OutlineInputBorder(
                          //         borderRadius:
                          //             BorderRadius.circular(8.r),
                          //       ),
                          //       isDense: true,
                          //       contentPadding:
                          //           EdgeInsets.all(15.w),
                          //       hintText: "Tất cả",
                          //     ),
                          //   ),
                          //   // onChanged: print,
                          //   selectedItem: selectedFlitterFlag,
                          // ),
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
                            text: " Loại",
                            fontsize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: blueText,
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          TextFormField(
                            onTapOutside: (event) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            // onChanged: searchProduct,
                            // controller: searchController,
                            style: TextStyle(fontSize: 14.sp, color: grey),
                            cursorColor: grey,
                            decoration: InputDecoration(
                                fillColor:
                                    const Color.fromARGB(255, 226, 104, 159),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color.fromRGBO(214, 51, 123, 0.6),
                                      width: 2.0),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
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
                            style: TextStyle(fontSize: 14.sp, color: grey),
                            cursorColor: grey,
                            decoration: InputDecoration(
                                suffixIcon: Icon(Icons.calendar_month),
                                fillColor:
                                    const Color.fromARGB(255, 226, 104, 159),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color.fromRGBO(214, 51, 123, 0.6),
                                      width: 2.0),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
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
                            style: TextStyle(fontSize: 14.sp, color: grey),
                            cursorColor: grey,
                            decoration: InputDecoration(
                                suffixIcon: Icon(Icons.calendar_month),
                                fillColor:
                                    const Color.fromARGB(255, 226, 104, 159),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color.fromRGBO(214, 51, 123, 0.6),
                                      width: 2.0),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
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
                Container(
                  width: 1.sw,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15.w),
                        bottomRight: Radius.circular(15.w)),
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
      ),
    );
  }
}
