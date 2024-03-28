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
  const BroughtReceiptState({
    this.errorText,
    this.broughtReceiptStatus,
    this.manageBroughtReceiptModel,
    this.quantityFoodBroughtReceiptModel,
    this.quantytibroughtReceiptStatus,
    this.orderIdNewBill,
  });

  final String? errorText;
  final BroughtReceiptStatus? broughtReceiptStatus;
  final BroughtReceiptStatus? quantytibroughtReceiptStatus;
  final int? orderIdNewBill;
  final ManageBroughtReceiptModel? manageBroughtReceiptModel;
  final QuantityFoodBroughtReceiptModel? quantityFoodBroughtReceiptModel;

  BroughtReceiptState copyWith(
      {String? errorText,
      BroughtReceiptStatus? broughtReceiptStatus,
      BroughtReceiptStatus? quantytibroughtReceiptStatus,
      int? orderIdNewBill,
      ManageBroughtReceiptModel? manageBroughtReceiptModel,
      QuantityFoodBroughtReceiptModel? quantityFoodBroughtReceiptModel}) {
    return BroughtReceiptState(
        errorText: errorText ?? this.errorText,
        broughtReceiptStatus: broughtReceiptStatus ?? this.broughtReceiptStatus,
        orderIdNewBill: orderIdNewBill ?? this.orderIdNewBill,
        quantytibroughtReceiptStatus:
            quantytibroughtReceiptStatus ?? this.quantytibroughtReceiptStatus,
        manageBroughtReceiptModel:
            manageBroughtReceiptModel ?? this.manageBroughtReceiptModel,
        quantityFoodBroughtReceiptModel: quantityFoodBroughtReceiptModel ??
            this.quantityFoodBroughtReceiptModel);
  }

  @override
  List<Object?> get props => [
        errorText,
        broughtReceiptStatus,
        quantytibroughtReceiptStatus,
        orderIdNewBill,
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

///STATE IN HOA DON
class PrintBroughtReceiptState extends Equatable {
  const PrintBroughtReceiptState({
    this.errorText,
    this.printBroughtReceiptStatus,
    this.printBroughtReceiptModel,
  });

  final String? errorText;
  final PrintBroughtReceiptStatus? printBroughtReceiptStatus;
  final PrintBroughtReceiptModel? printBroughtReceiptModel;

  PrintBroughtReceiptState copyWith({
    String? errorText,
    PrintBroughtReceiptStatus? printBroughtReceiptStatus,
    PrintBroughtReceiptModel? printBroughtReceiptModel,
  }) {
    return PrintBroughtReceiptState(
      errorText: errorText ?? this.errorText,
      printBroughtReceiptStatus:
          printBroughtReceiptStatus ?? this.printBroughtReceiptStatus,
      printBroughtReceiptModel:
          printBroughtReceiptModel ?? this.printBroughtReceiptModel,
    );
  }

  @override
  List<Object?> get props =>
      [errorText, printBroughtReceiptStatus, printBroughtReceiptModel];
}

enum PrintBroughtReceiptStatus { loading, succes, failed }
