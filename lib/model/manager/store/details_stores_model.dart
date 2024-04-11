// To parse this JSON data, do
//
//     final detailsStoreModel = detailsStoreModelFromJson(jsonString);

import 'dart:convert';

DetailsStoreModel detailsStoreModelFromJson(String str) =>
    DetailsStoreModel.fromJson(json.decode(str));

String detailsStoreModelToJson(DetailsStoreModel data) =>
    json.encode(data.toJson());

class DetailsStoreModel {
  int status;
  DataDetailsStore store;
  int? todayIncome;
  int? totalIncome;
  int? todayTotalOrder;
  int? todayTotalOrderPaid;
  int? todayTotalOrderUnpaid;
  int? monthTotalOrder;
  Data data;
  String shopId;

  DetailsStoreModel({
    required this.status,
    required this.store,
    required this.todayIncome,
    required this.totalIncome,
    required this.todayTotalOrder,
    required this.todayTotalOrderPaid,
    required this.todayTotalOrderUnpaid,
    required this.monthTotalOrder,
    required this.data,
    required this.shopId,
  });

  factory DetailsStoreModel.fromJson(Map<String, dynamic> json) =>
      DetailsStoreModel(
        status: json["status"],
        store: DataDetailsStore.fromJson(json["store"]),
        todayIncome: json["today_income"],
        totalIncome: json["total_income"],
        todayTotalOrder: json["today_total_order"],
        todayTotalOrderPaid: json["today_total_order_paid"],
        todayTotalOrderUnpaid: json["today_total_order_unpaid"],
        monthTotalOrder: json["month_total_order"],
        data: Data.fromJson(json["data"]),
        shopId: json["shop_id"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "store": store.toJson(),
        "today_income": todayIncome,
        "total_income": totalIncome,
        "today_total_order": todayTotalOrder,
        "today_total_order_paid": todayTotalOrderPaid,
        "today_total_order_unpaid": todayTotalOrderUnpaid,
        "month_total_order": monthTotalOrder,
        "data": data.toJson(),
        "shop_id": shopId,
      };
}

class Data {
  List<String> labels;
  List<int> data;

  Data({
    required this.labels,
    required this.data,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        labels: List<String>.from(json["labels"].map((x) => x)),
        data: List<int>.from(json["data"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "labels": List<dynamic>.from(labels.map((x) => x)),
        "data": List<dynamic>.from(data.map((x) => x)),
      };
}

class DataDetailsStore {
  int? storeId;
  int userId;
  String shopId;
  String? storeName;
  String? storeAddress;
  String? storeDescription;
  String? storeImages;
  String? storeLogo;
  int? activeFlg;
  int? deleteFlg;
  String? createdAt;
  String? updatedAt;
  int? staffsCount;

  DataDetailsStore({
    required this.storeId,
    required this.userId,
    required this.shopId,
    required this.storeName,
    required this.storeAddress,
    required this.storeDescription,
    required this.storeImages,
    required this.storeLogo,
    required this.activeFlg,
    required this.deleteFlg,
    required this.createdAt,
    required this.updatedAt,
    required this.staffsCount,
  });

  factory DataDetailsStore.fromJson(Map<String, dynamic> json) =>
      DataDetailsStore(
        storeId: json["store_id"],
        userId: json["user_id"],
        shopId: json["shop_id"],
        storeName: json["store_name"],
        storeAddress: json["store_address"],
        storeDescription: json["store_description"],
        storeImages: json["store_images"],
        storeLogo: json["store_logo"],
        activeFlg: json["active_flg"],
        deleteFlg: json["delete_flg"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        staffsCount: json["staffs_count"],
      );

  Map<String, dynamic> toJson() => {
        "store_id": storeId,
        "user_id": userId,
        "shop_id": shopId,
        "store_name": storeName,
        "store_address": storeAddress,
        "store_description": storeDescription,
        "store_images": storeImages,
        "store_logo": storeLogo,
        "active_flg": activeFlg,
        "delete_flg": deleteFlg,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "staffs_count": staffsCount,
      };
}
