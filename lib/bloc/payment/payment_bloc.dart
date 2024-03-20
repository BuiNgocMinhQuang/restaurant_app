import 'dart:convert';

import 'package:app_restaurant/config/text.dart';
import 'package:app_restaurant/model/bill_infor_model.dart';
import 'package:app_restaurant/model/payment_infor_model.dart';
import 'package:app_restaurant/utils/storage.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:app_restaurant/env/index.dart';
import 'package:app_restaurant/constant/api/index.dart';
part 'payment_state.dart';
part 'payment_event.dart';

class PaymentInforBloc extends Bloc<PaymentInforEvent, PaymentInforState> {
  PaymentInforBloc() : super(const PaymentInforState()) {
    on<GetPaymentInfor>(_onGetPaymentInfor);
  }

  void _onGetPaymentInfor(
    GetPaymentInfor event,
    Emitter<PaymentInforState> emit,
  ) async {
    emit(state.copyWith(paymentStatus: PaymentInforStateStatus.loading));
    await Future.delayed(const Duration(seconds: 1));

    try {
      var token = StorageUtils.instance.getString(key: 'token');
      final respons = await http.post(
        Uri.parse('$baseUrl$showPaymentInfor'),
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
          print("DATA PAYMENT ${data['order']}");

          var paymentInforDataRes = PaymentInforModel.fromJson(data);
          emit(state.copyWith(paymentInforModel: paymentInforDataRes));
          emit(state.copyWith(paymentStatus: PaymentInforStateStatus.succes));
        } else {
          print("ERROR PAYMENT INFOR 1");

          emit(state.copyWith(paymentStatus: PaymentInforStateStatus.failed));
          emit(state.copyWith(errorText: message['text']));
        }
      } catch (error) {
        print("ERROR PAYMENT INFOR 2 $error");

        emit(state.copyWith(paymentStatus: PaymentInforStateStatus.failed));
        emit(state.copyWith(errorText: someThingWrong));
      }
    } catch (error) {
      print("ERROR PAYMENT INFOR 3 $error");
      emit(state.copyWith(paymentStatus: PaymentInforStateStatus.failed));
      emit(state.copyWith(errorText: someThingWrong));
    }
  }
}
