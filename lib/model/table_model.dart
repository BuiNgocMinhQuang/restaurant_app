class TableModel {
  int? status;
  List<String>? foodKinds;
  Booking? booking;
  List<TablesNoBooking>? tablesNoBooking;

  TableModel({this.status, this.foodKinds, this.booking, this.tablesNoBooking});

  TableModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    foodKinds = json['food_kinds'].cast<String>();
    booking =
        json['booking'] != null ? new Booking.fromJson(json['booking']) : null;
    if (json['tables_no_booking'] != null) {
      tablesNoBooking = <TablesNoBooking>[];
      json['tables_no_booking'].forEach((v) {
        tablesNoBooking!.add(new TablesNoBooking.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['food_kinds'] = this.foodKinds;
    if (this.booking != null) {
      data['booking'] = this.booking!.toJson();
    }
    if (this.tablesNoBooking != null) {
      data['tables_no_booking'] =
          this.tablesNoBooking!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Booking {
  int? bookedTableId;
  int? orderId;
  int? roomTableId;
  int? activeFlg;
  String? createdAt;
  String? updatedAt;
  Order? order;

  Booking(
      {this.bookedTableId,
      this.orderId,
      this.roomTableId,
      this.activeFlg,
      this.createdAt,
      this.updatedAt,
      this.order});

  Booking.fromJson(Map<String, dynamic> json) {
    bookedTableId = json['booked_table_id'];
    orderId = json['order_id'];
    roomTableId = json['room_table_id'];
    activeFlg = json['active_flg'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    order = json['order'] != null ? new Order.fromJson(json['order']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['booked_table_id'] = this.bookedTableId;
    data['order_id'] = this.orderId;
    data['room_table_id'] = this.roomTableId;
    data['active_flg'] = this.activeFlg;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.order != null) {
      data['order'] = this.order!.toJson();
    }
    return data;
  }
}

class Order {
  int? orderId;
  int? userId;
  String? staffId;
  int? storeId;
  int? storeRoomId;
  String? clientId;
  String? deposit;
  String? amount;
  String? paymentAmount;
  String? clientName;
  String? clientPhone;
  String? clientEmail;
  String? startBookedTableAt;
  String? endBookedTableAt;
  String? note;
  String? cancellationReason;
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
  String? createdAt;
  String? updatedAt;

  Order(
      {this.orderId,
      this.userId,
      this.staffId,
      this.storeId,
      this.storeRoomId,
      this.clientId,
      this.deposit,
      this.amount,
      this.paymentAmount,
      this.clientName,
      this.clientPhone,
      this.clientEmail,
      this.startBookedTableAt,
      this.endBookedTableAt,
      this.note,
      this.cancellationReason,
      this.discount,
      this.guestPay,
      this.payKind,
      this.orderKind,
      this.guestPayClient,
      this.clientCanPay,
      this.orderTotal,
      this.payFlg,
      this.closeOrder,
      this.activeFlg,
      this.deleteFlg,
      this.createdAt,
      this.updatedAt});

  Order.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    userId = json['user_id'];
    staffId = json['staff_id'];
    storeId = json['store_id'];
    storeRoomId = json['store_room_id'];
    clientId = json['client_id'];
    deposit = json['deposit'];
    amount = json['amount'];
    paymentAmount = json['payment_amount'];
    clientName = json['client_name'];
    clientPhone = json['client_phone'];
    clientEmail = json['client_email'];
    startBookedTableAt = json['start_booked_table_at'];
    endBookedTableAt = json['end_booked_table_at'];
    note = json['note'];
    cancellationReason = json['cancellation_reason'];
    discount = json['discount'];
    guestPay = json['guest_pay'];
    payKind = json['pay_kind'];
    orderKind = json['order_kind'];
    guestPayClient = json['guest_pay_client'];
    clientCanPay = json['client_can_pay'];
    orderTotal = json['order_total'];
    payFlg = json['pay_flg'];
    closeOrder = json['close_order'];
    activeFlg = json['active_flg'];
    deleteFlg = json['delete_flg'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['user_id'] = this.userId;
    data['staff_id'] = this.staffId;
    data['store_id'] = this.storeId;
    data['store_room_id'] = this.storeRoomId;
    data['client_id'] = this.clientId;
    data['deposit'] = this.deposit;
    data['amount'] = this.amount;
    data['payment_amount'] = this.paymentAmount;
    data['client_name'] = this.clientName;
    data['client_phone'] = this.clientPhone;
    data['client_email'] = this.clientEmail;
    data['start_booked_table_at'] = this.startBookedTableAt;
    data['end_booked_table_at'] = this.endBookedTableAt;
    data['note'] = this.note;
    data['cancellation_reason'] = this.cancellationReason;
    data['discount'] = this.discount;
    data['guest_pay'] = this.guestPay;
    data['pay_kind'] = this.payKind;
    data['order_kind'] = this.orderKind;
    data['guest_pay_client'] = this.guestPayClient;
    data['client_can_pay'] = this.clientCanPay;
    data['order_total'] = this.orderTotal;
    data['pay_flg'] = this.payFlg;
    data['close_order'] = this.closeOrder;
    data['active_flg'] = this.activeFlg;
    data['delete_flg'] = this.deleteFlg;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class TablesNoBooking {
  int? roomTableId;
  int? storeRoomId;
  String? tableName;
  int? activeFlg;
  int? deleteFlg;
  String? createdAt;
  String? updatedAt;
  int? numberOfSeats;
  int? status;
  String? description;

  TablesNoBooking(
      {this.roomTableId,
      this.storeRoomId,
      this.tableName,
      this.activeFlg,
      this.deleteFlg,
      this.createdAt,
      this.updatedAt,
      this.numberOfSeats,
      this.status,
      this.description});

  TablesNoBooking.fromJson(Map<String, dynamic> json) {
    roomTableId = json['room_table_id'];
    storeRoomId = json['store_room_id'];
    tableName = json['table_name'];
    activeFlg = json['active_flg'];
    deleteFlg = json['delete_flg'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    numberOfSeats = json['number_of_seats'];
    status = json['status'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['room_table_id'] = this.roomTableId;
    data['store_room_id'] = this.storeRoomId;
    data['table_name'] = this.tableName;
    data['active_flg'] = this.activeFlg;
    data['delete_flg'] = this.deleteFlg;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['number_of_seats'] = this.numberOfSeats;
    data['status'] = this.status;
    data['description'] = this.description;
    return data;
  }
}
