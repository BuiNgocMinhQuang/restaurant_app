import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatusBoxIsActive extends StatelessWidget {
  const StatusBoxIsActive({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.w),
          color: Color.fromRGBO(205, 245, 155, 1),
        ),
        child: Padding(
          padding: EdgeInsets.all(5.w),
          child: TextApp(
            text: "Đang hoạt động".toUpperCase(),
            fontsize: 8.sp,
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(103, 177, 8, 1),
          ),
        ));
  }
}

class StatusBoxIsSelling extends StatelessWidget {
  const StatusBoxIsSelling({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.w),
          color: Color.fromRGBO(205, 245, 155, 1),
        ),
        child: Padding(
          padding: EdgeInsets.all(5.w),
          child: TextApp(
            text: "Đang bán".toUpperCase(),
            fontsize: 8.sp,
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(103, 177, 8, 1),
          ),
        ));
  }
}

class StatusBoxIsLock extends StatelessWidget {
  const StatusBoxIsLock({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.w),
          color: Color.fromRGBO(228, 232, 237, 1),
        ),
        child: Padding(
          padding: EdgeInsets.all(5.w),
          child: TextApp(
            text: "Đang bị khoá".toUpperCase(),
            fontsize: 8.sp,
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(89, 116, 162, 1),
          ),
        ));
  }
}

class StatusBoxStocking extends StatelessWidget {
  const StatusBoxStocking({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.w),
          color: Color.fromARGB(255, 144, 238, 30),
        ),
        child: Padding(
          padding: EdgeInsets.all(5.w),
          child: TextApp(
            text: "Còn hàng".toUpperCase(),
            fontsize: 8.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ));
  }
}

class StatusBoxOutOfStock extends StatelessWidget {
  const StatusBoxOutOfStock({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.w),
          color: Color.fromARGB(255, 238, 41, 15),
        ),
        child: Padding(
          padding: EdgeInsets.all(5.w),
          child: TextApp(
            text: "Hết hàng".toUpperCase(),
            fontsize: 8.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ));
  }
}
