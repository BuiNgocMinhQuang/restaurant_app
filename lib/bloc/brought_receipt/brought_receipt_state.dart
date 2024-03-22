part of 'brought_receipt_bloc.dart';

class BroughtReceiptPageState extends Equatable {
  const BroughtReceiptPageState({
    this.errorText,
    this.broughtReceiptPageStatus,
    this.listBroughtReceiptModel,
  });

  final String? errorText;
  final BroughtReceiptPageStatus? broughtReceiptPageStatus;
  final ListBroughtReceiptModel? listBroughtReceiptModel;

  BroughtReceiptPageState copyWith(
      {String? errorText,
      BroughtReceiptPageStatus? broughtReceiptPageStatus,
      ListBroughtReceiptModel? listBroughtReceiptModel}) {
    return BroughtReceiptPageState(
      errorText: errorText ?? this.errorText,
      broughtReceiptPageStatus:
          broughtReceiptPageStatus ?? this.broughtReceiptPageStatus,
      listBroughtReceiptModel:
          listBroughtReceiptModel ?? this.listBroughtReceiptModel,
    );
  }

  @override
  List<Object?> get props =>
      [errorText, broughtReceiptPageStatus, listBroughtReceiptModel];
}

enum BroughtReceiptPageStatus { loading, succes, failed }

///STATE của trang hoá đơn mang về

class BroughtReceiptState extends Equatable {
  const BroughtReceiptState(
      {this.errorText,
      this.broughtReceiptStatus,
      this.manageBroughtReceiptModel});

  final String? errorText;
  final BroughtReceiptStatus? broughtReceiptStatus;
  final ManageBroughtReceiptModel? manageBroughtReceiptModel;

  BroughtReceiptState copyWith(
      {String? errorText,
      BroughtReceiptStatus? broughtReceiptStatus,
      ManageBroughtReceiptModel? manageBroughtReceiptModel}) {
    return BroughtReceiptState(
        errorText: errorText ?? this.errorText,
        broughtReceiptStatus: broughtReceiptStatus ?? this.broughtReceiptStatus,
        manageBroughtReceiptModel:
            manageBroughtReceiptModel ?? this.manageBroughtReceiptModel);
  }

  @override
  List<Object?> get props => [
        errorText,
        broughtReceiptStatus,
        manageBroughtReceiptModel,
      ];
}

enum BroughtReceiptStatus { loading, succes, failed }

///STATE của dialog hoá đơn mang về