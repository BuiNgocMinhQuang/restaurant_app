// class FoodTableDataModel {
//   int? status;
//   int? countOrderFoods;
//   Foods? foods;
//   Booking? booking;

//   FoodTableDataModel(
//       {this.status, this.countOrderFoods, this.foods, this.booking});

//   FoodTableDataModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     countOrderFoods = json['count_order_foods'];
//     foods = json['foods'] != null ? new Foods.fromJson(json['foods']) : null;
//     booking =
//         json['booking'] != null ? new Booking.fromJson(json['booking']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     data['count_order_foods'] = this.countOrderFoods;
//     if (this.foods != null) {
//       data['foods'] = this.foods!.toJson();
//     }
//     if (this.booking != null) {
//       data['booking'] = this.booking!.toJson();
//     }
//     return data;
//   }
// }

// class Foods {
//   int? currentPage;
//   List<Data>? data;
//   String? firstPageUrl;
//   int? from;
//   int? lastPage;
//   String? lastPageUrl;
//   List<Links>? links;
//   String? nextPageUrl;
//   String? path;
//   int? perPage;
//   String? prevPageUrl;
//   int? to;
//   int? total;

//   Foods(
//       {this.currentPage,
//       this.data,
//       this.firstPageUrl,
//       this.from,
//       this.lastPage,
//       this.lastPageUrl,
//       this.links,
//       this.nextPageUrl,
//       this.path,
//       this.perPage,
//       this.prevPageUrl,
//       this.to,
//       this.total});

//   Foods.fromJson(Map<String, dynamic> json) {
//     currentPage = json['current_page'];
//     if (json['data'] != null) {
//       data = <Data>[];
//       json['data'].forEach((v) {
//         data!.add(new Data.fromJson(v));
//       });
//     }
//     firstPageUrl = json['first_page_url'];
//     from = json['from'];
//     lastPage = json['last_page'];
//     lastPageUrl = json['last_page_url'];
//     if (json['links'] != null) {
//       links = <Links>[];
//       json['links'].forEach((v) {
//         links!.add(new Links.fromJson(v));
//       });
//     }
//     nextPageUrl = json['next_page_url'];
//     path = json['path'];
//     perPage = json['per_page'];
//     prevPageUrl = json['prev_page_url'];
//     to = json['to'];
//     total = json['total'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['current_page'] = this.currentPage;
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     data['first_page_url'] = this.firstPageUrl;
//     data['from'] = this.from;
//     data['last_page'] = this.lastPage;
//     data['last_page_url'] = this.lastPageUrl;
//     if (this.links != null) {
//       data['links'] = this.links!.map((v) => v.toJson()).toList();
//     }
//     data['next_page_url'] = this.nextPageUrl;
//     data['path'] = this.path;
//     data['per_page'] = this.perPage;
//     data['prev_page_url'] = this.prevPageUrl;
//     data['to'] = this.to;
//     data['total'] = this.total;
//     return data;
//   }
// }

// class Data {
//   int? foodId;
//   int? userId;
//   int? storeId;
//   int? storeRoomId;
//   String? foodName;
//   String? foodDescription;
//   String? foodImages;
//   int? foodPrice;
//   String? foodContent;
//   int? foodRate;
//   int? foodKind;
//   int? activeFlg;
//   int? deleteFlg;
//   String? createdAt;
//   String? updatedAt;
//   int? quantityFood;
//   int? orderFoodId;
//   int? orderId;
//   int? roomTableId;

//   Data(
//       {this.foodId,
//       this.userId,
//       this.storeId,
//       this.storeRoomId,
//       this.foodName,
//       this.foodDescription,
//       this.foodImages,
//       this.foodPrice,
//       this.foodContent,
//       this.foodRate,
//       this.foodKind,
//       this.activeFlg,
//       this.deleteFlg,
//       this.createdAt,
//       this.updatedAt,
//       this.quantityFood,
//       this.orderFoodId,
//       this.orderId,
//       this.roomTableId});

//   Data.fromJson(Map<String, dynamic> json) {
//     foodId = json['food_id'];
//     userId = json['user_id'];
//     storeId = json['store_id'];
//     storeRoomId = json['store_room_id'];
//     foodName = json['food_name'];
//     foodDescription = json['food_description'];
//     foodImages = json['food_images'];
//     foodPrice = json['food_price'];
//     foodContent = json['food_content'];
//     foodRate = json['food_rate'];
//     foodKind = json['food_kind'];
//     activeFlg = json['active_flg'];
//     deleteFlg = json['delete_flg'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     quantityFood = json['quantity_food'];
//     orderFoodId = json['order_food_id'];
//     orderId = json['order_id'];
//     roomTableId = json['room_table_id'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['food_id'] = this.foodId;
//     data['user_id'] = this.userId;
//     data['store_id'] = this.storeId;
//     data['store_room_id'] = this.storeRoomId;
//     data['food_name'] = this.foodName;
//     data['food_description'] = this.foodDescription;
//     data['food_images'] = this.foodImages;
//     data['food_price'] = this.foodPrice;
//     data['food_content'] = this.foodContent;
//     data['food_rate'] = this.foodRate;
//     data['food_kind'] = this.foodKind;
//     data['active_flg'] = this.activeFlg;
//     data['delete_flg'] = this.deleteFlg;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     data['quantity_food'] = this.quantityFood;
//     data['order_food_id'] = this.orderFoodId;
//     data['order_id'] = this.orderId;
//     data['room_table_id'] = this.roomTableId;
//     return data;
//   }
// }

// class Links {
//   String? url;
//   String? label;
//   bool? active;

//   Links({this.url, this.label, this.active});

//   Links.fromJson(Map<String, dynamic> json) {
//     url = json['url'];
//     label = json['label'];
//     active = json['active'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['url'] = this.url;
//     data['label'] = this.label;
//     data['active'] = this.active;
//     return data;
//   }
// }

// class Booking {
//   int? bookedTableId;
//   int? orderId;
//   int? roomTableId;
//   int? activeFlg;
//   String? createdAt;
//   String? updatedAt;
//   Order? order;
//   RoomTable? roomTable;

//   Booking(
//       {this.bookedTableId,
//       this.orderId,
//       this.roomTableId,
//       this.activeFlg,
//       this.createdAt,
//       this.updatedAt,
//       this.order,
//       this.roomTable});

//   Booking.fromJson(Map<String, dynamic> json) {
//     bookedTableId = json['booked_table_id'];
//     orderId = json['order_id'];
//     roomTableId = json['room_table_id'];
//     activeFlg = json['active_flg'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     order = json['order'] != null ? new Order.fromJson(json['order']) : null;
//     roomTable = json['room_table'] != null
//         ? new RoomTable.fromJson(json['room_table'])
//         : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['booked_table_id'] = this.bookedTableId;
//     data['order_id'] = this.orderId;
//     data['room_table_id'] = this.roomTableId;
//     data['active_flg'] = this.activeFlg;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     if (this.order != null) {
//       data['order'] = this.order!.toJson();
//     }
//     if (this.roomTable != null) {
//       data['room_table'] = this.roomTable!.toJson();
//     }
//     return data;
//   }
// }

// class Order {
//   int? orderId;
//   int? userId;
//   int? staffId;
//   int? storeId;
//   int? storeRoomId;
//   int? clientId;
//   int? deposit;
//   int? amount;
//   int? paymentAmount;
//   String? clientName;
//   String? clientPhone;
//   String? clientEmail;
//   String? startBookedTableAt;
//   String? endBookedTableAt;
//   String? note;
//   String? cancellationReason;
//   int? discount;
//   int? guestPay;
//   int? payKind;
//   int? orderKind;
//   int? guestPayClient;
//   int? clientCanPay;
//   int? orderTotal;
//   int? payFlg;
//   int? closeOrder;
//   int? activeFlg;
//   int? deleteFlg;
//   String? createdAt;
//   String? updatedAt;

//   Order(
//       {this.orderId,
//       this.userId,
//       this.staffId,
//       this.storeId,
//       this.storeRoomId,
//       this.clientId,
//       this.deposit,
//       this.amount,
//       this.paymentAmount,
//       this.clientName,
//       this.clientPhone,
//       this.clientEmail,
//       this.startBookedTableAt,
//       this.endBookedTableAt,
//       this.note,
//       this.cancellationReason,
//       this.discount,
//       this.guestPay,
//       this.payKind,
//       this.orderKind,
//       this.guestPayClient,
//       this.clientCanPay,
//       this.orderTotal,
//       this.payFlg,
//       this.closeOrder,
//       this.activeFlg,
//       this.deleteFlg,
//       this.createdAt,
//       this.updatedAt});

//   Order.fromJson(Map<String, dynamic> json) {
//     orderId = json['order_id'];
//     userId = json['user_id'];
//     staffId = json['staff_id'];
//     storeId = json['store_id'];
//     storeRoomId = json['store_room_id'];
//     clientId = json['client_id'];
//     deposit = json['deposit'];
//     amount = json['amount'];
//     paymentAmount = json['payment_amount'];
//     clientName = json['client_name'];
//     clientPhone = json['client_phone'];
//     clientEmail = json['client_email'];
//     startBookedTableAt = json['start_booked_table_at'];
//     endBookedTableAt = json['end_booked_table_at'];
//     note = json['note'];
//     cancellationReason = json['cancellation_reason'];
//     discount = json['discount'];
//     guestPay = json['guest_pay'];
//     payKind = json['pay_kind'];
//     orderKind = json['order_kind'];
//     guestPayClient = json['guest_pay_client'];
//     clientCanPay = json['client_can_pay'];
//     orderTotal = json['order_total'];
//     payFlg = json['pay_flg'];
//     closeOrder = json['close_order'];
//     activeFlg = json['active_flg'];
//     deleteFlg = json['delete_flg'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['order_id'] = this.orderId;
//     data['user_id'] = this.userId;
//     data['staff_id'] = this.staffId;
//     data['store_id'] = this.storeId;
//     data['store_room_id'] = this.storeRoomId;
//     data['client_id'] = this.clientId;
//     data['deposit'] = this.deposit;
//     data['amount'] = this.amount;
//     data['payment_amount'] = this.paymentAmount;
//     data['client_name'] = this.clientName;
//     data['client_phone'] = this.clientPhone;
//     data['client_email'] = this.clientEmail;
//     data['start_booked_table_at'] = this.startBookedTableAt;
//     data['end_booked_table_at'] = this.endBookedTableAt;
//     data['note'] = this.note;
//     data['cancellation_reason'] = this.cancellationReason;
//     data['discount'] = this.discount;
//     data['guest_pay'] = this.guestPay;
//     data['pay_kind'] = this.payKind;
//     data['order_kind'] = this.orderKind;
//     data['guest_pay_client'] = this.guestPayClient;
//     data['client_can_pay'] = this.clientCanPay;
//     data['order_total'] = this.orderTotal;
//     data['pay_flg'] = this.payFlg;
//     data['close_order'] = this.closeOrder;
//     data['active_flg'] = this.activeFlg;
//     data['delete_flg'] = this.deleteFlg;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     return data;
//   }
// }

// class RoomTable {
//   int? roomTableId;
//   int? storeRoomId;
//   String? tableName;
//   int? activeFlg;
//   int? deleteFlg;
//   String? createdAt;
//   String? updatedAt;
//   int? numberOfSeats;
//   int? status;
//   String? description;

//   RoomTable(
//       {this.roomTableId,
//       this.storeRoomId,
//       this.tableName,
//       this.activeFlg,
//       this.deleteFlg,
//       this.createdAt,
//       this.updatedAt,
//       this.numberOfSeats,
//       this.status,
//       this.description});

//   RoomTable.fromJson(Map<String, dynamic> json) {
//     roomTableId = json['room_table_id'];
//     storeRoomId = json['store_room_id'];
//     tableName = json['table_name'];
//     activeFlg = json['active_flg'];
//     deleteFlg = json['delete_flg'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     numberOfSeats = json['number_of_seats'];
//     status = json['status'];
//     description = json['description'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['room_table_id'] = this.roomTableId;
//     data['store_room_id'] = this.storeRoomId;
//     data['table_name'] = this.tableName;
//     data['active_flg'] = this.activeFlg;
//     data['delete_flg'] = this.deleteFlg;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     data['number_of_seats'] = this.numberOfSeats;
//     data['status'] = this.status;
//     data['description'] = this.description;
//     return data;
//   }
// }

// To parse this JSON data, do
//
//     final foodTableDataModel = foodTableDataModelFromJson(jsonString);

import 'dart:convert';

FoodTableDataModel foodTableDataModelFromJson(String str) =>
    FoodTableDataModel.fromJson(json.decode(str));

String foodTableDataModelToJson(FoodTableDataModel data) =>
    json.encode(data.toJson());

class FoodTableDataModel {
  int status;
  int? countOrderFoods;
  Foods foods;
  dynamic booking;

  FoodTableDataModel({
    required this.status,
    required this.countOrderFoods,
    required this.foods,
    required this.booking,
  });

  factory FoodTableDataModel.fromJson(Map<String, dynamic> json) =>
      FoodTableDataModel(
        status: json["status"],
        countOrderFoods: json["count_order_foods"],
        foods: Foods.fromJson(json["foods"]),
        booking: json["booking"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "count_order_foods": countOrderFoods,
        "foods": foods.toJson(),
        "booking": booking,
      };
}

class Foods {
  int? currentPage;
  List<Datum> data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  String? nextPageUrl;
  String? path;
  int? perPage;
  dynamic prevPageUrl;
  int? to;
  int? total;

  Foods({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.nextPageUrl,
    required this.path,
    required this.perPage,
    required this.prevPageUrl,
    required this.to,
    required this.total,
  });

  factory Foods.fromJson(Map<String, dynamic> json) => Foods(
        currentPage: json["current_page"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
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
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
      };
}

class Datum {
  int? foodId;
  int? userId;
  int? storeId;
  dynamic storeRoomId;
  String? foodName;
  String? foodDescription;
  String? foodImages;
  int? foodPrice;
  String? foodContent;
  int? foodRate;
  int? foodKind;
  int? activeFlg;
  int? deleteFlg;
  DateTime createdAt;
  DateTime updatedAt;
  int? quantityFood;
  dynamic orderFoodId;
  dynamic orderId;
  dynamic roomTableId;
  int? foodsTotal;
  String? foodsWaiting;
  String? foodsCooking;
  String? foodsCompleted;

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
    required this.roomTableId,
    required this.foodsTotal,
    required this.foodsWaiting,
    required this.foodsCooking,
    required this.foodsCompleted,
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
        roomTableId: json["room_table_id"],
        foodsTotal: json["foods_total"],
        foodsWaiting: json["foods_waiting"],
        foodsCooking: json["foods_cooking"],
        foodsCompleted: json["foods_completed"],
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
        "room_table_id": roomTableId,
        "foods_total": foodsTotal,
        "foods_waiting": foodsWaiting,
        "foods_cooking": foodsCooking,
        "foods_completed": foodsCompleted,
      };
}
