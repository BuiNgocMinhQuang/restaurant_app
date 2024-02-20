import 'package:app_restaurant/routers/app_router_constant.dart';
import 'package:app_restaurant/screen/manager/forgot_password.dart';
import 'package:app_restaurant/screen/manager/signin.dart';
import 'package:app_restaurant/screen/manager/sigup.dart';
import 'package:app_restaurant/screen/staff/forgot_password.dart';
import 'package:app_restaurant/screen/staff/signin.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NyAppRouter {
  final GoRouter router = GoRouter(routes: <RouteBase>[
    GoRoute(
        name: AppRouterContants.managerSignInRouterName,
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const ManagerSignIn();
        }),
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
  ]);
}
