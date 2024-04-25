import 'dart:convert';

DataListFoodOrderModel dataListFoodOrderModelFromJson(String str) =>
    DataListFoodOrderModel.fromJson(json.decode(str));

String dataListFoodOrderModelToJson(DataListFoodOrderModel data) =>
    json.encode(data.toJson());

class DataListFoodOrderModel {
  int status;
  Data data;

  DataListFoodOrderModel({
    required this.status,
    required this.data,
  });

  factory DataListFoodOrderModel.fromJson(Map<String, dynamic> json) =>
      DataListFoodOrderModel(
        status: json["status"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
      };
}

class Data {
  int currentPage;
  List<DataFoodOrder> data;
  int total;
  Data({
    required this.currentPage,
    required this.data,
    required this.total,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        currentPage: json["current_page"],
        data: List<DataFoodOrder>.from(
            json["data"].map((x) => DataFoodOrder.fromJson(x))),
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "total": total,
      };
}

class DataFoodOrder {
  int foodInOrderId;
  int userId;
  int storeId;
  int? storeRoomId;
  int? roomTableId;
  int orderId;
  int orderFoodId;
  int foodId;
  int? foodInOrderStatus;
  int? activeFlg;
  String? createdAt;
  String? updatedAt;
  int foodPrice;
  String? foodImages;
  String? foodName;
  String? tableName;
  String? storeRoomName;
  int staffId;
  String? staffFullName;

  DataFoodOrder({
    required this.foodInOrderId,
    required this.userId,
    required this.storeId,
    required this.storeRoomId,
    required this.roomTableId,
    required this.orderId,
    required this.orderFoodId,
    required this.foodId,
    required this.foodInOrderStatus,
    required this.activeFlg,
    required this.createdAt,
    required this.updatedAt,
    required this.foodPrice,
    required this.foodImages,
    required this.foodName,
    required this.tableName,
    required this.storeRoomName,
    required this.staffId,
    required this.staffFullName,
  });

  factory DataFoodOrder.fromJson(Map<String, dynamic> json) => DataFoodOrder(
        foodInOrderId: json["food_in_order_id"],
        userId: json["user_id"],
        storeId: json["store_id"],
        storeRoomId: json["store_room_id"],
        roomTableId: json["room_table_id"],
        orderId: json["order_id"],
        orderFoodId: json["order_food_id"],
        foodId: json["food_id"],
        foodInOrderStatus: json["food_in_order_status"],
        activeFlg: json["active_flg"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        foodPrice: json["food_price"],
        foodImages: json["food_images"],
        foodName: json["food_name"],
        tableName: json["table_name"],
        storeRoomName: json["store_room_name"],
        staffId: json["staff_id"],
        staffFullName: json["staff_full_name"],
      );

  Map<String, dynamic> toJson() => {
        "food_in_order_id": foodInOrderId,
        "user_id": userId,
        "store_id": storeId,
        "store_room_id": storeRoomId,
        "room_table_id": roomTableId,
        "order_id": orderId,
        "order_food_id": orderFoodId,
        "food_id": foodId,
        "food_in_order_status": foodInOrderStatus,
        "active_flg": activeFlg,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "food_price": foodPrice,
        "food_images": foodImages,
        "food_name": foodName,
        "table_name": tableName,
        "store_room_name": storeRoomName,
        "staff_id": staffId,
        "staff_full_name": staffFullName,
      };
}
