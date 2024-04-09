// To parse this JSON data, do
//
//     final managerListFoodModel = managerListFoodModelFromJson(jsonString);

import 'dart:convert';

ManagerListFoodModel managerListFoodModelFromJson(String str) =>
    ManagerListFoodModel.fromJson(json.decode(str));

String managerListFoodModelToJson(ManagerListFoodModel data) =>
    json.encode(data.toJson());

class ManagerListFoodModel {
  int? status;
  String message;
  Data data;

  ManagerListFoodModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ManagerListFoodModel.fromJson(Map<String, dynamic> json) =>
      ManagerListFoodModel(
        status: json["status"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  int? currentPage;
  List<DataFoodAllStore> data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  String? nextPageUrl;
  String? path;
  int? perPage;
  int? to;
  int? total;

  Data({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.nextPageUrl,
    required this.path,
    required this.perPage,
    required this.to,
    required this.total,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        currentPage: json["current_page"],
        data: List<DataFoodAllStore>.from(
            json["data"].map((x) => DataFoodAllStore.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "to": to,
        "total": total,
      };
}

class DataFoodAllStore {
  int? foodId;
  int? userId;
  int? storeId;
  int? storeRoomId;
  String? foodName;
  String? foodDescription;
  String? foodImages;
  int? foodPrice;
  String? foodContent;
  int? foodRate;
  int? foodKind;
  int? activeFlg;
  int? deleteFlg;
  String? createdAt;
  String? updatedAt;
  String? storeName;

  DataFoodAllStore({
    required this.foodId,
    required this.userId,
    required this.storeId,
    required this.storeRoomId,
    required this.foodName,
    required this.foodDescription,
    required this.foodImages,
    required this.foodPrice,
    required this.foodContent,
    required this.foodRate,
    required this.foodKind,
    required this.activeFlg,
    required this.deleteFlg,
    required this.createdAt,
    required this.updatedAt,
    required this.storeName,
  });

  factory DataFoodAllStore.fromJson(Map<String, dynamic> json) =>
      DataFoodAllStore(
        foodId: json["food_id"],
        userId: json["user_id"],
        storeId: json["store_id"],
        storeRoomId: json["store_room_id"],
        foodName: json["food_name"],
        foodDescription: json["food_description"],
        foodImages: json["food_images"],
        foodPrice: json["food_price"],
        foodContent: json["food_content"],
        foodRate: json["food_rate"],
        foodKind: json["food_kind"],
        activeFlg: json["active_flg"],
        deleteFlg: json["delete_flg"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        storeName: json["store_name"],
      );

  Map<String, dynamic> toJson() => {
        "food_id": foodId,
        "user_id": userId,
        "store_id": storeId,
        "store_room_id": storeRoomId,
        "food_name": foodName,
        "food_description": foodDescription,
        "food_images": foodImages,
        "food_price": foodPrice,
        "food_content": foodContent,
        "food_rate": foodRate,
        "food_kind": foodKind,
        "active_flg": activeFlg,
        "delete_flg": deleteFlg,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "store_name": storeName,
      };
}

class Link {
  String? url;
  String label;
  bool active;

  Link({
    required this.url,
    required this.label,
    required this.active,
  });

  factory Link.fromJson(Map<String, dynamic> json) => Link(
        url: json["url"],
        label: json["label"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "label": label,
        "active": active,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
