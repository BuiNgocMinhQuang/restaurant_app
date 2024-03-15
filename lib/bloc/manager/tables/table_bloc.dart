import 'dart:convert';

import 'package:app_restaurant/config/text.dart';
import 'package:app_restaurant/model/table_model.dart';
import 'package:app_restaurant/utils/storage.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:app_restaurant/env/index.dart';
import 'package:app_restaurant/constant/api/index.dart';
part 'table_state.dart';
part 'table_event.dart';

class TableBloc extends Bloc<TableEvent, TableState> {
  TableBloc() : super(const TableState()) {
    on<GetTableInfor>(_onGetTableInfor);
    on<GetTableFoods>(_onGetTableFoods);
  }

  void _onGetTableInfor(
    GetTableInfor event,
    Emitter<TableState> emit,
  ) async {
    emit(state.copyWith(tableStatus: TableStatus.loading));

    await Future.delayed(const Duration(seconds: 1));

    try {
      var token = StorageUtils.instance.getString(key: 'token');
      print("TOKEN GET TABLE $token");

      final respons = await http.post(
        Uri.parse('$baseUrl$tableApi'),
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
          'table_id': event.tableId
        },
      );
      final data = jsonDecode(respons.body);
      var message = data['message'];
      print("DATA Table $data");
      try {
        if (data['status'] == 200) {
          var tableDataRes = TableModel.fromJson(data);
          emit(state.copyWith(tableModel: tableDataRes));
          emit(state.copyWith(tableStatus: TableStatus.succes));
        } else {
          emit(state.copyWith(tableStatus: TableStatus.failed));
          emit(state.copyWith(errorText: message['text']));
        }
      } catch (error) {
        emit(state.copyWith(tableStatus: TableStatus.failed));
        emit(state.copyWith(errorText: someThingWrong));
      }
    } catch (error) {
      print("ERROR TABLE INFOR $error");
      emit(state.copyWith(tableStatus: TableStatus.failed));
      emit(state.copyWith(errorText: someThingWrong));
    }
  }

  void _onGetTableFoods(
    GetTableFoods event,
    Emitter<TableState> emit,
  ) async {
    emit(state.copyWith(tableStatus: TableStatus.loading));
    await Future.delayed(const Duration(seconds: 1));

    var token = StorageUtils.instance.getString(key: 'token');
    print("TOKEN GET TABLE FOOD $token");

    final respons = await http.post(
      Uri.parse('$baseUrl$foodsTableApi'),
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
        'table_id': event.tableId,
        'limit': event.limit
      },
    );
    final data = jsonDecode(respons.body);
    var message = data['message'];
    print("DATA MENU TABLE $data");
  }
}
