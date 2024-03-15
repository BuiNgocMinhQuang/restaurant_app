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

part 'staff_infor_state.dart';
part 'staff_infor_event.dart';

class StaffInforBloc extends Bloc<StaffInforEvent, StaffInforState> {
  StaffInforBloc() : super(const StaffInforState()) {
    on<GetStaffInfor>(_onGetStaffInfor);
  }

  void _onGetStaffInfor(
    GetStaffInfor event,
    Emitter<StaffInforState> emit,
  ) async {
    try {
      emit(state.copyWith(staffInforStatus: StaffInforStatus.loading));
      await Future.delayed(const Duration(seconds: 1));

      var token = StorageUtils.instance.getString(key: 'token');
      final response = await http.post(
        Uri.parse('$baseUrl$userInformationApi'),
        headers: {"Authorization": "Bearer $token"},
      );
      final data = jsonDecode(response.body);
      var message = data['message'];

      try {
        print("GET STAFF INFOR R NE ${data}");

        if (data['status'] == 200) {
          var staffInforDataRes = StaffInfor.fromJson(data);
          emit(state.copyWith(staffInforDataModel: staffInforDataRes));
          emit(state.copyWith(staffInforStatus: StaffInforStatus.success));
        } else {
          emit(state.copyWith(staffInforStatus: StaffInforStatus.failed));

          emit(state.copyWith(errorText: message.toString()));
        }
      } catch (error) {
        print("LOI GI DO $error");
        emit(state.copyWith(staffInforStatus: StaffInforStatus.failed));
        emit(state.copyWith(errorText: message.toString()));
      }
    } catch (error) {
      emit(state.copyWith(staffInforStatus: StaffInforStatus.failed));
      emit(state.copyWith(errorText: "Đã có lỗi xảy ra !"));
    }
  }
}
