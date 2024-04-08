import 'dart:convert';
import 'package:app_restaurant/config/text.dart';
import 'package:app_restaurant/config/void_show_dialog.dart';
import 'package:app_restaurant/model/bill/list_bill_model.dart';
import 'package:app_restaurant/routers/app_router_config.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:app_restaurant/env/index.dart';
import 'package:app_restaurant/constant/api/index.dart';
part 'list_bill_shop_state.dart';
part 'list_bill_shop_event.dart';

class ListBillShopBloc extends Bloc<ListBillShopEvent, ListBillShopState> {
  ListBillShopBloc() : super(const ListBillShopState()) {
    on<GetListBillShop>(_onGetListBillShop);
  }
  void _onGetListBillShop(
    GetListBillShop event,
    Emitter<ListBillShopState> emit,
  ) async {
    emit(state.copyWith(listBillShopStatus: ListBillShopStatus.loading));
    await Future.delayed(const Duration(seconds: 1));

    try {
      final respons = await http.post(
        Uri.parse('$baseUrl$listBill'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer ${event.token}"
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
      try {
        if (data['status'] == 200) {
          var listAllBillRes = ListBillShopModel.fromJson(data);
          emit(state.copyWith(listBillShopModel: listAllBillRes));

          emit(state.copyWith(listBillShopStatus: ListBillShopStatus.succes));
        } else {
          print("ERROR LIST BILL 1");

          emit(state.copyWith(listBillShopStatus: ListBillShopStatus.failed));
          showSnackBarTopCustom(
              title: "Thất bại",
              context: navigatorKey.currentContext,
              mess: someThingWrong,
              color: Colors.red);
        }
      } catch (error) {
        print("ERROR LIST BILL 2 $error");

        emit(state.copyWith(listBillShopStatus: ListBillShopStatus.failed));
        emit(state.copyWith(errorText: someThingWrong));
      }
    } catch (error) {
      print("ERROR LIST BILL 3 $error");
      emit(state.copyWith(listBillShopStatus: ListBillShopStatus.failed));
      emit(state.copyWith(errorText: someThingWrong));
    }
  }
}
