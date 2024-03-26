import 'dart:convert';
import 'package:app_restaurant/config/text.dart';
import 'package:app_restaurant/model/list_food_menu_model.dart';
import 'package:app_restaurant/utils/storage.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:app_restaurant/env/index.dart';
import 'package:app_restaurant/constant/api/index.dart';
part 'menu_food_state.dart';
part 'menu_food_event.dart';

class MenuFoodBloc extends Bloc<GetListFoodMenu, MenuFoodState> {
  MenuFoodBloc() : super(const MenuFoodState()) {
    on<GetListFoodMenu>(_onGetListFoodMenu);
  }
  void _onGetListFoodMenu(
    GetListFoodMenu event,
    Emitter<MenuFoodState> emit,
  ) async {
    emit(state.copyWith(menuFoodStatus: MenuFoodStatus.loading));
    await Future.delayed(const Duration(seconds: 1));
    print("TRUYEN ${{
      {
        'client': event.client,
        'shop_id': event.shopId,
        'is_api': event.isApi.toString(),
        'limit': event.limit,
        'page': event.page,
        'filters': event.filters
      }
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
      var message = data['message'];
      try {
        if (data['status'] == 200) {
          var listMenuFoodRes = ListFoodMenuModel.fromJson(data);
          emit(state.copyWith(listFoodMenuModel: listMenuFoodRes));

          emit(state.copyWith(menuFoodStatus: MenuFoodStatus.succes));
        } else {
          print("ERROR LIST FOOD MENU 1");

          emit(state.copyWith(menuFoodStatus: MenuFoodStatus.failed));
          emit(state.copyWith(errorText: message['text']));
        }
      } catch (error) {
        print("ERROR LIST FOOD MENU 2 $error");

        emit(state.copyWith(menuFoodStatus: MenuFoodStatus.failed));
        emit(state.copyWith(errorText: someThingWrong));
      }
    } catch (error) {
      print("ERROR LIST FOOD MENU3 $error");
      emit(state.copyWith(menuFoodStatus: MenuFoodStatus.failed));
      emit(state.copyWith(errorText: someThingWrong));
    }
  }
}
