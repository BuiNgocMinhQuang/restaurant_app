import 'dart:convert';

import 'package:app_restaurant/config/void_show_dialog.dart';
import 'package:app_restaurant/env/index.dart';
import 'package:app_restaurant/constant/api/index.dart';
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
      Uri.parse('$baseUrl$staffLogout'),
      headers: {"Authorization": "Bearer $token"},
    );
  }

  void _onManagerLoginButtonPressed(
    ManagerLoginButtonPressed event,
    Emitter<ManagerLoginState> emit,
  ) async {
    print("TRUYEN CC GI V");
    print("${{
      'email': event.email,
      'password': event.password,
      'remember': event.remember,
    }}");
    emit(state.copyWith(loginStatus: ManagerLoginStatus.loading));
    print("111");

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
    print("???");
    print("${response.body}");

    final data = jsonDecode(response.body);
    var message = data['message'];

    try {
      if (data['status'] == 200) {
        var authManagerDataRes = ManagerInforModel.fromJson(data);
        // var authManagerDataString = jsonEncode(authManagerDataRes);
        var authMangerDataString = jsonEncode(authManagerDataRes);

        var token = authManagerDataRes.token;
        print("TOKEN MANAGER NE $token");

        StorageUtils.instance.setString(key: 'token_manager', val: token ?? '');
        StorageUtils.instance
            .setString(key: 'auth_manager', val: authMangerDataString);
        emit(state.copyWith(loginStatus: ManagerLoginStatus.success));
        navigatorKey.currentContext?.go("/manager_home");
        Future.delayed(Duration(milliseconds: 500), () {
          print("DANG NHAP THNAH CONG");
          showLoginSuccesDialog();
        });
        // StorageUtils.instance
        //     .setString(key: 'auth_manager', val: authManagerDataString);

        // try {
        //   final response = await http.post(
        //     Uri.parse('$baseUrl$userInformationApi'),
        //     headers: {
        //       'Content-type': 'application/json',
        //       'Accept': 'application/json',
        //       "Authorization": "Bearer ${authManagerDataRes.token}"
        //     },
        //   );
        //   final dataManagerInfor = jsonDecode(response.body);
        //   if (dataManagerInfor['status'] == 200) {
        //     var managerInforDataRes =
        //         ManagerInforModel.fromJson(dataManagerInfor);
        //     var managerInforDataString = jsonEncode(managerInforDataRes);

        //     StorageUtils.instance.setString(
        //         key: 'manager_infor_data', val: managerInforDataString);
        //     emit(state.copyWith(managerInforModel: managerInforDataRes));
        //   }
        // } catch (error) {
        //   print("ERROR LOGIN MANAGER $error");
        // }
      } else {
        emit(state.copyWith(loginStatus: ManagerLoginStatus.failed));
        emit(state.copyWith(errorText: message['text']));
      }
    } catch (error) {
      emit(state.copyWith(loginStatus: ManagerLoginStatus.failed));
      emit(state.copyWith(errorText: message['text']));
    }

    if (state.loginStatus == ManagerLoginStatus.failed) {
      showFailedModal(navigatorKey.currentContext, state.errorText);
    }
  }
}
