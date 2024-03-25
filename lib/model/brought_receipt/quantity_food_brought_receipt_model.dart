// To parse this JSON data, do
//
//     final quantityFoodBroughtReceiptModel = quantityFoodBroughtReceiptModelFromJson(jsonString);

import 'dart:convert';

QuantityFoodBroughtReceiptModel quantityFoodBroughtReceiptModelFromJson(
        String str) =>
    QuantityFoodBroughtReceiptModel.fromJson(json.decode(str));

String quantityFoodBroughtReceiptModelToJson(
        QuantityFoodBroughtReceiptModel data) =>
    json.encode(data.toJson());

class QuantityFoodBroughtReceiptModel {
  int status;
  Message message;
  int quantityFood;
  int orderId;
  String orderTotal;
  int countOrderFoods;

  QuantityFoodBroughtReceiptModel({
    required this.status,
    required this.message,
    required this.quantityFood,
    required this.orderId,
    required this.orderTotal,
    required this.countOrderFoods,
  });

  factory QuantityFoodBroughtReceiptModel.fromJson(Map<String, dynamic> json) =>
      QuantityFoodBroughtReceiptModel(
        status: json["status"],
        message: Message.fromJson(json["message"]),
        quantityFood: json["quantity_food"],
        orderId: json["order_id"],
        orderTotal: json["order_total"],
        countOrderFoods: json["count_order_foods"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message.toJson(),
        "quantity_food": quantityFood,
        "order_id": orderId,
        "order_total": orderTotal,
        "count_order_foods": countOrderFoods,
      };
}

class Message {
  String title;
  String icon;

  Message({
    required this.title,
    required this.icon,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        title: json["title"],
        icon: json["icon"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "icon": icon,
      };
}
