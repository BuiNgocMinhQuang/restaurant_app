import 'package:app_restaurant/bloc/bloc_provider.dart';
import 'package:app_restaurant/providers/theme_provider.dart';
import 'package:app_restaurant/routers/app_router_config.dart';
import 'package:app_restaurant/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageUtils.instance.init();
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    debugPrint("App $state");
    if (state == AppLifecycleState.resumed) {
      // Logic to handle app resume
      debugPrint("App Resumed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      builder: (BuildContext context, Widget? child) {
        return child!;
      },
      child: AppBlocProvider(
        child: Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return MaterialApp.router(
              theme: themeProvider.themeDataStyle,
              debugShowCheckedModeBanner: false,
              routerConfig: NyAppRouter().router,
            );
          },
        ),
      ),
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

