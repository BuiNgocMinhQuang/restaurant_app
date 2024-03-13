import 'dart:convert';

import 'package:app_restaurant/config/void_show_dialog.dart';
import 'package:app_restaurant/env/index.dart';
import 'package:app_restaurant/constant/api/index.dart';
import 'package:app_restaurant/model/manager_infor_model.dart';
import 'package:app_restaurant/model/staff_infor_model.dart';
import 'package:app_restaurant/model/user_model.dart';
import 'package:app_restaurant/routers/app_router_config.dart';
import 'package:app_restaurant/utils/storage.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';

part 'login_state.dart';
part 'login_event.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoginState()) {
    on<LoginAppInit>(_onLoginAppInit);
    on<LoginButtonPressed>(_onLoginButtonPressed);
    on<ManagerLoginButtonPressed>(_onManagerLoginButtonPressed);
    on<LogoutStaff>(_onLogout);
  }

  void _onLogout(
    LogoutStaff event,
    Emitter<LoginState> emit,
  ) async {
    print("LOGOUT HHHEHHE");

    var token = StorageUtils.instance.getString(key: 'token');
    await http.post(
      Uri.parse('$baseUrl$staffLogout'),
      headers: {"Authorization": "Bearer $token"},
    );
  }

  void _onLoginAppInit(
    LoginAppInit event,
    Emitter<LoginState> emit,
  ) async {
    var staffInforDataString =
        StorageUtils.instance.getString(key: 'staff_infor_data');
    print("CO DATA STAFF $staffInforDataString");

    var managerInforDataString =
        StorageUtils.instance.getString(key: 'manager_infor_data');
    print("CO DATA MANAGER $managerInforDataString");
    if (staffInforDataString != null && staffInforDataString != "") {
      var staffInforDataRes =
          StaffInfor.fromJson(jsonDecode(staffInforDataString));

      emit(state.copyWith(staffInforDataModel: staffInforDataRes));
    }
    if (managerInforDataString != null && managerInforDataString != "") {
      var managerInforDataRes =
          ManagerInforModel.fromJson(jsonDecode(managerInforDataString));

      emit(state.copyWith(managerInforModel: managerInforDataRes));
    }
  }

  void _onManagerLoginButtonPressed(
    ManagerLoginButtonPressed event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(loginStatus: LoginStatus.loading));
    final response = await http.post(
      Uri.parse('$baseUrl$managerLoginApi'),
      body: {
        'email': event.email,
        'password': event.password,
      },
    );
    final data = jsonDecode(response.body);
    var message = data['message'];

    try {
      if (data['status'] == 200) {
        var authManagerDataRes = ManagerInforModel.fromJson(data);
        var authManagerDataString = jsonEncode(authManagerDataRes);
        var token = authManagerDataRes.token;
        print("TOKEN MANAGER NE $token");

        StorageUtils.instance.setString(key: 'token', val: token ?? '');
        //save Token

        StorageUtils.instance
            .setString(key: 'auth_manager', val: authManagerDataString);

        try {
          final response = await http.post(
            Uri.parse('$baseUrl$userInformationApi'),
            headers: {
              'Content-type': 'application/json',
              'Accept': 'application/json',
              "Authorization": "Bearer ${authManagerDataRes.token}"
            },
          );
          final dataManagerInfor = jsonDecode(response.body);
          if (dataManagerInfor['status'] == 200) {
            var managerInforDataRes =
                ManagerInforModel.fromJson(dataManagerInfor);
            var managerInforDataString = jsonEncode(managerInforDataRes);
            StorageUtils.instance.setString(
                key: 'manager_infor_data', val: managerInforDataString);
            emit(state.copyWith(managerInforModel: managerInforDataRes));
          }
        } catch (error) {
          print("ERROR LOGIN MANAGER $error");
        }
        emit(state.copyWith(loginStatus: LoginStatus.success));
        navigatorKey.currentContext?.go("/manager_home");
      } else {
        emit(state.copyWith(loginStatus: LoginStatus.failed));
        emit(state.copyWith(errorText: message['text']));
      }
    } catch (error) {
      emit(state.copyWith(loginStatus: LoginStatus.failed));
      emit(state.copyWith(errorText: message['text']));
    }

    if (state.loginStatus == LoginStatus.failed) {
      showFailedModal(navigatorKey.currentContext, state.errorText);
    }
  }

  void _onLoginButtonPressed(
    LoginButtonPressed event,
    Emitter<LoginState> emit,
  ) async {
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
        print("DATA STAFF LOGIN $data");
        var authDataRes = StaffAuthData.fromJson(data);
        var authDataString = jsonEncode(authDataRes);
        var token = authDataRes.token;
        var token_expires_at = authDataRes.tokenExpiresAt;
        print("TOKEN STAFF NE $token");
        print("TOKEN Expires At $token_expires_at");

        StorageUtils.instance.setString(key: 'token', val: token ?? '');
        StorageUtils.instance
            .setString(key: 'token_expires', val: token_expires_at ?? '');
        StorageUtils.instance.setString(key: 'auth_staff', val: authDataString);

        emit(state.copyWith(loginStatus: LoginStatus.success));
        navigatorKey.currentContext?.go("/staff_home");
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

    if (state.loginStatus == LoginStatus.failed) {
      showFailedModal(navigatorKey.currentContext, state.errorText);
    }
  }
}
