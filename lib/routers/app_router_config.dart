import 'package:app_restaurant/routers/app_router_constant.dart';
import 'package:app_restaurant/screen/manager/add_food.dart';
import 'package:app_restaurant/screen/manager/add_staff.dart';
import 'package:app_restaurant/screen/manager/auth/signin.dart';
import 'package:app_restaurant/screen/manager/auth/sigup.dart';
import 'package:app_restaurant/screen/manager/booking_table.dart';
import 'package:app_restaurant/screen/manager/brought_receipt.dart';
import 'package:app_restaurant/screen/manager/auth/forgot_password.dart';
import 'package:app_restaurant/screen/manager/edit_staff_infor.dart';
import 'package:app_restaurant/screen/manager/home.dart';
import 'package:app_restaurant/screen/manager/list_food.dart';
import 'package:app_restaurant/screen/manager/nav_bottom.dart';
import 'package:app_restaurant/screen/manager/list_bill.dart';
import 'package:app_restaurant/screen/manager/list_staff.dart';
import 'package:app_restaurant/screen/manager/stores.dart';
import 'package:app_restaurant/screen/staff/auth/forgot_password.dart';
import 'package:app_restaurant/screen/staff/auth/signin.dart';
import 'package:app_restaurant/screen/staff/home.dart';
import 'package:app_restaurant/screen/staff/nav_bottom.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NyAppRouter {
  final GoRouter testRouter = GoRouter(routes: <RouteBase>[
    // GoRoute(
    //     name: AppRouterContants.managerListFoodRoutername,
    //     path: '/',
    //     builder: (BuildContext context, GoRouterState state) {
    //       return const ListFood();
    //     }),
    GoRoute(
        name: AppRouterContants.managerAddFoodRouterName,
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const StaffBookingTable();
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
          return const NavBottomManger();
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
          return const ManagerListBill();
        }),
    GoRoute(
        name: AppRouterContants.managerBroughtReceiptRouterName,
        path: '/manager_brought_receipt',
        builder: (BuildContext context, GoRouterState state) {
          return const ManagerBroughtReceipt();
        }),
    GoRoute(
        name: AppRouterContants.managerBookingTableRouterName,
        path: '/manager_booking_table',
        builder: (BuildContext context, GoRouterState state) {
          return const ManagerBookingTable();
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
    GoRoute(
        name: AppRouterContants.staffHomeRouterName,
        path: '/staff_home',
        builder: (BuildContext context, GoRouterState state) {
          return const NavBottomStaff();
        }),
  ]);
}
