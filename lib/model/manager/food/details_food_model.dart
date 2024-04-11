// To parse this JSON data, do
//
//     final detailsFoodModel = detailsFoodModelFromJson(jsonString);

import 'dart:convert';

DetailsFoodModel detailsFoodModelFromJson(String str) =>
    DetailsFoodModel.fromJson(json.decode(str));

String detailsFoodModelToJson(DetailsFoodModel data) =>
    json.encode(data.toJson());

class DetailsFoodModel {
  int status;
  DetailsFoodData food;
  List<String> foodKinds;
  List<Store> stores;

  DetailsFoodModel({
    required this.status,
    required this.food,
    required this.foodKinds,
    required this.stores,
  });

  factory DetailsFoodModel.fromJson(Map<String, dynamic> json) =>
      DetailsFoodModel(
        status: json["status"],
        food: DetailsFoodData.fromJson(json["food"]),
        foodKinds: List<String>.from(json["food_kinds"].map((x) => x)),
        stores: List<Store>.from(json["stores"].map((x) => Store.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "food": food.toJson(),
        "food_kinds": List<dynamic>.from(foodKinds.map((x) => x)),
        "stores": List<dynamic>.from(stores.map((x) => x.toJson())),
      };
}

class DetailsFoodData {
  int foodId;
  int? userId;
  int? storeId;
  int? storeRoomId;
  String? foodName;
  String? foodDescription;
  List<FoodImage> foodImages;
  int? foodPrice;
  String foodContent;
  int? foodRate;
  int? foodKind;
  int? activeFlg;
  int? deleteFlg;
  String? createdAt;
  String? updatedAt;
  String? storeName;

  DetailsFoodData({
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

  factory DetailsFoodData.fromJson(Map<String, dynamic> json) =>
      DetailsFoodData(
        foodId: json["food_id"],
        userId: json["user_id"],
        storeId: json["store_id"],
        storeRoomId: json["store_room_id"],
        foodName: json["food_name"],
        foodDescription: json["food_description"],
        foodImages: List<FoodImage>.from(
            json["food_images"].map((x) => FoodImage.fromJson(x))),
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
        "food_images": List<dynamic>.from(foodImages.map((x) => x.toJson())),
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

class FoodImage {
  String? name;
  int? size;
  String? path;
  String? normal;

  FoodImage({
    required this.name,
    required this.size,
    required this.path,
    required this.normal,
  });

  factory FoodImage.fromJson(Map<String, dynamic> json) => FoodImage(
        name: json["name"],
        size: json["size"],
        path: json["path"],
        normal: json["normal"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "size": size,
        "path": path,
        "normal": normal,
      };
}

class Store {
  int? storeId;
  String? storeName;

  Store({
    required this.storeId,
    required this.storeName,
  });

  factory Store.fromJson(Map<String, dynamic> json) => Store(
        storeId: json["store_id"],
        storeName: json["store_name"],
      );

  Map<String, dynamic> toJson() => {
        "store_id": storeId,
        "store_name": storeName,
      };
}
