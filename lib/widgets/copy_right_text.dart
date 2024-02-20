import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CopyRightText extends StatelessWidget {
  const CopyRightText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Center(
          child: Text(
            "© 2024, một trong số các dự án được thực hiện của công ty",
            textAlign: TextAlign.center,
          ),
        ),
        InkWell(
          onTap: _launchURL,
          child: Text(
            "Thương Hiệu Việt",
            style: TextStyle(fontWeight: FontWeight.bold),
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
