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
import 'package:app_restaurant/model/list_room_model.dart';

part 'list_room_state.dart';
part 'list_room_event.dart';

class ListRoomBloc extends Bloc<ListRoomEvent, ListRoomState> {
  ListRoomBloc() : super(const ListRoomState()) {
    on<ListRoomInit>(_onListRoomInit);
    on<GetListRoom>(_onGetListRoom);
  }

  void _onListRoomInit(
    ListRoomInit event,
    Emitter<ListRoomState> emit,
  ) async {}

  void _onGetListRoom(
    GetListRoom event,
    Emitter<ListRoomState> emit,
  ) async {
    print("ASSYNSCC");

    emit(state.copyWith(listRoomStatus: ListRoomStatus.loading));
    var token = StorageUtils.instance.getString(key: 'token');
    print("TOKEN DAY R $token");
    final respons = await http.post(
      Uri.parse('$baseUrl$bookingApi'),
      headers: {
        // 'Content-type': 'application/json',
        // 'Accept': 'application/json',
        "Authorization": "Bearer $token"
      },
      body: {
        'client': event.client,
        'shop_id': event.shopId,
        'is_api': event.isApi.toString(),
        'room_id': event.roomId,
      },
    );
    final data = jsonDecode(respons.body);
    var message = data['message'];

    print("DATA ROOM $data");
    try {
      if (data['status'] == 200) {
        var roomDataRes = ListRoomModel.fromJson(data);
        emit(state.copyWith(listRoomModel: roomDataRes));
        emit(state.copyWith(listRoomStatus: ListRoomStatus.succes));
      } else {
        emit(state.copyWith(listRoomStatus: ListRoomStatus.failed));
        emit(state.copyWith(errorText: message['text']));
      }
    } catch (error) {
      emit(state.copyWith(listRoomStatus: ListRoomStatus.failed));
      emit(state.copyWith(errorText: message['text']));
    }
  }
}
