part of 'menu_food_bloc.dart';

abstract class MenuFoodEvent extends Equatable {
  const MenuFoodEvent();
}

class GetListFoodMenu extends MenuFoodEvent {
  final String client;
  final String shopId;
  final bool isApi;
  final int limit;
  final int page;
  final Map<String, int?> filters; //chua bit type

  const GetListFoodMenu(
      {required this.client,
      required this.shopId,
      this.isApi = true,
      required this.limit,
      required this.page,
      required this.filters});

  @override
  List<Object> get props => [];
}
