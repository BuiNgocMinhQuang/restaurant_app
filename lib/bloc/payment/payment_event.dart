part of 'payment_bloc.dart';

abstract class PaymentInforEvent extends Equatable {
  const PaymentInforEvent();
}

class GetPaymentInfor extends PaymentInforEvent {
  final String client;
  final String shopId;
  final bool isApi;
  final String roomId;
  final String tableId;
  final String orderId;

  const GetPaymentInfor(
      {required this.client,
      required this.shopId,
      this.isApi = true,
      required this.roomId,
      required this.tableId,
      required this.orderId});

  @override
  List<Object> get props => [];
}

class UpdatePaymentInfor extends PaymentInforEvent {
  final String client;
  final String shopId;
  final bool isApi;
  final String orderId;
  final String orderTotal;
  final String discount;
  final String guestPay;
  final int payKind;

  const UpdatePaymentInfor({
    required this.client,
    required this.shopId,
    this.isApi = true,
    required this.orderId,
    required this.orderTotal,
    required this.discount,
    required this.guestPay,
    required this.payKind,
  });

  @override
  List<Object> get props => [];
}

class ConfirmPayment extends PaymentInforEvent {
  final String client;
  final String shopId;
  final bool isApi;
  final String orderId;

  const ConfirmPayment({
    required this.client,
    required this.shopId,
    this.isApi = true,
    required this.orderId,
  });

  @override
  List<Object> get props => [];
}
