import 'dart:convert';
import 'dart:developer';
import 'package:app_restaurant/env/index.dart';
import 'package:app_restaurant/constant/api/index.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:app_restaurant/model/list_room_model.dart';

part 'list_room_state.dart';
part 'list_room_event.dart';

class ListRoomBloc extends Bloc<ListRoomEvent, ListRoomState> {
  ListRoomBloc() : super(const ListRoomState()) {
    on<GetListRoom>(_onGetListRoom);
  }

  void _onGetListRoom(
    GetListRoom event,
    Emitter<ListRoomState> emit,
  ) async {
    try {
      emit(state.copyWith(listRoomStatus: ListRoomStatus.loading));
      var token = event.token;
      await Future.delayed(const Duration(seconds: 1));
      final respons = await http.post(
        Uri.parse('$baseUrl$bookingApi'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          'client': event.client,
          'shop_id': event.shopId,
          'is_api': event.isApi.toString(),
          'room_id': event.roomId,
        }),
      );
      final data = jsonDecode(respons.body);

      var message = data['message'];

      try {
        if (data['status'] == 200) {
          var roomDataRes = ListRoomModel.fromJson(data);
          emit(state.copyWith(listRoomModel: roomDataRes));
          emit(state.copyWith(listRoomStatus: ListRoomStatus.succes));
        } else {
          log("ERROR _onGetListRoom 1");

          emit(state.copyWith(listRoomStatus: ListRoomStatus.failed));
          emit(state.copyWith(errorText: message));
          // showLoginSessionExpiredDialog(
          //     context: navigatorKey.currentContext,
          //     okEvent: () {
          //       // handleLogout();
          //       BlocProvider.of<LoginBloc>(navigatorKey.currentContext!)
          //           .add(const LogoutStaff());
          //       // StorageUtils.instance.removeKey(key: 'token_staff');
          //       navigatorKey.currentContext!.go("/staff_sign_in");
          //     });
        }
      } catch (error) {
        log("ERROR _onGetListRoom 2 $error");
        emit(state.copyWith(listRoomStatus: ListRoomStatus.failed));
        emit(state.copyWith(errorText: message));
      }
    } catch (error) {
      log("ERROR _onGetListRoom 3 $error");

      emit(state.copyWith(listRoomStatus: ListRoomStatus.failed));
      emit(state.copyWith(errorText: "Đã có lỗi xảy ra !"));
    }
  }
}
