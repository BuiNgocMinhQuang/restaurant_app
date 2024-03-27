import 'dart:convert';

import 'package:app_restaurant/config/text.dart';
import 'package:app_restaurant/config/void_show_dialog.dart';
import 'package:app_restaurant/model/bill/list_bill_model.dart';
import 'package:app_restaurant/routers/app_router_config.dart';
import 'package:app_restaurant/utils/storage.dart';
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
      var token = StorageUtils.instance.getString(key: 'token');
      final respons = await http.post(
        Uri.parse('$baseUrl$listBill'),
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
      // print("UPDATE QUANTYTI FODD TO BILL $data");

      try {
        if (data['status'] == 200) {
          var listAllBillRes = ListBillShopModel.fromJson(data);
          emit(state.copyWith(listBillShopModel: listAllBillRes));

          emit(state.copyWith(listBillShopStatus: ListBillShopStatus.succes));
          // showSnackBarTopCustom(
          //     context: navigatorKey.currentContext,
          //     mess: someThingWrong,
          //     color: Colors.green);
        } else {
          print("ERROR UPDATE QUANTYTI FODD TO BILL 1");

          emit(state.copyWith(listBillShopStatus: ListBillShopStatus.failed));
          showSnackBarTopCustom(
              context: navigatorKey.currentContext,
              mess: someThingWrong,
              color: Colors.red);
        }
      } catch (error) {
        print("ERROR UPDATE QUANTYTI FODD BILL 2 $error");

        emit(state.copyWith(listBillShopStatus: ListBillShopStatus.failed));
        emit(state.copyWith(errorText: someThingWrong));
      }
    } catch (error) {
      print("ERROR UPDATE QUANTYTI FODD BILL 3 $error");
      emit(state.copyWith(listBillShopStatus: ListBillShopStatus.failed));
      emit(state.copyWith(errorText: someThingWrong));
    }
  }
}
