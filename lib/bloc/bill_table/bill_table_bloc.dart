import 'dart:convert';
import 'dart:developer';
import 'package:app_restaurant/config/text.dart';
import 'package:app_restaurant/model/bill_infor_model.dart';
// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:app_restaurant/env/index.dart';
import 'package:app_restaurant/constant/api/index.dart';
part 'bill_table_state.dart';
part 'bill_table_event.dart';

class BillInforBloc extends Bloc<BillInforEvent, BillInforState> {
  BillInforBloc() : super(const BillInforState()) {
    on<GetBillInfor>(_onGetBillInfor);
  }

  void _onGetBillInfor(
    GetBillInfor event,
    Emitter<BillInforState> emit,
  ) async {
    emit(state.copyWith(billStatus: BillInforStateStatus.loading));
    await Future.delayed(const Duration(seconds: 1));

    try {
      var token = event.token;
      final respons = await http.post(
        Uri.parse('$baseUrl$showBillInfor'),
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
      try {
        if (data['status'] == 200) {
          var billTableDataRes = BillInforModel.fromJson(data);
          emit(state.copyWith(billInforModel: billTableDataRes));
          emit(state.copyWith(billStatus: BillInforStateStatus.succes));
        } else {
          log("ERROR _onGetBillInfor 1");
          emit(state.copyWith(billStatus: BillInforStateStatus.failed));
          emit(state.copyWith(errorText: someThingWrong));
        }
      } catch (error) {
        log("ERROR _onGetBillInfor 2 $error");

        emit(state.copyWith(billStatus: BillInforStateStatus.failed));
        emit(state.copyWith(errorText: someThingWrong));
      }
    } catch (error) {
      log("ERROR _onGetBillInfor 3 $error");
      emit(state.copyWith(billStatus: BillInforStateStatus.failed));
      emit(state.copyWith(errorText: someThingWrong));
    }
  }
}
