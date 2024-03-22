// To parse this JSON data, do
//
//     final listBroughtReceiptModel = broughtReceiptModelFromJson(jsonString);

import 'dart:convert';

ListBroughtReceiptModel broughtReceiptModelFromJson(String str) =>
    ListBroughtReceiptModel.fromJson(json.decode(str));

String broughtReceiptModelToJson(ListBroughtReceiptModel data) =>
    json.encode(data.toJson());

class ListBroughtReceiptModel {
  int status;
  Data data;

  ListBroughtReceiptModel({
    required this.status,
    required this.data,
  });

  factory ListBroughtReceiptModel.fromJson(Map<String, dynamic> json) =>
      ListBroughtReceiptModel(
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
  int from;
  int lastPage;
  String lastPageUrl;
  List<Link> links;
  dynamic nextPageUrl;
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
  int orderId;
  int userId;
  int staffId;
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
  String? cancellationReason;
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
