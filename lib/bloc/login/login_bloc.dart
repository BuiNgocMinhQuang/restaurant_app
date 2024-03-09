import 'dart:convert';

import 'package:app_restaurant/config/void_show_dialog.dart';
import 'package:app_restaurant/model/user_model.dart';
import 'package:app_restaurant/routers/app_router_config.dart';
import 'package:app_restaurant/utils/common.dart';
import 'package:app_restaurant/utils/storage.dart';
import 'package:app_restaurant/utils/user.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';

part 'login_state.dart';
part 'login_event.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoginState()) {
    on<LoginAppInit>(_onLoginAppInit);
    on<LoginButtonPressed>(_onLoginButtonPressed);
  }

  void _onLoginAppInit(
    LoginAppInit event,
    Emitter<LoginState> emit,
  ) async {
    var authDataString = StorageUtils.instance.getString(key: 'auth_staff');
    if (authDataString != null && authDataString != "") {
      var authDataRes =
          AuthDataModel.fromJson(jsonDecode(authDataString ?? ""));

      emit(state.copyWith(authDataModel: authDataRes));
    }
  }

  void _onLoginButtonPressed(
    LoginButtonPressed event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(loginStatus: LoginStatus.loading));

    try {
      final response = await http.post(
        Uri.parse('https://shop.layoutwebdemo.com/api/staff/login'),
        body: {
          'shop_id': event.shopId,
          'email': event.email,
          'password': event.password,
        },
      );
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        var authDataRes = AuthDataModel.fromJson(data);
        var authDataString = jsonEncode(authDataRes);
        StorageUtils.instance.setString(key: 'auth_staff', val: authDataString);
        if (data['status'] == 200) {
          print("DATA $data");
          emit(state.copyWith(authDataModel: authDataRes));
          emit(state.copyWith(loginStatus: LoginStatus.success));
          print("TOI DSY");
          navigatorKey.currentContext?.go("/staff_home");
        } else if (data['status'] == 422) {
          // emit(LoginFailure("Tài khoản không tồn tại"));
          emit(state.copyWith(loginStatus: LoginStatus.failed));
          emit(state.copyWith(errorText: 'Tài khoản không tồn tại'));
        } else if (data['status'] == 503) {
          // emit(LoginFailure(data['message']));
          emit(state.copyWith(loginStatus: LoginStatus.failed));
          emit(state.copyWith(errorText: data['message']));
        } else {
          // emit(LoginFailure(data['message']));
          emit(state.copyWith(loginStatus: LoginStatus.failed));
          emit(state.copyWith(errorText: data['message']));
        }
      } else {
        print("LoginFailure");

        // emit(LoginFailure(data.errors));
        emit(state.copyWith(loginStatus: LoginStatus.failed));
        emit(state.copyWith(errorText: data.errors));
      }
    } catch (error) {
      print("LoginFailure2");

      // emit(LoginFailure("Thất bại!"));
      emit(state.copyWith(loginStatus: LoginStatus.failed));
      emit(state.copyWith(errorText: "Thất bại!"));
    }

    if (state.loginStatus == LoginStatus.failed) {
      showFailedModal(navigatorKey.currentContext, state.errorText);
    }
  }
}
