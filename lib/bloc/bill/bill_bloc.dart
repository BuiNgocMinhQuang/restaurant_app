import 'dart:convert';

import 'package:app_restaurant/config/text.dart';
import 'package:app_restaurant/model/bill_infor_model.dart';
import 'package:app_restaurant/utils/storage.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:app_restaurant/env/index.dart';
import 'package:app_restaurant/constant/api/index.dart';
part 'bill_state.dart';
part 'bill_event.dart';

class BillInforBloc extends Bloc<BillInforEvent, BillInforState> {
  BillInforBloc() : super(const BillInforState()) {
    on<GetBillInfor>(_onGetBillInfor);
    on<AddFoodToBill>(_onAddFoodToBill);
    on<RemoveFoodToBill>(_onRemoveFoodToBill);
  }

  void _onRemoveFoodToBill(
    RemoveFoodToBill event,
    Emitter<BillInforState> emit,
  ) async {
    emit(state.copyWith(billStatus: BillInforStateStatus.loading));
    await Future.delayed(const Duration(seconds: 1));
    try {
      var token = StorageUtils.instance.getString(key: 'token');
      final respons = await http.post(
        Uri.parse('$baseUrl$removeFoodTable'),
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
          'order_id': event.orderId,
          'food_id': event.foodId
        },
      );
      final data = jsonDecode(respons.body);
      print("BILL DATA REMOVE FOOD TO BILL $data");
      var message = data['message'];
      try {
        if (data['status'] == 200) {
          emit(state.copyWith(billStatus: BillInforStateStatus.succes));
        } else {
          print("ERROR REMOVE FOOD TO BILL 1");

          emit(state.copyWith(billStatus: BillInforStateStatus.failed));
          emit(state.copyWith(errorText: message['text']));
        }
      } catch (error) {
        print("ERROR REMOVE FOOD TO BILL 2 $error");

        emit(state.copyWith(billStatus: BillInforStateStatus.failed));
        emit(state.copyWith(errorText: someThingWrong));
      }
    } catch (error) {
      print("ERROR REMOVE FOOD TO BILL 3 $error");
      emit(state.copyWith(billStatus: BillInforStateStatus.failed));
      emit(state.copyWith(errorText: someThingWrong));
    }
  }

  void _onAddFoodToBill(
    AddFoodToBill event,
    Emitter<BillInforState> emit,
  ) async {
    emit(state.copyWith(billStatus: BillInforStateStatus.loading));
    await Future.delayed(const Duration(seconds: 1));
    try {
      var token = StorageUtils.instance.getString(key: 'token');
      final respons = await http.post(
        Uri.parse('$baseUrl$addFoodTable'),
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
          'order_id': event.orderId,
          'food_id': event.foodId
        },
      );
      final data = jsonDecode(respons.body);
      print("BILL DATA ADD FOOD TO BILL $data");
      var message = data['message'];
      try {
        if (data['status'] == 200) {
          emit(state.copyWith(billStatus: BillInforStateStatus.succes));
        } else {
          print("ERROR ADD FOOD TO BILL 1");

          emit(state.copyWith(billStatus: BillInforStateStatus.failed));
          emit(state.copyWith(errorText: message['text']));
        }
      } catch (error) {
        print("ERROR ADD FOOD TO BILL 2 $error");

        emit(state.copyWith(billStatus: BillInforStateStatus.failed));
        emit(state.copyWith(errorText: someThingWrong));
      }
    } catch (error) {
      print("ERROR ADD FOOD TO BILL 3 $error");
      emit(state.copyWith(billStatus: BillInforStateStatus.failed));
      emit(state.copyWith(errorText: someThingWrong));
    }
  }

  void _onGetBillInfor(
    GetBillInfor event,
    Emitter<BillInforState> emit,
  ) async {
    emit(state.copyWith(billStatus: BillInforStateStatus.loading));
    await Future.delayed(const Duration(seconds: 1));

    try {
      var token = StorageUtils.instance.getString(key: 'token');
      print("TOKEN GET TABLE $token");

      final respons = await http.post(
        Uri.parse('$baseUrl$showBillInfor'),
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
      // print("BILL INFOR $data");
      var message = data['message'];
      try {
        if (data['status'] == 200) {
          print("DATA ORDER ${data['order']}");

          var billTableDataRes = BillInforModel.fromJson(data);
          emit(state.copyWith(billInforModel: billTableDataRes));
          emit(state.copyWith(billStatus: BillInforStateStatus.succes));
        } else {
          print("ERROR BILL INFOR 1");

          emit(state.copyWith(billStatus: BillInforStateStatus.failed));
          emit(state.copyWith(errorText: message['text']));
        }
      } catch (error) {
        print("ERROR BILL INFOR 2 $error");

        emit(state.copyWith(billStatus: BillInforStateStatus.failed));
        emit(state.copyWith(errorText: someThingWrong));
      }
    } catch (error) {
      print("ERROR BILL INFOR 3 $error");
      emit(state.copyWith(billStatus: BillInforStateStatus.failed));
      emit(state.copyWith(errorText: someThingWrong));
    }
  }
}