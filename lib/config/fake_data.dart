import 'package:flutter/material.dart';

List<String> listStore = [
  "Cửa hàng 1",
  "Cửa hàng 2",
  "Cửa hàng 3",
  "Cửa hàng 4"
];
List<String> optionsCancle = [
  "Đổi trả lại",
  "Thêm nhầm đơn hàng",
  "Khách báo hủy",
  "Khác"
];
List<String> listRole = ["Nhân viên", "Trưởng nhóm", "Quản lý", "Kế toán"];
List<String> listTable = ["ban so 2", "ban so 3", "ban so 4"];
List<String> optionsPayment = ["Tiền mặt", "Thẻ", "Chuyển khoản"];
final List<String> categories = [
  "Combo",
  "Món nướng",
  "Món lẩu",
  "Nước giải khát"
];
List<Object> listProvinces = [
  "An Giang",
  "Bà Rịa - Vũng Tàu",
  "Bạc Liêu"
  // {
  //   "_id": "60eaaa6f1173335842c35663",
  //   "name": "An Giang",
  //   "slug": "an-giang",
  //   "type": "tinh",
  //   "name_with_type": "Tỉnh An Giang",
  //   "code": "89",
  //   "isDeleted": false
  // },
  // {
  //   "_id": "60eaaa6f1173335842c3565b",
  //   "name": "Bà Rịa - Vũng Tàu",
  //   "slug": "ba-ria---vung-tau",
  //   "type": "tinh",
  //   "name_with_type": "Tỉnh Bà Rịa - Vũng Tàu",
  //   "code": "77",
  //   "isDeleted": false
  // },
  // {
  //   "_id": "60eaaa6f1173335842c35668",
  //   "name": "Bạc Liêu",
  //   "slug": "bac-lieu",
  //   "type": "tinh",
  //   "name_with_type": "Tỉnh Bạc Liêu",
  //   "code": "95",
  //   "isDeleted": false
  // },
];

List<Object> listDistricts = [
  "Ba Đình",
  "Hoàn Kiếm",
  "Tây Hồ"
  // {
  //   "_id": "60eaaa6f1173335842c3536a",
  //   "name": "Ba Đình",
  //   "type": "quan",
  //   "slug": "ba-dinh",
  //   "name_with_type": "Quận Ba Đình",
  //   "path": "Ba Đình, Hà Nội",
  //   "path_with_type": "Quận Ba Đình, Thành phố Hà Nội",
  //   "code": "001",
  //   "parent_code": "01",
  //   "isDeleted": false
  // },
  // {
  //   "_id": "60eaaa6f1173335842c3536b",
  //   "name": "Hoàn Kiếm",
  //   "type": "quan",
  //   "slug": "hoan-kiem",
  //   "name_with_type": "Quận Hoàn Kiếm",
  //   "path": "Hoàn Kiếm, Hà Nội",
  //   "path_with_type": "Quận Hoàn Kiếm, Thành phố Hà Nội",
  //   "code": "002",
  //   "parent_code": "01",
  //   "isDeleted": false
  // },
  // {
  //   "_id": "60eaaa6f1173335842c3536c",
  //   "name": "Tây Hồ",
  //   "type": "quan",
  //   "slug": "tay-ho",
  //   "name_with_type": "Quận Tây Hồ",
  //   "path": "Tây Hồ, Hà Nội",
  //   "path_with_type": "Quận Tây Hồ, Thành phố Hà Nội",
  //   "code": "003",
  //   "parent_code": "01",
  //   "isDeleted": false
  // },
];

List<Object> listwards = [
  "A Dơi",
  "Đắk Lao",
  "Đắk Lao"
  // {
  //   "_id": "60eaaa721173335842c35ebd",
  //   "name": " A Dơi",
  //   "type": "xa",
  //   "slug": "a-doi",
  //   "name_with_type": "Xã  A Dơi",
  //   "path": " A Dơi, Hướng Hóa, Quảng Trị",
  //   "path_with_type": "Xã  A Dơi, Huyện Hướng Hóa, Tỉnh Quảng Trị",
  //   "code": "19483",
  //   "parent_code": "465",
  //   "isDeleted": false
  // },
  // {
  //   "_id": "60eaaa721173335842c369a0",
  //   "name": " An Lạc",
  //   "type": "phuong",
  //   "slug": "an-lac",
  //   "name_with_type": "Phường  An Lạc",
  //   "path": " An Lạc, Bình Tân, Hồ Chí Minh",
  //   "path_with_type": "Phường  An Lạc, Quận Bình Tân, Thành phố Hồ Chí Minh",
  //   "code": "27460",
  //   "parent_code": "777",
  //   "isDeleted": false
  // },
  // {
  //   "_id": "60eaaa721173335842c365d2",
  //   "name": " Đắk Lao",
  //   "type": "xa",
  //   "slug": "dak-lao",
  //   "name_with_type": "Xã  Đắk Lao",
  //   "path": " Đắk Lao, Đắk Mil, Đắk Nông",
  //   "path_with_type": "Xã  Đắk Lao, Huyện Đắk Mil, Tỉnh Đắk Nông",
  //   "code": "24667",
  //   "parent_code": "663",
  //   "isDeleted": false
  // },
];

String searchText = " ";

class ItemFood {
  final String name;
  final String image;
  final String category;
  final String price;

  ItemFood({
    required this.name,
    required this.image,
    required this.category,
    required this.price,
  });
}

List<ItemFood> listFood = [
  ItemFood(
      name: "combo lau",
      image: "assets/images/banner1.png",
      price: "20,000 đ",
      category: "Combo"),
  ItemFood(
      name: "combo nuong",
      image: "assets/images/banner2.png",
      price: "40,000 đ",
      category: "Combo"),
  ItemFood(
      name: "thit heo nuong",
      image: "assets/images/banner2.png",
      price: "60,000 đ",
      category: "Món nướng"),
  ItemFood(
      name: "hai san nuong",
      image: "assets/images/banner3.png",
      price: "67,000 đ",
      category: "Món nướng"),
  ItemFood(
      name: "Lau hai san",
      image: "assets/images/banner3.png",
      price: "200,000 đ",
      category: "Món lẩu"),
  ItemFood(
      name: "Lau thai",
      image: "assets/images/banner2.png",
      price: "200,000 đ",
      category: "Món lẩu"),
  ItemFood(
      name: "Sting",
      image: "assets/images/banner1.png",
      price: "10,000 đ",
      category: "Nước giải khát"),
  ItemFood(
      name: "Coca",
      image: "assets/images/banner3.png",
      price: "10,000 đ",
      category: "Nước giải khát"),
];

List<DataColumn> dataColumn = [
  DataColumn(label: Text('Tên mặt hàng')),
  DataColumn(label: Text('Đơn vị')),
  DataColumn(label: Text('SL tối thiểu')),
  DataColumn(label: Text('SL tồn cuối')),
  DataColumn(label: Text('Trạng thái')),
  DataColumn(label: Text('Thao tác kho')),
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
