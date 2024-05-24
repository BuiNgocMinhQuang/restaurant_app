import 'package:app_restaurant/routers/app_router_constant.dart';
import 'package:app_restaurant/screen/manager/auth/change_password.dart';
import 'package:app_restaurant/screen/manager/auth/confirm_otp.dart';
import 'package:app_restaurant/screen/manager/auth/signin.dart';
import 'package:app_restaurant/screen/manager/auth/sigup.dart';
import 'package:app_restaurant/screen/manager/auth/forgot_password.dart';
import 'package:app_restaurant/screen/manager/manage_bottom_nav.dart';
import 'package:app_restaurant/screen/staff/auth/change_password.dart';
import 'package:app_restaurant/screen/staff/auth/confirm_otp.dart';
import 'package:app_restaurant/screen/staff/auth/forgot_password.dart';
import 'package:app_restaurant/screen/staff/auth/signin.dart';

import 'package:app_restaurant/screen/staff/staff_bottom_nav.dart';
import 'package:app_restaurant/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class NyAppRouter {
  final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    routes: <RouteBase>[
      //Router Manager
      GoRoute(
        name: AppRouterContants.managerSignInRouterName,
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          // if (StorageUtils.instance.getString(key: 'token_staff') != null) {
          //   print("HOME STAFF");
          //   return StaffFabTab(
          //     selectedIndex: 2,
          //   );
          // } else if (StorageUtils.instance.getString(key: 'token_manager') !=
          //     null) {
          //   print("HOME MANAGER");
          //   return ManagerFabTab(
          //     selectedIndex: 2,
          //   );
          // }
          return const ManagerSignIn();
        },
      ),
      GoRoute(
          name: AppRouterContants.managerSignUpRouterName,
          path: '/manager_sign_up',
          builder: (BuildContext context, GoRouterState state) {
            return const ManagerSignUp();
          }),
      GoRoute(
          name: AppRouterContants.managerForgotpasswordRouterName,
          path: '/manager_forgot_password',
          builder: (BuildContext context, GoRouterState state) {
            return const ManagerForgotPassword();
          }),
      GoRoute(
          name: AppRouterContants.managerConfirmOtpRouterName,
          path: '/manager_confirm_otp',
          builder: (BuildContext context, GoRouterState state) {
            return const ManagerConfirmOTP();
          }),
      GoRoute(
          name: AppRouterContants.managerChangePasswordRouterName,
          path: '/manager_change_password',
          builder: (BuildContext context, GoRouterState state) {
            return const ManagerChangePassword();
          }),
      GoRoute(
          name: AppRouterContants.managerHomeRouterName,
          path: '/manager_home',
          builder: (BuildContext context, GoRouterState state) {
            return ManagerFabTab(
              selectedIndex: 2,
            );
          }),

//Router Staff
      GoRoute(
          name: AppRouterContants.staffSignInRouterName,
          path: '/staff_sign_in',
          builder: (BuildContext context, GoRouterState state) {
            return const StaffSignIn();
          }),
      GoRoute(
          name: AppRouterContants.staffForgotpasswordRouterName,
          path: '/staff_forgot_password',
          builder: (BuildContext context, GoRouterState state) {
            return const StaffForgotPassword();
          }),
      GoRoute(
          name: AppRouterContants.staffConfirmOtpRouterName,
          path: '/staff_confirm_otp',
          builder: (BuildContext context, GoRouterState state) {
            return const StaffConfirmOTP();
          }),
      GoRoute(
          name: AppRouterContants.staffChangePasswordRouterName,
          path: '/staff_change_password',
          builder: (BuildContext context, GoRouterState state) {
            return const StaffChangePassword();
          }),
      GoRoute(
          name: AppRouterContants.staffHomeRouterName,
          path: '/staff_home',
          builder: (BuildContext context, GoRouterState state) {
            return StaffFabTab(
              selectedIndex: 2,
            );
          }),
    ],
    redirect: (BuildContext context, GoRouterState state) async {
      if (StorageUtils.instance.getString(key: 'token_staff') != null) {
        return '/staff_home';
      } else if (StorageUtils.instance.getString(key: 'token_manager') !=
          null) {
        return '/manager_home';
      }
      return null;
    },
  );
}
