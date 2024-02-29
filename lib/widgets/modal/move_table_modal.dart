import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/config/fake_data.dart';
import 'package:app_restaurant/config/text.dart';
import 'package:app_restaurant/widgets/button/button_app.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MoveTableModal extends StatefulWidget {
  Function eventCloseButton;
  MoveTableModal({
    Key? key,
    required this.eventCloseButton,
  }) : super(key: key);

  @override
  State<MoveTableModal> createState() => _MoveTableModalState();
}

class _MoveTableModalState extends State<MoveTableModal> {
  @override
  Widget build(BuildContext context) {
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
              height: 1.sh / 2,
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
                              // Flexible(
                              //     fit: FlexFit.tight,
                              //     child: Column(
                              //       children: [
                              //         GridView.builder(
                              //             physics:
                              //                 NeverScrollableScrollPhysics(),
                              //             itemCount: listTable.length,
                              //             gridDelegate:
                              //                 SliverGridDelegateWithFixedCrossAxisCount(
                              //               crossAxisCount: 2,
                              //             ),
                              //             itemBuilder: (context, index) {
                              //               return Padding(
                              //                 padding: EdgeInsets.all(10.w),
                              //                 child: ButtonApp(
                              //                   event: () {},
                              //                   text: listTable[index],
                              //                   colorText: Colors.white,
                              //                   backgroundColor: Color.fromRGBO(
                              //                       131, 146, 171, 1),
                              //                   outlineColor: Color.fromRGBO(
                              //                       131, 146, 171, 1),
                              //                 ),
                              //               );
                              //             }),
                              //       ],
                              //     ))
                            ],
                          ),
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
                            // widget.eventSaveButton();
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
