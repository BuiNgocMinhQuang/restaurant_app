import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:app_restaurant/config/void_show_dialog.dart';

class CopyRightText extends StatelessWidget {
  const CopyRightText({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: TextApp(
            isOverFlow: false,
            softWrap: true,
            text: "© 2024, một trong số các dự án được thực hiện của cty",
            textAlign: TextAlign.center,
            fontsize: 14.sp,
            color: Colors.grey,
          ),
        ),
        InkWell(
          onTap: launchURL,
          child: TextApp(
            text: "Thương Hiệu Việt",
            fontWeight: FontWeight.bold,
            fontsize: 14.sp,
            color: Colors.black,
          ),
        )
      ],
    );
  }
}
