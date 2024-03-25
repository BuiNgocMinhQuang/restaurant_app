import 'dart:convert';

import 'package:app_restaurant/config/text.dart';
import 'package:app_restaurant/config/void_show_dialog.dart';
import 'package:app_restaurant/model/bill_infor_model.dart';
import 'package:app_restaurant/model/brought_receipt/list_brought_receipt_model.dart';
import 'package:app_restaurant/model/brought_receipt/manage_brought_receipt_model.dart';
import 'package:app_restaurant/routers/app_router_config.dart';
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
      'filters': event.filters
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
          var broughtReceiptPageRes = ListBroughtReceiptModel.fromJson(data);
          emit(state.copyWith(listBroughtReceiptModel: broughtReceiptPageRes));
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

class ManageBroughtReceiptBloc
    extends Bloc<BroughtReceiptEvent, BroughtReceiptState> {
  ManageBroughtReceiptBloc() : super(const BroughtReceiptState()) {
    on<GetDetailsBroughtReceipt>(_onGetDetailsBroughtReceipt);
    on<AddFoodToBroughtReceipt>(_onAddFoodToBroughtReceipt);
    on<RemoveFoodToBroughtReceipt>(_onRemoveFoodToBroughtReceipt);
    on<UpdateQuantytiFoodToBroughtReceipt>(
        _onUpdateQuantytiFoodToBroughtReceipt);
  }

  void _onAddFoodToBroughtReceipt(
    AddFoodToBroughtReceipt event,
    Emitter<BroughtReceiptState> emit,
  ) async {
    emit(state.copyWith(broughtReceiptStatus: BroughtReceiptStatus.loading));
    await Future.delayed(const Duration(seconds: 1));
    print("DATA TRUYEN LEN ${{
      'client': event.client,
      'shop_id': event.shopId,
      'is_api': event.isApi,
      'order_id': event.orderId,
      'food_id': event.foodId
    }}");
    try {
      var token = StorageUtils.instance.getString(key: 'token');
      final respons = await http.post(
        Uri.parse('$baseUrl$addFoodToBroughtReceipt'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          'client': event.client,
          'shop_id': event.shopId,
          'is_api': event.isApi,
          'order_id': event.orderId,
          'food_id': event.foodId
        }),
      );
      final data = jsonDecode(respons.body);
      print(" DATA ADD FOOD TO TABLE $data");
      var message = data['message'];
      try {
        if (data['status'] == 200) {
          emit(state.copyWith(
              broughtReceiptStatus: BroughtReceiptStatus.succes));
          showSnackBarTopUpdateSucces(navigatorKey.currentContext);
        } else {
          print("ERROR ADD FOOD TO TABLE 1");

          emit(state.copyWith(
              broughtReceiptStatus: BroughtReceiptStatus.failed));
          emit(state.copyWith(errorText: message['text']));
        }
      } catch (error) {
        print("ERROR ADD FOOD TO TABLE 2 $error");

        emit(state.copyWith(broughtReceiptStatus: BroughtReceiptStatus.failed));
        emit(state.copyWith(errorText: someThingWrong));
      }
    } catch (error) {
      print("ERROR ADD FOOD TO TABLE 3 $error");
      emit(state.copyWith(broughtReceiptStatus: BroughtReceiptStatus.failed));
      emit(state.copyWith(errorText: someThingWrong));
    }
  }

  void _onRemoveFoodToBroughtReceipt(
    RemoveFoodToBroughtReceipt event,
    Emitter<BroughtReceiptState> emit,
  ) async {
    emit(state.copyWith(broughtReceiptStatus: BroughtReceiptStatus.loading));
    await Future.delayed(const Duration(seconds: 1));
    try {
      var token = StorageUtils.instance.getString(key: 'token');
      final respons = await http.post(
        Uri.parse('$baseUrl$removeFoodToBroughtReceipt'),
        headers: {
          // 'Content-type': 'application/json',
          // 'Accept': 'application/json',
          "Authorization": "Bearer $token"
        },
        body: {
          'client': event.client,
          'shop_id': event.shopId,
          'is_api': event.isApi.toString(),
          'order_id': event.orderId,
          'food_id': event.foodId
        },
      );
      final data = jsonDecode(respons.body);
      print(" DATA ADD FOOD TO TABLE $data");
      var message = data['message'];
      try {
        if (data['status'] == 200) {
          emit(state.copyWith(
              broughtReceiptStatus: BroughtReceiptStatus.succes));
          showSnackBarTopUpdateSucces(navigatorKey.currentContext);
        } else {
          print("ERROR ADD FOOD TO TABLE 1");

          emit(state.copyWith(
              broughtReceiptStatus: BroughtReceiptStatus.failed));
          emit(state.copyWith(errorText: message['text']));
        }
      } catch (error) {
        print("ERROR ADD FOOD TO TABLE 2 $error");

        emit(state.copyWith(broughtReceiptStatus: BroughtReceiptStatus.failed));
        emit(state.copyWith(errorText: someThingWrong));
      }
    } catch (error) {
      print("ERROR ADD FOOD TO TABLE 3 $error");
      emit(state.copyWith(broughtReceiptStatus: BroughtReceiptStatus.failed));
      emit(state.copyWith(errorText: someThingWrong));
    }
  }

  void _onUpdateQuantytiFoodToBroughtReceipt(
    UpdateQuantytiFoodToBroughtReceipt event,
    Emitter<BroughtReceiptState> emit,
  ) async {
    emit(state.copyWith(broughtReceiptStatus: BroughtReceiptStatus.loading));
    await Future.delayed(const Duration(seconds: 1));
    try {
      var token = StorageUtils.instance.getString(key: 'token');
      final respons = await http.post(
        Uri.parse('$baseUrl$updateQuantityFoodBroughtReceipt'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          'client': event.client,
          'shop_id': event.shopId,
          'is_api': event.isApi.toString(),
          'order_id': event.orderId,
          'food_id': event.foodId,
          'value': event.value
        }),
      );
      final data = jsonDecode(respons.body);
      print("UPDATE QUANTYTI FODD TO BILL $data");
      var message = data['message'];
      try {
        if (data['status'] == 200) {
          emit(state.copyWith(
              broughtReceiptStatus: BroughtReceiptStatus.succes));
          showSnackBarTopUpdateSucces(navigatorKey.currentContext);
        } else {
          print("ERROR UPDATE QUANTYTI FODD TO BILL 1");

          emit(state.copyWith(
              broughtReceiptStatus: BroughtReceiptStatus.failed));
          emit(state.copyWith(errorText: message['text']));
        }
      } catch (error) {
        print("ERROR UPDATE QUANTYTI FODD BILL 2 $error");

        emit(state.copyWith(broughtReceiptStatus: BroughtReceiptStatus.failed));
        emit(state.copyWith(errorText: someThingWrong));
      }
    } catch (error) {
      print("ERROR UPDATE QUANTYTI FODD BILL 3 $error");
      emit(state.copyWith(broughtReceiptStatus: BroughtReceiptStatus.failed));
      emit(state.copyWith(errorText: someThingWrong));
    }
  }

  void _onGetDetailsBroughtReceipt(
    GetDetailsBroughtReceipt event,
    Emitter<BroughtReceiptState> emit,
  ) async {
    emit(state.copyWith(broughtReceiptStatus: BroughtReceiptStatus.loading));
    await Future.delayed(const Duration(seconds: 1));
    print("DATA TRUYEN LEN ${{
      'client': event.client,
      'shop_id': event.shopId,
      'is_api': event.isApi.toString(),
      'limit': event.limit,
      'page': event.page,
      'filters': event.filters,
      'order_id': event.orderId
    }}");
    try {
      var token = StorageUtils.instance.getString(key: 'token');
      final respons = await http.post(
        Uri.parse('$baseUrl$getListFoodBroughtReceipt'),
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
          'filters': event.filters,
          'order_id': event.orderId
        }),
      );
      final data = jsonDecode(respons.body);
      var message = data['message'];
      try {
        if (data['status'] == 200) {
          var detailsBroughtReceiptRes =
              ManageBroughtReceiptModel.fromJson(data);
          emit(state.copyWith(
              manageBroughtReceiptModel: detailsBroughtReceiptRes));
          emit(state.copyWith(
              broughtReceiptStatus: BroughtReceiptStatus.succes));
        } else {
          print("ERROR BROUGHT RECEIPT PAGE 1");

          emit(state.copyWith(
              broughtReceiptStatus: BroughtReceiptStatus.failed));
          emit(state.copyWith(errorText: message['text']));
        }
      } catch (error) {
        print("ERROR BROUGHT RECEIPT PAGE 2 $error");

        emit(state.copyWith(broughtReceiptStatus: BroughtReceiptStatus.failed));
        emit(state.copyWith(errorText: someThingWrong));
      }
    } catch (error) {
      print("ERROR BROUGHT RECEIPT PAGE 3 $error");
      emit(state.copyWith(broughtReceiptStatus: BroughtReceiptStatus.failed));
      emit(state.copyWith(errorText: someThingWrong));
    }
  }
}
