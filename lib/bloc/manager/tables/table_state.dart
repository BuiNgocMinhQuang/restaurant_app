part of 'table_bloc.dart';

class TableState extends Equatable {
  const TableState(
      {this.errorText,
      this.tableStatus,
      this.tableModel,
      this.foodTableDataModel,
      this.switchTableDataModel,
      this.quantityFoodTableState});

  final String? errorText;
  final TableStatus? tableStatus;
  final TableStatus? quantityFoodTableState;
  final TableModel? tableModel;
  final FoodTableDataModel? foodTableDataModel;
  final SwitchTableDataModel? switchTableDataModel;

  TableState copyWith(
      {String? errorText,
      TableStatus? tableStatus,
      TableStatus? quantityFoodTableState,
      TableModel? tableModel,
      FoodTableDataModel? foodTableDataModel,
      SwitchTableDataModel? switchTableDataModel}) {
    return TableState(
        errorText: errorText ?? this.errorText,
        tableStatus: tableStatus ?? this.tableStatus,
        quantityFoodTableState:
            quantityFoodTableState ?? this.quantityFoodTableState,
        tableModel: tableModel ?? this.tableModel,
        foodTableDataModel: foodTableDataModel ?? this.foodTableDataModel,
        switchTableDataModel:
            switchTableDataModel ?? this.switchTableDataModel);
  }

  @override
  List<Object?> get props => [
        errorText,
        tableStatus,
        tableModel,
        foodTableDataModel,
        switchTableDataModel,
        quantityFoodTableState
      ];
}

enum TableStatus { loading, succes, failed }

class TableCancleState extends Equatable {
  const TableCancleState({
    this.errorText,
    this.tableCancleStatus,
  });

  final String? errorText;
  final TableCancleStatus? tableCancleStatus;

  TableCancleState copyWith({
    String? errorText,
    TableCancleStatus? tableCancleStatus,
  }) {
    return TableCancleState(
      errorText: errorText ?? this.errorText,
      tableCancleStatus: tableCancleStatus ?? this.tableCancleStatus,
    );
  }

  @override
  List<Object?> get props => [errorText, tableCancleStatus];
}

enum TableCancleStatus { loading, succes, failed }

class TableSaveInforState extends Equatable {
  const TableSaveInforState({
    this.errorText,
    this.tableSaveInforStatus,
  });

  final String? errorText;
  final TableSaveInforStatus? tableSaveInforStatus;

  TableSaveInforState copyWith({
    String? errorText,
    TableSaveInforStatus? tableSaveInforStatus,
  }) {
    return TableSaveInforState(
      errorText: errorText ?? this.errorText,
      tableSaveInforStatus: tableSaveInforStatus ?? this.tableSaveInforStatus,
    );
  }

  @override
  List<Object?> get props => [errorText, tableSaveInforStatus];
}

enum TableSaveInforStatus { loading, succes, failed }

class SwitchTableState extends Equatable {
  const SwitchTableState({
    this.errorText,
    this.switchtableStatus,
  });

  final String? errorText;
  final SwitchTableStatus? switchtableStatus;

  SwitchTableState copyWith({
    String? errorText,
    SwitchTableStatus? switchtableStatus,
  }) {
    return SwitchTableState(
      errorText: errorText ?? this.errorText,
      switchtableStatus: switchtableStatus ?? this.switchtableStatus,
    );
  }

  @override
  List<Object?> get props => [errorText, switchtableStatus];
}

enum SwitchTableStatus { loading, succes, failed }
