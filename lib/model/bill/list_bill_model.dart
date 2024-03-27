// import 'dart:convert';

// ListBillShopModel listBillShopModelFromJson(String str) =>
//     ListBillShopModel.fromJson(json.decode(str));

// String listBillShopModelToJson(ListBillShopModel data) =>
//     json.encode(data.toJson());

// class ListBillShopModel {
//   int status;
//   Data data;

//   ListBillShopModel({
//     required this.status,
//     required this.data,
//   });

//   factory ListBillShopModel.fromJson(Map<String, dynamic> json) =>
//       ListBillShopModel(
//         status: json["status"],
//         data: Data.fromJson(json["data"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "status": status,
//         "data": data.toJson(),
//       };
// }

// class Data {
//   int? currentPage;
//   List<Datum> data;
//   String? firstPageUrl;
//   int? from;
//   int? lastPage;
//   String? lastPageUrl;
//   List<Link> links;
//   String? nextPageUrl;
//   String? path;
//   int? perPage;
//   String? prevPageUrl;
//   int? to;
//   int? total;

//   Data({
//     required this.currentPage,
//     required this.data,
//     required this.firstPageUrl,
//     required this.from,
//     required this.lastPage,
//     required this.lastPageUrl,
//     required this.links,
//     required this.nextPageUrl,
//     required this.path,
//     required this.perPage,
//     required this.prevPageUrl,
//     required this.to,
//     required this.total,
//   });

//   factory Data.fromJson(Map<String, dynamic> json) => Data(
//         currentPage: json["current_page"],
//         data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
//         firstPageUrl: json["first_page_url"],
//         from: json["from"],
//         lastPage: json["last_page"],
//         lastPageUrl: json["last_page_url"],
//         links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
//         nextPageUrl: json["next_page_url"],
//         path: json["path"],
//         perPage: json["per_page"],
//         prevPageUrl: json["prev_page_url"],
//         to: json["to"],
//         total: json["total"],
//       );

//   Map<String, dynamic> toJson() => {
//         "current_page": currentPage,
//         "data": List<dynamic>.from(data.map((x) => x.toJson())),
//         "first_page_url": firstPageUrl,
//         "from": from,
//         "last_page": lastPage,
//         "last_page_url": lastPageUrl,
//         "links": List<dynamic>.from(links.map((x) => x.toJson())),
//         "next_page_url": nextPageUrl,
//         "path": path,
//         "per_page": perPage,
//         "prev_page_url": prevPageUrl,
//         "to": to,
//         "total": total,
//       };
// }

// class Datum {
//   int? orderId;
//   int? userId;
//   int? staffId;
//   int? storeId;
//   int? storeRoomId;
//   dynamic clientId;
//   dynamic deposit;
//   dynamic amount;
//   dynamic paymentAmount;
//   dynamic clientName;
//   dynamic clientPhone;
//   dynamic clientEmail;
//   dynamic startBookedTableAt;
//   dynamic endBookedTableAt;
//   dynamic note;
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
//   DateTime createdAt;
//   DateTime updatedAt;
//   List<BookedTable> bookedTables;
//   Room? room;

//   Datum({
//     required this.orderId,
//     required this.userId,
//     required this.staffId,
//     required this.storeId,
//     required this.storeRoomId,
//     required this.clientId,
//     required this.deposit,
//     required this.amount,
//     required this.paymentAmount,
//     required this.clientName,
//     required this.clientPhone,
//     required this.clientEmail,
//     required this.startBookedTableAt,
//     required this.endBookedTableAt,
//     required this.note,
//     required this.cancellationReason,
//     required this.discount,
//     required this.guestPay,
//     required this.payKind,
//     required this.orderKind,
//     required this.guestPayClient,
//     required this.clientCanPay,
//     required this.orderTotal,
//     required this.payFlg,
//     required this.closeOrder,
//     required this.activeFlg,
//     required this.deleteFlg,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.bookedTables,
//     required this.room,
//   });

//   factory Datum.fromJson(Map<String, dynamic> json) => Datum(
//         orderId: json["order_id"],
//         userId: json["user_id"],
//         staffId: json["staff_id"],
//         storeId: json["store_id"],
//         storeRoomId: json["store_room_id"],
//         clientId: json["client_id"],
//         deposit: json["deposit"],
//         amount: json["amount"],
//         paymentAmount: json["payment_amount"],
//         clientName: json["client_name"],
//         clientPhone: json["client_phone"],
//         clientEmail: json["client_email"],
//         startBookedTableAt: json["start_booked_table_at"],
//         endBookedTableAt: json["end_booked_table_at"],
//         note: json["note"],
//         cancellationReason: json["cancellation_reason"],
//         discount: json["discount"],
//         guestPay: json["guest_pay"],
//         payKind: json["pay_kind"],
//         orderKind: json["order_kind"],
//         guestPayClient: json["guest_pay_client"],
//         clientCanPay: json["client_can_pay"],
//         orderTotal: json["order_total"],
//         payFlg: json["pay_flg"],
//         closeOrder: json["close_order"],
//         activeFlg: json["active_flg"],
//         deleteFlg: json["delete_flg"],
//         createdAt: DateTime.parse(json["created_at"]),
//         updatedAt: DateTime.parse(json["updated_at"]),
//         bookedTables: List<BookedTable>.from(
//             json["booked_tables"].map((x) => BookedTable.fromJson(x))),
//         room: json["room"] == null ? null : Room.fromJson(json["room"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "order_id": orderId,
//         "user_id": userId,
//         "staff_id": staffId,
//         "store_id": storeId,
//         "store_room_id": storeRoomId,
//         "client_id": clientId,
//         "deposit": deposit,
//         "amount": amount,
//         "payment_amount": paymentAmount,
//         "client_name": clientName,
//         "client_phone": clientPhone,
//         "client_email": clientEmail,
//         "start_booked_table_at": startBookedTableAt,
//         "end_booked_table_at": endBookedTableAt,
//         "note": note,
//         "cancellation_reason": cancellationReason,
//         "discount": discount,
//         "guest_pay": guestPay,
//         "pay_kind": payKind,
//         "order_kind": orderKind,
//         "guest_pay_client": guestPayClient,
//         "client_can_pay": clientCanPay,
//         "order_total": orderTotal,
//         "pay_flg": payFlg,
//         "close_order": closeOrder,
//         "active_flg": activeFlg,
//         "delete_flg": deleteFlg,
//         "created_at": createdAt.toIso8601String(),
//         "updated_at": updatedAt.toIso8601String(),
//         "booked_tables":
//             List<dynamic>.from(bookedTables.map((x) => x.toJson())),
//         "room": room?.toJson(),
//       };
// }

// class BookedTable {
//   int? bookedTableId;
//   int? orderId;
//   int? roomTableId;
//   int? activeFlg;
//   DateTime createdAt;
//   DateTime updatedAt;
//   RoomTable roomTable;

//   BookedTable({
//     required this.bookedTableId,
//     required this.orderId,
//     required this.roomTableId,
//     required this.activeFlg,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.roomTable,
//   });

//   factory BookedTable.fromJson(Map<String, dynamic> json) => BookedTable(
//         bookedTableId: json["booked_table_id"],
//         orderId: json["order_id"],
//         roomTableId: json["room_table_id"],
//         activeFlg: json["active_flg"],
//         createdAt: DateTime.parse(json["created_at"]),
//         updatedAt: DateTime.parse(json["updated_at"]),
//         roomTable: RoomTable.fromJson(json["room_table"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "booked_table_id": bookedTableId,
//         "order_id": orderId,
//         "room_table_id": roomTableId,
//         "active_flg": activeFlg,
//         "created_at": createdAt.toIso8601String(),
//         "updated_at": updatedAt.toIso8601String(),
//         "room_table": roomTable.toJson(),
//       };
// }

// class RoomTable {
//   int? roomTableId;
//   int? storeRoomId;
//   String? tableName;
//   int? activeFlg;
//   int? deleteFlg;
//   DateTime createdAt;
//   DateTime updatedAt;
//   int? numberOfSeats;
//   int? status;
//   String? description;

//   RoomTable({
//     required this.roomTableId,
//     required this.storeRoomId,
//     required this.tableName,
//     required this.activeFlg,
//     required this.deleteFlg,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.numberOfSeats,
//     required this.status,
//     required this.description,
//   });

//   factory RoomTable.fromJson(Map<String, dynamic> json) => RoomTable(
//         roomTableId: json["room_table_id"],
//         storeRoomId: json["store_room_id"],
//         tableName: json["table_name"],
//         activeFlg: json["active_flg"],
//         deleteFlg: json["delete_flg"],
//         createdAt: DateTime.parse(json["created_at"]),
//         updatedAt: DateTime.parse(json["updated_at"]),
//         numberOfSeats: json["number_of_seats"],
//         status: json["status"],
//         description: json["description"],
//       );

//   Map<String, dynamic> toJson() => {
//         "room_table_id": roomTableId,
//         "store_room_id": storeRoomId,
//         "table_name": tableName,
//         "active_flg": activeFlg,
//         "delete_flg": deleteFlg,
//         "created_at": createdAt.toIso8601String(),
//         "updated_at": updatedAt.toIso8601String(),
//         "number_of_seats": numberOfSeats,
//         "status": status,
//         "description": description,
//       };
// }

// class Room {
//   int? storeRoomId;
//   int? userId;
//   int? storeId;
//   String? storeRoomName;
//   int? activeFlg;
//   int? deleteFlg;
//   DateTime createdAt;
//   DateTime updatedAt;
//   String? slug;
//   String? images;

//   Room({
//     required this.storeRoomId,
//     required this.userId,
//     required this.storeId,
//     required this.storeRoomName,
//     required this.activeFlg,
//     required this.deleteFlg,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.slug,
//     required this.images,
//   });

//   factory Room.fromJson(Map<String, dynamic> json) => Room(
//         storeRoomId: json["store_room_id"],
//         userId: json["user_id"],
//         storeId: json["store_id"],
//         storeRoomName: json["store_room_name"],
//         activeFlg: json["active_flg"],
//         deleteFlg: json["delete_flg"],
//         createdAt: DateTime.parse(json["created_at"]),
//         updatedAt: DateTime.parse(json["updated_at"]),
//         slug: json["slug"],
//         images: json["images"],
//       );

//   Map<String, dynamic> toJson() => {
//         "store_room_id": storeRoomId,
//         "user_id": userId,
//         "store_id": storeId,
//         "store_room_name": storeRoomName,
//         "active_flg": activeFlg,
//         "delete_flg": deleteFlg,
//         "created_at": createdAt.toIso8601String(),
//         "updated_at": updatedAt.toIso8601String(),
//         "slug": slug,
//         "images": images,
//       };
// }

// // enum Slug { PHONG_SO_1, PHONG_SO_2 }

// // final slugValues =
// //     EnumValues({"phong-so-1": Slug.PHONG_SO_1, "phong-so-2": Slug.PHONG_SO_2});

// // enum StoreRoomName { PHONG_SO_1, PHONG_SO_2 }

// // final storeRoomNameValues = EnumValues({
// //   "phong so 1": StoreRoomName.PHONG_SO_1,
// //   "phong so 2": StoreRoomName.PHONG_SO_2
// // });

// class Link {
//   String? url;
//   String? label;
//   bool active;

//   Link({
//     required this.url,
//     required this.label,
//     required this.active,
//   });

//   factory Link.fromJson(Map<String, dynamic> json) => Link(
//         url: json["url"],
//         label: json["label"],
//         active: json["active"],
//       );

//   Map<String, dynamic> toJson() => {
//         "url": url,
//         "label": label,
//         "active": active,
//       };
// }

// class EnumValues<T> {
//   Map<String, T> map;
//   late Map<T, String> reverseMap;

//   EnumValues(this.map);

//   Map<T, String> get reverse {
//     reverseMap = map.map((k, v) => MapEntry(v, k));
//     return reverseMap;
//   }
// }

// To parse this JSON data, do
//
//     final listBillShopModel = listBillShopModelFromJson(jsonString);

import 'dart:convert';

ListBillShopModel listBillShopModelFromJson(String str) =>
    ListBillShopModel.fromJson(json.decode(str));

String listBillShopModelToJson(ListBillShopModel data) =>
    json.encode(data.toJson());

class ListBillShopModel {
  int status;
  Data data;

  ListBillShopModel({
    required this.status,
    required this.data,
  });

  factory ListBillShopModel.fromJson(Map<String, dynamic> json) =>
      ListBillShopModel(
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
  List<Datum> data;
  String firstPageUrl;
  int? from;
  int? lastPage;
  String lastPageUrl;
  List<Link> links;
  dynamic nextPageUrl;
  String path;
  int? perPage;
  dynamic prevPageUrl;
  int? to;
  int? total;

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
  int? orderId;
  int? userId;
  int? staffId;
  int? storeId;
  int? storeRoomId;
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
  int? discount;
  int? guestPay;
  int? payKind;
  int? orderKind;
  int? guestPayClient;
  int? clientCanPay;
  int? orderTotal;
  int? payFlg;
  int? closeOrder;
  int? activeFlg;
  int? deleteFlg;
  DateTime createdAt;
  DateTime updatedAt;
  List<BookedTable> bookedTables;
  Room room;

  Datum({
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
    required this.bookedTables,
    required this.room,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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
        bookedTables: List<BookedTable>.from(
            json["booked_tables"].map((x) => BookedTable.fromJson(x))),
        room: Room.fromJson(json["room"]),
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
        "booked_tables":
            List<dynamic>.from(bookedTables.map((x) => x.toJson())),
        "room": room.toJson(),
      };
}

class BookedTable {
  int? bookedTableId;
  int? orderId;
  int? roomTableId;
  int? activeFlg;
  DateTime createdAt;
  DateTime updatedAt;
  RoomTable roomTable;

  BookedTable({
    required this.bookedTableId,
    required this.orderId,
    required this.roomTableId,
    required this.activeFlg,
    required this.createdAt,
    required this.updatedAt,
    required this.roomTable,
  });

  factory BookedTable.fromJson(Map<String, dynamic> json) => BookedTable(
        bookedTableId: json["booked_table_id"],
        orderId: json["order_id"],
        roomTableId: json["room_table_id"],
        activeFlg: json["active_flg"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        roomTable: RoomTable.fromJson(json["room_table"]),
      );

  Map<String, dynamic> toJson() => {
        "booked_table_id": bookedTableId,
        "order_id": orderId,
        "room_table_id": roomTableId,
        "active_flg": activeFlg,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "room_table": roomTable.toJson(),
      };
}

class RoomTable {
  int? roomTableId;
  int? storeRoomId;
  String tableName;
  int? activeFlg;
  int? deleteFlg;
  DateTime createdAt;
  DateTime updatedAt;
  int? numberOfSeats;
  int? status;
  String? description;

  RoomTable({
    required this.roomTableId,
    required this.storeRoomId,
    required this.tableName,
    required this.activeFlg,
    required this.deleteFlg,
    required this.createdAt,
    required this.updatedAt,
    required this.numberOfSeats,
    required this.status,
    required this.description,
  });

  factory RoomTable.fromJson(Map<String, dynamic> json) => RoomTable(
        roomTableId: json["room_table_id"],
        storeRoomId: json["store_room_id"],
        tableName: json["table_name"],
        activeFlg: json["active_flg"],
        deleteFlg: json["delete_flg"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        numberOfSeats: json["number_of_seats"],
        status: json["status"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "room_table_id": roomTableId,
        "store_room_id": storeRoomId,
        "table_name": tableName,
        "active_flg": activeFlg,
        "delete_flg": deleteFlg,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "number_of_seats": numberOfSeats,
        "status": status,
        "description": description,
      };
}

class Room {
  int? storeRoomId;
  int? userId;
  int? storeId;
  String storeRoomName;
  int? activeFlg;
  int? deleteFlg;
  DateTime createdAt;
  DateTime updatedAt;
  String slug;
  String images;

  Room({
    required this.storeRoomId,
    required this.userId,
    required this.storeId,
    required this.storeRoomName,
    required this.activeFlg,
    required this.deleteFlg,
    required this.createdAt,
    required this.updatedAt,
    required this.slug,
    required this.images,
  });

  factory Room.fromJson(Map<String, dynamic> json) => Room(
        storeRoomId: json["store_room_id"],
        userId: json["user_id"],
        storeId: json["store_id"],
        storeRoomName: json["store_room_name"],
        activeFlg: json["active_flg"],
        deleteFlg: json["delete_flg"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        slug: json["slug"],
        images: json["images"],
      );

  Map<String, dynamic> toJson() => {
        "store_room_id": storeRoomId,
        "user_id": userId,
        "store_id": storeId,
        "store_room_name": storeRoomName,
        "active_flg": activeFlg,
        "delete_flg": deleteFlg,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "slug": slug,
        "images": images,
      };
}

class Link {
  String? url;
  String? label;
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
