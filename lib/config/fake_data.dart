import 'package:flutter/material.dart';

List<String> optionsCancle = [
  "Đổi trả lại",
  "Thêm nhầm đơn hàng",
  "Khách báo hủy",
  "Khác"
];
List<String> optionsPayment = ["Tiền mặt", "Thẻ", "Chuyển khoản"];
final List<String> categories = [
  "Combo",
  "Món nướng",
  "Món lẩu",
  "Nước giải khát"
];

List<DataColumn> dataColumn = [
  const DataColumn(label: Text('Tên mặt hàng')),
  const DataColumn(label: Text('Đơn vị')),
  const DataColumn(label: Text('SL tối thiểu')),
  const DataColumn(label: Text('SL tồn cuối')),
  const DataColumn(label: Text('Trạng thái')),
  const DataColumn(label: Text('Thao tác kho')),
];
List<List<dynamic>> dataRow = [
  ['Mặt hàng 1', 'Kg', 1, 10, 'Còn hàng'],
  [2, 'Jane Smith', 'jane.smith@example.com'],
  [3, 'Michael Brown', 'michael.brown@example.com'],
  [3, 'Michael Brown', 'michael.brown@example.com'],
  [3, 'Michael Brown', 'michael.brown@example.com'],
  [3, 'Michael Brown', 'michael.brown@example.com'],
];

class MyData {
  // final int id;
  final String name;
  final String unit;
  final int minQuantity;
  final int maxQuantity;
  final String status;
  bool isSelected = false;

  MyData({
    required this.name,
    required this.unit,
    required this.minQuantity,
    required this.maxQuantity,
    required this.status,
  });
}

List<MyData> myData = [
  MyData(
      name: 'Mặt hàng 1',
      unit: 'Kg',
      minQuantity: 1,
      maxQuantity: 100,
      status: 'Còn hàng'),
  MyData(
      name: 'Mặt hàng 2',
      unit: 'Tấn',
      minQuantity: 0,
      maxQuantity: 10,
      status: 'Hết hàng'),
  MyData(
      name: 'Mặt hàng 3',
      unit: 'Gam',
      minQuantity: 98,
      maxQuantity: 200,
      status: 'Còn hàng'),
];

List<String> listMeasure = [
  "Tấn",
  "Tạ",
  "Yến",
  "Kg",
  "Gram",
];

final List jsonData = [
  {
    "booking_status": false,
    "order_id": 1,
    "client_can_pay": "20,000,011,111",
    "order_created_at": "13:55",
    "table_name": "ban 1",
    "room_table_id": 1
  },
  {
    "booking_status": false,
    "order_id": 1,
    "client_can_pay": "20,000,011,111",
    "order_created_at": "13:55",
    "table_name": "ban so 2",
    "room_table_id": 2
  },
  {
    "booking_status": true,
    "order_id": null,
    "client_can_pay": 0,
    "order_created_at": "",
    "table_name": "ban so 3",
    "room_table_id": 3
  },
  {
    "booking_status": false,
    "order_id": 2,
    "client_can_pay": "0",
    "order_created_at": "14:30",
    "table_name": "ban so 4",
    "room_table_id": 4
  }
];
