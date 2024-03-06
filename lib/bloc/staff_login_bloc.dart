import 'dart:convert';

import 'package:app_restaurant/utils/common.dart';
import 'package:app_restaurant/utils/user.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

part 'staff_login_state.dart';
part 'staff_login_event.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginButtonPressed>(_onLoginButtonPressed);
  }

  void _onLoginButtonPressed(
    LoginButtonPressed event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());

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
        print("DATA $data");
        // print("LoginSuccess");

        // emit(LoginSuccess());

        if (data['status'] == 200) {
          await saveToken(data['token']);
          // final userData = {
          //   'staff_id': data['data']['staff_id'],
          //   'staff_full_name': data['data']['staff_full_name'],
          //   'staff_email': data['data']['staff_email'],
          //   'staff_phone': data['data']['staff_phone'],
          //   // ... other relevant data
          // };
          // await saveUserData(userData);
          emit(LoginSuccess());
        } else if (data['status'] == 422) {
          emit(LoginFailure("Tài khoản không tồn tại"));
        } else if (data['status'] == 503) {
          emit(LoginFailure(data['message']));
        } else {
          emit(LoginFailure(data['message']));
        }
      } else {
        print("LoginFailure");

        emit(LoginFailure(data.errors));
      }
    } catch (error) {
      print("LoginFailure2");

      emit(LoginFailure("Thất bại!"));
    }
  }
}
