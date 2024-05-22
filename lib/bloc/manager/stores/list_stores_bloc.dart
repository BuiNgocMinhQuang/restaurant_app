import 'dart:convert';
import 'dart:developer';
import 'package:app_restaurant/env/index.dart';
import 'package:app_restaurant/constant/api/index.dart';
import 'package:app_restaurant/model/manager/manager_list_store_model.dart';
import 'package:app_restaurant/utils/storage.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
part 'list_stores_state.dart';
part 'list_stores_event.dart';

class ListStoresBloc extends Bloc<ListStoresEvent, ListStoresState> {
  ListStoresBloc() : super(const ListStoresState()) {
    on<GetListStores>(_onGetListStores);
  }

  void _onGetListStores(
    GetListStores event,
    Emitter<ListStoresState> emit,
  ) async {
    try {
      emit(state.copyWith(listStoresStatus: ListStoresStatus.loading));
      var token = StorageUtils.instance.getString(key: 'token_manager');

      await Future.delayed(const Duration(seconds: 1));
      final responseListStore = await http.post(
        Uri.parse('$baseUrl$managerGetListStores'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );
      final dataListStore = jsonDecode(responseListStore.body);
      log("dataListStore $dataListStore");
      try {
        if (dataListStore['status'] == 200) {
          var listStoreManagerDataRes = ListStoreModel.fromJson(dataListStore);
          emit(state.copyWith(listStoreModel: listStoreManagerDataRes));
          emit(state.copyWith(listStoresStatus: ListStoresStatus.succes));
        } else {
          log("ERRRO GET LIST STORE 111111");
          emit(state.copyWith(listStoresStatus: ListStoresStatus.failed));
        }
      } catch (error) {
        log("ERRRO GET LIST STORE $error");
        emit(state.copyWith(listStoresStatus: ListStoresStatus.failed));
      }
    } catch (error) {
      log("NO DATA ROOM $error");

      emit(state.copyWith(listStoresStatus: ListStoresStatus.failed));

      emit(state.copyWith(errorText: "Đã có lỗi xảy ra !"));
    }
  }
}
