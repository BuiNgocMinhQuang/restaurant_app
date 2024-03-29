import 'dart:convert';

import 'package:app_restaurant/config/void_show_dialog.dart';
import 'package:app_restaurant/env/index.dart';
import 'package:app_restaurant/constant/api/index.dart';
import 'package:app_restaurant/routers/app_router_config.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

part 'manager_register_state.dart';
part 'manager_register_event.dart';

class ManagerRegisterBloc
    extends Bloc<ManagerRegisterEvent, ManagerRegisterState> {
  ManagerRegisterBloc() : super(const ManagerRegisterState()) {
    on<ManagerRegisterButtonPressed>(_onManagerRegisterButtonPressed);
  }

  void _onManagerRegisterButtonPressed(
    ManagerRegisterButtonPressed event,
    Emitter<ManagerRegisterState> emit,
  ) async {
    emit(state.copyWith(managerRegisterStatus: ManagerRegisterStatus.loading));
    try {
      final response = await http.post(Uri.parse('$baseUrl$managerRegister'),
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode({
            "first_name": event.firstName,
            "last_name": event.lastName,
            "full_name": event.fullName,
            "email": event.email,
            "phone": event.phone,
            "password": event.password,
            "confirm_password": event.confirmPassword,
            "agree_conditon": event.agreeConditon
          }));
      final data = jsonDecode(response.body);
      // var message = data['message'];

      if (data['status'] == 200) {
        emit(state.copyWith(
            managerRegisterStatus: ManagerRegisterStatus.success));
      } else {
        emit(state.copyWith(
            managerRegisterStatus: ManagerRegisterStatus.failed));
      }
    } catch (error) {
      emit(state.copyWith(managerRegisterStatus: ManagerRegisterStatus.failed));
    }
  }
}
