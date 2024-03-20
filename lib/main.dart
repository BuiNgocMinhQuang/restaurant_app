import 'package:app_restaurant/bloc/bloc_provider.dart';
import 'package:app_restaurant/bloc/network/network_cubit.dart';
import 'package:app_restaurant/routers/app_router_config.dart';
import 'package:app_restaurant/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageUtils.instance.init();
  runApp(BlocProvider<InternetCubit>(
    create: (context) => InternetCubit(),
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late InternetCubit internetCubit;
  @override
  void initState() {
    internetCubit = context.read<InternetCubit>();
    internetCubit.checkConectivity();
    internetCubit.trackConnectivityChange();
    super.initState();
  }

  @override
  void dispose() {
    internetCubit.disposeInternet();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      builder: (BuildContext context, Widget? child) {
        // print("Build lai Screen");
        return child!;
      },
      child: AppBlocProvider(
        child: MaterialApp.router(
            theme:
                new ThemeData(scaffoldBackgroundColor: const Color(0xFFEFEFEF)),
            debugShowCheckedModeBanner: false,
            routerConfig: NyAppRouter().router),
      ),
    );
  }
}


// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // bool isLogin = true;
//     return ScreenUtilInit(
//       designSize: const Size(430, 932),
//       builder: (BuildContext context, Widget? child) {
//         print("Build lai Screen");
//         return child!;
//       },
//       child: MaterialApp.router(
//           debugShowCheckedModeBanner: false,
//           routerConfig: NyAppRouter().router),
//     );
//   }
// }





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

