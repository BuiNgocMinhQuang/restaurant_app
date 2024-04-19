// To parse this JSON data, do
//
//     final homeDataModel = homeDataModelFromJson(jsonString);

import 'dart:convert';

HomeDataModel homeDataModelFromJson(String str) =>
    HomeDataModel.fromJson(json.decode(str));

String homeDataModelToJson(HomeDataModel data) => json.encode(data.toJson());

class HomeDataModel {
  int status;
  int orderTotal;
  int staffTotal;
  int orderTotalClose;
  int orderTotalSuccess;
  List<DetailsStoreHome> stores;

  HomeDataModel({
    required this.status,
    required this.orderTotal,
    required this.staffTotal,
    required this.orderTotalClose,
    required this.orderTotalSuccess,
    required this.stores,
  });

  factory HomeDataModel.fromJson(Map<String, dynamic> json) => HomeDataModel(
        status: json["status"],
        orderTotal: json["order_total"],
        staffTotal: json["staff_total"],
        orderTotalClose: json["order_total_close"],
        orderTotalSuccess: json["order_total_success"],
        stores: List<DetailsStoreHome>.from(
            json["stores"].map((x) => DetailsStoreHome.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "order_total": orderTotal,
        "staff_total": staffTotal,
        "order_total_close": orderTotalClose,
        "order_total_success": orderTotalSuccess,
        "stores": List<dynamic>.from(stores.map((x) => x.toJson())),
      };
}

class DetailsStoreHome {
  int storeId;
  int userId;
  String shopId;
  String storeName;
  String storeAddress;
  String storeDescription;
  String storeImages;
  String storeLogo;
  int activeFlg;
  int deleteFlg;
  String? createdAt;
  String? updatedAt;
  int? staffsCount;
  int? ordersSumOrderTotal;
  DetailsStoreHome({
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
    required this.ordersSumOrderTotal,
  });

  factory DetailsStoreHome.fromJson(Map<String, dynamic> json) =>
      DetailsStoreHome(
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
        ordersSumOrderTotal: json["orders_sum_order_total"],
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
        "orders_sum_order_total": ordersSumOrderTotal,
      };
}
