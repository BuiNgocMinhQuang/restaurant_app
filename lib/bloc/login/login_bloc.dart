import 'dart:convert';

import 'package:app_restaurant/config/void_show_dialog.dart';
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
    // on<GetInforUser>(_onGetInforUser);
  }

  void _onLoginAppInit(
    LoginAppInit event,
    Emitter<LoginState> emit,
  ) async {
    var authDataString = StorageUtils.instance.getString(key: 'auth_staff');
    if (authDataString != null && authDataString != "") {
      var authDataRes = AuthDataModel.fromJson(jsonDecode(authDataString));

      emit(state.copyWith(authDataModel: authDataRes));
    }
  }

  // void _onGetInforUser(
  //   GetInforUser event,
  //   Emitter<LoginState> emit,
  // ) async {
  //   // emit(state.copyWith(loginStatus: LoginStatus.loading));
  //   try {
  //     print("TOKEN22 ${StorageUtils.instance.getString(key: 'staff_token')}");

  //     final response = await http.post(
  //       Uri.parse('http://shop.layoutwebdemo.com/api/information'),
  //       headers: {
  //         'Content-type': 'application/json',
  //         'Accept': 'application/json',
  //         "Authorization":
  //             "Bearer ${StorageUtils.instance.getString(key: 'staff_token')}"
  //       },
  //     );
  //     final data = jsonDecode(response.body);

  //     print("DATA STAFF INFOR $data");
  //   } catch (error) {
  //     print("LOI GI DO");

  //     emit(state.copyWith(loginStatus: LoginStatus.failed));
  //     emit(state.copyWith(errorText: "HET CUU!"));
  //   }
  // }

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
      if (data['status'] == 200) {
        // print("DATA $data");
        var authDataRes = AuthDataModel.fromJson(data);
        var authDataString = jsonEncode(authDataRes);
        StorageUtils.instance.setString(key: 'auth_staff', val: authDataString);

        // try {

        //   final response = await http.post(
        //     Uri.parse('http://shop.layoutwebdemo.com/api/information'),
        //     headers: {
        //       'Content-type': 'application/json',
        //       'Accept': 'application/json',
        //       "Authorization": "Bearer ${authDataRes.token}"
        //     },
        //   );
        //   final dataStaffInfor = jsonDecode(response.body);
        //   if (dataStaffInfor['status'] == 200) {
        //     var staffInforDataRes = StaffInfor.fromJson(dataStaffInfor);
        //     var staffInforDataString = jsonEncode(staffInforDataRes);
        // StorageUtils.instance.setString(key: 'staff_infor_data', val: staffInforDataString);
        // emit(state.copyWith(staffInforDataModel: staffInforDataRes));

        //   }

        //   print("DATA STAFF INFOR $dataStaffInfor");
        // } catch (error) {
        //   print("LOI GI DO");

        //   emit(state.copyWith(loginStatus: LoginStatus.failed));
        //   emit(state.copyWith(errorText: "HET CUU!"));
        // }
        emit(state.copyWith(authDataModel: authDataRes));
        emit(state.copyWith(loginStatus: LoginStatus.success));
        navigatorKey.currentContext?.go("/staff_home");
      } else {
        print("LoginFailure2");
        // print("DATA2 $data");

        emit(state.copyWith(loginStatus: LoginStatus.failed));
        emit(state.copyWith(errorText: data['message']));
      }
    } catch (error) {
      print("LoginFailure2");
      emit(state.copyWith(loginStatus: LoginStatus.failed));
      emit(state.copyWith(errorText: "Thông tin không tồn tại!"));
    }

    if (state.loginStatus == LoginStatus.failed) {
      showFailedModal(navigatorKey.currentContext, state.errorText);
    }
  }
}
