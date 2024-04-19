import 'dart:convert';
import 'dart:developer';

import 'package:app_restaurant/config/void_show_dialog.dart';
import 'package:app_restaurant/env/index.dart';
import 'package:app_restaurant/constant/api/index.dart';
import 'package:app_restaurant/model/manager/manager_list_store_model.dart';
import 'package:app_restaurant/model/manager_infor_model.dart';
import 'package:app_restaurant/routers/app_router_config.dart';
import 'package:app_restaurant/utils/storage.dart';
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
    print("LOGOUT");

    var token = StorageUtils.instance.getString(key: 'token_manager');
    await http.post(
      Uri.parse('$baseUrl$managerLogout'),
      headers: {"Authorization": "Bearer $token"},
    );
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
    print("LLLLL $data");
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
        Future.delayed(Duration(milliseconds: 500), () {
          print("DANG NHAP THNAH CONG");
          showLoginSuccesDialog();
        });
      } else {
        emit(state.copyWith(loginStatus: ManagerLoginStatus.failed));
        emit(state.copyWith(errorText: message['text']));
      }
    } catch (error) {
      emit(state.copyWith(loginStatus: ManagerLoginStatus.failed));
      emit(state.copyWith(errorText: message['text']));
    }

    if (state.loginStatus == ManagerLoginStatus.failed) {
      showFailedModal(
          context: navigatorKey.currentContext, desWhyFail: state.errorText);
    }
  }
}
