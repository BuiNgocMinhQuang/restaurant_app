part of 'payment_bloc.dart';

class PaymentInforState extends Equatable {
  const PaymentInforState(
      {this.errorText, this.paymentStatus, this.paymentInforModel});

  final String? errorText;
  final PaymentInforStateStatus? paymentStatus;
  final PaymentInforModel? paymentInforModel;

  PaymentInforState copyWith(
      {String? errorText,
      PaymentInforStateStatus? paymentStatus,
      PaymentInforModel? paymentInforModel}) {
    return PaymentInforState(
        errorText: errorText ?? this.errorText,
        paymentStatus: paymentStatus ?? this.paymentStatus,
        paymentInforModel: paymentInforModel ?? this.paymentInforModel);
  }

  @override
  List<Object?> get props => [errorText, paymentStatus, paymentInforModel];
}

enum PaymentInforStateStatus { loading, succes, failed }
