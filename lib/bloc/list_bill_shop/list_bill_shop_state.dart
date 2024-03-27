part of 'list_bill_shop_bloc.dart';

class ListBillShopState extends Equatable {
  const ListBillShopState({
    this.errorText,
    this.listBillShopStatus,
    this.listBillShopModel,
  });

  final String? errorText;
  final ListBillShopStatus? listBillShopStatus;
  final ListBillShopModel? listBillShopModel;

  ListBillShopState copyWith(
      {String? errorText,
      ListBillShopStatus? listBillShopStatus,
      ListBillShopModel? listBillShopModel}) {
    return ListBillShopState(
        errorText: errorText ?? this.errorText,
        listBillShopStatus: listBillShopStatus ?? this.listBillShopStatus,
        listBillShopModel: listBillShopModel ?? this.listBillShopModel);
  }

  @override
  List<Object?> get props => [errorText, listBillShopStatus, listBillShopModel];
}

enum ListBillShopStatus { loading, succes, failed }
