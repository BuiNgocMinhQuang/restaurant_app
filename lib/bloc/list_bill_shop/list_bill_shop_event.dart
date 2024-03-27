part of 'list_bill_shop_bloc.dart';

abstract class ListBillShopEvent extends Equatable {
  const ListBillShopEvent();
}

class GetListBillShop extends ListBillShopEvent {
  final String client;
  final String shopId;
  final bool isApi;
  final int limit;
  final int page;
  final Map<String, int?> filters; //chua bit type

  const GetListBillShop(
      {required this.client,
      required this.shopId,
      this.isApi = true,
      required this.limit,
      required this.page,
      required this.filters});

  @override
  List<Object> get props => [];
}
