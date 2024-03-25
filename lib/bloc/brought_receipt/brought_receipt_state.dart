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
      this.manageBroughtReceiptModel,
      this.quantityFoodBroughtReceiptModel});

  final String? errorText;
  final BroughtReceiptStatus? broughtReceiptStatus;
  final ManageBroughtReceiptModel? manageBroughtReceiptModel;
  final QuantityFoodBroughtReceiptModel? quantityFoodBroughtReceiptModel;

  BroughtReceiptState copyWith(
      {String? errorText,
      BroughtReceiptStatus? broughtReceiptStatus,
      ManageBroughtReceiptModel? manageBroughtReceiptModel,
      QuantityFoodBroughtReceiptModel? quantityFoodBroughtReceiptModel}) {
    return BroughtReceiptState(
        errorText: errorText ?? this.errorText,
        broughtReceiptStatus: broughtReceiptStatus ?? this.broughtReceiptStatus,
        manageBroughtReceiptModel:
            manageBroughtReceiptModel ?? this.manageBroughtReceiptModel,
        quantityFoodBroughtReceiptModel: quantityFoodBroughtReceiptModel ??
            this.quantityFoodBroughtReceiptModel);
  }

  @override
  List<Object?> get props => [
        errorText,
        broughtReceiptStatus,
        manageBroughtReceiptModel,
        quantityFoodBroughtReceiptModel
      ];
}

enum BroughtReceiptStatus { loading, succes, failed }

///STATE của dialog hoá đơn mang về
///
///
///
///
///STATE HUY HOA DON
class CancleBroughtReceiptState extends Equatable {
  const CancleBroughtReceiptState({
    this.errorText,
    this.cancleBroughtReceiptStatus,
  });

  final String? errorText;
  final CancleBroughtReceiptStatus? cancleBroughtReceiptStatus;

  CancleBroughtReceiptState copyWith({
    String? errorText,
    CancleBroughtReceiptStatus? cancleBroughtReceiptStatus,
  }) {
    return CancleBroughtReceiptState(
      errorText: errorText ?? this.errorText,
      cancleBroughtReceiptStatus:
          cancleBroughtReceiptStatus ?? this.cancleBroughtReceiptStatus,
    );
  }

  @override
  List<Object?> get props => [
        errorText,
        cancleBroughtReceiptStatus,
      ];
}

enum CancleBroughtReceiptStatus { loading, succes, failed }

///STATE SO LUONG MON AN
///
class QuantityBroughtReceiptState extends Equatable {
  const QuantityBroughtReceiptState(
      {this.errorText,
      this.quantityBroughtReceiptStatus,
      this.quantityFoodBroughtReceiptModel});

  final String? errorText;
  final QuantityBroughtReceiptStatus? quantityBroughtReceiptStatus;
  final QuantityFoodBroughtReceiptModel? quantityFoodBroughtReceiptModel;
  QuantityBroughtReceiptState copyWith(
      {String? errorText,
      QuantityBroughtReceiptStatus? quantityBroughtReceiptStatus,
      QuantityFoodBroughtReceiptModel? quantityFoodBroughtReceiptModel}) {
    return QuantityBroughtReceiptState(
        errorText: errorText ?? this.errorText,
        quantityBroughtReceiptStatus:
            quantityBroughtReceiptStatus ?? this.quantityBroughtReceiptStatus,
        quantityFoodBroughtReceiptModel: quantityFoodBroughtReceiptModel ??
            this.quantityFoodBroughtReceiptModel);
  }

  @override
  List<Object?> get props => [
        errorText,
        quantityBroughtReceiptStatus,
        quantityFoodBroughtReceiptModel
      ];
}

enum QuantityBroughtReceiptStatus { loading, succes, failed }
