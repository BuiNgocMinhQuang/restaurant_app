import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class CopyRightText extends StatelessWidget {
  const CopyRightText({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: TextApp(
            text: "© 2024, một trong số các dự án được thực hiện của công ty",
            textAlign: TextAlign.center,
            fontsize: 12.sp,
            color: Colors.grey,
          ),
        ),
        InkWell(
          onTap: _launchURL,
          child: TextApp(
            text: "Thương Hiệu Việt",
            fontWeight: FontWeight.bold,
            fontsize: 12.sp,
            color: Colors.black,
          ),
        )
      ],
    );
  }
}

_launchURL() async {
  final Uri url = Uri.parse('https://thuonghieuvietsol.com/');
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}
