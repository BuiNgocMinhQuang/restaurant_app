part of 'bill_bloc.dart';

abstract class BillInforEvent extends Equatable {
  const BillInforEvent();
}

class GetBillInfor extends BillInforEvent {
  final String client;
  final String shopId;
  final bool isApi;
  final String roomId;
  final String tableId;
  final String orderId;

  const GetBillInfor(
      {required this.client,
      required this.shopId,
      this.isApi = true,
      required this.roomId,
      required this.tableId,
      required this.orderId});

  @override
  List<Object> get props => [];
}

class AddFoodToBill extends BillInforEvent {
  final String client;
  final String shopId;
  final bool isApi;
  final String roomId;
  final String tableId;
  final String? orderId;
  final String foodId;

  const AddFoodToBill(
      {required this.client,
      required this.shopId,
      this.isApi = true,
      required this.roomId,
      required this.tableId,
      required this.orderId,
      required this.foodId});

  @override
  List<Object> get props => [];
}

class RemoveFoodToBill extends BillInforEvent {
  final String client;
  final String shopId;
  final bool isApi;
  final String roomId;
  final String tableId;
  final String? orderId;
  final String foodId;

  const RemoveFoodToBill(
      {required this.client,
      required this.shopId,
      this.isApi = true,
      required this.roomId,
      required this.tableId,
      required this.orderId,
      required this.foodId});

  @override
  List<Object> get props => [];
}

class UpdateQuantytiFoodToBill extends BillInforEvent {
  final String client;
  final String shopId;
  final bool isApi;
  final String roomId;
  final String tableId;
  final String? orderId;
  final String foodId;
  final String value;

  const UpdateQuantytiFoodToBill({
    required this.client,
    required this.shopId,
    this.isApi = true,
    required this.roomId,
    required this.tableId,
    required this.orderId,
    required this.foodId,
    required this.value,
  });

  @override
  List<Object> get props => [];
}
