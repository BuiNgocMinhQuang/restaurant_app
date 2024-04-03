// To parse this JSON data, do
//
//     final printBroughtReceiptModel = printBroughtReceiptModelFromJson(jsonString);

import 'dart:convert';

PrintBroughtReceiptModel printBroughtReceiptModelFromJson(String str) =>
    PrintBroughtReceiptModel.fromJson(json.decode(str));

String printBroughtReceiptModelToJson(PrintBroughtReceiptModel data) =>
    json.encode(data.toJson());

class PrintBroughtReceiptModel {
  int status;
  List<Datum> data;
  Order order;
  Store store;

  PrintBroughtReceiptModel({
    required this.status,
    required this.data,
    required this.order,
    required this.store,
  });

  factory PrintBroughtReceiptModel.fromJson(Map<String, dynamic> json) =>
      PrintBroughtReceiptModel(
        status: json["status"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        order: Order.fromJson(json["order"]),
        store: Store.fromJson(json["store"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "order": order.toJson(),
        "store": store.toJson(),
      };
}

class Datum {
  int orderFoodId;
  int foodId;
  int orderId;
  int quantityFood;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic roomTableId;
  int doneFlg;
  int userId;
  int storeId;
  dynamic storeRoomId;
  String foodName;
  String foodDescription;
  String foodImages;
  int foodPrice;
  String foodContent;
  int foodRate;
  int foodKind;
  dynamic activeFlg;
  dynamic deleteFlg;
  dynamic tableName;
  dynamic numberOfSeats;
  dynamic status;
  dynamic description;

  Datum({
    required this.orderFoodId,
    required this.foodId,
    required this.orderId,
    required this.quantityFood,
    required this.createdAt,
    required this.updatedAt,
    required this.roomTableId,
    required this.doneFlg,
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
    required this.tableName,
    required this.numberOfSeats,
    required this.status,
    required this.description,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        orderFoodId: json["order_food_id"],
        foodId: json["food_id"],
        orderId: json["order_id"],
        quantityFood: json["quantity_food"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        roomTableId: json["room_table_id"],
        doneFlg: json["done_flg"],
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
        tableName: json["table_name"],
        numberOfSeats: json["number_of_seats"],
        status: json["status"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "order_food_id": orderFoodId,
        "food_id": foodId,
        "order_id": orderId,
        "quantity_food": quantityFood,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "room_table_id": roomTableId,
        "done_flg": doneFlg,
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
        "table_name": tableName,
        "number_of_seats": numberOfSeats,
        "status": status,
        "description": description,
      };
}

class Order {
  int orderId;
  int userId;
  dynamic staffId;
  int storeId;
  dynamic storeRoomId;
  dynamic clientId;
  dynamic deposit;
  dynamic amount;
  dynamic paymentAmount;
  dynamic clientName;
  dynamic clientPhone;
  dynamic clientEmail;
  dynamic startBookedTableAt;
  dynamic endBookedTableAt;
  dynamic note;
  dynamic cancellationReason;
  int discount;
  int guestPay;
  int payKind;
  int orderKind;
  int guestPayClient;
  int clientCanPay;
  int orderTotal;
  int payFlg;
  int closeOrder;
  int activeFlg;
  int deleteFlg;
  DateTime createdAt;
  DateTime updatedAt;

  Order({
    required this.orderId,
    required this.userId,
    required this.staffId,
    required this.storeId,
    required this.storeRoomId,
    required this.clientId,
    required this.deposit,
    required this.amount,
    required this.paymentAmount,
    required this.clientName,
    required this.clientPhone,
    required this.clientEmail,
    required this.startBookedTableAt,
    required this.endBookedTableAt,
    required this.note,
    required this.cancellationReason,
    required this.discount,
    required this.guestPay,
    required this.payKind,
    required this.orderKind,
    required this.guestPayClient,
    required this.clientCanPay,
    required this.orderTotal,
    required this.payFlg,
    required this.closeOrder,
    required this.activeFlg,
    required this.deleteFlg,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        orderId: json["order_id"],
        userId: json["user_id"],
        staffId: json["staff_id"],
        storeId: json["store_id"],
        storeRoomId: json["store_room_id"],
        clientId: json["client_id"],
        deposit: json["deposit"],
        amount: json["amount"],
        paymentAmount: json["payment_amount"],
        clientName: json["client_name"],
        clientPhone: json["client_phone"],
        clientEmail: json["client_email"],
        startBookedTableAt: json["start_booked_table_at"],
        endBookedTableAt: json["end_booked_table_at"],
        note: json["note"],
        cancellationReason: json["cancellation_reason"],
        discount: json["discount"],
        guestPay: json["guest_pay"],
        payKind: json["pay_kind"],
        orderKind: json["order_kind"],
        guestPayClient: json["guest_pay_client"],
        clientCanPay: json["client_can_pay"],
        orderTotal: json["order_total"],
        payFlg: json["pay_flg"],
        closeOrder: json["close_order"],
        activeFlg: json["active_flg"],
        deleteFlg: json["delete_flg"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "user_id": userId,
        "staff_id": staffId,
        "store_id": storeId,
        "store_room_id": storeRoomId,
        "client_id": clientId,
        "deposit": deposit,
        "amount": amount,
        "payment_amount": paymentAmount,
        "client_name": clientName,
        "client_phone": clientPhone,
        "client_email": clientEmail,
        "start_booked_table_at": startBookedTableAt,
        "end_booked_table_at": endBookedTableAt,
        "note": note,
        "cancellation_reason": cancellationReason,
        "discount": discount,
        "guest_pay": guestPay,
        "pay_kind": payKind,
        "order_kind": orderKind,
        "guest_pay_client": guestPayClient,
        "client_can_pay": clientCanPay,
        "order_total": orderTotal,
        "pay_flg": payFlg,
        "close_order": closeOrder,
        "active_flg": activeFlg,
        "delete_flg": deleteFlg,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class Store {
  int storeId;
  int userId;
  String shopId;
  String storeName;
  String storeAddress;
  String storeDescription;
  String storeImages;
  dynamic storeLogo;
  int activeFlg;
  int deleteFlg;
  DateTime createdAt;
  DateTime updatedAt;

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
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
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
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
