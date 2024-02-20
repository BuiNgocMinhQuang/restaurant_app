import 'package:flutter/material.dart';

class BackgroundWelcome extends StatelessWidget {
  const BackgroundWelcome({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          "Chào mừng!",
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Icomoon",
            fontWeight: FontWeight.bold,
            fontSize: 26,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 15, left: 15, right: 15),
          child: Center(
            child: Text(
              textAlign: TextAlign.center,
              "Sử dụng các biểu mẫu tuyệt vời này để đăng nhập hoặc tạo tài khoản mới trong cửa hàng của bạn.",
              style: TextStyle(
                color: Colors.white,
                fontFamily: "Icomoon",
                fontWeight: FontWeight.normal,
                fontSize: 16,
              ),
            ),
          ),
        )
      ],
    );
  }
}
