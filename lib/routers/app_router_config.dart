import 'package:app_restaurant/config/void_show_dialog.dart';
import 'package:app_restaurant/routers/app_router_constant.dart';
import 'package:app_restaurant/screen/manager/food_menu/list_food.dart';
import 'package:app_restaurant/screen/manager/staff/add_staff.dart';
import 'package:app_restaurant/screen/manager/auth/change_password.dart';
import 'package:app_restaurant/screen/manager/auth/confirm_otp.dart';
import 'package:app_restaurant/screen/manager/auth/signin.dart';
import 'package:app_restaurant/screen/manager/auth/sigup.dart';
import 'package:app_restaurant/screen/manager/store/booking_table.dart';
import 'package:app_restaurant/screen/manager/store/brought_receipt.dart';
import 'package:app_restaurant/screen/manager/auth/forgot_password.dart';
import 'package:app_restaurant/screen/manager/staff/edit_staff_infor.dart';
import 'package:app_restaurant/screen/manager/store/manage_store.dart';
import 'package:app_restaurant/screen/manager/manage_bottom_nav.dart';
import 'package:app_restaurant/screen/manager/store/list_bill.dart';
import 'package:app_restaurant/screen/manager/staff/list_staff.dart';
import 'package:app_restaurant/screen/manager/store/list_stores.dart';
import 'package:app_restaurant/screen/staff/auth/change_password.dart';
import 'package:app_restaurant/screen/staff/auth/confirm_otp.dart';
import 'package:app_restaurant/screen/staff/auth/forgot_password.dart';
import 'package:app_restaurant/screen/staff/auth/signin.dart';
import 'package:app_restaurant/screen/staff/food_menu/list_food.dart';

import 'package:app_restaurant/screen/staff/staff_bottom_nav.dart';
import 'package:app_restaurant/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class NyAppRouter {
  final GoRouter testRouter =
      GoRouter(navigatorKey: navigatorKey, routes: <RouteBase>[
    GoRoute(
        name: AppRouterContants.managerHomeRouterName,
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return ManageStore();
        }),
  ]);
  final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    routes: <RouteBase>[
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
      // GoRoute(
      //     name: AppRouterContants.managerListStoresRouterName,
      //     path: '/manager_list_stores',
      //     builder: (BuildContext context, GoRouterState state) {
      //       return const ListStores();
      //     }),
      GoRoute(
          name: AppRouterContants.managerManageStoresRouterName,
          path: '/manager_manage_stores',
          builder: (BuildContext context, GoRouterState state) {
            return const ManageStore();
          }),
      // GoRoute(
      //     name: AppRouterContants.managerListFoodRouterName,
      //     path: '/manager_list_food',
      //     builder: (BuildContext context, GoRouterState state) {
      //       return const ListFoodManager();
      //     }),
      // GoRoute(
      //     name: AppRouterContants.managerListBillRouterName,
      //     path: '/manager_list_bill',
      //     builder: (BuildContext context, GoRouterState state) {
      //       return const ManagerListBill();
      //     }),
      // GoRoute(
      //     name: AppRouterContants.managerBroughtReceiptRouterName,
      //     path: '/manager_brought_receipt',
      //     builder: (BuildContext context, GoRouterState state) {
      //       return const ManagerBroughtReceipt();
      //     }),
      // GoRoute(
      //     name: AppRouterContants.managerBookingTableRouterName,
      //     path: '/manager_booking_table',
      //     builder: (BuildContext context, GoRouterState state) {
      //       return const ManagerBookingTable();
      //     }),

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
      // GoRoute(
      //     name: AppRouterContants.managerAddFoodRouterName,
      //     path: '/manager_list_staff',
      //     builder: (BuildContext context, GoRouterState state) {
      //       return const ManagerAddFood();
      //     }),
      GoRoute(
          name: AppRouterContants.managerEditStaffInformationRouterName,
          path: '/manager_edit_staff_info',
          builder: (BuildContext context, GoRouterState state) {
            return const EditStaffInformation();
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
      GoRoute(
          name: AppRouterContants.staffListFoodRouterName,
          path: '/staff_list_food',
          builder: (BuildContext context, GoRouterState state) {
            return const ListFoodStaff();
          }),
    ],
    redirect: (BuildContext context, GoRouterState state) async {
      if (StorageUtils.instance.getString(key: 'token_staff') != null) {
        print("HOME STAFF");
        return '/staff_home';
      } else if (StorageUtils.instance.getString(key: 'token_manager') !=
          null) {
        print("HOME MANAGER");
        // GoRoute(
        //     name: AppRouterContants.managerListFoodRouterName,
        //     path: '/manager_list_food',
        //     builder: (BuildContext context, GoRouterState state) {
        //       return const ListFoodManager();
        //     });
        return '/manager_home';
      }
      return null;
    },
  );
}
