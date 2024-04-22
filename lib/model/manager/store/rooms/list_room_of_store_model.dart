// To parse this JSON data, do
//
//     final listRoomOfStoreModel = listRoomOfStoreModelFromJson(jsonString);

import 'dart:convert';

ListRoomOfStoreModel listRoomOfStoreModelFromJson(String str) =>
    ListRoomOfStoreModel.fromJson(json.decode(str));

String listRoomOfStoreModelToJson(ListRoomOfStoreModel data) =>
    json.encode(data.toJson());

class ListRoomOfStoreModel {
  int status;
  List<DataListRoomOfStore> rooms;

  ListRoomOfStoreModel({
    required this.status,
    required this.rooms,
  });

  factory ListRoomOfStoreModel.fromJson(Map<String, dynamic> json) =>
      ListRoomOfStoreModel(
        status: json["status"],
        rooms: List<DataListRoomOfStore>.from(
            json["rooms"].map((x) => DataListRoomOfStore.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "rooms": List<dynamic>.from(rooms.map((x) => x.toJson())),
      };
}

class DataListRoomOfStore {
  int storeRoomId;
  int userId;
  int storeId;
  String storeRoomName;
  int activeFlg;
  int deleteFlg;
  String? createdAt;
  String? updatedAt;
  String? images;
  int roomTablesCount;
  Store store;

  DataListRoomOfStore({
    required this.storeRoomId,
    required this.userId,
    required this.storeId,
    required this.storeRoomName,
    required this.activeFlg,
    required this.deleteFlg,
    required this.createdAt,
    required this.updatedAt,
    required this.images,
    required this.roomTablesCount,
    required this.store,
  });

  factory DataListRoomOfStore.fromJson(Map<String, dynamic> json) =>
      DataListRoomOfStore(
        storeRoomId: json["store_room_id"],
        userId: json["user_id"],
        storeId: json["store_id"],
        storeRoomName: json["store_room_name"],
        activeFlg: json["active_flg"],
        deleteFlg: json["delete_flg"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        images: json["images"],
        roomTablesCount: json["room_tables_count"],
        store: Store.fromJson(json["store"]),
      );

  Map<String, dynamic> toJson() => {
        "store_room_id": storeRoomId,
        "user_id": userId,
        "store_id": storeId,
        "store_room_name": storeRoomName,
        "active_flg": activeFlg,
        "delete_flg": deleteFlg,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "images": images,
        "room_tables_count": roomTablesCount,
        "store": store.toJson(),
      };
}

class Store {
  int storeId;
  int userId;
  String shopId;
  String? storeName;
  String? storeAddress;
  String? storeDescription;
  String? storeImages;
  String? storeLogo;
  int activeFlg;
  int deleteFlg;
  String? createdAt;
  String? updatedAt;

  Store({
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

  factory Store.fromJson(Map<String, dynamic> json) => Store(
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
