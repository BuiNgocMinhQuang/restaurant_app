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
  final Map<String, int?> filters; //chua bit type

  const GetListBroughtReceipt(
      {required this.client,
      required this.shopId,
      this.isApi = true,
      required this.limit,
      required this.page,
      required this.filters});

  @override
  List<Object> get props => [];
}

class GetDetailsBroughtReceipt extends BroughtReceiptEvent {
  final String client;
  final String shopId;
  final bool isApi;
  final int limit;
  final int page;
  final int? orderId;
  final List? filters;

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

class ResetOrderID extends BroughtReceiptEvent {
  const ResetOrderID();

  @override
  List<Object> get props => [];
}

class AddFoodToBroughtReceipt extends BroughtReceiptEvent {
  final String client;
  final String shopId;
  final bool isApi;
  final int? orderId;
  final String foodId;

  const AddFoodToBroughtReceipt(
      {required this.client,
      required this.shopId,
      this.isApi = true,
      required this.orderId,
      required this.foodId});

  @override
  List<Object> get props => [];
}

class RemoveFoodToBroughtReceipt extends BroughtReceiptEvent {
  final String client;
  final String shopId;
  final bool isApi;
  final int? orderId;
  final String foodId;

  const RemoveFoodToBroughtReceipt(
      {required this.client,
      required this.shopId,
      this.isApi = true,
      required this.orderId,
      required this.foodId});

  @override
  List<Object> get props => [];
}

class UpdateQuantytiFoodToBroughtReceipt extends BroughtReceiptEvent {
  final String client;
  final String shopId;
  final bool isApi;
  final int? orderId;
  final String foodId;
  final String value;

  const UpdateQuantytiFoodToBroughtReceipt({
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

class CancleBroughtReceipt extends BroughtReceiptEvent {
  final String client;
  final String shopId;
  final bool isApi;
  final int? orderId;
  final String cancellationReason;

  const CancleBroughtReceipt({
    required this.client,
    required this.shopId,
    this.isApi = true,
    required this.orderId,
    required this.cancellationReason,
  });

  @override
  List<Object> get props => [];
}

class PrintBroughtReceipt extends BroughtReceiptEvent {
  final String client;
  final String shopId;
  final bool isApi;
  final int orderId;

  const PrintBroughtReceipt({
    required this.client,
    required this.shopId,
    this.isApi = true,
    required this.orderId,
  });

  @override
  List<Object> get props => [];
}
