import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BackgroundWelcome extends StatelessWidget {
  const BackgroundWelcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Chào mừng!",
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Icomoon",
            fontWeight: FontWeight.bold,
            fontSize: 24.sp,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 15.w, left: 15.w, right: 15.w),
          child: Center(
            child: TextApp(
              isOverFlow: false,
              softWrap: true,
              textAlign: TextAlign.center,
              text:
                  "Sử dụng các biểu mẫu tuyệt vời này để đăng nhập hoặc tạo tài khoản mới trong cửa hàng của bạn.",
              color: Colors.white,
              fontFamily: "Icomoon",
              fontWeight: FontWeight.normal,
              fontsize: 14.sp,
            ),
          ),
        )
      ],
    );
  }
}
