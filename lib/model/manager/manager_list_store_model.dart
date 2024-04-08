// To parse this JSON data, do
//
//     final listStoreModel = listStoreModelFromJson(jsonString);

import 'dart:convert';

ListStoreModel listStoreModelFromJson(String str) =>
    ListStoreModel.fromJson(json.decode(str));

String listStoreModelToJson(ListStoreModel data) => json.encode(data.toJson());

class ListStoreModel {
  int status;
  String message;
  List<DataListStore> data;

  ListStoreModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ListStoreModel.fromJson(Map<String, dynamic> json) => ListStoreModel(
        status: json["status"],
        message: json["message"],
        data: List<DataListStore>.from(
            json["data"].map((x) => DataListStore.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class DataListStore {
  int storeId;
  int userId;
  String shopId;
  String storeName;
  String storeAddress;
  String? storeDescription;
  String? storeImages;
  String? storeLogo;
  int activeFlg;
  int deleteFlg;
  String createdAt;
  String updatedAt;

  DataListStore({
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
  });

  factory DataListStore.fromJson(Map<String, dynamic> json) => DataListStore(
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
      };
}
