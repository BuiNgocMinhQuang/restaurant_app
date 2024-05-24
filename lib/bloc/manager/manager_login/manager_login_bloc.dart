import 'dart:convert';
import 'dart:developer';

import 'package:app_restaurant/config/void_show_dialog.dart';
import 'package:app_restaurant/env/index.dart';
import 'package:app_restaurant/constant/api/index.dart';
import 'package:app_restaurant/model/manager_infor_model.dart';
import 'package:app_restaurant/routers/app_router_config.dart';
import 'package:app_restaurant/utils/storage.dart';
// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';

part 'manager_login_state.dart';
part 'manager_login_event.dart';

class ManagerLoginBloc extends Bloc<ManagerLoginEvent, ManagerLoginState> {
  ManagerLoginBloc() : super(const ManagerLoginState()) {
    on<ManagerLoginButtonPressed>(_onManagerLoginButtonPressed);
    on<ManagerLogout>(_onManagerLogout);
  }
  void _onManagerLogout(
    ManagerLogout event,
    Emitter<ManagerLoginState> emit,
  ) async {
    try {
      var token = StorageUtils.instance.getString(key: 'token_manager');
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
          StorageUtils.instance.removeKey(key: 'token_manager');
          navigatorKey.currentContext?.go('/');
        } else {
          log("ERROR _onManagerLogout 1");
        }
      } catch (error) {
        log("ERROR _onManagerLogout 2");
      }
    } catch (error) {
      log("ERROR _onManagerLogout 3");
    }
  }

  void _onManagerLoginButtonPressed(
    ManagerLoginButtonPressed event,
    Emitter<ManagerLoginState> emit,
  ) async {
    emit(state.copyWith(loginStatus: ManagerLoginStatus.loading));

    final response = await http.post(
      Uri.parse('$baseUrl$managerLoginApi'),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'email': event.email,
        'password': event.password,
        'remember': event.remember,
      }),
    );

    final data = jsonDecode(response.body);
    var message = data['message'];
    try {
      if (data['status'] == 200) {
        var authManagerDataRes = ManagerInforModel.fromJson(data);
        var authMangerDataString = jsonEncode(authManagerDataRes);

        var token = authManagerDataRes.token;
        var tokenExpiresAt = authManagerDataRes.tokenExpiresAt;
        StorageUtils.instance.setString(key: 'token_manager', val: token ?? '');
        StorageUtils.instance
            .setString(key: 'token_manager_expires', val: tokenExpiresAt ?? '');
        StorageUtils.instance
            .setString(key: 'auth_manager', val: authMangerDataString);
        emit(state.copyWith(loginStatus: ManagerLoginStatus.success));
        log(token.toString());
        navigatorKey.currentContext?.go("/manager_home");
        Future.delayed(const Duration(milliseconds: 300), () {
          showLoginSuccesDialog();
        });
      } else {
        log("ERROR _onManagerLoginButtonPressed 1");
        emit(state.copyWith(loginStatus: ManagerLoginStatus.failed));
        emit(state.copyWith(errorText: message['text']));
      }
    } catch (error) {
      log("ERROR _onManagerLoginButtonPressed 2");
      emit(state.copyWith(loginStatus: ManagerLoginStatus.failed));
      emit(state.copyWith(errorText: "Không thể kết nối với máy chủ !"));
    }

    if (state.loginStatus == ManagerLoginStatus.failed) {
      showFailedModal(
          context: navigatorKey.currentContext, desWhyFail: state.errorText);
    }
  }
}
