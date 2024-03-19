part of 'table_bloc.dart';

abstract class TableEvent extends Equatable {
  const TableEvent();
}

abstract class TableCancleEvent extends Equatable {
  const TableCancleEvent();
}

abstract class TableSaveInforEvent extends Equatable {
  const TableSaveInforEvent();
}

class GetTableInfor extends TableEvent {
  final String client;
  final String shopId;
  final bool isApi;
  final String roomId;
  final String tableId;

  const GetTableInfor({
    required this.client,
    required this.shopId,
    this.isApi = true,
    required this.roomId,
    required this.tableId,
  });

  @override
  List<Object> get props => [];
}

class GetTableFoods extends TableEvent {
  final String client;
  final String shopId;
  final bool isApi;
  final String roomId;
  final String tableId;
  final String limit; //phan trang
  final String page;

  const GetTableFoods(
      {required this.client,
      required this.shopId,
      this.isApi = true,
      required this.roomId,
      required this.tableId,
      required this.limit,
      required this.page});

  @override
  List<Object> get props => [];
}

class CancleTable extends TableCancleEvent {
  final String client;
  final String shopId;
  final bool isApi;
  final String roomId;
  final String tableId;
  final String cancellationReason; //phan trang

  const CancleTable({
    required this.client,
    required this.shopId,
    this.isApi = true,
    required this.roomId,
    required this.tableId,
    required this.cancellationReason,
  });

  @override
  List<Object> get props => [];
}

class SaveTableInfor extends TableSaveInforEvent {
  final String client;
  final String shopId;
  final bool isApi;
  final String roomId;
  final String tableId;
  final String clientName;
  final String clientPhone;
  final String note;
  final String endDate;
  final List tables;

  const SaveTableInfor({
    required this.client,
    required this.shopId,
    this.isApi = true,
    required this.roomId,
    required this.tableId,
    required this.clientName,
    required this.clientPhone,
    required this.note,
    required this.endDate,
    required this.tables,
  });

  @override
  List<Object> get props => [];
}
