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
