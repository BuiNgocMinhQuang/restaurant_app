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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.rooms != null) {
      data['rooms'] = this.rooms!.map((v) => v.toJson()).toList();
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
        tables!.add(new Tables.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['store_room_id'] = this.storeRoomId;
    data['store_room_name'] = this.storeRoomName;
    if (this.tables != null) {
      data['tables'] = this.tables!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['booking_status'] = this.bookingStatus;
    data['order_id'] = this.orderId;
    data['client_can_pay'] = this.clientCanPay;
    data['order_created_at'] = this.orderCreatedAt;
    data['table_name'] = this.tableName;
    data['room_table_id'] = this.roomTableId;
    return data;
  }
}
