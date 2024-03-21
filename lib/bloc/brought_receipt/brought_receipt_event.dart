part of 'brought_receipt_bloc.dart';

abstract class BroughtReceiptEvent extends Equatable {
  const BroughtReceiptEvent();
}

class GetListBroughtReceipt extends BroughtReceiptEvent {
  final String client;
  final String shopId;
  final bool isApi;
  final int limit;
  final int page;
  final List filters; //chua bit type

  const GetListBroughtReceipt(
      {required this.client,
      required this.shopId,
      this.isApi = true,
      required this.limit,
      required this.page,
      this.filters = const []});

  @override
  List<Object> get props => [];
}

class GetDetailsBroughtReceipt extends BroughtReceiptEvent {
  final String client;
  final String shopId;
  final bool isApi;
  final int limit;
  final int page;
  final String orderId;
  final List filters;

  const GetDetailsBroughtReceipt({
    required this.client,
    required this.shopId,
    this.isApi = true,
    required this.limit,
    required this.orderId,
    required this.page,
    this.filters = const [],
  });

  @override
  List<Object> get props => [];
}

class AddFoodToBill extends BroughtReceiptEvent {
  final String client;
  final String shopId;
  final bool isApi;
  final String orderId;
  final String foodId;

  const AddFoodToBill(
      {required this.client,
      required this.shopId,
      this.isApi = true,
      required this.orderId,
      required this.foodId});

  @override
  List<Object> get props => [];
}

class RemoveFoodToBill extends BroughtReceiptEvent {
  final String client;
  final String shopId;
  final bool isApi;
  final String orderId;
  final String foodId;

  const RemoveFoodToBill(
      {required this.client,
      required this.shopId,
      this.isApi = true,
      required this.orderId,
      required this.foodId});

  @override
  List<Object> get props => [];
}

class UpdateQuantytiFoodToBill extends BroughtReceiptEvent {
  final String client;
  final String shopId;
  final bool isApi;
  final String orderId;
  final String foodId;
  final String value;

  const UpdateQuantytiFoodToBill({
    required this.client,
    required this.shopId,
    this.isApi = true,
    required this.orderId,
    required this.foodId,
    required this.value,
  });

  @override
  List<Object> get props => [];
}
