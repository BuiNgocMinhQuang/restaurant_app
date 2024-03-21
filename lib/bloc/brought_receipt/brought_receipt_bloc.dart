import 'dart:convert';

import 'package:app_restaurant/config/text.dart';
import 'package:app_restaurant/model/bill_infor_model.dart';
import 'package:app_restaurant/model/brought_receipt/brought_receipt_model.dart';
import 'package:app_restaurant/utils/storage.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:app_restaurant/env/index.dart';
import 'package:app_restaurant/constant/api/index.dart';
part 'brought_receipt_state.dart';
part 'brought_receipt_event.dart';

class BroughtReceiptBloc
    extends Bloc<GetListBroughtReceipt, BroughtReceiptPageState> {
  BroughtReceiptBloc() : super(const BroughtReceiptPageState()) {
    on<GetListBroughtReceipt>(_onGetListBroughtReceipt);
  }
  void _onGetListBroughtReceipt(
    GetListBroughtReceipt event,
    Emitter<BroughtReceiptPageState> emit,
  ) async {
    emit(state.copyWith(
        broughtReceiptPageStatus: BroughtReceiptPageStatus.loading));
    await Future.delayed(const Duration(seconds: 1));
    print("DATA TRUYEN LEN ${{
      'client': event.client,
      'shop_id': event.shopId,
      'is_api': event.isApi.toString(),
      'limit': event.limit,
      'page': event.page,
      'filters': event.filters,
    }}");
    try {
      var token = StorageUtils.instance.getString(key: 'token');
      final respons = await http.post(
        Uri.parse('$baseUrl$getListBroughtReceipt'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          'client': event.client,
          'shop_id': event.shopId,
          'is_api': event.isApi.toString(),
          'limit': event.limit,
          'page': event.page,
          'filters': event.filters
        }),
      );
      final data = jsonDecode(respons.body);
      print("BROUGHT RECEIPT PAGE  $data");
      var message = data['message'];
      try {
        if (data['status'] == 200) {
          var broughtReceiptPageRes = BroughtReceiptModel.fromJson(data);
          emit(state.copyWith(broughtReceiptModel: broughtReceiptPageRes));
          emit(state.copyWith(
              broughtReceiptPageStatus: BroughtReceiptPageStatus.succes));
        } else {
          print("ERROR BROUGHT RECEIPT PAGE 1");

          emit(state.copyWith(
              broughtReceiptPageStatus: BroughtReceiptPageStatus.failed));
          emit(state.copyWith(errorText: message['text']));
        }
      } catch (error) {
        print("ERROR BROUGHT RECEIPT PAGE 2 $error");

        emit(state.copyWith(
            broughtReceiptPageStatus: BroughtReceiptPageStatus.failed));
        emit(state.copyWith(errorText: someThingWrong));
      }
    } catch (error) {
      print("ERROR BROUGHT RECEIPT PAGE 3 $error");
      emit(state.copyWith(
          broughtReceiptPageStatus: BroughtReceiptPageStatus.failed));
      emit(state.copyWith(errorText: someThingWrong));
    }
  }
}
