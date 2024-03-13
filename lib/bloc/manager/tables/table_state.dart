part of 'table_bloc.dart';

class TableState extends Equatable {
  const TableState({this.errorText, this.tableStatus, this.tableModel});

  final String? errorText;
  final TableStatus? tableStatus;
  final TableModel? tableModel;

  TableState copyWith(
      {String? errorText, TableStatus? tableStatus, TableModel? tableModel}) {
    return TableState(
        errorText: errorText ?? this.errorText,
        tableStatus: tableStatus ?? this.tableStatus,
        tableModel: tableModel ?? this.tableModel);
  }

  @override
  List<Object?> get props => [errorText, tableStatus, tableModel];
}

enum TableStatus { loading, succes, failed }
