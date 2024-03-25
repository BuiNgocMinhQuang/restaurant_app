import 'dart:convert';

import 'package:app_restaurant/config/text.dart';
import 'package:app_restaurant/config/void_show_dialog.dart';
import 'package:app_restaurant/model/food_table_data_model.dart';
import 'package:app_restaurant/model/switch_table_data_model.dart';

import 'package:app_restaurant/model/table_model.dart';
import 'package:app_restaurant/routers/app_router_config.dart';
import 'package:app_restaurant/utils/storage.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
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
      var token = StorageUtils.instance.getString(key: 'token');

      final respons = await http.post(
        Uri.parse('$baseUrl$cancleTable'),
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
          'cancellation_reason': event.cancellationReason
        },
      );
      final data = jsonDecode(respons.body);
      var message = data['message'];

      try {
        if (data['status'] == 200) {
          // print("DATA Cancle Table $data");

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
    on<AddFoodToTable>(_onAddFoodToTable);
    on<RemoveFoodToTable>(_onRemoveFoodToTable);
    on<UpdateQuantytiFoodToTable>(_onUpdateQuantytiFoodToTable);
  }

  void _onAddFoodToTable(
    AddFoodToTable event,
    Emitter<TableState> emit,
  ) async {
    emit(state.copyWith(tableStatus: TableStatus.loading));
    await Future.delayed(const Duration(seconds: 1));
    print("DAT TRUYEN ${{
      'client': event.client,
      'shop_id': event.shopId,
      'is_api': event.isApi.toString(),
      'room_id': event.roomId,
      'table_id': event.tableId,
      'order_id': event.orderId,
      'food_id': event.foodId
    }}");
    try {
      var token = StorageUtils.instance.getString(key: 'token');
      final respons = await http.post(
        Uri.parse('$baseUrl$addFoodTable'),
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
          'order_id': event.orderId,
          'food_id': event.foodId
        }),
      );
      final data = jsonDecode(respons.body);
      print(" DATA ADD FOOD TO TABLE $data");
      final message = data['message'];

      try {
        if (data['status'] == 200) {
          emit(state.copyWith(tableStatus: TableStatus.succes));
          showSnackBarTopCustom(
              context: navigatorKey.currentContext,
              mess: message['title'],
              color: Colors.green);
        } else {
          print("ERROR ADD FOOD TO TABLE 1");

          emit(state.copyWith(tableStatus: TableStatus.failed));
          emit(state.copyWith(errorText: someThingWrong));
          showSnackBarTopCustom(
              context: navigatorKey.currentContext,
              mess: message['text'],
              color: Colors.red);
        }
      } catch (error) {
        print("ERROR ADD FOOD TO TABLE 2 $error");

        emit(state.copyWith(tableStatus: TableStatus.failed));
        emit(state.copyWith(errorText: someThingWrong));
      }
    } catch (error) {
      print("ERROR ADD FOOD TO TABLE 3 $error");
      emit(state.copyWith(tableStatus: TableStatus.failed));
      emit(state.copyWith(errorText: someThingWrong));
    }
  }

  void _onRemoveFoodToTable(
    RemoveFoodToTable event,
    Emitter<TableState> emit,
  ) async {
    emit(state.copyWith(tableStatus: TableStatus.loading));
    await Future.delayed(const Duration(seconds: 1));
    try {
      var token = StorageUtils.instance.getString(key: 'token');
      final respons = await http.post(
        Uri.parse('$baseUrl$removeFoodTable'),
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
          'food_id': event.foodId
        }),
      );
      final data = jsonDecode(respons.body);
      final message = data['message'];
      print(" DATA ADD FOOD TO TABLE $data");
      try {
        if (data['status'] == 200) {
          emit(state.copyWith(tableStatus: TableStatus.succes));
          showSnackBarTopUpdateSucces(navigatorKey.currentContext);
          showSnackBarTopCustom(
              context: navigatorKey.currentContext,
              mess: message['title'],
              color: Colors.green);
        } else {
          print("ERROR ADD FOOD TO TABLE 1");

          emit(state.copyWith(tableStatus: TableStatus.failed));
          emit(state.copyWith(errorText: someThingWrong));
          showSnackBarTopCustom(
              context: navigatorKey.currentContext,
              mess: message['text'],
              color: Colors.red);
        }
      } catch (error) {
        print("ERROR ADD FOOD TO TABLE 2 $error");

        emit(state.copyWith(tableStatus: TableStatus.failed));
        emit(state.copyWith(errorText: someThingWrong));
      }
    } catch (error) {
      print("ERROR ADD FOOD TO TABLE 3 $error");
      emit(state.copyWith(tableStatus: TableStatus.failed));
      emit(state.copyWith(errorText: someThingWrong));
    }
  }

  void _onUpdateQuantytiFoodToTable(
    UpdateQuantytiFoodToTable event,
    Emitter<TableState> emit,
  ) async {
    emit(state.copyWith(tableStatus: TableStatus.loading));
    await Future.delayed(const Duration(seconds: 1));
    try {
      var token = StorageUtils.instance.getString(key: 'token');
      final respons = await http.post(
        Uri.parse('$baseUrl$updateQuantityFoodTable'),
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
          'food_id': event.foodId,
          'value': event.value
        }),
      );
      final data = jsonDecode(respons.body);
      final message = data['message'];

      try {
        if (data['status'] == 200) {
          emit(state.copyWith(tableStatus: TableStatus.succes));
          showSnackBarTopCustom(
              context: navigatorKey.currentContext,
              mess: message['title'],
              color: Colors.green);
        } else {
          print("ERROR UPDATE QUANTYTI FODD TO BILL 1");
          emit(state.copyWith(tableStatus: TableStatus.failed));
          emit(state.copyWith(errorText: someThingWrong));
          showSnackBarTopCustom(
              context: navigatorKey.currentContext,
              mess: message['text'],
              color: Colors.red);
        }
      } catch (error) {
        print("ERROR UPDATE QUANTYTI FODD BILL 2 $error");

        emit(state.copyWith(tableStatus: TableStatus.failed));
        emit(state.copyWith(errorText: someThingWrong));
      }
    } catch (error) {
      print("ERROR UPDATE QUANTYTI FODD BILL 3 $error");
      emit(state.copyWith(tableStatus: TableStatus.failed));
      emit(state.copyWith(errorText: someThingWrong));
    }
  }

  void _onGetSwitchTableInfor(
    GetTableSwitchInfor event,
    Emitter<TableState> emit,
  ) async {
    emit(state.copyWith(tableStatus: TableStatus.loading));
    await Future.delayed(const Duration(seconds: 1));

    try {
      var token = StorageUtils.instance.getString(key: 'token');
      print("TOKEN GET TABLE $token");

      final respons = await http.post(
        Uri.parse('$baseUrl$getSwitchTable'),
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
          'order_id': event.orderId
        },
      );
      final data = jsonDecode(respons.body);
      print("DATA SWITCH $data");
      var message = data['message'];
      try {
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
      var token = StorageUtils.instance.getString(key: 'token');
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
          'limit': event.limit,
          'page': event.page
        },
      );
      final data = jsonDecode(respons.body);

      try {
        if (data['status'] == 200) {
          print("DATA FOOD TABLE ${data['booking']}");
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
      var token = StorageUtils.instance.getString(key: 'token');

      print('DATA SEND ${{
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
      }}');

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
      var token = StorageUtils.instance.getString(key: 'token');
      print("CAI DONG TRUYEN ZO");
      print("${{
        'client': event.client,
        'shop_id': event.shopId,
        'is_api': event.isApi.toString(),
        'room_id': event.roomId,
        'table_id': event.tableId,
        'order_id': event.orderId,
        'select_tables': event.selectedTableId
      }}");

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
