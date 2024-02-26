import 'package:app_restaurant/routers/app_router_constant.dart';
import 'package:app_restaurant/screen/manager/add_staff.dart';
import 'package:app_restaurant/screen/manager/booking_table.dart';
import 'package:app_restaurant/screen/manager/brought_receipt.dart';
import 'package:app_restaurant/screen/manager/forgot_password.dart';
import 'package:app_restaurant/screen/manager/home.dart';
import 'package:app_restaurant/screen/manager/nav_bottom.dart';
import 'package:app_restaurant/screen/manager/list_bill.dart';
import 'package:app_restaurant/screen/manager/list_staff.dart';
import 'package:app_restaurant/screen/manager/signin.dart';
import 'package:app_restaurant/screen/manager/signin_copy.dart';
import 'package:app_restaurant/screen/manager/sigup.dart';
import 'package:app_restaurant/screen/manager/stores.dart';
import 'package:app_restaurant/screen/manager/test_flexible.dart';
import 'package:app_restaurant/screen/staff/forgot_password.dart';
import 'package:app_restaurant/screen/staff/signin.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NyAppRouter {
  final GoRouter customRouter = GoRouter(routes: [
    // GoRoute(
    //     name: AppRouterContants.managerHomeRouterName,
    //     path: '/',
    //     builder: (BuildContext context, GoRouterState state) {
    //       return const ManagerHome();
    //     }),
    GoRoute(
        name: AppRouterContants.managerSignInRouterName,
        // path: '/manager_stores',
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const NavBottom();
        }),
  ]);

  final GoRouter isAuth = GoRouter(routes: <RouteBase>[
    GoRoute(
      name: AppRouterContants.managerHomeRouterName,
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const ManagerHome();
      },
    ),
    GoRoute(
        name: AppRouterContants.managerStoresRouterName,
        path: '/manager_stores',
        builder: (BuildContext context, GoRouterState state) {
          return const Stores();
        }),
    GoRoute(
        name: AppRouterContants.managerListBillRouterName,
        path: '/manager_list_bill',
        builder: (BuildContext context, GoRouterState state) {
          return const ListBill();
        }),
    GoRoute(
        name: AppRouterContants.managerBroughtReceiptRouterName,
        path: '/manager_brought_receipt',
        builder: (BuildContext context, GoRouterState state) {
          return const BroughtReceipt();
        }),
    GoRoute(
        name: AppRouterContants.managerBookingTableRouterName,
        path: '/manager_booking_table',
        builder: (BuildContext context, GoRouterState state) {
          return const BookingTable();
        }),
    GoRoute(
        name: AppRouterContants.managerAddStaffRouterName,
        path: '/manager_add_staff',
        builder: (BuildContext context, GoRouterState state) {
          return const AddStaff();
        }),
    GoRoute(
        name: AppRouterContants.managerListStaffRouterName,
        path: '/manager_list_staff',
        builder: (BuildContext context, GoRouterState state) {
          return const ListStaff();
        }),
  ]);
  final GoRouter router = GoRouter(routes: <RouteBase>[
    //Router Manager

    GoRoute(
      name: AppRouterContants.managerSignInRouterName,
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
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
        name: AppRouterContants.managerHomeRouterName,
        path: '/manager_home',
        builder: (BuildContext context, GoRouterState state) {
          return const ManagerHome();
        }),
    GoRoute(
        name: AppRouterContants.managerStoresRouterName,
        path: '/manager_stores',
        builder: (BuildContext context, GoRouterState state) {
          return const Stores();
        }),
    GoRoute(
        name: AppRouterContants.managerListBillRouterName,
        path: '/manager_list_bill',
        builder: (BuildContext context, GoRouterState state) {
          return const ListBill();
        }),
    GoRoute(
        name: AppRouterContants.managerBroughtReceiptRouterName,
        path: '/manager_brought_receipt',
        builder: (BuildContext context, GoRouterState state) {
          return const BroughtReceipt();
        }),
    GoRoute(
        name: AppRouterContants.managerBookingTableRouterName,
        path: '/manager_booking_table',
        builder: (BuildContext context, GoRouterState state) {
          return const BookingTable();
        }),

    GoRoute(
        name: AppRouterContants.managerAddStaffRouterName,
        path: '/manager_add_staff',
        builder: (BuildContext context, GoRouterState state) {
          return const AddStaff();
        }),

    GoRoute(
        name: AppRouterContants.managerListStaffRouterName,
        path: '/manager_list_staff',
        builder: (BuildContext context, GoRouterState state) {
          return const ListStaff();
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
  ]);
}
