import 'package:app_restaurant/routers/app_router_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(430, 932),
        builder: (_, child) {
          return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              routerConfig: NyAppRouter().router
              // routeInformationProvider: NyAppRouter().router.routeInformationProvider,
              // routeInformationParser: NyAppRouter().router.routeInformationParser,
              // routerDelegate: NyAppRouter().router.routerDelegate,
              );
        });
  }
}
