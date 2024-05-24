import 'dart:convert';
import 'dart:developer';

import 'package:app_restaurant/config/text.dart';
import 'package:app_restaurant/model/payment_infor_model.dart';
// ignore: depend_on_referenced_packages
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
    on<UpdatePaymentInfor>(_onUpdatePaymentInfor);
    on<ConfirmPayment>(_onConfirmPayment);
  }

  void _onUpdatePaymentInfor(
    UpdatePaymentInfor event,
    Emitter<PaymentInforState> emit,
  ) async {
    emit(state.copyWith(paymentStatus: PaymentInforStateStatus.loading));
    await Future.delayed(const Duration(seconds: 1));

    try {
      var token = event.token;

      final respons = await http.post(
        Uri.parse('$baseUrl$updatePaymentInfor'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          'shop_id': event.shopId,
          'client': event.client,
          'is_api': event.isApi.toString(),
          'order_total': event.orderTotal,
          'order_id': event.orderId,
          'discount': event.discount,
          'guest_pay': event.guestPay,
          'pay_kind': event.payKind,
        }),
      );
      final data = jsonDecode(respons.body);
      var message = data['message'];

      try {
        if (data['status'] == 200) {
          emit(state.copyWith(paymentStatus: PaymentInforStateStatus.succes));
        } else {
          log("ERROR _onUpdatePaymentInfor 1");

          emit(state.copyWith(paymentStatus: PaymentInforStateStatus.failed));
          emit(state.copyWith(errorText: message['text']));
        }
      } catch (error) {
        log("ERROR _onUpdatePaymentInfor 2 $error");

        emit(state.copyWith(paymentStatus: PaymentInforStateStatus.failed));
        emit(state.copyWith(errorText: someThingWrong));
      }
    } catch (error) {
      log("ERROR _onUpdatePaymentInfor 3 $error");
      emit(state.copyWith(paymentStatus: PaymentInforStateStatus.failed));
      emit(state.copyWith(errorText: someThingWrong));
    }
  }

  void _onConfirmPayment(
    ConfirmPayment event,
    Emitter<PaymentInforState> emit,
  ) async {
    emit(state.copyWith(paymentStatus: PaymentInforStateStatus.loading));
    await Future.delayed(const Duration(seconds: 1));

    try {
      var token = event.token;

      final respons = await http.post(
        Uri.parse('$baseUrl$confirmPayment'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          'shop_id': event.shopId,
          'client': event.client,
          'is_api': event.isApi.toString(),
          'order_id': event.orderId,
        }),
      );
      final data = jsonDecode(respons.body);
      try {
        if (data['status'] == 200) {
          emit(state.copyWith(paymentStatus: PaymentInforStateStatus.succes));
        } else {
          log("ERROR _onConfirmPayment  1");

          emit(state.copyWith(paymentStatus: PaymentInforStateStatus.failed));
          emit(state.copyWith(errorText: someThingWrong));
          // showSnackBarTopCustom(
        }
      } catch (error) {
        log("ERROR _onConfirmPayment 2 $error");

        emit(state.copyWith(paymentStatus: PaymentInforStateStatus.failed));
        emit(state.copyWith(errorText: someThingWrong));
      }
    } catch (error) {
      log("ERROR _onConfirmPayment 3 $error");
      emit(state.copyWith(paymentStatus: PaymentInforStateStatus.failed));
      emit(state.copyWith(errorText: someThingWrong));
    }
  }

  void _onGetPaymentInfor(
    GetPaymentInfor event,
    Emitter<PaymentInforState> emit,
  ) async {
    emit(state.copyWith(paymentStatus: PaymentInforStateStatus.loading));
    await Future.delayed(const Duration(seconds: 1));

    try {
      var token = event.token;
      final respons = await http.post(
        Uri.parse('$baseUrl$showPaymentInfor'),
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
          'order_id': event.orderId
        }),
      );
      final data = jsonDecode(respons.body);
      var message = data['message'];
      try {
        if (data['status'] == 200) {
          var paymentInforDataRes = PaymentInforModel.fromJson(data);
          emit(state.copyWith(paymentInforModel: paymentInforDataRes));
          emit(state.copyWith(paymentStatus: PaymentInforStateStatus.succes));
        } else {
          log("ERROR _onGetPaymentInfor 1");

          emit(state.copyWith(paymentStatus: PaymentInforStateStatus.failed));
          emit(state.copyWith(errorText: message['text']));
        }
      } catch (error) {
        log("ERROR _onGetPaymentInfor 2 $error");

        emit(state.copyWith(paymentStatus: PaymentInforStateStatus.failed));
        emit(state.copyWith(errorText: someThingWrong));
      }
    } catch (error) {
      log("ERROR _onGetPaymentInfor 3 $error");
      emit(state.copyWith(paymentStatus: PaymentInforStateStatus.failed));
      emit(state.copyWith(errorText: someThingWrong));
    }
  }
}
