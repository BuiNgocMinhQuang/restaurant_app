part of 'table_bloc.dart';

abstract class TableEvent extends Equatable {
  const TableEvent();
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

  const GetTableFoods({
    required this.client,
    required this.shopId,
    this.isApi = true,
    required this.roomId,
    required this.tableId,
    required this.limit,
  });

  @override
  List<Object> get props => [];
}
