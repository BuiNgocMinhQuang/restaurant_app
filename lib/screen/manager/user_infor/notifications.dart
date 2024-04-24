import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/config/space.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class ManagerNotifications extends StatefulWidget {
  const ManagerNotifications({super.key});

  @override
  State<ManagerNotifications> createState() => _ManagerNotificationsState();
}

class _ManagerNotificationsState extends State<ManagerNotifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thông báo"),
      ),
      body: Container(
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 300,
              height: 300,
              // color: Colors.amber,
              child: Lottie.asset('assets/lottie/no_mess.json'),
            ),
            space15H,
            TextApp(
              text: "Chưa có thông báo nào !",
              fontsize: 16.sp,
              fontWeight: FontWeight.bold,
              color: blueText,
            ),
          ],
        )),
      ),
    );
  }
}
