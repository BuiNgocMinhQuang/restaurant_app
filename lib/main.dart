import 'package:app_restaurant/provider/drawer_provider.dart';
import 'package:app_restaurant/routers/app_router_config.dart';
import 'package:app_restaurant/screen/manager/signin_copy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // bool isLogin = true;
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      builder: (BuildContext context, Widget? child) {
        print("Build lai Screen");
        return child!;
      },
      child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: NyAppRouter().customRouter),
    );
  }
}


//          _ . - / ` )
//         //    /   / )
//    . = //    /   / / )
//   //`  /    /   / / /
//   //` /            /
//  ||               /
//   \\             /
//   ))           .'
//  //           /
//             /
// Khi bắt đầu dự án này, chỉ có Chúa và tôi biêt cách chạy nó.
// Giờ thì chỉ có Chúa mới biết :( !!!

