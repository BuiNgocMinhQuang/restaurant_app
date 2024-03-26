part of 'menu_food_bloc.dart';

class MenuFoodState extends Equatable {
  const MenuFoodState({
    this.errorText,
    this.menuFoodStatus,
    this.listFoodMenuModel,
  });

  final String? errorText;
  final MenuFoodStatus? menuFoodStatus;
  final ListFoodMenuModel? listFoodMenuModel;

  MenuFoodState copyWith(
      {String? errorText,
      MenuFoodStatus? menuFoodStatus,
      ListFoodMenuModel? listFoodMenuModel}) {
    return MenuFoodState(
      errorText: errorText ?? this.errorText,
      menuFoodStatus: menuFoodStatus ?? this.menuFoodStatus,
      listFoodMenuModel: listFoodMenuModel ?? this.listFoodMenuModel,
    );
  }

  @override
  List<Object?> get props => [errorText, menuFoodStatus, listFoodMenuModel];
}

enum MenuFoodStatus { loading, succes, failed }
