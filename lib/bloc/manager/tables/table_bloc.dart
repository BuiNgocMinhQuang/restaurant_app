import 'dart:convert';
import 'dart:developer';
import 'package:app_restaurant/config/text.dart';
import 'package:app_restaurant/model/food_table_data_model.dart';
import 'package:app_restaurant/model/switch_table_data_model.dart';
import 'package:app_restaurant/model/table_model.dart';
import 'package:app_restaurant/utils/storage.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:app_restaurant/env/index.dart';
import 'package:app_restaurant/constant/api/index.dart';
part 'table_state.dart';
part 'table_event.dart';

class TableCancleBloc extends Bloc<TableCancleEvent, TableCancleState> {
  TableCancleBloc() : super(const TableCancleState()) {
    on<CancleTable>(_onCancleTable);
  }
  void _onCancleTable(
    CancleTable event,
    Emitter<TableCancleState> emit,
  ) async {
    emit(state.copyWith(tableCancleStatus: TableCancleStatus.loading));

    try {
      // var token = StorageUtils.instance.getString(key: 'token_staff');
      var token = event.token;
      final respons = await http.post(
        Uri.parse('$baseUrl$cancleTable'),
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
          'table_id': event.tableId,
          'order_id': event.orderId,
          'cancellation_reason': event.cancellationReason
        }),
      );
      final data = jsonDecode(respons.body);
      var message = data['message'];

      try {
        if (data['status'] == 200) {
          emit(state.copyWith(tableCancleStatus: TableCancleStatus.succes));
        } else {
          print("ERROR Cancle Table 1");

          emit(state.copyWith(tableCancleStatus: TableCancleStatus.failed));
          emit(state.copyWith(errorText: message['text']));
        }
      } catch (error) {
        print("ERROR Cancle Table 2 $error");

        emit(state.copyWith(tableCancleStatus: TableCancleStatus.failed));
        emit(state.copyWith(errorText: someThingWrong));
      }
    } catch (error) {
      print("ERROR Cancle Table 3 $error");
      emit(state.copyWith(tableCancleStatus: TableCancleStatus.failed));
      emit(state.copyWith(errorText: someThingWrong));
    }
  }
}

class TableBloc extends Bloc<TableEvent, TableState> {
  TableBloc() : super(const TableState()) {
    on<GetTableInfor>(_onGetTableInfor);
    on<GetTableFoods>(_onGetTableFoods);
    on<GetTableSwitchInfor>(_onGetSwitchTableInfor);
  }

  void _onGetSwitchTableInfor(
    GetTableSwitchInfor event,
    Emitter<TableState> emit,
  ) async {
    emit(state.copyWith(tableStatus: TableStatus.loading));
    await Future.delayed(const Duration(seconds: 1));

    try {
      // var token = StorageUtils.instance.getString(key: 'token_staff');
      var token = event.token;
      final respons = await http.post(
        Uri.parse('$baseUrl$getSwitchTable'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          'client': event.client,
          'shop_id': event.shopId,
          'is_api': event.isApi,
          'room_id': event.roomId,
          'table_id': event.tableId,
          'order_id': event.orderId
        }),
      );
      final data = jsonDecode(respons.body);
      print(event.roomId);
      print("DATA SWITCH $data");
      var message = data['message'];
      try {
        emit(state.copyWith(currentRoomId: event.roomId));
        if (data['status'] == 200) {
          print("DATA SWITCH $data");

          var switchTableDataRes = SwitchTableDataModel.fromJson(data);
          emit(state.copyWith(switchTableDataModel: switchTableDataRes));
          emit(state.copyWith(tableStatus: TableStatus.succes));
        } else {
          print("ERROR SWITCH TABLE  1");

          emit(state.copyWith(tableStatus: TableStatus.failed));
          emit(state.copyWith(errorText: message['text']));
        }
      } catch (error) {
        print("ERROR SWITCH TABLE 2  $error");

        emit(state.copyWith(tableStatus: TableStatus.failed));
        emit(state.copyWith(errorText: someThingWrong));
      }
    } catch (error) {
      print("ERROR SWITCH TABLE 2 $error");
      emit(state.copyWith(tableStatus: TableStatus.failed));
      emit(state.copyWith(errorText: someThingWrong));
    }
  }

  void _onGetTableInfor(
    GetTableInfor event,
    Emitter<TableState> emit,
  ) async {
    emit(state.copyWith(tableStatus: TableStatus.loading));

    await Future.delayed(const Duration(seconds: 1));

    try {
      var token = event.token;

      final respons = await http.post(
        Uri.parse('$baseUrl$tableApi'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": 'Bearer $token'
        },
        body: jsonEncode({
          'client': event.client,
          'shop_id': event.shopId,
          'is_api': true,
          'room_id': event.roomId,
          'table_id': event.tableId,
          'order_id': event.orderID,
        }),
      );
      final data = jsonDecode(respons.body);
      var message = data['message'];
      print("DATA Table $data");

      try {
        if (data['status'] == 200) {
          // print("DATA Table $data");

          var tableDataRes = TableModel.fromJson(data);

          emit(state.copyWith(tableModel: tableDataRes));

          StorageUtils.instance.setStringList(
              key: 'food_kinds_list',
              val: tableDataRes.foodKinds ?? []); //luu danh muc thuc an

          emit(state.copyWith(tableStatus: TableStatus.succes));
        } else {
          print("ERROR TABLE INFOR danhjdba");

          emit(state.copyWith(tableStatus: TableStatus.failed));
          emit(state.copyWith(errorText: message['text']));
        }
      } catch (error) {
        print("ERROR TABLE INFOR1111 $error");

        emit(state.copyWith(tableStatus: TableStatus.failed));
        emit(state.copyWith(errorText: someThingWrong));
      }
    } catch (error) {
      print("ERROR TABLE INFOR222 $error");
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
    try {
      // var token = StorageUtils.instance.getString(key: 'token_staff');
      var token = event.token;
      final respons = await http.post(
        Uri.parse('$baseUrl$foodsTableApi'),
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
          'table_id': event.tableId,
          'limit': event.limit,
          'page': event.page
        }),
      );
      final data = jsonDecode(respons.body);
      try {
        if (data['status'] == 200) {
          var foodTableDataRes = FoodTableDataModel.fromJson(data);

          emit(state.copyWith(foodTableDataModel: foodTableDataRes));
          emit(state.copyWith(tableStatus: TableStatus.succes));
        } else {
          print("ERROR DATA FOOD TABLE 1 ${data}");

          emit(state.copyWith(tableStatus: TableStatus.failed));
        }
      } catch (error) {
        print("ERROR DATA FOOD TABLE 2 ${error}");

        emit(state.copyWith(tableStatus: TableStatus.failed));
      }
    } catch (error) {
      print("ERROR DATA FOOD TABLE 3 $error");

      emit(state.copyWith(tableStatus: TableStatus.failed));
    }
  }
}

class TableSaveInforBloc
    extends Bloc<TableSaveInforEvent, TableSaveInforState> {
  TableSaveInforBloc() : super(const TableSaveInforState()) {
    on<SaveTableInfor>(_onSaveInforTable);
  }
  void _onSaveInforTable(
    SaveTableInfor event,
    Emitter<TableSaveInforState> emit,
  ) async {
    emit(state.copyWith(tableSaveInforStatus: TableSaveInforStatus.loading));

    try {
      // var token = StorageUtils.instance.getString(key: 'token_staff');
      var token = event.token;

      final respons = await http.post(
        Uri.parse('$baseUrl$saveInforTable'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          'client': event.client,
          'shop_id': event.shopId,
          'is_api': event.isApi,
          'room_id': event.roomId,
          'table_id': event.tableId,
          'client_name': event.clientName,
          'client_phone': event.clientPhone,
          'note': event.note,
          'end_date': event.endDate,
          'tables': event.tables,
        }),
      );
      final data = jsonDecode(respons.body);
      var message = data['message'];
      try {
        if (data['status'] == 200) {
          print("REQUESTTTT ${data}");

          emit(state.copyWith(
              tableSaveInforStatus: TableSaveInforStatus.succes));
        } else {
          print("ERROR Save Infor Table 1");

          emit(state.copyWith(
              tableSaveInforStatus: TableSaveInforStatus.failed));

          emit(state.copyWith(errorText: message['text']));
        }
      } catch (error) {
        print("ERROR Save Infor Table 2 $error");

        emit(state.copyWith(tableSaveInforStatus: TableSaveInforStatus.failed));
        emit(state.copyWith(errorText: someThingWrong));
      }
    } catch (error) {
      print("ERROR Save Infor Table 3 $error");
      emit(state.copyWith(tableSaveInforStatus: TableSaveInforStatus.failed));

      emit(state.copyWith(errorText: someThingWrong));
    }
  }
}

class SwitchTableBloc extends Bloc<SwitchTableEvent, SwitchTableState> {
  SwitchTableBloc() : super(const SwitchTableState()) {
    on<HandleSwitchTable>(_onHandleSwitchTable);
  }
  void _onHandleSwitchTable(
    HandleSwitchTable event,
    Emitter<SwitchTableState> emit,
  ) async {
    emit(state.copyWith(switchtableStatus: SwitchTableStatus.loading));

    try {
      // var token = StorageUtils.instance.getString(key: 'token_staff');
      var token = event.token;
      final respons = await http.post(
        Uri.parse('$baseUrl$handleSwitchTable'),
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
          'table_id': event.tableId,
          'order_id': event.orderId,
          'select_tables': event.selectedTableId
        }),
      );
      final data = jsonDecode(respons.body);
      var message = data['message'];
      print("DATA HANDLE  SWITCH Table $data");

      try {
        if (data['status'] == 200) {
          emit(state.copyWith(switchtableStatus: SwitchTableStatus.succes));
        } else {
          print("ERROR HANDLE  SWITCH  Table 1");

          emit(state.copyWith(switchtableStatus: SwitchTableStatus.failed));
          emit(state.copyWith(errorText: message['text']));
        }
      } catch (error) {
        print("ERROR HANDLE  SWITCH  Table 2 $error");

        emit(state.copyWith(switchtableStatus: SwitchTableStatus.failed));
        emit(state.copyWith(errorText: someThingWrong));
      }
    } catch (error) {
      print("ERROR HANDLE  SWITCH  Table 3 $error");
      emit(state.copyWith(switchtableStatus: SwitchTableStatus.failed));
      emit(state.copyWith(errorText: someThingWrong));
    }
  }
}
