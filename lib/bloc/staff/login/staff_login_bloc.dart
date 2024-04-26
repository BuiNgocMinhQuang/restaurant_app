import 'dart:convert';
import 'dart:developer';

import 'package:app_restaurant/config/void_show_dialog.dart';
import 'package:app_restaurant/env/index.dart';
import 'package:app_restaurant/constant/api/index.dart';
import 'package:app_restaurant/model/manager_infor_model.dart';
import 'package:app_restaurant/model/staff/staff_infor_model.dart';
import 'package:app_restaurant/model/staff/staff_auth_model.dart';
import 'package:app_restaurant/routers/app_router_config.dart';
import 'package:app_restaurant/utils/storage.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';

part 'staff_login_state.dart';
part 'staff_login_event.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoginState()) {
    on<StaffLoginButtonPressed>(_onStaffLoginButtonPressed);
    on<LogoutStaff>(_onLogout);
  }

  void _onLogout(
    LogoutStaff event,
    Emitter<LoginState> emit,
  ) async {
    try {
      var token = StorageUtils.instance.getString(key: 'token_staff');
      final response = await http.post(
        Uri.parse('$baseUrl$logoutApi'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': "Bearer $token",
        },
      );
      final data = jsonDecode(response.body);
      log(data.toString());
      try {
        if (data['status'] == 200) {
          StorageUtils.instance.removeKey(key: 'token_staff');
          navigatorKey.currentContext?.go('/staff_sign_in');
        }
      } catch (error) {
        print("ERROR LOGOUT 1");
      }
    } catch (error) {
      print("ERROR LOGOUT 2");
    }
  }

  void _onStaffLoginButtonPressed(
    StaffLoginButtonPressed event,
    Emitter<LoginState> emit,
  ) async {
    try {
      emit(state.copyWith(loginStatus: LoginStatus.loading));
      final response = await http.post(
        Uri.parse('$baseUrl$staffLoginApi'),
        body: {
          'shop_id': event.shopId,
          'email': event.email,
          'password': event.password,
          'remember': event.remember.toString() //sua cho nay
        },
      );
      final data = jsonDecode(response.body);
      print("DATAAAA $data");
      try {
        if (data['status'] == 200) {
          var authStaffDataRes = StaffAuthData.fromJson(data);
          var token = authStaffDataRes.token;
          var staffShopID = authStaffDataRes.data!.shopId;
          var tokenExpiresAt = authStaffDataRes.tokenExpiresAt;
          StorageUtils.instance.setString(key: 'token_staff', val: token ?? '');
          StorageUtils.instance.removeKey(key: 'staff_shop_id');

          StorageUtils.instance
              .setString(key: 'staff_shop_id', val: staffShopID!);
          StorageUtils.instance
              .setString(key: 'token_staff_expires', val: tokenExpiresAt ?? '');
          log(token.toString());
          emit(state.copyWith(loginStatus: LoginStatus.success));
          navigatorKey.currentContext?.go("/staff_home");
          Future.delayed(const Duration(milliseconds: 500), () {
            print("DANG NHAP THNAH CONG");
            showLoginSuccesDialog();
          });
        } else {
          print("LoginFailure2");
          emit(state.copyWith(loginStatus: LoginStatus.failed));
          emit(state.copyWith(errorText: data['message']));
        }
      } catch (error) {
        print("LoginFailure2 $error");
        emit(state.copyWith(loginStatus: LoginStatus.failed));
        emit(state.copyWith(errorText: data['message']));
      }
    } catch (error) {
      print("NO CONNECT DATA $error");
      emit(state.copyWith(loginStatus: LoginStatus.failed));
      emit(state.copyWith(errorText: "Không thể kết nối với máy chủ !"));
    }

    if (state.loginStatus == LoginStatus.failed) {
      showFailedModal(
          context: navigatorKey.currentContext, desWhyFail: state.errorText);
    }
  }
}
