part of 'brought_receipt_bloc.dart';

class BroughtReceiptPageState extends Equatable {
  const BroughtReceiptPageState({
    this.errorText,
    this.broughtReceiptPageStatus,
    this.broughtReceiptModel,
  });

  final String? errorText;
  final BroughtReceiptPageStatus? broughtReceiptPageStatus;
  final BroughtReceiptModel? broughtReceiptModel;

  BroughtReceiptPageState copyWith(
      {String? errorText,
      BroughtReceiptPageStatus? broughtReceiptPageStatus,
      BroughtReceiptModel? broughtReceiptModel}) {
    return BroughtReceiptPageState(
      errorText: errorText ?? this.errorText,
      broughtReceiptPageStatus:
          broughtReceiptPageStatus ?? this.broughtReceiptPageStatus,
      broughtReceiptModel: broughtReceiptModel ?? this.broughtReceiptModel,
    );
  }

  @override
  List<Object?> get props =>
      [errorText, broughtReceiptPageStatus, broughtReceiptModel];
}

enum BroughtReceiptPageStatus { loading, succes, failed }

///STATE của trang hoá đơn mang về

class BroughtReceiptState extends Equatable {
  const BroughtReceiptState({
    this.errorText,
    this.broughtReceiptStatus,
  });

  final String? errorText;
  final BroughtReceiptStatus? broughtReceiptStatus;

  BroughtReceiptState copyWith({
    String? errorText,
    BroughtReceiptStatus? broughtReceiptStatus,
  }) {
    return BroughtReceiptState(
      errorText: errorText ?? this.errorText,
      broughtReceiptStatus: broughtReceiptStatus ?? this.broughtReceiptStatus,
    );
  }

  @override
  List<Object?> get props => [
        errorText,
        broughtReceiptStatus,
      ];
}

enum BroughtReceiptStatus { loading, succes, failed }

///STATE của dialog hoá đơn mang về