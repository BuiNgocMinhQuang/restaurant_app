import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/widgets/text_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TestFlexible extends StatelessWidget {
  const TestFlexible({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
                flex: 1,
                child: Column(
                  children: [
                    Container(
                      width: 1.sw,
                      height: 300.h,
                      color: Colors.green,
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.all(20.w),
                            child: Container(
                              width: 100.w,
                              height: 30.h,
                              color: Colors.amber,
                            ),
                          );
                        })
                    // Flexible(
                    //     child: Column(
                    //   children: [
                    //     TextApp(
                    //       text: " Từ ngày",
                    //       fontsize: 12.sp,
                    //       fontWeight: FontWeight.bold,
                    //       color: blueText,
                    //     ),
                    //     ListView.builder(
                    //         shrinkWrap: true,
                    //         itemCount: 10,
                    //         itemBuilder: (context, index) {
                    //           return Padding(
                    //             padding: EdgeInsets.all(20.w),
                    //             child: Container(
                    //               width: 100.w,
                    //               height: 30.h,
                    //               color: Colors.amber,
                    //             ),
                    //           );
                    //         })
                    //   ],
                    // ))
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
