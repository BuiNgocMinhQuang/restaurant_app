// To parse this JSON data, do
//
//     final manageBroughtReceiptModel = manageBroughtReceiptModelFromJson(jsonString);

import 'dart:convert';

ManageBroughtReceiptModel manageBroughtReceiptModelFromJson(String str) =>
    ManageBroughtReceiptModel.fromJson(json.decode(str));

String manageBroughtReceiptModelToJson(ManageBroughtReceiptModel data) =>
    json.encode(data.toJson());

class ManageBroughtReceiptModel {
  int status;
  Data data;
  int countOrderFoods;
  String orderTotal;

  ManageBroughtReceiptModel({
    required this.status,
    required this.data,
    required this.countOrderFoods,
    required this.orderTotal,
  });

  factory ManageBroughtReceiptModel.fromJson(Map<String, dynamic> json) =>
      ManageBroughtReceiptModel(
        status: json["status"],
        data: Data.fromJson(json["data"]),
        countOrderFoods: json["count_order_foods"],
        orderTotal: json["order_total"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
        "count_order_foods": countOrderFoods,
        "order_total": orderTotal,
      };
}

class Data {
  int currentPage;
  List<Datum> data;
  String firstPageUrl;
  int from;
  int lastPage;
  String lastPageUrl;
  List<Link> links;
  String nextPageUrl;
  String path;
  int perPage;
  dynamic prevPageUrl;
  int to;
  int total;

  Data({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    required this.nextPageUrl,
    required this.path,
    required this.perPage,
    required this.prevPageUrl,
    required this.to,
    required this.total,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        currentPage: json["current_page"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
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
        "links": List<dynamic>.from(links.map((x) => x.toJson())),
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
      };
}

class Datum {
  int foodId;
  int userId;
  int storeId;
  dynamic storeRoomId;
  String foodName;
  String foodDescription;
  String? foodImages;
  int foodPrice;
  String foodContent;
  int foodRate;
  int foodKind;
  int activeFlg;
  int deleteFlg;
  DateTime createdAt;
  DateTime updatedAt;
  int quantityFood;
  int? orderFoodId;
  int? orderId;

  Datum({
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
    required this.quantityFood,
    required this.orderFoodId,
    required this.orderId,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        quantityFood: json["quantity_food"],
        orderFoodId: json["order_food_id"],
        orderId: json["order_id"],
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
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "quantity_food": quantityFood,
        "order_food_id": orderFoodId,
        "order_id": orderId,
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
