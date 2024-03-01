import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/config/fake_data.dart';
import 'package:app_restaurant/config/space.dart';
import 'package:app_restaurant/widgets/button/button_gradient.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AboutStaffModal extends StatefulWidget {
  // Function eventCloseButton;
  AboutStaffModal({
    Key? key,
    // required this.eventCloseButton,
  }) : super(key: key);

  @override
  State<AboutStaffModal> createState() => _AboutStaffModalState();
}

class _AboutStaffModalState extends State<AboutStaffModal> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextApp(
                      text: "Về nhân viên",
                      color: const Color.fromRGBO(52, 71, 103, 1),
                      fontFamily: "OpenSans",
                      fontWeight: FontWeight.bold,
                      fontsize: 20.sp,
                    ),
                    space10H,
                    TextApp(
                      text: "Thông tin bắt buộc",
                      color: Colors.grey,
                      fontFamily: "OpenSans",
                      fontWeight: FontWeight.normal,
                      fontsize: 14.sp,
                    ),
                    space20H,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextApp(
                          text: " Thuộc cửa hàng",
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
                          items: listStore,
                          dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
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
                              isDense: true,
                              contentPadding: EdgeInsets.all(15.w),
                              hintText: "Chọn cửa hàng",
                            ),
                          ),
                          onChanged: print,
                          selectedItem: "Chọn cửa hàng",
                        ),
                      ],
                    ),
                    space20H,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextApp(
                          text: " Chức vụ",
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
                          items: listRole,
                          dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
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
                              isDense: true,
                              contentPadding: EdgeInsets.all(15.w),
                              hintText: "Chọn chức vụ",
                            ),
                          ),
                          onChanged: print,
                          selectedItem: "Chọn chức vụ",
                        ),
                      ],
                    ),
                    space20H,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextApp(
                          text: " Tên đầy đủ",
                          fontsize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: blueText,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        TextField(
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
                              hintText: 'Tên đầy đủ',
                              isDense: true,
                              contentPadding: EdgeInsets.all(15.w)),
                        ),
                      ],
                    ),
                    space20H,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextApp(
                          text: " Họ",
                          fontsize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: blueText,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        TextField(
                          style: TextStyle(fontSize: 14.sp, color: grey),
                          cursorColor: grey,
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
                            hintText: 'Họ',
                            isDense: true,
                            contentPadding: EdgeInsets.all(15.w),
                          ),
                        ),
                      ],
                    ),
                    space20H,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextApp(
                          text: " Tên",
                          fontsize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: blueText,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        TextField(
                          style: TextStyle(fontSize: 14.sp, color: grey),
                          cursorColor: grey,
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
                            hintText: 'Tên',
                            isDense: true,
                            contentPadding: EdgeInsets.all(15.w),
                          ),
                        ),
                      ],
                    ),
                    space20H,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                          style: TextStyle(fontSize: 14.sp, color: grey),
                          cursorColor: grey,
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
                            hintText: 'Số điện thoại',
                            isDense: true,
                            contentPadding: EdgeInsets.all(15.w),
                          ),
                        ),
                      ],
                    ),
                    space20H,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextApp(
                          text: " Email",
                          fontsize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: blueText,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        TextField(
                          style: TextStyle(fontSize: 14.sp, color: grey),
                          cursorColor: grey,
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
                            hintText: 'Email',
                            isDense: true,
                            contentPadding: EdgeInsets.all(15.w),
                          ),
                        ),
                      ],
                    ),
                    space20H,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextApp(
                          text: " Mật khẩu",
                          fontsize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: blueText,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        TextField(
                          style: TextStyle(fontSize: 14.sp, color: grey),
                          cursorColor: grey,
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
                            hintText: 'Mật khẩu',
                            isDense: true,
                            contentPadding: EdgeInsets.all(15.w),
                          ),
                        ),
                      ],
                    ),
                    space20H,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextApp(
                          text: " Nhập lại mật khẩu",
                          fontsize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: blueText,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        TextField(
                          style: TextStyle(fontSize: 14.sp, color: grey),
                          cursorColor: grey,
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
                            hintText: 'Nhập lại mật khẩu',
                            isDense: true,
                            contentPadding: EdgeInsets.all(15.w),
                          ),
                        ),
                      ],
                    ),
                    space20H,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 100.w,
                          child: ButtonGradient(
                            color1: color1DarkButton,
                            color2: color2DarkButton,
                            event: () {},
                            text: "Tiếp",
                            fontSize: 12.sp,
                            radius: 8.r,
                            textColor: Colors.white,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
