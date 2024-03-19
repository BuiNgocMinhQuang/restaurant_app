part of 'table_bloc.dart';

class TableState extends Equatable {
  const TableState(
      {this.errorText,
      this.tableStatus,
      this.tableModel,
      this.foodTableDataModel});

  final String? errorText;
  final TableStatus? tableStatus;
  final TableModel? tableModel;
  final FoodTableDataModel? foodTableDataModel;

  TableState copyWith(
      {String? errorText,
      TableStatus? tableStatus,
      TableModel? tableModel,
      FoodTableDataModel? foodTableDataModel}) {
    return TableState(
      errorText: errorText ?? this.errorText,
      tableStatus: tableStatus ?? this.tableStatus,
      tableModel: tableModel ?? this.tableModel,
      foodTableDataModel: foodTableDataModel ?? this.foodTableDataModel,
    );
  }

  @override
  List<Object?> get props =>
      [errorText, tableStatus, tableModel, foodTableDataModel];
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
