import 'dart:convert';
import 'package:app_restaurant/bloc/login/login_bloc.dart';
import 'package:app_restaurant/env/index.dart';
import 'package:app_restaurant/constant/api/index.dart';
import 'package:app_restaurant/routers/app_router_config.dart';
import 'package:app_restaurant/utils/storage.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:app_restaurant/model/list_room_model.dart';
import 'package:go_router/go_router.dart';

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
    try {
      emit(state.copyWith(listRoomStatus: ListRoomStatus.loading));
      await Future.delayed(const Duration(seconds: 1));

      var token = StorageUtils.instance.getString(key: 'token');
      print("TOKEN GET ROOM $token");
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

      // print(" LIST ROOM $data");
      try {
        if (data['status'] == 200) {
          var roomDataRes = ListRoomModel.fromJson(data);
          emit(state.copyWith(listRoomModel: roomDataRes));

          emit(state.copyWith(listRoomStatus: ListRoomStatus.succes));
        } else {
          emit(state.copyWith(listRoomStatus: ListRoomStatus.failed));
          emit(state.copyWith(errorText: message));
          //unauthor thi da ra ngoai dang nhap
          BlocProvider.of<LoginBloc>(navigatorKey.currentContext!)
              .add(const LogoutStaff());
          StorageUtils.instance.removeKey(key: 'auth_staff');
          StorageUtils.instance.removeKey(key: 'staff_infor_data');
          navigatorKey.currentContext?.go("/staff_sign_in");
        }
      } catch (error) {
        print("ERROR GET LIST ROOM $error");
        emit(state.copyWith(listRoomStatus: ListRoomStatus.failed));
        emit(state.copyWith(errorText: message));
        BlocProvider.of<LoginBloc>(navigatorKey.currentContext!)
            .add(const LogoutStaff());
        StorageUtils.instance.removeKey(key: 'auth_staff');
        StorageUtils.instance.removeKey(key: 'staff_infor_data');
        navigatorKey.currentContext?.go("/staff_sign_in");
      }
    } catch (error) {
      print("NO DATA ROOM $error");

      emit(state.copyWith(listRoomStatus: ListRoomStatus.failed));
      emit(state.copyWith(errorText: "Đã có lỗi xảy ra !"));
      BlocProvider.of<LoginBloc>(navigatorKey.currentContext!)
          .add(const LogoutStaff());
      StorageUtils.instance.removeKey(key: 'auth_staff');
      StorageUtils.instance.removeKey(key: 'staff_infor_data');
      navigatorKey.currentContext?.go("/staff_sign_in");
    }
  }
}
