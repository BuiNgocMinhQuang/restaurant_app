class ListRoomModel {
  int? status;
  List<Rooms>? rooms;

  ListRoomModel({this.status, this.rooms});

  ListRoomModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['rooms'] != null) {
      rooms = <Rooms>[];
      json['rooms'].forEach((v) {
        rooms!.add(new Rooms.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (rooms != null) {
      data['rooms'] = rooms!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Rooms {
  int? storeRoomId;
  String? storeRoomName;
  List<Tables>? tables;

  Rooms({this.storeRoomId, this.storeRoomName, this.tables});

  Rooms.fromJson(Map<String, dynamic> json) {
    storeRoomId = json['store_room_id'];
    storeRoomName = json['store_room_name'];
    if (json['tables'] != null) {
      tables = <Tables>[];
      json['tables'].forEach((v) {
        tables!.add(Tables.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['store_room_id'] = storeRoomId;
    data['store_room_name'] = storeRoomName;
    if (tables != null) {
      data['tables'] = tables!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Tables {
  bool? bookingStatus;
  int? orderId;
  String? clientCanPay;
  String? orderCreatedAt;
  String? tableName;
  int? roomTableId;

  Tables(
      {this.bookingStatus,
      this.orderId,
      this.clientCanPay,
      this.orderCreatedAt,
      this.tableName,
      this.roomTableId});

  Tables.fromJson(Map<String, dynamic> json) {
    bookingStatus = json['booking_status'];
    orderId = json['order_id'];
    clientCanPay = json['client_can_pay'].toString();
    orderCreatedAt = json['order_created_at'];
    tableName = json['table_name'];
    roomTableId = json['room_table_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['booking_status'] = bookingStatus;
    data['order_id'] = orderId;
    data['client_can_pay'] = clientCanPay;
    data['order_created_at'] = orderCreatedAt;
    data['table_name'] = tableName;
    data['room_table_id'] = roomTableId;
    return data;
  }
}
